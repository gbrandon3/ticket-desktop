const https = require('node:https');
const db = require('./db');

const SUPABASE_URL = process.env.SUPABASE_URL || 'https://vygaxqdaeekcegalrgry.supabase.co';
const SUPABASE_KEY = process.env.SUPABASE_ANON_KEY ||
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ5Z2F4cWRhZWVrY2VnYWxyZ3J5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMzMjI5OTcsImV4cCI6MjEwODg5ODk5N30.AgOzTzf85T1HZ0ef7gyNxV4hy01evvL5-4_axJPXU90';

const TABLES = [
  { name: 'configuracion_empresa', boolCols: ['is_setup_completed'] },
  { name: 'usuarios', boolCols: ['activo'] },
  { name: 'clientes', boolCols: [] },
  { name: 'tipos_falla', boolCols: ['activo'] },
  { name: 'notificaciones_auditoria', boolCols: [] },
  { name: 'auditoria_cambios', boolCols: [] },
  { name: 'equipos', boolCols: [] },
  { name: 'ordenes', boolCols: [] },
  {
    name: 'formato_ot',
    boolCols: [
      'accesorio_cargador',
      'accesorio_cable_poder',
      'accesorio_mouse',
      'accesorio_maletin',
      'encendido_inicial',
    ],
  },
  {
    name: 'formato_actividades',
    boolCols: [
      'pasta_termica',
      'alcohol_isopropilico',
      'sopleteado_contactos',
      'brocha_antiestatica',
      'pano_microfibra',
      'depuracion_temporales',
      'optimizacion_inicio',
      'escaneo_malware',
      'actualizacion_drivers',
      'comprobacion_disco',
      'qa_estres_termico',
      'qa_puertos',
      'qa_conectividad',
      'qa_bateria',
      'qa_teclado_touchpad',
    ],
  },
  { name: 'repuestos_orden', boolCols: [] },
  { name: 'formato_acta_entrega', boolCols: ['check_conformidad'] },
  { name: 'fotos_evidencia', boolCols: [] },
];

// En pruebas unitarias cuando se define TICKETS_DB_PATH, no sincronizar con la nube
function isSyncEnabled() {
  if (process.env.TICKETS_DB_PATH) {
    return false;
  }
  return true;
}

function supabaseRequest(method, pathAndQuery, body = null, extraHeaders = {}) {
  return new Promise((resolve, reject) => {
    const url = new URL(pathAndQuery, SUPABASE_URL);
    const headers = {
      apikey: SUPABASE_KEY,
      Authorization: `Bearer ${SUPABASE_KEY}`,
      ...extraHeaders,
    };
    let payload = null;
    if (body !== null) {
      payload = JSON.stringify(body);
      headers['Content-Type'] = 'application/json';
      headers['Content-Length'] = Buffer.byteLength(payload);
    }

    const req = https.request(
      {
        hostname: url.hostname,
        port: 443,
        path: url.pathname + url.search,
        method,
        headers,
        timeout: 8000,
      },
      res => {
        let raw = '';
        res.on('data', chunk => {
          raw += chunk;
        });
        res.on('end', () => {
          if (res.statusCode >= 200 && res.statusCode < 300) {
            try {
              resolve(raw ? JSON.parse(raw) : null);
            } catch (_) {
              resolve(raw);
            }
          } else {
            reject(new Error(`Supabase ${method} ${pathAndQuery} failed (${res.statusCode}): ${raw}`));
          }
        });
      }
    );

    req.on('error', reject);
    req.on('timeout', () => {
      req.destroy(new Error(`Supabase timeout on ${method} ${pathAndQuery}`));
    });
    if (payload) req.write(payload);
    req.end();
  });
}

// Snapshot del estado remoto por tabla: Map<tableName, Map<id, serializedPgRow>>
const remoteSnapshot = new Map();
let lastPullTime = 0;

function toPgRow(row, boolCols) {
  const out = {};
  for (const [k, v] of Object.entries(row)) {
    if (boolCols.includes(k)) {
      out[k] = v === 1 || v === true || v === '1' || v === 'true';
    } else {
      out[k] = v;
    }
  }
  return out;
}

function toSqliteValue(val, isBool) {
  if (val === undefined || val === null) return null;
  if (isBool) return val === true || val === 1 || val === '1' || val === 'true' ? 1 : 0;
  return val;
}

async function pullFromSupabase(force = false) {
  if (!isSyncEnabled()) return;
  const now = Date.now();
  // Si acabamos de sincronizar hace menos de 1.5s en esta misma instancia, reutilizar
  if (!force && lastPullTime > 0 && now - lastPullTime < 1500) {
    return;
  }

  try {
    const results = await Promise.all(
      TABLES.map(async t => {
        const rows = await supabaseRequest('GET', `/rest/v1/${t.name}?select=*&order=id.asc`);
        return { table: t, rows: Array.isArray(rows) ? rows : [] };
      })
    );

    db.exec('PRAGMA foreign_keys = OFF;');
    db.exec('BEGIN IMMEDIATE;');
    try {
      for (let i = TABLES.length - 1; i >= 0; i--) {
        db.exec(`DELETE FROM ${TABLES[i].name};`);
      }

      for (const { table, rows } of results) {
        const tableSnap = new Map();
        remoteSnapshot.set(table.name, tableSnap);

        if (rows.length === 0) {
          try {
            db.prepare('DELETE FROM sqlite_sequence WHERE name = ?').run(table.name);
          } catch (_) {}
          continue;
        }

        const cols = Object.keys(rows[0]);
        const placeholders = cols.map(() => '?').join(', ');
        const stmt = db.prepare(`INSERT INTO ${table.name} (${cols.join(', ')}) VALUES (${placeholders})`);

        let maxId = 0;
        for (const r of rows) {
          const vals = cols.map(c => toSqliteValue(r[c], table.boolCols.includes(c)));
          stmt.run(...vals);
          if (typeof r.id === 'number' && r.id > maxId) maxId = r.id;

          const normalizedPg = toPgRow(r, table.boolCols);
          tableSnap.set(r.id, JSON.stringify(normalizedPg));
        }

        try {
          db.prepare('DELETE FROM sqlite_sequence WHERE name = ?').run(table.name);
          if (maxId > 0) {
            db.prepare('INSERT INTO sqlite_sequence (name, seq) VALUES (?, ?)').run(table.name, maxId);
          }
        } catch (_) {}
      }

      db.exec('COMMIT;');
      lastPullTime = Date.now();
    } catch (innerErr) {
      try {
        db.exec('ROLLBACK;');
      } catch (_) {}
      throw innerErr;
    } finally {
      db.exec('PRAGMA foreign_keys = ON;');
    }
  } catch (err) {
    console.error('[Supabase Pull Error]:', err.message);
  }
}

async function pushToSupabase() {
  if (!isSyncEnabled()) return;

  try {
    // 1. Procesar eliminaciones en orden inverso (hijos antes que padres)
    for (let i = TABLES.length - 1; i >= 0; i--) {
      const table = TABLES[i];
      const prevSnap = remoteSnapshot.get(table.name) || new Map();
      if (prevSnap.size === 0) continue;

      const localIds = new Set(
        db
          .prepare(`SELECT id FROM ${table.name}`)
          .all()
          .map(r => r.id)
      );

      const deletedIds = [];
      for (const id of prevSnap.keys()) {
        if (!localIds.has(id)) {
          deletedIds.push(id);
        }
      }

      if (deletedIds.length > 0) {
        await supabaseRequest('DELETE', `/rest/v1/${table.name}?id=in.(${deletedIds.join(',')})`);
        for (const id of deletedIds) {
          prevSnap.delete(id);
        }
      }
    }

    // 2. Procesar inserciones y actualizaciones en orden directo (padres antes que hijos)
    for (const table of TABLES) {
      let prevSnap = remoteSnapshot.get(table.name);
      if (!prevSnap) {
        prevSnap = new Map();
        remoteSnapshot.set(table.name, prevSnap);
      }

      const localRows = db.prepare(`SELECT * FROM ${table.name} ORDER BY id ASC`).all();
      const changedRows = [];

      for (const row of localRows) {
        const pgRow = toPgRow(row, table.boolCols);
        const serialized = JSON.stringify(pgRow);
        if (prevSnap.get(row.id) !== serialized) {
          changedRows.push({ id: row.id, pgRow, serialized });
        }
      }

      if (changedRows.length > 0) {
        await supabaseRequest(
          'POST',
          `/rest/v1/${table.name}?on_conflict=id`,
          changedRows.map(c => c.pgRow),
          { Prefer: 'resolution=merge-duplicates,return=minimal' }
        );
        for (const c of changedRows) {
          prevSnap.set(c.id, c.serialized);
        }
      }
    }

    lastPullTime = Date.now();
  } catch (err) {
    console.error('[Supabase Push Error]:', err.message);
  }
}

async function supabaseSyncMiddleware(req, res, next) {
  if (!isSyncEnabled()) return next();
  // En escrituras siempre forzar pull fresco para evitar colisiones de IDs entre instancias serverless
  const forcePull = req.method !== 'GET';
  await pullFromSupabase(forcePull);
  next();
}

module.exports = {
  pullFromSupabase,
  pushToSupabase,
  supabaseSyncMiddleware,
  isSyncEnabled,
  supabaseRequest,
};
