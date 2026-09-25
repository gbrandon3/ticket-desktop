// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsuariosTableTable extends UsuariosTable
    with TableInfo<$UsuariosTableTable, UsuariosTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'UNIQUE',
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentoMeta = const VerificationMeta(
    'documento',
  );
  @override
  late final GeneratedColumn<String> documento = GeneratedColumn<String>(
    'documento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rolMeta = const VerificationMeta('rol');
  @override
  late final GeneratedColumn<String> rol = GeneratedColumn<String>(
    'rol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    email,
    password,
    documento,
    telefono,
    rol,
    activo,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsuariosTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('documento')) {
      context.handle(
        _documentoMeta,
        documento.isAcceptableOrUnknown(data['documento']!, _documentoMeta),
      );
    } else if (isInserting) {
      context.missing(_documentoMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    if (data.containsKey('rol')) {
      context.handle(
        _rolMeta,
        rol.isAcceptableOrUnknown(data['rol']!, _rolMeta),
      );
    } else if (isInserting) {
      context.missing(_rolMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsuariosTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsuariosTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      documento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}documento'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      rol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rol'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsuariosTableTable createAlias(String alias) {
    return $UsuariosTableTable(attachedDatabase, alias);
  }
}

class UsuariosTableData extends DataClass
    implements Insertable<UsuariosTableData> {
  final int id;
  final String nombre;
  final String email;
  final String password;
  final String documento;
  final String telefono;
  final String rol;
  final bool activo;
  final DateTime createdAt;
  const UsuariosTableData({
    required this.id,
    required this.nombre,
    required this.email,
    required this.password,
    required this.documento,
    required this.telefono,
    required this.rol,
    required this.activo,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    map['documento'] = Variable<String>(documento);
    map['telefono'] = Variable<String>(telefono);
    map['rol'] = Variable<String>(rol);
    map['activo'] = Variable<bool>(activo);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsuariosTableCompanion toCompanion(bool nullToAbsent) {
    return UsuariosTableCompanion(
      id: Value(id),
      nombre: Value(nombre),
      email: Value(email),
      password: Value(password),
      documento: Value(documento),
      telefono: Value(telefono),
      rol: Value(rol),
      activo: Value(activo),
      createdAt: Value(createdAt),
    );
  }

  factory UsuariosTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsuariosTableData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      documento: serializer.fromJson<String>(json['documento']),
      telefono: serializer.fromJson<String>(json['telefono']),
      rol: serializer.fromJson<String>(json['rol']),
      activo: serializer.fromJson<bool>(json['activo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'documento': serializer.toJson<String>(documento),
      'telefono': serializer.toJson<String>(telefono),
      'rol': serializer.toJson<String>(rol),
      'activo': serializer.toJson<bool>(activo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UsuariosTableData copyWith({
    int? id,
    String? nombre,
    String? email,
    String? password,
    String? documento,
    String? telefono,
    String? rol,
    bool? activo,
    DateTime? createdAt,
  }) => UsuariosTableData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    email: email ?? this.email,
    password: password ?? this.password,
    documento: documento ?? this.documento,
    telefono: telefono ?? this.telefono,
    rol: rol ?? this.rol,
    activo: activo ?? this.activo,
    createdAt: createdAt ?? this.createdAt,
  );
  UsuariosTableData copyWithCompanion(UsuariosTableCompanion data) {
    return UsuariosTableData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      documento: data.documento.present ? data.documento.value : this.documento,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      rol: data.rol.present ? data.rol.value : this.rol,
      activo: data.activo.present ? data.activo.value : this.activo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosTableData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('documento: $documento, ')
          ..write('telefono: $telefono, ')
          ..write('rol: $rol, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    email,
    password,
    documento,
    telefono,
    rol,
    activo,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsuariosTableData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.email == this.email &&
          other.password == this.password &&
          other.documento == this.documento &&
          other.telefono == this.telefono &&
          other.rol == this.rol &&
          other.activo == this.activo &&
          other.createdAt == this.createdAt);
}

class UsuariosTableCompanion extends UpdateCompanion<UsuariosTableData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> email;
  final Value<String> password;
  final Value<String> documento;
  final Value<String> telefono;
  final Value<String> rol;
  final Value<bool> activo;
  final Value<DateTime> createdAt;
  const UsuariosTableCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.documento = const Value.absent(),
    this.telefono = const Value.absent(),
    this.rol = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsuariosTableCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String email,
    required String password,
    required String documento,
    required String telefono,
    required String rol,
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : nombre = Value(nombre),
       email = Value(email),
       password = Value(password),
       documento = Value(documento),
       telefono = Value(telefono),
       rol = Value(rol);
  static Insertable<UsuariosTableData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? documento,
    Expression<String>? telefono,
    Expression<String>? rol,
    Expression<bool>? activo,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (documento != null) 'documento': documento,
      if (telefono != null) 'telefono': telefono,
      if (rol != null) 'rol': rol,
      if (activo != null) 'activo': activo,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsuariosTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? email,
    Value<String>? password,
    Value<String>? documento,
    Value<String>? telefono,
    Value<String>? rol,
    Value<bool>? activo,
    Value<DateTime>? createdAt,
  }) {
    return UsuariosTableCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      password: password ?? this.password,
      documento: documento ?? this.documento,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (documento.present) {
      map['documento'] = Variable<String>(documento.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (rol.present) {
      map['rol'] = Variable<String>(rol.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosTableCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('documento: $documento, ')
          ..write('telefono: $telefono, ')
          ..write('rol: $rol, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ClientesTableTable extends ClientesTable
    with TableInfo<$ClientesTableTable, ClientesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tipoDocumentoMeta = const VerificationMeta(
    'tipoDocumento',
  );
  @override
  late final GeneratedColumn<String> tipoDocumento = GeneratedColumn<String>(
    'tipo_documento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroDocumentoMeta = const VerificationMeta(
    'numeroDocumento',
  );
  @override
  late final GeneratedColumn<String> numeroDocumento = GeneratedColumn<String>(
    'numero_documento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'UNIQUE',
  );
  static const VerificationMeta _nombreCompletoMeta = const VerificationMeta(
    'nombreCompleto',
  );
  @override
  late final GeneratedColumn<String> nombreCompleto = GeneratedColumn<String>(
    'nombre_completo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipoDocumento,
    numeroDocumento,
    nombreCompleto,
    telefono,
    email,
    direccion,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClientesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo_documento')) {
      context.handle(
        _tipoDocumentoMeta,
        tipoDocumento.isAcceptableOrUnknown(
          data['tipo_documento']!,
          _tipoDocumentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoDocumentoMeta);
    }
    if (data.containsKey('numero_documento')) {
      context.handle(
        _numeroDocumentoMeta,
        numeroDocumento.isAcceptableOrUnknown(
          data['numero_documento']!,
          _numeroDocumentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroDocumentoMeta);
    }
    if (data.containsKey('nombre_completo')) {
      context.handle(
        _nombreCompletoMeta,
        nombreCompleto.isAcceptableOrUnknown(
          data['nombre_completo']!,
          _nombreCompletoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreCompletoMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    } else if (isInserting) {
      context.missing(_direccionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipoDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_documento'],
      )!,
      numeroDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_documento'],
      )!,
      nombreCompleto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_completo'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ClientesTableTable createAlias(String alias) {
    return $ClientesTableTable(attachedDatabase, alias);
  }
}

class ClientesTableData extends DataClass
    implements Insertable<ClientesTableData> {
  final int id;
  final String tipoDocumento;
  final String numeroDocumento;
  final String nombreCompleto;
  final String telefono;
  final String? email;
  final String direccion;
  final DateTime createdAt;
  const ClientesTableData({
    required this.id,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.nombreCompleto,
    required this.telefono,
    this.email,
    required this.direccion,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tipo_documento'] = Variable<String>(tipoDocumento);
    map['numero_documento'] = Variable<String>(numeroDocumento);
    map['nombre_completo'] = Variable<String>(nombreCompleto);
    map['telefono'] = Variable<String>(telefono);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['direccion'] = Variable<String>(direccion);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ClientesTableCompanion toCompanion(bool nullToAbsent) {
    return ClientesTableCompanion(
      id: Value(id),
      tipoDocumento: Value(tipoDocumento),
      numeroDocumento: Value(numeroDocumento),
      nombreCompleto: Value(nombreCompleto),
      telefono: Value(telefono),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      direccion: Value(direccion),
      createdAt: Value(createdAt),
    );
  }

  factory ClientesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientesTableData(
      id: serializer.fromJson<int>(json['id']),
      tipoDocumento: serializer.fromJson<String>(json['tipoDocumento']),
      numeroDocumento: serializer.fromJson<String>(json['numeroDocumento']),
      nombreCompleto: serializer.fromJson<String>(json['nombreCompleto']),
      telefono: serializer.fromJson<String>(json['telefono']),
      email: serializer.fromJson<String?>(json['email']),
      direccion: serializer.fromJson<String>(json['direccion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipoDocumento': serializer.toJson<String>(tipoDocumento),
      'numeroDocumento': serializer.toJson<String>(numeroDocumento),
      'nombreCompleto': serializer.toJson<String>(nombreCompleto),
      'telefono': serializer.toJson<String>(telefono),
      'email': serializer.toJson<String?>(email),
      'direccion': serializer.toJson<String>(direccion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ClientesTableData copyWith({
    int? id,
    String? tipoDocumento,
    String? numeroDocumento,
    String? nombreCompleto,
    String? telefono,
    Value<String?> email = const Value.absent(),
    String? direccion,
    DateTime? createdAt,
  }) => ClientesTableData(
    id: id ?? this.id,
    tipoDocumento: tipoDocumento ?? this.tipoDocumento,
    numeroDocumento: numeroDocumento ?? this.numeroDocumento,
    nombreCompleto: nombreCompleto ?? this.nombreCompleto,
    telefono: telefono ?? this.telefono,
    email: email.present ? email.value : this.email,
    direccion: direccion ?? this.direccion,
    createdAt: createdAt ?? this.createdAt,
  );
  ClientesTableData copyWithCompanion(ClientesTableCompanion data) {
    return ClientesTableData(
      id: data.id.present ? data.id.value : this.id,
      tipoDocumento: data.tipoDocumento.present
          ? data.tipoDocumento.value
          : this.tipoDocumento,
      numeroDocumento: data.numeroDocumento.present
          ? data.numeroDocumento.value
          : this.numeroDocumento,
      nombreCompleto: data.nombreCompleto.present
          ? data.nombreCompleto.value
          : this.nombreCompleto,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientesTableData(')
          ..write('id: $id, ')
          ..write('tipoDocumento: $tipoDocumento, ')
          ..write('numeroDocumento: $numeroDocumento, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipoDocumento,
    numeroDocumento,
    nombreCompleto,
    telefono,
    email,
    direccion,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientesTableData &&
          other.id == this.id &&
          other.tipoDocumento == this.tipoDocumento &&
          other.numeroDocumento == this.numeroDocumento &&
          other.nombreCompleto == this.nombreCompleto &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.direccion == this.direccion &&
          other.createdAt == this.createdAt);
}

class ClientesTableCompanion extends UpdateCompanion<ClientesTableData> {
  final Value<int> id;
  final Value<String> tipoDocumento;
  final Value<String> numeroDocumento;
  final Value<String> nombreCompleto;
  final Value<String> telefono;
  final Value<String?> email;
  final Value<String> direccion;
  final Value<DateTime> createdAt;
  const ClientesTableCompanion({
    this.id = const Value.absent(),
    this.tipoDocumento = const Value.absent(),
    this.numeroDocumento = const Value.absent(),
    this.nombreCompleto = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ClientesTableCompanion.insert({
    this.id = const Value.absent(),
    required String tipoDocumento,
    required String numeroDocumento,
    required String nombreCompleto,
    required String telefono,
    this.email = const Value.absent(),
    required String direccion,
    this.createdAt = const Value.absent(),
  }) : tipoDocumento = Value(tipoDocumento),
       numeroDocumento = Value(numeroDocumento),
       nombreCompleto = Value(nombreCompleto),
       telefono = Value(telefono),
       direccion = Value(direccion);
  static Insertable<ClientesTableData> custom({
    Expression<int>? id,
    Expression<String>? tipoDocumento,
    Expression<String>? numeroDocumento,
    Expression<String>? nombreCompleto,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? direccion,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipoDocumento != null) 'tipo_documento': tipoDocumento,
      if (numeroDocumento != null) 'numero_documento': numeroDocumento,
      if (nombreCompleto != null) 'nombre_completo': nombreCompleto,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (direccion != null) 'direccion': direccion,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ClientesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? tipoDocumento,
    Value<String>? numeroDocumento,
    Value<String>? nombreCompleto,
    Value<String>? telefono,
    Value<String?>? email,
    Value<String>? direccion,
    Value<DateTime>? createdAt,
  }) {
    return ClientesTableCompanion(
      id: id ?? this.id,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipoDocumento.present) {
      map['tipo_documento'] = Variable<String>(tipoDocumento.value);
    }
    if (numeroDocumento.present) {
      map['numero_documento'] = Variable<String>(numeroDocumento.value);
    }
    if (nombreCompleto.present) {
      map['nombre_completo'] = Variable<String>(nombreCompleto.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesTableCompanion(')
          ..write('id: $id, ')
          ..write('tipoDocumento: $tipoDocumento, ')
          ..write('numeroDocumento: $numeroDocumento, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EquiposTableTable extends EquiposTable
    with TableInfo<$EquiposTableTable, EquiposTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquiposTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tipoEquipoMeta = const VerificationMeta(
    'tipoEquipo',
  );
  @override
  late final GeneratedColumn<String> tipoEquipo = GeneratedColumn<String>(
    'tipo_equipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  @override
  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
    'modelo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroSerieMeta = const VerificationMeta(
    'numeroSerie',
  );
  @override
  late final GeneratedColumn<String> numeroSerie = GeneratedColumn<String>(
    'numero_serie',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sistemaOperativoMeta = const VerificationMeta(
    'sistemaOperativo',
  );
  @override
  late final GeneratedColumn<String> sistemaOperativo = GeneratedColumn<String>(
    'sistema_operativo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _procesadorMeta = const VerificationMeta(
    'procesador',
  );
  @override
  late final GeneratedColumn<String> procesador = GeneratedColumn<String>(
    'procesador',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoriaRamMeta = const VerificationMeta(
    'memoriaRam',
  );
  @override
  late final GeneratedColumn<String> memoriaRam = GeneratedColumn<String>(
    'memoria_ram',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _almacenamientoMeta = const VerificationMeta(
    'almacenamiento',
  );
  @override
  late final GeneratedColumn<String> almacenamiento = GeneratedColumn<String>(
    'almacenamiento',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tarjetaGraficaMeta = const VerificationMeta(
    'tarjetaGrafica',
  );
  @override
  late final GeneratedColumn<String> tarjetaGrafica = GeneratedColumn<String>(
    'tarjeta_grafica',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoEquipoMeta = const VerificationMeta(
    'estadoEquipo',
  );
  @override
  late final GeneratedColumn<String> estadoEquipo = GeneratedColumn<String>(
    'estado_equipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('OPERATIVO'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    tipoEquipo,
    marca,
    modelo,
    numeroSerie,
    sistemaOperativo,
    procesador,
    memoriaRam,
    almacenamiento,
    tarjetaGrafica,
    estadoEquipo,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipos_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquiposTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('tipo_equipo')) {
      context.handle(
        _tipoEquipoMeta,
        tipoEquipo.isAcceptableOrUnknown(data['tipo_equipo']!, _tipoEquipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoEquipoMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    } else if (isInserting) {
      context.missing(_marcaMeta);
    }
    if (data.containsKey('modelo')) {
      context.handle(
        _modeloMeta,
        modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta),
      );
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('numero_serie')) {
      context.handle(
        _numeroSerieMeta,
        numeroSerie.isAcceptableOrUnknown(
          data['numero_serie']!,
          _numeroSerieMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroSerieMeta);
    }
    if (data.containsKey('sistema_operativo')) {
      context.handle(
        _sistemaOperativoMeta,
        sistemaOperativo.isAcceptableOrUnknown(
          data['sistema_operativo']!,
          _sistemaOperativoMeta,
        ),
      );
    }
    if (data.containsKey('procesador')) {
      context.handle(
        _procesadorMeta,
        procesador.isAcceptableOrUnknown(data['procesador']!, _procesadorMeta),
      );
    }
    if (data.containsKey('memoria_ram')) {
      context.handle(
        _memoriaRamMeta,
        memoriaRam.isAcceptableOrUnknown(data['memoria_ram']!, _memoriaRamMeta),
      );
    }
    if (data.containsKey('almacenamiento')) {
      context.handle(
        _almacenamientoMeta,
        almacenamiento.isAcceptableOrUnknown(
          data['almacenamiento']!,
          _almacenamientoMeta,
        ),
      );
    }
    if (data.containsKey('tarjeta_grafica')) {
      context.handle(
        _tarjetaGraficaMeta,
        tarjetaGrafica.isAcceptableOrUnknown(
          data['tarjeta_grafica']!,
          _tarjetaGraficaMeta,
        ),
      );
    }
    if (data.containsKey('estado_equipo')) {
      context.handle(
        _estadoEquipoMeta,
        estadoEquipo.isAcceptableOrUnknown(
          data['estado_equipo']!,
          _estadoEquipoMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquiposTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquiposTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      tipoEquipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_equipo'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      )!,
      modelo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modelo'],
      )!,
      numeroSerie: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_serie'],
      )!,
      sistemaOperativo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sistema_operativo'],
      ),
      procesador: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}procesador'],
      ),
      memoriaRam: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memoria_ram'],
      ),
      almacenamiento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}almacenamiento'],
      ),
      tarjetaGrafica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tarjeta_grafica'],
      ),
      estadoEquipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado_equipo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EquiposTableTable createAlias(String alias) {
    return $EquiposTableTable(attachedDatabase, alias);
  }
}

class EquiposTableData extends DataClass
    implements Insertable<EquiposTableData> {
  final int id;
  final int clienteId;
  final String tipoEquipo;
  final String marca;
  final String modelo;
  final String numeroSerie;
  final String? sistemaOperativo;
  final String? procesador;
  final String? memoriaRam;
  final String? almacenamiento;
  final String? tarjetaGrafica;
  final String estadoEquipo;
  final DateTime createdAt;
  const EquiposTableData({
    required this.id,
    required this.clienteId,
    required this.tipoEquipo,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    this.sistemaOperativo,
    this.procesador,
    this.memoriaRam,
    this.almacenamiento,
    this.tarjetaGrafica,
    required this.estadoEquipo,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    map['tipo_equipo'] = Variable<String>(tipoEquipo);
    map['marca'] = Variable<String>(marca);
    map['modelo'] = Variable<String>(modelo);
    map['numero_serie'] = Variable<String>(numeroSerie);
    if (!nullToAbsent || sistemaOperativo != null) {
      map['sistema_operativo'] = Variable<String>(sistemaOperativo);
    }
    if (!nullToAbsent || procesador != null) {
      map['procesador'] = Variable<String>(procesador);
    }
    if (!nullToAbsent || memoriaRam != null) {
      map['memoria_ram'] = Variable<String>(memoriaRam);
    }
    if (!nullToAbsent || almacenamiento != null) {
      map['almacenamiento'] = Variable<String>(almacenamiento);
    }
    if (!nullToAbsent || tarjetaGrafica != null) {
      map['tarjeta_grafica'] = Variable<String>(tarjetaGrafica);
    }
    map['estado_equipo'] = Variable<String>(estadoEquipo);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EquiposTableCompanion toCompanion(bool nullToAbsent) {
    return EquiposTableCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      tipoEquipo: Value(tipoEquipo),
      marca: Value(marca),
      modelo: Value(modelo),
      numeroSerie: Value(numeroSerie),
      sistemaOperativo: sistemaOperativo == null && nullToAbsent
          ? const Value.absent()
          : Value(sistemaOperativo),
      procesador: procesador == null && nullToAbsent
          ? const Value.absent()
          : Value(procesador),
      memoriaRam: memoriaRam == null && nullToAbsent
          ? const Value.absent()
          : Value(memoriaRam),
      almacenamiento: almacenamiento == null && nullToAbsent
          ? const Value.absent()
          : Value(almacenamiento),
      tarjetaGrafica: tarjetaGrafica == null && nullToAbsent
          ? const Value.absent()
          : Value(tarjetaGrafica),
      estadoEquipo: Value(estadoEquipo),
      createdAt: Value(createdAt),
    );
  }

  factory EquiposTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquiposTableData(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      tipoEquipo: serializer.fromJson<String>(json['tipoEquipo']),
      marca: serializer.fromJson<String>(json['marca']),
      modelo: serializer.fromJson<String>(json['modelo']),
      numeroSerie: serializer.fromJson<String>(json['numeroSerie']),
      sistemaOperativo: serializer.fromJson<String?>(json['sistemaOperativo']),
      procesador: serializer.fromJson<String?>(json['procesador']),
      memoriaRam: serializer.fromJson<String?>(json['memoriaRam']),
      almacenamiento: serializer.fromJson<String?>(json['almacenamiento']),
      tarjetaGrafica: serializer.fromJson<String?>(json['tarjetaGrafica']),
      estadoEquipo: serializer.fromJson<String>(json['estadoEquipo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clienteId': serializer.toJson<int>(clienteId),
      'tipoEquipo': serializer.toJson<String>(tipoEquipo),
      'marca': serializer.toJson<String>(marca),
      'modelo': serializer.toJson<String>(modelo),
      'numeroSerie': serializer.toJson<String>(numeroSerie),
      'sistemaOperativo': serializer.toJson<String?>(sistemaOperativo),
      'procesador': serializer.toJson<String?>(procesador),
      'memoriaRam': serializer.toJson<String?>(memoriaRam),
      'almacenamiento': serializer.toJson<String?>(almacenamiento),
      'tarjetaGrafica': serializer.toJson<String?>(tarjetaGrafica),
      'estadoEquipo': serializer.toJson<String>(estadoEquipo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EquiposTableData copyWith({
    int? id,
    int? clienteId,
    String? tipoEquipo,
    String? marca,
    String? modelo,
    String? numeroSerie,
    Value<String?> sistemaOperativo = const Value.absent(),
    Value<String?> procesador = const Value.absent(),
    Value<String?> memoriaRam = const Value.absent(),
    Value<String?> almacenamiento = const Value.absent(),
    Value<String?> tarjetaGrafica = const Value.absent(),
    String? estadoEquipo,
    DateTime? createdAt,
  }) => EquiposTableData(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    tipoEquipo: tipoEquipo ?? this.tipoEquipo,
    marca: marca ?? this.marca,
    modelo: modelo ?? this.modelo,
    numeroSerie: numeroSerie ?? this.numeroSerie,
    sistemaOperativo: sistemaOperativo.present
        ? sistemaOperativo.value
        : this.sistemaOperativo,
    procesador: procesador.present ? procesador.value : this.procesador,
    memoriaRam: memoriaRam.present ? memoriaRam.value : this.memoriaRam,
    almacenamiento: almacenamiento.present
        ? almacenamiento.value
        : this.almacenamiento,
    tarjetaGrafica: tarjetaGrafica.present
        ? tarjetaGrafica.value
        : this.tarjetaGrafica,
    estadoEquipo: estadoEquipo ?? this.estadoEquipo,
    createdAt: createdAt ?? this.createdAt,
  );
  EquiposTableData copyWithCompanion(EquiposTableCompanion data) {
    return EquiposTableData(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      tipoEquipo: data.tipoEquipo.present
          ? data.tipoEquipo.value
          : this.tipoEquipo,
      marca: data.marca.present ? data.marca.value : this.marca,
      modelo: data.modelo.present ? data.modelo.value : this.modelo,
      numeroSerie: data.numeroSerie.present
          ? data.numeroSerie.value
          : this.numeroSerie,
      sistemaOperativo: data.sistemaOperativo.present
          ? data.sistemaOperativo.value
          : this.sistemaOperativo,
      procesador: data.procesador.present
          ? data.procesador.value
          : this.procesador,
      memoriaRam: data.memoriaRam.present
          ? data.memoriaRam.value
          : this.memoriaRam,
      almacenamiento: data.almacenamiento.present
          ? data.almacenamiento.value
          : this.almacenamiento,
      tarjetaGrafica: data.tarjetaGrafica.present
          ? data.tarjetaGrafica.value
          : this.tarjetaGrafica,
      estadoEquipo: data.estadoEquipo.present
          ? data.estadoEquipo.value
          : this.estadoEquipo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquiposTableData(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('tipoEquipo: $tipoEquipo, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('numeroSerie: $numeroSerie, ')
          ..write('sistemaOperativo: $sistemaOperativo, ')
          ..write('procesador: $procesador, ')
          ..write('memoriaRam: $memoriaRam, ')
          ..write('almacenamiento: $almacenamiento, ')
          ..write('tarjetaGrafica: $tarjetaGrafica, ')
          ..write('estadoEquipo: $estadoEquipo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clienteId,
    tipoEquipo,
    marca,
    modelo,
    numeroSerie,
    sistemaOperativo,
    procesador,
    memoriaRam,
    almacenamiento,
    tarjetaGrafica,
    estadoEquipo,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquiposTableData &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.tipoEquipo == this.tipoEquipo &&
          other.marca == this.marca &&
          other.modelo == this.modelo &&
          other.numeroSerie == this.numeroSerie &&
          other.sistemaOperativo == this.sistemaOperativo &&
          other.procesador == this.procesador &&
          other.memoriaRam == this.memoriaRam &&
          other.almacenamiento == this.almacenamiento &&
          other.tarjetaGrafica == this.tarjetaGrafica &&
          other.estadoEquipo == this.estadoEquipo &&
          other.createdAt == this.createdAt);
}

class EquiposTableCompanion extends UpdateCompanion<EquiposTableData> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<String> tipoEquipo;
  final Value<String> marca;
  final Value<String> modelo;
  final Value<String> numeroSerie;
  final Value<String?> sistemaOperativo;
  final Value<String?> procesador;
  final Value<String?> memoriaRam;
  final Value<String?> almacenamiento;
  final Value<String?> tarjetaGrafica;
  final Value<String> estadoEquipo;
  final Value<DateTime> createdAt;
  const EquiposTableCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.tipoEquipo = const Value.absent(),
    this.marca = const Value.absent(),
    this.modelo = const Value.absent(),
    this.numeroSerie = const Value.absent(),
    this.sistemaOperativo = const Value.absent(),
    this.procesador = const Value.absent(),
    this.memoriaRam = const Value.absent(),
    this.almacenamiento = const Value.absent(),
    this.tarjetaGrafica = const Value.absent(),
    this.estadoEquipo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EquiposTableCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    required String tipoEquipo,
    required String marca,
    required String modelo,
    required String numeroSerie,
    this.sistemaOperativo = const Value.absent(),
    this.procesador = const Value.absent(),
    this.memoriaRam = const Value.absent(),
    this.almacenamiento = const Value.absent(),
    this.tarjetaGrafica = const Value.absent(),
    this.estadoEquipo = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : clienteId = Value(clienteId),
       tipoEquipo = Value(tipoEquipo),
       marca = Value(marca),
       modelo = Value(modelo),
       numeroSerie = Value(numeroSerie);
  static Insertable<EquiposTableData> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<String>? tipoEquipo,
    Expression<String>? marca,
    Expression<String>? modelo,
    Expression<String>? numeroSerie,
    Expression<String>? sistemaOperativo,
    Expression<String>? procesador,
    Expression<String>? memoriaRam,
    Expression<String>? almacenamiento,
    Expression<String>? tarjetaGrafica,
    Expression<String>? estadoEquipo,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (tipoEquipo != null) 'tipo_equipo': tipoEquipo,
      if (marca != null) 'marca': marca,
      if (modelo != null) 'modelo': modelo,
      if (numeroSerie != null) 'numero_serie': numeroSerie,
      if (sistemaOperativo != null) 'sistema_operativo': sistemaOperativo,
      if (procesador != null) 'procesador': procesador,
      if (memoriaRam != null) 'memoria_ram': memoriaRam,
      if (almacenamiento != null) 'almacenamiento': almacenamiento,
      if (tarjetaGrafica != null) 'tarjeta_grafica': tarjetaGrafica,
      if (estadoEquipo != null) 'estado_equipo': estadoEquipo,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EquiposTableCompanion copyWith({
    Value<int>? id,
    Value<int>? clienteId,
    Value<String>? tipoEquipo,
    Value<String>? marca,
    Value<String>? modelo,
    Value<String>? numeroSerie,
    Value<String?>? sistemaOperativo,
    Value<String?>? procesador,
    Value<String?>? memoriaRam,
    Value<String?>? almacenamiento,
    Value<String?>? tarjetaGrafica,
    Value<String>? estadoEquipo,
    Value<DateTime>? createdAt,
  }) {
    return EquiposTableCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      tipoEquipo: tipoEquipo ?? this.tipoEquipo,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      numeroSerie: numeroSerie ?? this.numeroSerie,
      sistemaOperativo: sistemaOperativo ?? this.sistemaOperativo,
      procesador: procesador ?? this.procesador,
      memoriaRam: memoriaRam ?? this.memoriaRam,
      almacenamiento: almacenamiento ?? this.almacenamiento,
      tarjetaGrafica: tarjetaGrafica ?? this.tarjetaGrafica,
      estadoEquipo: estadoEquipo ?? this.estadoEquipo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (tipoEquipo.present) {
      map['tipo_equipo'] = Variable<String>(tipoEquipo.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (numeroSerie.present) {
      map['numero_serie'] = Variable<String>(numeroSerie.value);
    }
    if (sistemaOperativo.present) {
      map['sistema_operativo'] = Variable<String>(sistemaOperativo.value);
    }
    if (procesador.present) {
      map['procesador'] = Variable<String>(procesador.value);
    }
    if (memoriaRam.present) {
      map['memoria_ram'] = Variable<String>(memoriaRam.value);
    }
    if (almacenamiento.present) {
      map['almacenamiento'] = Variable<String>(almacenamiento.value);
    }
    if (tarjetaGrafica.present) {
      map['tarjeta_grafica'] = Variable<String>(tarjetaGrafica.value);
    }
    if (estadoEquipo.present) {
      map['estado_equipo'] = Variable<String>(estadoEquipo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquiposTableCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('tipoEquipo: $tipoEquipo, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('numeroSerie: $numeroSerie, ')
          ..write('sistemaOperativo: $sistemaOperativo, ')
          ..write('procesador: $procesador, ')
          ..write('memoriaRam: $memoriaRam, ')
          ..write('almacenamiento: $almacenamiento, ')
          ..write('tarjetaGrafica: $tarjetaGrafica, ')
          ..write('estadoEquipo: $estadoEquipo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OrdenesTableTable extends OrdenesTable
    with TableInfo<$OrdenesTableTable, OrdenesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdenesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codigoOrdenMeta = const VerificationMeta(
    'codigoOrden',
  );
  @override
  late final GeneratedColumn<String> codigoOrden = GeneratedColumn<String>(
    'codigo_orden',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'UNIQUE',
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes_table (id)',
    ),
  );
  static const VerificationMeta _equipoIdMeta = const VerificationMeta(
    'equipoId',
  );
  @override
  late final GeneratedColumn<int> equipoId = GeneratedColumn<int>(
    'equipo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipos_table (id)',
    ),
  );
  static const VerificationMeta _tecnicoIdMeta = const VerificationMeta(
    'tecnicoId',
  );
  @override
  late final GeneratedColumn<int> tecnicoId = GeneratedColumn<int>(
    'tecnico_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios_table (id)',
    ),
  );
  static const VerificationMeta _solicitanteIdMeta = const VerificationMeta(
    'solicitanteId',
  );
  @override
  late final GeneratedColumn<int> solicitanteId = GeneratedColumn<int>(
    'solicitante_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios_table (id)',
    ),
  );
  static const VerificationMeta _tipoServicioMeta = const VerificationMeta(
    'tipoServicio',
  );
  @override
  late final GeneratedColumn<String> tipoServicio = GeneratedColumn<String>(
    'tipo_servicio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaFallaMeta = const VerificationMeta(
    'categoriaFalla',
  );
  @override
  late final GeneratedColumn<String> categoriaFalla = GeneratedColumn<String>(
    'categoria_falla',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prioridadMeta = const VerificationMeta(
    'prioridad',
  );
  @override
  late final GeneratedColumn<String> prioridad = GeneratedColumn<String>(
    'prioridad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('RECIBIDO'),
  );
  static const VerificationMeta _fechaIngresoMeta = const VerificationMeta(
    'fechaIngreso',
  );
  @override
  late final GeneratedColumn<DateTime> fechaIngreso = GeneratedColumn<DateTime>(
    'fecha_ingreso',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _fechaLimiteSlaMeta = const VerificationMeta(
    'fechaLimiteSla',
  );
  @override
  late final GeneratedColumn<DateTime> fechaLimiteSla =
      GeneratedColumn<DateTime>(
        'fecha_limite_sla',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fechaCierreMeta = const VerificationMeta(
    'fechaCierre',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCierre = GeneratedColumn<DateTime>(
    'fecha_cierre',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigoOrden,
    clienteId,
    equipoId,
    tecnicoId,
    solicitanteId,
    tipoServicio,
    categoriaFalla,
    prioridad,
    titulo,
    descripcion,
    estado,
    fechaIngreso,
    fechaLimiteSla,
    fechaCierre,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ordenes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrdenesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo_orden')) {
      context.handle(
        _codigoOrdenMeta,
        codigoOrden.isAcceptableOrUnknown(
          data['codigo_orden']!,
          _codigoOrdenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_codigoOrdenMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('equipo_id')) {
      context.handle(
        _equipoIdMeta,
        equipoId.isAcceptableOrUnknown(data['equipo_id']!, _equipoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_equipoIdMeta);
    }
    if (data.containsKey('tecnico_id')) {
      context.handle(
        _tecnicoIdMeta,
        tecnicoId.isAcceptableOrUnknown(data['tecnico_id']!, _tecnicoIdMeta),
      );
    }
    if (data.containsKey('solicitante_id')) {
      context.handle(
        _solicitanteIdMeta,
        solicitanteId.isAcceptableOrUnknown(
          data['solicitante_id']!,
          _solicitanteIdMeta,
        ),
      );
    }
    if (data.containsKey('tipo_servicio')) {
      context.handle(
        _tipoServicioMeta,
        tipoServicio.isAcceptableOrUnknown(
          data['tipo_servicio']!,
          _tipoServicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoServicioMeta);
    }
    if (data.containsKey('categoria_falla')) {
      context.handle(
        _categoriaFallaMeta,
        categoriaFalla.isAcceptableOrUnknown(
          data['categoria_falla']!,
          _categoriaFallaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaFallaMeta);
    }
    if (data.containsKey('prioridad')) {
      context.handle(
        _prioridadMeta,
        prioridad.isAcceptableOrUnknown(data['prioridad']!, _prioridadMeta),
      );
    } else if (isInserting) {
      context.missing(_prioridadMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('fecha_ingreso')) {
      context.handle(
        _fechaIngresoMeta,
        fechaIngreso.isAcceptableOrUnknown(
          data['fecha_ingreso']!,
          _fechaIngresoMeta,
        ),
      );
    }
    if (data.containsKey('fecha_limite_sla')) {
      context.handle(
        _fechaLimiteSlaMeta,
        fechaLimiteSla.isAcceptableOrUnknown(
          data['fecha_limite_sla']!,
          _fechaLimiteSlaMeta,
        ),
      );
    }
    if (data.containsKey('fecha_cierre')) {
      context.handle(
        _fechaCierreMeta,
        fechaCierre.isAcceptableOrUnknown(
          data['fecha_cierre']!,
          _fechaCierreMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdenesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdenesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigoOrden: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_orden'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      equipoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipo_id'],
      )!,
      tecnicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tecnico_id'],
      ),
      solicitanteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}solicitante_id'],
      ),
      tipoServicio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_servicio'],
      )!,
      categoriaFalla: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria_falla'],
      )!,
      prioridad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prioridad'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      fechaIngreso: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_ingreso'],
      )!,
      fechaLimiteSla: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_limite_sla'],
      ),
      fechaCierre: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_cierre'],
      ),
    );
  }

  @override
  $OrdenesTableTable createAlias(String alias) {
    return $OrdenesTableTable(attachedDatabase, alias);
  }
}

class OrdenesTableData extends DataClass
    implements Insertable<OrdenesTableData> {
  final int id;
  final String codigoOrden;
  final int clienteId;
  final int equipoId;
  final int? tecnicoId;
  final int? solicitanteId;
  final String tipoServicio;
  final String categoriaFalla;
  final String prioridad;
  final String titulo;
  final String descripcion;
  final String estado;
  final DateTime fechaIngreso;
  final DateTime? fechaLimiteSla;
  final DateTime? fechaCierre;
  const OrdenesTableData({
    required this.id,
    required this.codigoOrden,
    required this.clienteId,
    required this.equipoId,
    this.tecnicoId,
    this.solicitanteId,
    required this.tipoServicio,
    required this.categoriaFalla,
    required this.prioridad,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.fechaIngreso,
    this.fechaLimiteSla,
    this.fechaCierre,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo_orden'] = Variable<String>(codigoOrden);
    map['cliente_id'] = Variable<int>(clienteId);
    map['equipo_id'] = Variable<int>(equipoId);
    if (!nullToAbsent || tecnicoId != null) {
      map['tecnico_id'] = Variable<int>(tecnicoId);
    }
    if (!nullToAbsent || solicitanteId != null) {
      map['solicitante_id'] = Variable<int>(solicitanteId);
    }
    map['tipo_servicio'] = Variable<String>(tipoServicio);
    map['categoria_falla'] = Variable<String>(categoriaFalla);
    map['prioridad'] = Variable<String>(prioridad);
    map['titulo'] = Variable<String>(titulo);
    map['descripcion'] = Variable<String>(descripcion);
    map['estado'] = Variable<String>(estado);
    map['fecha_ingreso'] = Variable<DateTime>(fechaIngreso);
    if (!nullToAbsent || fechaLimiteSla != null) {
      map['fecha_limite_sla'] = Variable<DateTime>(fechaLimiteSla);
    }
    if (!nullToAbsent || fechaCierre != null) {
      map['fecha_cierre'] = Variable<DateTime>(fechaCierre);
    }
    return map;
  }

  OrdenesTableCompanion toCompanion(bool nullToAbsent) {
    return OrdenesTableCompanion(
      id: Value(id),
      codigoOrden: Value(codigoOrden),
      clienteId: Value(clienteId),
      equipoId: Value(equipoId),
      tecnicoId: tecnicoId == null && nullToAbsent
          ? const Value.absent()
          : Value(tecnicoId),
      solicitanteId: solicitanteId == null && nullToAbsent
          ? const Value.absent()
          : Value(solicitanteId),
      tipoServicio: Value(tipoServicio),
      categoriaFalla: Value(categoriaFalla),
      prioridad: Value(prioridad),
      titulo: Value(titulo),
      descripcion: Value(descripcion),
      estado: Value(estado),
      fechaIngreso: Value(fechaIngreso),
      fechaLimiteSla: fechaLimiteSla == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaLimiteSla),
      fechaCierre: fechaCierre == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCierre),
    );
  }

  factory OrdenesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdenesTableData(
      id: serializer.fromJson<int>(json['id']),
      codigoOrden: serializer.fromJson<String>(json['codigoOrden']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      equipoId: serializer.fromJson<int>(json['equipoId']),
      tecnicoId: serializer.fromJson<int?>(json['tecnicoId']),
      solicitanteId: serializer.fromJson<int?>(json['solicitanteId']),
      tipoServicio: serializer.fromJson<String>(json['tipoServicio']),
      categoriaFalla: serializer.fromJson<String>(json['categoriaFalla']),
      prioridad: serializer.fromJson<String>(json['prioridad']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      estado: serializer.fromJson<String>(json['estado']),
      fechaIngreso: serializer.fromJson<DateTime>(json['fechaIngreso']),
      fechaLimiteSla: serializer.fromJson<DateTime?>(json['fechaLimiteSla']),
      fechaCierre: serializer.fromJson<DateTime?>(json['fechaCierre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigoOrden': serializer.toJson<String>(codigoOrden),
      'clienteId': serializer.toJson<int>(clienteId),
      'equipoId': serializer.toJson<int>(equipoId),
      'tecnicoId': serializer.toJson<int?>(tecnicoId),
      'solicitanteId': serializer.toJson<int?>(solicitanteId),
      'tipoServicio': serializer.toJson<String>(tipoServicio),
      'categoriaFalla': serializer.toJson<String>(categoriaFalla),
      'prioridad': serializer.toJson<String>(prioridad),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
      'estado': serializer.toJson<String>(estado),
      'fechaIngreso': serializer.toJson<DateTime>(fechaIngreso),
      'fechaLimiteSla': serializer.toJson<DateTime?>(fechaLimiteSla),
      'fechaCierre': serializer.toJson<DateTime?>(fechaCierre),
    };
  }

  OrdenesTableData copyWith({
    int? id,
    String? codigoOrden,
    int? clienteId,
    int? equipoId,
    Value<int?> tecnicoId = const Value.absent(),
    Value<int?> solicitanteId = const Value.absent(),
    String? tipoServicio,
    String? categoriaFalla,
    String? prioridad,
    String? titulo,
    String? descripcion,
    String? estado,
    DateTime? fechaIngreso,
    Value<DateTime?> fechaLimiteSla = const Value.absent(),
    Value<DateTime?> fechaCierre = const Value.absent(),
  }) => OrdenesTableData(
    id: id ?? this.id,
    codigoOrden: codigoOrden ?? this.codigoOrden,
    clienteId: clienteId ?? this.clienteId,
    equipoId: equipoId ?? this.equipoId,
    tecnicoId: tecnicoId.present ? tecnicoId.value : this.tecnicoId,
    solicitanteId: solicitanteId.present
        ? solicitanteId.value
        : this.solicitanteId,
    tipoServicio: tipoServicio ?? this.tipoServicio,
    categoriaFalla: categoriaFalla ?? this.categoriaFalla,
    prioridad: prioridad ?? this.prioridad,
    titulo: titulo ?? this.titulo,
    descripcion: descripcion ?? this.descripcion,
    estado: estado ?? this.estado,
    fechaIngreso: fechaIngreso ?? this.fechaIngreso,
    fechaLimiteSla: fechaLimiteSla.present
        ? fechaLimiteSla.value
        : this.fechaLimiteSla,
    fechaCierre: fechaCierre.present ? fechaCierre.value : this.fechaCierre,
  );
  OrdenesTableData copyWithCompanion(OrdenesTableCompanion data) {
    return OrdenesTableData(
      id: data.id.present ? data.id.value : this.id,
      codigoOrden: data.codigoOrden.present
          ? data.codigoOrden.value
          : this.codigoOrden,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      equipoId: data.equipoId.present ? data.equipoId.value : this.equipoId,
      tecnicoId: data.tecnicoId.present ? data.tecnicoId.value : this.tecnicoId,
      solicitanteId: data.solicitanteId.present
          ? data.solicitanteId.value
          : this.solicitanteId,
      tipoServicio: data.tipoServicio.present
          ? data.tipoServicio.value
          : this.tipoServicio,
      categoriaFalla: data.categoriaFalla.present
          ? data.categoriaFalla.value
          : this.categoriaFalla,
      prioridad: data.prioridad.present ? data.prioridad.value : this.prioridad,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaIngreso: data.fechaIngreso.present
          ? data.fechaIngreso.value
          : this.fechaIngreso,
      fechaLimiteSla: data.fechaLimiteSla.present
          ? data.fechaLimiteSla.value
          : this.fechaLimiteSla,
      fechaCierre: data.fechaCierre.present
          ? data.fechaCierre.value
          : this.fechaCierre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdenesTableData(')
          ..write('id: $id, ')
          ..write('codigoOrden: $codigoOrden, ')
          ..write('clienteId: $clienteId, ')
          ..write('equipoId: $equipoId, ')
          ..write('tecnicoId: $tecnicoId, ')
          ..write('solicitanteId: $solicitanteId, ')
          ..write('tipoServicio: $tipoServicio, ')
          ..write('categoriaFalla: $categoriaFalla, ')
          ..write('prioridad: $prioridad, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('estado: $estado, ')
          ..write('fechaIngreso: $fechaIngreso, ')
          ..write('fechaLimiteSla: $fechaLimiteSla, ')
          ..write('fechaCierre: $fechaCierre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigoOrden,
    clienteId,
    equipoId,
    tecnicoId,
    solicitanteId,
    tipoServicio,
    categoriaFalla,
    prioridad,
    titulo,
    descripcion,
    estado,
    fechaIngreso,
    fechaLimiteSla,
    fechaCierre,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdenesTableData &&
          other.id == this.id &&
          other.codigoOrden == this.codigoOrden &&
          other.clienteId == this.clienteId &&
          other.equipoId == this.equipoId &&
          other.tecnicoId == this.tecnicoId &&
          other.solicitanteId == this.solicitanteId &&
          other.tipoServicio == this.tipoServicio &&
          other.categoriaFalla == this.categoriaFalla &&
          other.prioridad == this.prioridad &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.estado == this.estado &&
          other.fechaIngreso == this.fechaIngreso &&
          other.fechaLimiteSla == this.fechaLimiteSla &&
          other.fechaCierre == this.fechaCierre);
}

class OrdenesTableCompanion extends UpdateCompanion<OrdenesTableData> {
  final Value<int> id;
  final Value<String> codigoOrden;
  final Value<int> clienteId;
  final Value<int> equipoId;
  final Value<int?> tecnicoId;
  final Value<int?> solicitanteId;
  final Value<String> tipoServicio;
  final Value<String> categoriaFalla;
  final Value<String> prioridad;
  final Value<String> titulo;
  final Value<String> descripcion;
  final Value<String> estado;
  final Value<DateTime> fechaIngreso;
  final Value<DateTime?> fechaLimiteSla;
  final Value<DateTime?> fechaCierre;
  const OrdenesTableCompanion({
    this.id = const Value.absent(),
    this.codigoOrden = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.tecnicoId = const Value.absent(),
    this.solicitanteId = const Value.absent(),
    this.tipoServicio = const Value.absent(),
    this.categoriaFalla = const Value.absent(),
    this.prioridad = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaIngreso = const Value.absent(),
    this.fechaLimiteSla = const Value.absent(),
    this.fechaCierre = const Value.absent(),
  });
  OrdenesTableCompanion.insert({
    this.id = const Value.absent(),
    required String codigoOrden,
    required int clienteId,
    required int equipoId,
    this.tecnicoId = const Value.absent(),
    this.solicitanteId = const Value.absent(),
    required String tipoServicio,
    required String categoriaFalla,
    required String prioridad,
    required String titulo,
    required String descripcion,
    this.estado = const Value.absent(),
    this.fechaIngreso = const Value.absent(),
    this.fechaLimiteSla = const Value.absent(),
    this.fechaCierre = const Value.absent(),
  }) : codigoOrden = Value(codigoOrden),
       clienteId = Value(clienteId),
       equipoId = Value(equipoId),
       tipoServicio = Value(tipoServicio),
       categoriaFalla = Value(categoriaFalla),
       prioridad = Value(prioridad),
       titulo = Value(titulo),
       descripcion = Value(descripcion);
  static Insertable<OrdenesTableData> custom({
    Expression<int>? id,
    Expression<String>? codigoOrden,
    Expression<int>? clienteId,
    Expression<int>? equipoId,
    Expression<int>? tecnicoId,
    Expression<int>? solicitanteId,
    Expression<String>? tipoServicio,
    Expression<String>? categoriaFalla,
    Expression<String>? prioridad,
    Expression<String>? titulo,
    Expression<String>? descripcion,
    Expression<String>? estado,
    Expression<DateTime>? fechaIngreso,
    Expression<DateTime>? fechaLimiteSla,
    Expression<DateTime>? fechaCierre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigoOrden != null) 'codigo_orden': codigoOrden,
      if (clienteId != null) 'cliente_id': clienteId,
      if (equipoId != null) 'equipo_id': equipoId,
      if (tecnicoId != null) 'tecnico_id': tecnicoId,
      if (solicitanteId != null) 'solicitante_id': solicitanteId,
      if (tipoServicio != null) 'tipo_servicio': tipoServicio,
      if (categoriaFalla != null) 'categoria_falla': categoriaFalla,
      if (prioridad != null) 'prioridad': prioridad,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (estado != null) 'estado': estado,
      if (fechaIngreso != null) 'fecha_ingreso': fechaIngreso,
      if (fechaLimiteSla != null) 'fecha_limite_sla': fechaLimiteSla,
      if (fechaCierre != null) 'fecha_cierre': fechaCierre,
    });
  }

  OrdenesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? codigoOrden,
    Value<int>? clienteId,
    Value<int>? equipoId,
    Value<int?>? tecnicoId,
    Value<int?>? solicitanteId,
    Value<String>? tipoServicio,
    Value<String>? categoriaFalla,
    Value<String>? prioridad,
    Value<String>? titulo,
    Value<String>? descripcion,
    Value<String>? estado,
    Value<DateTime>? fechaIngreso,
    Value<DateTime?>? fechaLimiteSla,
    Value<DateTime?>? fechaCierre,
  }) {
    return OrdenesTableCompanion(
      id: id ?? this.id,
      codigoOrden: codigoOrden ?? this.codigoOrden,
      clienteId: clienteId ?? this.clienteId,
      equipoId: equipoId ?? this.equipoId,
      tecnicoId: tecnicoId ?? this.tecnicoId,
      solicitanteId: solicitanteId ?? this.solicitanteId,
      tipoServicio: tipoServicio ?? this.tipoServicio,
      categoriaFalla: categoriaFalla ?? this.categoriaFalla,
      prioridad: prioridad ?? this.prioridad,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      fechaLimiteSla: fechaLimiteSla ?? this.fechaLimiteSla,
      fechaCierre: fechaCierre ?? this.fechaCierre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigoOrden.present) {
      map['codigo_orden'] = Variable<String>(codigoOrden.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (equipoId.present) {
      map['equipo_id'] = Variable<int>(equipoId.value);
    }
    if (tecnicoId.present) {
      map['tecnico_id'] = Variable<int>(tecnicoId.value);
    }
    if (solicitanteId.present) {
      map['solicitante_id'] = Variable<int>(solicitanteId.value);
    }
    if (tipoServicio.present) {
      map['tipo_servicio'] = Variable<String>(tipoServicio.value);
    }
    if (categoriaFalla.present) {
      map['categoria_falla'] = Variable<String>(categoriaFalla.value);
    }
    if (prioridad.present) {
      map['prioridad'] = Variable<String>(prioridad.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (fechaIngreso.present) {
      map['fecha_ingreso'] = Variable<DateTime>(fechaIngreso.value);
    }
    if (fechaLimiteSla.present) {
      map['fecha_limite_sla'] = Variable<DateTime>(fechaLimiteSla.value);
    }
    if (fechaCierre.present) {
      map['fecha_cierre'] = Variable<DateTime>(fechaCierre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdenesTableCompanion(')
          ..write('id: $id, ')
          ..write('codigoOrden: $codigoOrden, ')
          ..write('clienteId: $clienteId, ')
          ..write('equipoId: $equipoId, ')
          ..write('tecnicoId: $tecnicoId, ')
          ..write('solicitanteId: $solicitanteId, ')
          ..write('tipoServicio: $tipoServicio, ')
          ..write('categoriaFalla: $categoriaFalla, ')
          ..write('prioridad: $prioridad, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('estado: $estado, ')
          ..write('fechaIngreso: $fechaIngreso, ')
          ..write('fechaLimiteSla: $fechaLimiteSla, ')
          ..write('fechaCierre: $fechaCierre')
          ..write(')'))
        .toString();
  }
}

class $FormatoOtTableTable extends FormatoOtTable
    with TableInfo<$FormatoOtTableTable, FormatoOtTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormatoOtTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _diagnosticoPreliminarMeta =
      const VerificationMeta('diagnosticoPreliminar');
  @override
  late final GeneratedColumn<String> diagnosticoPreliminar =
      GeneratedColumn<String>(
        'diagnostico_preliminar',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _herramientasChipsMeta = const VerificationMeta(
    'herramientasChips',
  );
  @override
  late final GeneratedColumn<String> herramientasChips =
      GeneratedColumn<String>(
        'herramientas_chips',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _tiempoEstimadoEntregaMeta =
      const VerificationMeta('tiempoEstimadoEntrega');
  @override
  late final GeneratedColumn<DateTime> tiempoEstimadoEntrega =
      GeneratedColumn<DateTime>(
        'tiempo_estimado_entrega',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _accesorioCargadorMeta = const VerificationMeta(
    'accesorioCargador',
  );
  @override
  late final GeneratedColumn<bool> accesorioCargador = GeneratedColumn<bool>(
    'accesorio_cargador',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("accesorio_cargador" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _accesorioCablePoderMeta =
      const VerificationMeta('accesorioCablePoder');
  @override
  late final GeneratedColumn<bool> accesorioCablePoder = GeneratedColumn<bool>(
    'accesorio_cable_poder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("accesorio_cable_poder" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _accesorioMouseMeta = const VerificationMeta(
    'accesorioMouse',
  );
  @override
  late final GeneratedColumn<bool> accesorioMouse = GeneratedColumn<bool>(
    'accesorio_mouse',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("accesorio_mouse" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _accesorioMaletinMeta = const VerificationMeta(
    'accesorioMaletin',
  );
  @override
  late final GeneratedColumn<bool> accesorioMaletin = GeneratedColumn<bool>(
    'accesorio_maletin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("accesorio_maletin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _encendidoInicialMeta = const VerificationMeta(
    'encendidoInicial',
  );
  @override
  late final GeneratedColumn<bool> encendidoInicial = GeneratedColumn<bool>(
    'encendido_inicial',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("encendido_inicial" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _estadoCarcasaMeta = const VerificationMeta(
    'estadoCarcasa',
  );
  @override
  late final GeneratedColumn<String> estadoCarcasa = GeneratedColumn<String>(
    'estado_carcasa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinContrasenaMeta = const VerificationMeta(
    'pinContrasena',
  );
  @override
  late final GeneratedColumn<String> pinContrasena = GeneratedColumn<String>(
    'pin_contrasena',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ordenId,
    diagnosticoPreliminar,
    herramientasChips,
    tiempoEstimadoEntrega,
    accesorioCargador,
    accesorioCablePoder,
    accesorioMouse,
    accesorioMaletin,
    encendidoInicial,
    estadoCarcasa,
    pinContrasena,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'formato_ot_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormatoOtTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('diagnostico_preliminar')) {
      context.handle(
        _diagnosticoPreliminarMeta,
        diagnosticoPreliminar.isAcceptableOrUnknown(
          data['diagnostico_preliminar']!,
          _diagnosticoPreliminarMeta,
        ),
      );
    }
    if (data.containsKey('herramientas_chips')) {
      context.handle(
        _herramientasChipsMeta,
        herramientasChips.isAcceptableOrUnknown(
          data['herramientas_chips']!,
          _herramientasChipsMeta,
        ),
      );
    }
    if (data.containsKey('tiempo_estimado_entrega')) {
      context.handle(
        _tiempoEstimadoEntregaMeta,
        tiempoEstimadoEntrega.isAcceptableOrUnknown(
          data['tiempo_estimado_entrega']!,
          _tiempoEstimadoEntregaMeta,
        ),
      );
    }
    if (data.containsKey('accesorio_cargador')) {
      context.handle(
        _accesorioCargadorMeta,
        accesorioCargador.isAcceptableOrUnknown(
          data['accesorio_cargador']!,
          _accesorioCargadorMeta,
        ),
      );
    }
    if (data.containsKey('accesorio_cable_poder')) {
      context.handle(
        _accesorioCablePoderMeta,
        accesorioCablePoder.isAcceptableOrUnknown(
          data['accesorio_cable_poder']!,
          _accesorioCablePoderMeta,
        ),
      );
    }
    if (data.containsKey('accesorio_mouse')) {
      context.handle(
        _accesorioMouseMeta,
        accesorioMouse.isAcceptableOrUnknown(
          data['accesorio_mouse']!,
          _accesorioMouseMeta,
        ),
      );
    }
    if (data.containsKey('accesorio_maletin')) {
      context.handle(
        _accesorioMaletinMeta,
        accesorioMaletin.isAcceptableOrUnknown(
          data['accesorio_maletin']!,
          _accesorioMaletinMeta,
        ),
      );
    }
    if (data.containsKey('encendido_inicial')) {
      context.handle(
        _encendidoInicialMeta,
        encendidoInicial.isAcceptableOrUnknown(
          data['encendido_inicial']!,
          _encendidoInicialMeta,
        ),
      );
    }
    if (data.containsKey('estado_carcasa')) {
      context.handle(
        _estadoCarcasaMeta,
        estadoCarcasa.isAcceptableOrUnknown(
          data['estado_carcasa']!,
          _estadoCarcasaMeta,
        ),
      );
    }
    if (data.containsKey('pin_contrasena')) {
      context.handle(
        _pinContrasenaMeta,
        pinContrasena.isAcceptableOrUnknown(
          data['pin_contrasena']!,
          _pinContrasenaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormatoOtTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormatoOtTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden_id'],
      )!,
      diagnosticoPreliminar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnostico_preliminar'],
      ),
      herramientasChips: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}herramientas_chips'],
      )!,
      tiempoEstimadoEntrega: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tiempo_estimado_entrega'],
      ),
      accesorioCargador: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}accesorio_cargador'],
      )!,
      accesorioCablePoder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}accesorio_cable_poder'],
      )!,
      accesorioMouse: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}accesorio_mouse'],
      )!,
      accesorioMaletin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}accesorio_maletin'],
      )!,
      encendidoInicial: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}encendido_inicial'],
      )!,
      estadoCarcasa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado_carcasa'],
      ),
      pinContrasena: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_contrasena'],
      ),
    );
  }

  @override
  $FormatoOtTableTable createAlias(String alias) {
    return $FormatoOtTableTable(attachedDatabase, alias);
  }
}

class FormatoOtTableData extends DataClass
    implements Insertable<FormatoOtTableData> {
  final int id;
  final int ordenId;
  final String? diagnosticoPreliminar;
  final String herramientasChips;
  final DateTime? tiempoEstimadoEntrega;
  final bool accesorioCargador;
  final bool accesorioCablePoder;
  final bool accesorioMouse;
  final bool accesorioMaletin;
  final bool encendidoInicial;
  final String? estadoCarcasa;
  final String? pinContrasena;
  const FormatoOtTableData({
    required this.id,
    required this.ordenId,
    this.diagnosticoPreliminar,
    required this.herramientasChips,
    this.tiempoEstimadoEntrega,
    required this.accesorioCargador,
    required this.accesorioCablePoder,
    required this.accesorioMouse,
    required this.accesorioMaletin,
    required this.encendidoInicial,
    this.estadoCarcasa,
    this.pinContrasena,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    if (!nullToAbsent || diagnosticoPreliminar != null) {
      map['diagnostico_preliminar'] = Variable<String>(diagnosticoPreliminar);
    }
    map['herramientas_chips'] = Variable<String>(herramientasChips);
    if (!nullToAbsent || tiempoEstimadoEntrega != null) {
      map['tiempo_estimado_entrega'] = Variable<DateTime>(
        tiempoEstimadoEntrega,
      );
    }
    map['accesorio_cargador'] = Variable<bool>(accesorioCargador);
    map['accesorio_cable_poder'] = Variable<bool>(accesorioCablePoder);
    map['accesorio_mouse'] = Variable<bool>(accesorioMouse);
    map['accesorio_maletin'] = Variable<bool>(accesorioMaletin);
    map['encendido_inicial'] = Variable<bool>(encendidoInicial);
    if (!nullToAbsent || estadoCarcasa != null) {
      map['estado_carcasa'] = Variable<String>(estadoCarcasa);
    }
    if (!nullToAbsent || pinContrasena != null) {
      map['pin_contrasena'] = Variable<String>(pinContrasena);
    }
    return map;
  }

  FormatoOtTableCompanion toCompanion(bool nullToAbsent) {
    return FormatoOtTableCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      diagnosticoPreliminar: diagnosticoPreliminar == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosticoPreliminar),
      herramientasChips: Value(herramientasChips),
      tiempoEstimadoEntrega: tiempoEstimadoEntrega == null && nullToAbsent
          ? const Value.absent()
          : Value(tiempoEstimadoEntrega),
      accesorioCargador: Value(accesorioCargador),
      accesorioCablePoder: Value(accesorioCablePoder),
      accesorioMouse: Value(accesorioMouse),
      accesorioMaletin: Value(accesorioMaletin),
      encendidoInicial: Value(encendidoInicial),
      estadoCarcasa: estadoCarcasa == null && nullToAbsent
          ? const Value.absent()
          : Value(estadoCarcasa),
      pinContrasena: pinContrasena == null && nullToAbsent
          ? const Value.absent()
          : Value(pinContrasena),
    );
  }

  factory FormatoOtTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormatoOtTableData(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      diagnosticoPreliminar: serializer.fromJson<String?>(
        json['diagnosticoPreliminar'],
      ),
      herramientasChips: serializer.fromJson<String>(json['herramientasChips']),
      tiempoEstimadoEntrega: serializer.fromJson<DateTime?>(
        json['tiempoEstimadoEntrega'],
      ),
      accesorioCargador: serializer.fromJson<bool>(json['accesorioCargador']),
      accesorioCablePoder: serializer.fromJson<bool>(
        json['accesorioCablePoder'],
      ),
      accesorioMouse: serializer.fromJson<bool>(json['accesorioMouse']),
      accesorioMaletin: serializer.fromJson<bool>(json['accesorioMaletin']),
      encendidoInicial: serializer.fromJson<bool>(json['encendidoInicial']),
      estadoCarcasa: serializer.fromJson<String?>(json['estadoCarcasa']),
      pinContrasena: serializer.fromJson<String?>(json['pinContrasena']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'diagnosticoPreliminar': serializer.toJson<String?>(
        diagnosticoPreliminar,
      ),
      'herramientasChips': serializer.toJson<String>(herramientasChips),
      'tiempoEstimadoEntrega': serializer.toJson<DateTime?>(
        tiempoEstimadoEntrega,
      ),
      'accesorioCargador': serializer.toJson<bool>(accesorioCargador),
      'accesorioCablePoder': serializer.toJson<bool>(accesorioCablePoder),
      'accesorioMouse': serializer.toJson<bool>(accesorioMouse),
      'accesorioMaletin': serializer.toJson<bool>(accesorioMaletin),
      'encendidoInicial': serializer.toJson<bool>(encendidoInicial),
      'estadoCarcasa': serializer.toJson<String?>(estadoCarcasa),
      'pinContrasena': serializer.toJson<String?>(pinContrasena),
    };
  }

  FormatoOtTableData copyWith({
    int? id,
    int? ordenId,
    Value<String?> diagnosticoPreliminar = const Value.absent(),
    String? herramientasChips,
    Value<DateTime?> tiempoEstimadoEntrega = const Value.absent(),
    bool? accesorioCargador,
    bool? accesorioCablePoder,
    bool? accesorioMouse,
    bool? accesorioMaletin,
    bool? encendidoInicial,
    Value<String?> estadoCarcasa = const Value.absent(),
    Value<String?> pinContrasena = const Value.absent(),
  }) => FormatoOtTableData(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    diagnosticoPreliminar: diagnosticoPreliminar.present
        ? diagnosticoPreliminar.value
        : this.diagnosticoPreliminar,
    herramientasChips: herramientasChips ?? this.herramientasChips,
    tiempoEstimadoEntrega: tiempoEstimadoEntrega.present
        ? tiempoEstimadoEntrega.value
        : this.tiempoEstimadoEntrega,
    accesorioCargador: accesorioCargador ?? this.accesorioCargador,
    accesorioCablePoder: accesorioCablePoder ?? this.accesorioCablePoder,
    accesorioMouse: accesorioMouse ?? this.accesorioMouse,
    accesorioMaletin: accesorioMaletin ?? this.accesorioMaletin,
    encendidoInicial: encendidoInicial ?? this.encendidoInicial,
    estadoCarcasa: estadoCarcasa.present
        ? estadoCarcasa.value
        : this.estadoCarcasa,
    pinContrasena: pinContrasena.present
        ? pinContrasena.value
        : this.pinContrasena,
  );
  FormatoOtTableData copyWithCompanion(FormatoOtTableCompanion data) {
    return FormatoOtTableData(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      diagnosticoPreliminar: data.diagnosticoPreliminar.present
          ? data.diagnosticoPreliminar.value
          : this.diagnosticoPreliminar,
      herramientasChips: data.herramientasChips.present
          ? data.herramientasChips.value
          : this.herramientasChips,
      tiempoEstimadoEntrega: data.tiempoEstimadoEntrega.present
          ? data.tiempoEstimadoEntrega.value
          : this.tiempoEstimadoEntrega,
      accesorioCargador: data.accesorioCargador.present
          ? data.accesorioCargador.value
          : this.accesorioCargador,
      accesorioCablePoder: data.accesorioCablePoder.present
          ? data.accesorioCablePoder.value
          : this.accesorioCablePoder,
      accesorioMouse: data.accesorioMouse.present
          ? data.accesorioMouse.value
          : this.accesorioMouse,
      accesorioMaletin: data.accesorioMaletin.present
          ? data.accesorioMaletin.value
          : this.accesorioMaletin,
      encendidoInicial: data.encendidoInicial.present
          ? data.encendidoInicial.value
          : this.encendidoInicial,
      estadoCarcasa: data.estadoCarcasa.present
          ? data.estadoCarcasa.value
          : this.estadoCarcasa,
      pinContrasena: data.pinContrasena.present
          ? data.pinContrasena.value
          : this.pinContrasena,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormatoOtTableData(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('diagnosticoPreliminar: $diagnosticoPreliminar, ')
          ..write('herramientasChips: $herramientasChips, ')
          ..write('tiempoEstimadoEntrega: $tiempoEstimadoEntrega, ')
          ..write('accesorioCargador: $accesorioCargador, ')
          ..write('accesorioCablePoder: $accesorioCablePoder, ')
          ..write('accesorioMouse: $accesorioMouse, ')
          ..write('accesorioMaletin: $accesorioMaletin, ')
          ..write('encendidoInicial: $encendidoInicial, ')
          ..write('estadoCarcasa: $estadoCarcasa, ')
          ..write('pinContrasena: $pinContrasena')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ordenId,
    diagnosticoPreliminar,
    herramientasChips,
    tiempoEstimadoEntrega,
    accesorioCargador,
    accesorioCablePoder,
    accesorioMouse,
    accesorioMaletin,
    encendidoInicial,
    estadoCarcasa,
    pinContrasena,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormatoOtTableData &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.diagnosticoPreliminar == this.diagnosticoPreliminar &&
          other.herramientasChips == this.herramientasChips &&
          other.tiempoEstimadoEntrega == this.tiempoEstimadoEntrega &&
          other.accesorioCargador == this.accesorioCargador &&
          other.accesorioCablePoder == this.accesorioCablePoder &&
          other.accesorioMouse == this.accesorioMouse &&
          other.accesorioMaletin == this.accesorioMaletin &&
          other.encendidoInicial == this.encendidoInicial &&
          other.estadoCarcasa == this.estadoCarcasa &&
          other.pinContrasena == this.pinContrasena);
}

class FormatoOtTableCompanion extends UpdateCompanion<FormatoOtTableData> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<String?> diagnosticoPreliminar;
  final Value<String> herramientasChips;
  final Value<DateTime?> tiempoEstimadoEntrega;
  final Value<bool> accesorioCargador;
  final Value<bool> accesorioCablePoder;
  final Value<bool> accesorioMouse;
  final Value<bool> accesorioMaletin;
  final Value<bool> encendidoInicial;
  final Value<String?> estadoCarcasa;
  final Value<String?> pinContrasena;
  const FormatoOtTableCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.diagnosticoPreliminar = const Value.absent(),
    this.herramientasChips = const Value.absent(),
    this.tiempoEstimadoEntrega = const Value.absent(),
    this.accesorioCargador = const Value.absent(),
    this.accesorioCablePoder = const Value.absent(),
    this.accesorioMouse = const Value.absent(),
    this.accesorioMaletin = const Value.absent(),
    this.encendidoInicial = const Value.absent(),
    this.estadoCarcasa = const Value.absent(),
    this.pinContrasena = const Value.absent(),
  });
  FormatoOtTableCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    this.diagnosticoPreliminar = const Value.absent(),
    this.herramientasChips = const Value.absent(),
    this.tiempoEstimadoEntrega = const Value.absent(),
    this.accesorioCargador = const Value.absent(),
    this.accesorioCablePoder = const Value.absent(),
    this.accesorioMouse = const Value.absent(),
    this.accesorioMaletin = const Value.absent(),
    this.encendidoInicial = const Value.absent(),
    this.estadoCarcasa = const Value.absent(),
    this.pinContrasena = const Value.absent(),
  }) : ordenId = Value(ordenId);
  static Insertable<FormatoOtTableData> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<String>? diagnosticoPreliminar,
    Expression<String>? herramientasChips,
    Expression<DateTime>? tiempoEstimadoEntrega,
    Expression<bool>? accesorioCargador,
    Expression<bool>? accesorioCablePoder,
    Expression<bool>? accesorioMouse,
    Expression<bool>? accesorioMaletin,
    Expression<bool>? encendidoInicial,
    Expression<String>? estadoCarcasa,
    Expression<String>? pinContrasena,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (diagnosticoPreliminar != null)
        'diagnostico_preliminar': diagnosticoPreliminar,
      if (herramientasChips != null) 'herramientas_chips': herramientasChips,
      if (tiempoEstimadoEntrega != null)
        'tiempo_estimado_entrega': tiempoEstimadoEntrega,
      if (accesorioCargador != null) 'accesorio_cargador': accesorioCargador,
      if (accesorioCablePoder != null)
        'accesorio_cable_poder': accesorioCablePoder,
      if (accesorioMouse != null) 'accesorio_mouse': accesorioMouse,
      if (accesorioMaletin != null) 'accesorio_maletin': accesorioMaletin,
      if (encendidoInicial != null) 'encendido_inicial': encendidoInicial,
      if (estadoCarcasa != null) 'estado_carcasa': estadoCarcasa,
      if (pinContrasena != null) 'pin_contrasena': pinContrasena,
    });
  }

  FormatoOtTableCompanion copyWith({
    Value<int>? id,
    Value<int>? ordenId,
    Value<String?>? diagnosticoPreliminar,
    Value<String>? herramientasChips,
    Value<DateTime?>? tiempoEstimadoEntrega,
    Value<bool>? accesorioCargador,
    Value<bool>? accesorioCablePoder,
    Value<bool>? accesorioMouse,
    Value<bool>? accesorioMaletin,
    Value<bool>? encendidoInicial,
    Value<String?>? estadoCarcasa,
    Value<String?>? pinContrasena,
  }) {
    return FormatoOtTableCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      diagnosticoPreliminar:
          diagnosticoPreliminar ?? this.diagnosticoPreliminar,
      herramientasChips: herramientasChips ?? this.herramientasChips,
      tiempoEstimadoEntrega:
          tiempoEstimadoEntrega ?? this.tiempoEstimadoEntrega,
      accesorioCargador: accesorioCargador ?? this.accesorioCargador,
      accesorioCablePoder: accesorioCablePoder ?? this.accesorioCablePoder,
      accesorioMouse: accesorioMouse ?? this.accesorioMouse,
      accesorioMaletin: accesorioMaletin ?? this.accesorioMaletin,
      encendidoInicial: encendidoInicial ?? this.encendidoInicial,
      estadoCarcasa: estadoCarcasa ?? this.estadoCarcasa,
      pinContrasena: pinContrasena ?? this.pinContrasena,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (diagnosticoPreliminar.present) {
      map['diagnostico_preliminar'] = Variable<String>(
        diagnosticoPreliminar.value,
      );
    }
    if (herramientasChips.present) {
      map['herramientas_chips'] = Variable<String>(herramientasChips.value);
    }
    if (tiempoEstimadoEntrega.present) {
      map['tiempo_estimado_entrega'] = Variable<DateTime>(
        tiempoEstimadoEntrega.value,
      );
    }
    if (accesorioCargador.present) {
      map['accesorio_cargador'] = Variable<bool>(accesorioCargador.value);
    }
    if (accesorioCablePoder.present) {
      map['accesorio_cable_poder'] = Variable<bool>(accesorioCablePoder.value);
    }
    if (accesorioMouse.present) {
      map['accesorio_mouse'] = Variable<bool>(accesorioMouse.value);
    }
    if (accesorioMaletin.present) {
      map['accesorio_maletin'] = Variable<bool>(accesorioMaletin.value);
    }
    if (encendidoInicial.present) {
      map['encendido_inicial'] = Variable<bool>(encendidoInicial.value);
    }
    if (estadoCarcasa.present) {
      map['estado_carcasa'] = Variable<String>(estadoCarcasa.value);
    }
    if (pinContrasena.present) {
      map['pin_contrasena'] = Variable<String>(pinContrasena.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormatoOtTableCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('diagnosticoPreliminar: $diagnosticoPreliminar, ')
          ..write('herramientasChips: $herramientasChips, ')
          ..write('tiempoEstimadoEntrega: $tiempoEstimadoEntrega, ')
          ..write('accesorioCargador: $accesorioCargador, ')
          ..write('accesorioCablePoder: $accesorioCablePoder, ')
          ..write('accesorioMouse: $accesorioMouse, ')
          ..write('accesorioMaletin: $accesorioMaletin, ')
          ..write('encendidoInicial: $encendidoInicial, ')
          ..write('estadoCarcasa: $estadoCarcasa, ')
          ..write('pinContrasena: $pinContrasena')
          ..write(')'))
        .toString();
  }
}

class $FormatoActividadesTableTable extends FormatoActividadesTable
    with TableInfo<$FormatoActividadesTableTable, FormatoActividadesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormatoActividadesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _procedimientosRealizadosMeta =
      const VerificationMeta('procedimientosRealizados');
  @override
  late final GeneratedColumn<String> procedimientosRealizados =
      GeneratedColumn<String>(
        'procedimientos_realizados',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _pastaTermicaMeta = const VerificationMeta(
    'pastaTermica',
  );
  @override
  late final GeneratedColumn<bool> pastaTermica = GeneratedColumn<bool>(
    'pasta_termica',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pasta_termica" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _alcoholIsopropilicoMeta =
      const VerificationMeta('alcoholIsopropilico');
  @override
  late final GeneratedColumn<bool> alcoholIsopropilico = GeneratedColumn<bool>(
    'alcohol_isopropilico',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alcohol_isopropilico" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sopleteadoContactosMeta =
      const VerificationMeta('sopleteadoContactos');
  @override
  late final GeneratedColumn<bool> sopleteadoContactos = GeneratedColumn<bool>(
    'sopleteado_contactos',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sopleteado_contactos" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _brochaAntiestaticaMeta =
      const VerificationMeta('brochaAntiestatica');
  @override
  late final GeneratedColumn<bool> brochaAntiestatica = GeneratedColumn<bool>(
    'brocha_antiestatica',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("brocha_antiestatica" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _panoMicrofibraMeta = const VerificationMeta(
    'panoMicrofibra',
  );
  @override
  late final GeneratedColumn<bool> panoMicrofibra = GeneratedColumn<bool>(
    'pano_microfibra',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pano_microfibra" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _depuracionTemporalesMeta =
      const VerificationMeta('depuracionTemporales');
  @override
  late final GeneratedColumn<bool> depuracionTemporales = GeneratedColumn<bool>(
    'depuracion_temporales',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("depuracion_temporales" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _optimizacionInicioMeta =
      const VerificationMeta('optimizacionInicio');
  @override
  late final GeneratedColumn<bool> optimizacionInicio = GeneratedColumn<bool>(
    'optimizacion_inicio',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("optimizacion_inicio" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _escaneoMalwareMeta = const VerificationMeta(
    'escaneoMalware',
  );
  @override
  late final GeneratedColumn<bool> escaneoMalware = GeneratedColumn<bool>(
    'escaneo_malware',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("escaneo_malware" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _actualizacionDriversMeta =
      const VerificationMeta('actualizacionDrivers');
  @override
  late final GeneratedColumn<bool> actualizacionDrivers = GeneratedColumn<bool>(
    'actualizacion_drivers',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("actualizacion_drivers" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _comprobacionDiscoMeta = const VerificationMeta(
    'comprobacionDisco',
  );
  @override
  late final GeneratedColumn<bool> comprobacionDisco = GeneratedColumn<bool>(
    'comprobacion_disco',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("comprobacion_disco" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _qaEstresTermicoMeta = const VerificationMeta(
    'qaEstresTermico',
  );
  @override
  late final GeneratedColumn<bool> qaEstresTermico = GeneratedColumn<bool>(
    'qa_estres_termico',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("qa_estres_termico" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _qaPuertosMeta = const VerificationMeta(
    'qaPuertos',
  );
  @override
  late final GeneratedColumn<bool> qaPuertos = GeneratedColumn<bool>(
    'qa_puertos',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("qa_puertos" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _qaConectividadMeta = const VerificationMeta(
    'qaConectividad',
  );
  @override
  late final GeneratedColumn<bool> qaConectividad = GeneratedColumn<bool>(
    'qa_conectividad',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("qa_conectividad" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _qaBateriaMeta = const VerificationMeta(
    'qaBateria',
  );
  @override
  late final GeneratedColumn<bool> qaBateria = GeneratedColumn<bool>(
    'qa_bateria',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("qa_bateria" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _qaTecladoTouchpadMeta = const VerificationMeta(
    'qaTecladoTouchpad',
  );
  @override
  late final GeneratedColumn<bool> qaTecladoTouchpad = GeneratedColumn<bool>(
    'qa_teclado_touchpad',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("qa_teclado_touchpad" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _costoManoObraMeta = const VerificationMeta(
    'costoManoObra',
  );
  @override
  late final GeneratedColumn<double> costoManoObra = GeneratedColumn<double>(
    'costo_mano_obra',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ordenId,
    procedimientosRealizados,
    pastaTermica,
    alcoholIsopropilico,
    sopleteadoContactos,
    brochaAntiestatica,
    panoMicrofibra,
    depuracionTemporales,
    optimizacionInicio,
    escaneoMalware,
    actualizacionDrivers,
    comprobacionDisco,
    qaEstresTermico,
    qaPuertos,
    qaConectividad,
    qaBateria,
    qaTecladoTouchpad,
    costoManoObra,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'formato_actividades_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormatoActividadesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('procedimientos_realizados')) {
      context.handle(
        _procedimientosRealizadosMeta,
        procedimientosRealizados.isAcceptableOrUnknown(
          data['procedimientos_realizados']!,
          _procedimientosRealizadosMeta,
        ),
      );
    }
    if (data.containsKey('pasta_termica')) {
      context.handle(
        _pastaTermicaMeta,
        pastaTermica.isAcceptableOrUnknown(
          data['pasta_termica']!,
          _pastaTermicaMeta,
        ),
      );
    }
    if (data.containsKey('alcohol_isopropilico')) {
      context.handle(
        _alcoholIsopropilicoMeta,
        alcoholIsopropilico.isAcceptableOrUnknown(
          data['alcohol_isopropilico']!,
          _alcoholIsopropilicoMeta,
        ),
      );
    }
    if (data.containsKey('sopleteado_contactos')) {
      context.handle(
        _sopleteadoContactosMeta,
        sopleteadoContactos.isAcceptableOrUnknown(
          data['sopleteado_contactos']!,
          _sopleteadoContactosMeta,
        ),
      );
    }
    if (data.containsKey('brocha_antiestatica')) {
      context.handle(
        _brochaAntiestaticaMeta,
        brochaAntiestatica.isAcceptableOrUnknown(
          data['brocha_antiestatica']!,
          _brochaAntiestaticaMeta,
        ),
      );
    }
    if (data.containsKey('pano_microfibra')) {
      context.handle(
        _panoMicrofibraMeta,
        panoMicrofibra.isAcceptableOrUnknown(
          data['pano_microfibra']!,
          _panoMicrofibraMeta,
        ),
      );
    }
    if (data.containsKey('depuracion_temporales')) {
      context.handle(
        _depuracionTemporalesMeta,
        depuracionTemporales.isAcceptableOrUnknown(
          data['depuracion_temporales']!,
          _depuracionTemporalesMeta,
        ),
      );
    }
    if (data.containsKey('optimizacion_inicio')) {
      context.handle(
        _optimizacionInicioMeta,
        optimizacionInicio.isAcceptableOrUnknown(
          data['optimizacion_inicio']!,
          _optimizacionInicioMeta,
        ),
      );
    }
    if (data.containsKey('escaneo_malware')) {
      context.handle(
        _escaneoMalwareMeta,
        escaneoMalware.isAcceptableOrUnknown(
          data['escaneo_malware']!,
          _escaneoMalwareMeta,
        ),
      );
    }
    if (data.containsKey('actualizacion_drivers')) {
      context.handle(
        _actualizacionDriversMeta,
        actualizacionDrivers.isAcceptableOrUnknown(
          data['actualizacion_drivers']!,
          _actualizacionDriversMeta,
        ),
      );
    }
    if (data.containsKey('comprobacion_disco')) {
      context.handle(
        _comprobacionDiscoMeta,
        comprobacionDisco.isAcceptableOrUnknown(
          data['comprobacion_disco']!,
          _comprobacionDiscoMeta,
        ),
      );
    }
    if (data.containsKey('qa_estres_termico')) {
      context.handle(
        _qaEstresTermicoMeta,
        qaEstresTermico.isAcceptableOrUnknown(
          data['qa_estres_termico']!,
          _qaEstresTermicoMeta,
        ),
      );
    }
    if (data.containsKey('qa_puertos')) {
      context.handle(
        _qaPuertosMeta,
        qaPuertos.isAcceptableOrUnknown(data['qa_puertos']!, _qaPuertosMeta),
      );
    }
    if (data.containsKey('qa_conectividad')) {
      context.handle(
        _qaConectividadMeta,
        qaConectividad.isAcceptableOrUnknown(
          data['qa_conectividad']!,
          _qaConectividadMeta,
        ),
      );
    }
    if (data.containsKey('qa_bateria')) {
      context.handle(
        _qaBateriaMeta,
        qaBateria.isAcceptableOrUnknown(data['qa_bateria']!, _qaBateriaMeta),
      );
    }
    if (data.containsKey('qa_teclado_touchpad')) {
      context.handle(
        _qaTecladoTouchpadMeta,
        qaTecladoTouchpad.isAcceptableOrUnknown(
          data['qa_teclado_touchpad']!,
          _qaTecladoTouchpadMeta,
        ),
      );
    }
    if (data.containsKey('costo_mano_obra')) {
      context.handle(
        _costoManoObraMeta,
        costoManoObra.isAcceptableOrUnknown(
          data['costo_mano_obra']!,
          _costoManoObraMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormatoActividadesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormatoActividadesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden_id'],
      )!,
      procedimientosRealizados: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}procedimientos_realizados'],
      ),
      pastaTermica: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pasta_termica'],
      )!,
      alcoholIsopropilico: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alcohol_isopropilico'],
      )!,
      sopleteadoContactos: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sopleteado_contactos'],
      )!,
      brochaAntiestatica: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}brocha_antiestatica'],
      )!,
      panoMicrofibra: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pano_microfibra'],
      )!,
      depuracionTemporales: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}depuracion_temporales'],
      )!,
      optimizacionInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}optimizacion_inicio'],
      )!,
      escaneoMalware: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}escaneo_malware'],
      )!,
      actualizacionDrivers: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}actualizacion_drivers'],
      )!,
      comprobacionDisco: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}comprobacion_disco'],
      )!,
      qaEstresTermico: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}qa_estres_termico'],
      )!,
      qaPuertos: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}qa_puertos'],
      )!,
      qaConectividad: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}qa_conectividad'],
      )!,
      qaBateria: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}qa_bateria'],
      )!,
      qaTecladoTouchpad: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}qa_teclado_touchpad'],
      )!,
      costoManoObra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}costo_mano_obra'],
      )!,
    );
  }

  @override
  $FormatoActividadesTableTable createAlias(String alias) {
    return $FormatoActividadesTableTable(attachedDatabase, alias);
  }
}

class FormatoActividadesTableData extends DataClass
    implements Insertable<FormatoActividadesTableData> {
  final int id;
  final int ordenId;
  final String? procedimientosRealizados;
  final bool pastaTermica;
  final bool alcoholIsopropilico;
  final bool sopleteadoContactos;
  final bool brochaAntiestatica;
  final bool panoMicrofibra;
  final bool depuracionTemporales;
  final bool optimizacionInicio;
  final bool escaneoMalware;
  final bool actualizacionDrivers;
  final bool comprobacionDisco;
  final bool qaEstresTermico;
  final bool qaPuertos;
  final bool qaConectividad;
  final bool qaBateria;
  final bool qaTecladoTouchpad;
  final double costoManoObra;
  const FormatoActividadesTableData({
    required this.id,
    required this.ordenId,
    this.procedimientosRealizados,
    required this.pastaTermica,
    required this.alcoholIsopropilico,
    required this.sopleteadoContactos,
    required this.brochaAntiestatica,
    required this.panoMicrofibra,
    required this.depuracionTemporales,
    required this.optimizacionInicio,
    required this.escaneoMalware,
    required this.actualizacionDrivers,
    required this.comprobacionDisco,
    required this.qaEstresTermico,
    required this.qaPuertos,
    required this.qaConectividad,
    required this.qaBateria,
    required this.qaTecladoTouchpad,
    required this.costoManoObra,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    if (!nullToAbsent || procedimientosRealizados != null) {
      map['procedimientos_realizados'] = Variable<String>(
        procedimientosRealizados,
      );
    }
    map['pasta_termica'] = Variable<bool>(pastaTermica);
    map['alcohol_isopropilico'] = Variable<bool>(alcoholIsopropilico);
    map['sopleteado_contactos'] = Variable<bool>(sopleteadoContactos);
    map['brocha_antiestatica'] = Variable<bool>(brochaAntiestatica);
    map['pano_microfibra'] = Variable<bool>(panoMicrofibra);
    map['depuracion_temporales'] = Variable<bool>(depuracionTemporales);
    map['optimizacion_inicio'] = Variable<bool>(optimizacionInicio);
    map['escaneo_malware'] = Variable<bool>(escaneoMalware);
    map['actualizacion_drivers'] = Variable<bool>(actualizacionDrivers);
    map['comprobacion_disco'] = Variable<bool>(comprobacionDisco);
    map['qa_estres_termico'] = Variable<bool>(qaEstresTermico);
    map['qa_puertos'] = Variable<bool>(qaPuertos);
    map['qa_conectividad'] = Variable<bool>(qaConectividad);
    map['qa_bateria'] = Variable<bool>(qaBateria);
    map['qa_teclado_touchpad'] = Variable<bool>(qaTecladoTouchpad);
    map['costo_mano_obra'] = Variable<double>(costoManoObra);
    return map;
  }

  FormatoActividadesTableCompanion toCompanion(bool nullToAbsent) {
    return FormatoActividadesTableCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      procedimientosRealizados: procedimientosRealizados == null && nullToAbsent
          ? const Value.absent()
          : Value(procedimientosRealizados),
      pastaTermica: Value(pastaTermica),
      alcoholIsopropilico: Value(alcoholIsopropilico),
      sopleteadoContactos: Value(sopleteadoContactos),
      brochaAntiestatica: Value(brochaAntiestatica),
      panoMicrofibra: Value(panoMicrofibra),
      depuracionTemporales: Value(depuracionTemporales),
      optimizacionInicio: Value(optimizacionInicio),
      escaneoMalware: Value(escaneoMalware),
      actualizacionDrivers: Value(actualizacionDrivers),
      comprobacionDisco: Value(comprobacionDisco),
      qaEstresTermico: Value(qaEstresTermico),
      qaPuertos: Value(qaPuertos),
      qaConectividad: Value(qaConectividad),
      qaBateria: Value(qaBateria),
      qaTecladoTouchpad: Value(qaTecladoTouchpad),
      costoManoObra: Value(costoManoObra),
    );
  }

  factory FormatoActividadesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormatoActividadesTableData(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      procedimientosRealizados: serializer.fromJson<String?>(
        json['procedimientosRealizados'],
      ),
      pastaTermica: serializer.fromJson<bool>(json['pastaTermica']),
      alcoholIsopropilico: serializer.fromJson<bool>(
        json['alcoholIsopropilico'],
      ),
      sopleteadoContactos: serializer.fromJson<bool>(
        json['sopleteadoContactos'],
      ),
      brochaAntiestatica: serializer.fromJson<bool>(json['brochaAntiestatica']),
      panoMicrofibra: serializer.fromJson<bool>(json['panoMicrofibra']),
      depuracionTemporales: serializer.fromJson<bool>(
        json['depuracionTemporales'],
      ),
      optimizacionInicio: serializer.fromJson<bool>(json['optimizacionInicio']),
      escaneoMalware: serializer.fromJson<bool>(json['escaneoMalware']),
      actualizacionDrivers: serializer.fromJson<bool>(
        json['actualizacionDrivers'],
      ),
      comprobacionDisco: serializer.fromJson<bool>(json['comprobacionDisco']),
      qaEstresTermico: serializer.fromJson<bool>(json['qaEstresTermico']),
      qaPuertos: serializer.fromJson<bool>(json['qaPuertos']),
      qaConectividad: serializer.fromJson<bool>(json['qaConectividad']),
      qaBateria: serializer.fromJson<bool>(json['qaBateria']),
      qaTecladoTouchpad: serializer.fromJson<bool>(json['qaTecladoTouchpad']),
      costoManoObra: serializer.fromJson<double>(json['costoManoObra']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'procedimientosRealizados': serializer.toJson<String?>(
        procedimientosRealizados,
      ),
      'pastaTermica': serializer.toJson<bool>(pastaTermica),
      'alcoholIsopropilico': serializer.toJson<bool>(alcoholIsopropilico),
      'sopleteadoContactos': serializer.toJson<bool>(sopleteadoContactos),
      'brochaAntiestatica': serializer.toJson<bool>(brochaAntiestatica),
      'panoMicrofibra': serializer.toJson<bool>(panoMicrofibra),
      'depuracionTemporales': serializer.toJson<bool>(depuracionTemporales),
      'optimizacionInicio': serializer.toJson<bool>(optimizacionInicio),
      'escaneoMalware': serializer.toJson<bool>(escaneoMalware),
      'actualizacionDrivers': serializer.toJson<bool>(actualizacionDrivers),
      'comprobacionDisco': serializer.toJson<bool>(comprobacionDisco),
      'qaEstresTermico': serializer.toJson<bool>(qaEstresTermico),
      'qaPuertos': serializer.toJson<bool>(qaPuertos),
      'qaConectividad': serializer.toJson<bool>(qaConectividad),
      'qaBateria': serializer.toJson<bool>(qaBateria),
      'qaTecladoTouchpad': serializer.toJson<bool>(qaTecladoTouchpad),
      'costoManoObra': serializer.toJson<double>(costoManoObra),
    };
  }

  FormatoActividadesTableData copyWith({
    int? id,
    int? ordenId,
    Value<String?> procedimientosRealizados = const Value.absent(),
    bool? pastaTermica,
    bool? alcoholIsopropilico,
    bool? sopleteadoContactos,
    bool? brochaAntiestatica,
    bool? panoMicrofibra,
    bool? depuracionTemporales,
    bool? optimizacionInicio,
    bool? escaneoMalware,
    bool? actualizacionDrivers,
    bool? comprobacionDisco,
    bool? qaEstresTermico,
    bool? qaPuertos,
    bool? qaConectividad,
    bool? qaBateria,
    bool? qaTecladoTouchpad,
    double? costoManoObra,
  }) => FormatoActividadesTableData(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    procedimientosRealizados: procedimientosRealizados.present
        ? procedimientosRealizados.value
        : this.procedimientosRealizados,
    pastaTermica: pastaTermica ?? this.pastaTermica,
    alcoholIsopropilico: alcoholIsopropilico ?? this.alcoholIsopropilico,
    sopleteadoContactos: sopleteadoContactos ?? this.sopleteadoContactos,
    brochaAntiestatica: brochaAntiestatica ?? this.brochaAntiestatica,
    panoMicrofibra: panoMicrofibra ?? this.panoMicrofibra,
    depuracionTemporales: depuracionTemporales ?? this.depuracionTemporales,
    optimizacionInicio: optimizacionInicio ?? this.optimizacionInicio,
    escaneoMalware: escaneoMalware ?? this.escaneoMalware,
    actualizacionDrivers: actualizacionDrivers ?? this.actualizacionDrivers,
    comprobacionDisco: comprobacionDisco ?? this.comprobacionDisco,
    qaEstresTermico: qaEstresTermico ?? this.qaEstresTermico,
    qaPuertos: qaPuertos ?? this.qaPuertos,
    qaConectividad: qaConectividad ?? this.qaConectividad,
    qaBateria: qaBateria ?? this.qaBateria,
    qaTecladoTouchpad: qaTecladoTouchpad ?? this.qaTecladoTouchpad,
    costoManoObra: costoManoObra ?? this.costoManoObra,
  );
  FormatoActividadesTableData copyWithCompanion(
    FormatoActividadesTableCompanion data,
  ) {
    return FormatoActividadesTableData(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      procedimientosRealizados: data.procedimientosRealizados.present
          ? data.procedimientosRealizados.value
          : this.procedimientosRealizados,
      pastaTermica: data.pastaTermica.present
          ? data.pastaTermica.value
          : this.pastaTermica,
      alcoholIsopropilico: data.alcoholIsopropilico.present
          ? data.alcoholIsopropilico.value
          : this.alcoholIsopropilico,
      sopleteadoContactos: data.sopleteadoContactos.present
          ? data.sopleteadoContactos.value
          : this.sopleteadoContactos,
      brochaAntiestatica: data.brochaAntiestatica.present
          ? data.brochaAntiestatica.value
          : this.brochaAntiestatica,
      panoMicrofibra: data.panoMicrofibra.present
          ? data.panoMicrofibra.value
          : this.panoMicrofibra,
      depuracionTemporales: data.depuracionTemporales.present
          ? data.depuracionTemporales.value
          : this.depuracionTemporales,
      optimizacionInicio: data.optimizacionInicio.present
          ? data.optimizacionInicio.value
          : this.optimizacionInicio,
      escaneoMalware: data.escaneoMalware.present
          ? data.escaneoMalware.value
          : this.escaneoMalware,
      actualizacionDrivers: data.actualizacionDrivers.present
          ? data.actualizacionDrivers.value
          : this.actualizacionDrivers,
      comprobacionDisco: data.comprobacionDisco.present
          ? data.comprobacionDisco.value
          : this.comprobacionDisco,
      qaEstresTermico: data.qaEstresTermico.present
          ? data.qaEstresTermico.value
          : this.qaEstresTermico,
      qaPuertos: data.qaPuertos.present ? data.qaPuertos.value : this.qaPuertos,
      qaConectividad: data.qaConectividad.present
          ? data.qaConectividad.value
          : this.qaConectividad,
      qaBateria: data.qaBateria.present ? data.qaBateria.value : this.qaBateria,
      qaTecladoTouchpad: data.qaTecladoTouchpad.present
          ? data.qaTecladoTouchpad.value
          : this.qaTecladoTouchpad,
      costoManoObra: data.costoManoObra.present
          ? data.costoManoObra.value
          : this.costoManoObra,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormatoActividadesTableData(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('procedimientosRealizados: $procedimientosRealizados, ')
          ..write('pastaTermica: $pastaTermica, ')
          ..write('alcoholIsopropilico: $alcoholIsopropilico, ')
          ..write('sopleteadoContactos: $sopleteadoContactos, ')
          ..write('brochaAntiestatica: $brochaAntiestatica, ')
          ..write('panoMicrofibra: $panoMicrofibra, ')
          ..write('depuracionTemporales: $depuracionTemporales, ')
          ..write('optimizacionInicio: $optimizacionInicio, ')
          ..write('escaneoMalware: $escaneoMalware, ')
          ..write('actualizacionDrivers: $actualizacionDrivers, ')
          ..write('comprobacionDisco: $comprobacionDisco, ')
          ..write('qaEstresTermico: $qaEstresTermico, ')
          ..write('qaPuertos: $qaPuertos, ')
          ..write('qaConectividad: $qaConectividad, ')
          ..write('qaBateria: $qaBateria, ')
          ..write('qaTecladoTouchpad: $qaTecladoTouchpad, ')
          ..write('costoManoObra: $costoManoObra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ordenId,
    procedimientosRealizados,
    pastaTermica,
    alcoholIsopropilico,
    sopleteadoContactos,
    brochaAntiestatica,
    panoMicrofibra,
    depuracionTemporales,
    optimizacionInicio,
    escaneoMalware,
    actualizacionDrivers,
    comprobacionDisco,
    qaEstresTermico,
    qaPuertos,
    qaConectividad,
    qaBateria,
    qaTecladoTouchpad,
    costoManoObra,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormatoActividadesTableData &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.procedimientosRealizados == this.procedimientosRealizados &&
          other.pastaTermica == this.pastaTermica &&
          other.alcoholIsopropilico == this.alcoholIsopropilico &&
          other.sopleteadoContactos == this.sopleteadoContactos &&
          other.brochaAntiestatica == this.brochaAntiestatica &&
          other.panoMicrofibra == this.panoMicrofibra &&
          other.depuracionTemporales == this.depuracionTemporales &&
          other.optimizacionInicio == this.optimizacionInicio &&
          other.escaneoMalware == this.escaneoMalware &&
          other.actualizacionDrivers == this.actualizacionDrivers &&
          other.comprobacionDisco == this.comprobacionDisco &&
          other.qaEstresTermico == this.qaEstresTermico &&
          other.qaPuertos == this.qaPuertos &&
          other.qaConectividad == this.qaConectividad &&
          other.qaBateria == this.qaBateria &&
          other.qaTecladoTouchpad == this.qaTecladoTouchpad &&
          other.costoManoObra == this.costoManoObra);
}

class FormatoActividadesTableCompanion
    extends UpdateCompanion<FormatoActividadesTableData> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<String?> procedimientosRealizados;
  final Value<bool> pastaTermica;
  final Value<bool> alcoholIsopropilico;
  final Value<bool> sopleteadoContactos;
  final Value<bool> brochaAntiestatica;
  final Value<bool> panoMicrofibra;
  final Value<bool> depuracionTemporales;
  final Value<bool> optimizacionInicio;
  final Value<bool> escaneoMalware;
  final Value<bool> actualizacionDrivers;
  final Value<bool> comprobacionDisco;
  final Value<bool> qaEstresTermico;
  final Value<bool> qaPuertos;
  final Value<bool> qaConectividad;
  final Value<bool> qaBateria;
  final Value<bool> qaTecladoTouchpad;
  final Value<double> costoManoObra;
  const FormatoActividadesTableCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.procedimientosRealizados = const Value.absent(),
    this.pastaTermica = const Value.absent(),
    this.alcoholIsopropilico = const Value.absent(),
    this.sopleteadoContactos = const Value.absent(),
    this.brochaAntiestatica = const Value.absent(),
    this.panoMicrofibra = const Value.absent(),
    this.depuracionTemporales = const Value.absent(),
    this.optimizacionInicio = const Value.absent(),
    this.escaneoMalware = const Value.absent(),
    this.actualizacionDrivers = const Value.absent(),
    this.comprobacionDisco = const Value.absent(),
    this.qaEstresTermico = const Value.absent(),
    this.qaPuertos = const Value.absent(),
    this.qaConectividad = const Value.absent(),
    this.qaBateria = const Value.absent(),
    this.qaTecladoTouchpad = const Value.absent(),
    this.costoManoObra = const Value.absent(),
  });
  FormatoActividadesTableCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    this.procedimientosRealizados = const Value.absent(),
    this.pastaTermica = const Value.absent(),
    this.alcoholIsopropilico = const Value.absent(),
    this.sopleteadoContactos = const Value.absent(),
    this.brochaAntiestatica = const Value.absent(),
    this.panoMicrofibra = const Value.absent(),
    this.depuracionTemporales = const Value.absent(),
    this.optimizacionInicio = const Value.absent(),
    this.escaneoMalware = const Value.absent(),
    this.actualizacionDrivers = const Value.absent(),
    this.comprobacionDisco = const Value.absent(),
    this.qaEstresTermico = const Value.absent(),
    this.qaPuertos = const Value.absent(),
    this.qaConectividad = const Value.absent(),
    this.qaBateria = const Value.absent(),
    this.qaTecladoTouchpad = const Value.absent(),
    this.costoManoObra = const Value.absent(),
  }) : ordenId = Value(ordenId);
  static Insertable<FormatoActividadesTableData> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<String>? procedimientosRealizados,
    Expression<bool>? pastaTermica,
    Expression<bool>? alcoholIsopropilico,
    Expression<bool>? sopleteadoContactos,
    Expression<bool>? brochaAntiestatica,
    Expression<bool>? panoMicrofibra,
    Expression<bool>? depuracionTemporales,
    Expression<bool>? optimizacionInicio,
    Expression<bool>? escaneoMalware,
    Expression<bool>? actualizacionDrivers,
    Expression<bool>? comprobacionDisco,
    Expression<bool>? qaEstresTermico,
    Expression<bool>? qaPuertos,
    Expression<bool>? qaConectividad,
    Expression<bool>? qaBateria,
    Expression<bool>? qaTecladoTouchpad,
    Expression<double>? costoManoObra,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (procedimientosRealizados != null)
        'procedimientos_realizados': procedimientosRealizados,
      if (pastaTermica != null) 'pasta_termica': pastaTermica,
      if (alcoholIsopropilico != null)
        'alcohol_isopropilico': alcoholIsopropilico,
      if (sopleteadoContactos != null)
        'sopleteado_contactos': sopleteadoContactos,
      if (brochaAntiestatica != null) 'brocha_antiestatica': brochaAntiestatica,
      if (panoMicrofibra != null) 'pano_microfibra': panoMicrofibra,
      if (depuracionTemporales != null)
        'depuracion_temporales': depuracionTemporales,
      if (optimizacionInicio != null) 'optimizacion_inicio': optimizacionInicio,
      if (escaneoMalware != null) 'escaneo_malware': escaneoMalware,
      if (actualizacionDrivers != null)
        'actualizacion_drivers': actualizacionDrivers,
      if (comprobacionDisco != null) 'comprobacion_disco': comprobacionDisco,
      if (qaEstresTermico != null) 'qa_estres_termico': qaEstresTermico,
      if (qaPuertos != null) 'qa_puertos': qaPuertos,
      if (qaConectividad != null) 'qa_conectividad': qaConectividad,
      if (qaBateria != null) 'qa_bateria': qaBateria,
      if (qaTecladoTouchpad != null) 'qa_teclado_touchpad': qaTecladoTouchpad,
      if (costoManoObra != null) 'costo_mano_obra': costoManoObra,
    });
  }

  FormatoActividadesTableCompanion copyWith({
    Value<int>? id,
    Value<int>? ordenId,
    Value<String?>? procedimientosRealizados,
    Value<bool>? pastaTermica,
    Value<bool>? alcoholIsopropilico,
    Value<bool>? sopleteadoContactos,
    Value<bool>? brochaAntiestatica,
    Value<bool>? panoMicrofibra,
    Value<bool>? depuracionTemporales,
    Value<bool>? optimizacionInicio,
    Value<bool>? escaneoMalware,
    Value<bool>? actualizacionDrivers,
    Value<bool>? comprobacionDisco,
    Value<bool>? qaEstresTermico,
    Value<bool>? qaPuertos,
    Value<bool>? qaConectividad,
    Value<bool>? qaBateria,
    Value<bool>? qaTecladoTouchpad,
    Value<double>? costoManoObra,
  }) {
    return FormatoActividadesTableCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      procedimientosRealizados:
          procedimientosRealizados ?? this.procedimientosRealizados,
      pastaTermica: pastaTermica ?? this.pastaTermica,
      alcoholIsopropilico: alcoholIsopropilico ?? this.alcoholIsopropilico,
      sopleteadoContactos: sopleteadoContactos ?? this.sopleteadoContactos,
      brochaAntiestatica: brochaAntiestatica ?? this.brochaAntiestatica,
      panoMicrofibra: panoMicrofibra ?? this.panoMicrofibra,
      depuracionTemporales: depuracionTemporales ?? this.depuracionTemporales,
      optimizacionInicio: optimizacionInicio ?? this.optimizacionInicio,
      escaneoMalware: escaneoMalware ?? this.escaneoMalware,
      actualizacionDrivers: actualizacionDrivers ?? this.actualizacionDrivers,
      comprobacionDisco: comprobacionDisco ?? this.comprobacionDisco,
      qaEstresTermico: qaEstresTermico ?? this.qaEstresTermico,
      qaPuertos: qaPuertos ?? this.qaPuertos,
      qaConectividad: qaConectividad ?? this.qaConectividad,
      qaBateria: qaBateria ?? this.qaBateria,
      qaTecladoTouchpad: qaTecladoTouchpad ?? this.qaTecladoTouchpad,
      costoManoObra: costoManoObra ?? this.costoManoObra,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (procedimientosRealizados.present) {
      map['procedimientos_realizados'] = Variable<String>(
        procedimientosRealizados.value,
      );
    }
    if (pastaTermica.present) {
      map['pasta_termica'] = Variable<bool>(pastaTermica.value);
    }
    if (alcoholIsopropilico.present) {
      map['alcohol_isopropilico'] = Variable<bool>(alcoholIsopropilico.value);
    }
    if (sopleteadoContactos.present) {
      map['sopleteado_contactos'] = Variable<bool>(sopleteadoContactos.value);
    }
    if (brochaAntiestatica.present) {
      map['brocha_antiestatica'] = Variable<bool>(brochaAntiestatica.value);
    }
    if (panoMicrofibra.present) {
      map['pano_microfibra'] = Variable<bool>(panoMicrofibra.value);
    }
    if (depuracionTemporales.present) {
      map['depuracion_temporales'] = Variable<bool>(depuracionTemporales.value);
    }
    if (optimizacionInicio.present) {
      map['optimizacion_inicio'] = Variable<bool>(optimizacionInicio.value);
    }
    if (escaneoMalware.present) {
      map['escaneo_malware'] = Variable<bool>(escaneoMalware.value);
    }
    if (actualizacionDrivers.present) {
      map['actualizacion_drivers'] = Variable<bool>(actualizacionDrivers.value);
    }
    if (comprobacionDisco.present) {
      map['comprobacion_disco'] = Variable<bool>(comprobacionDisco.value);
    }
    if (qaEstresTermico.present) {
      map['qa_estres_termico'] = Variable<bool>(qaEstresTermico.value);
    }
    if (qaPuertos.present) {
      map['qa_puertos'] = Variable<bool>(qaPuertos.value);
    }
    if (qaConectividad.present) {
      map['qa_conectividad'] = Variable<bool>(qaConectividad.value);
    }
    if (qaBateria.present) {
      map['qa_bateria'] = Variable<bool>(qaBateria.value);
    }
    if (qaTecladoTouchpad.present) {
      map['qa_teclado_touchpad'] = Variable<bool>(qaTecladoTouchpad.value);
    }
    if (costoManoObra.present) {
      map['costo_mano_obra'] = Variable<double>(costoManoObra.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormatoActividadesTableCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('procedimientosRealizados: $procedimientosRealizados, ')
          ..write('pastaTermica: $pastaTermica, ')
          ..write('alcoholIsopropilico: $alcoholIsopropilico, ')
          ..write('sopleteadoContactos: $sopleteadoContactos, ')
          ..write('brochaAntiestatica: $brochaAntiestatica, ')
          ..write('panoMicrofibra: $panoMicrofibra, ')
          ..write('depuracionTemporales: $depuracionTemporales, ')
          ..write('optimizacionInicio: $optimizacionInicio, ')
          ..write('escaneoMalware: $escaneoMalware, ')
          ..write('actualizacionDrivers: $actualizacionDrivers, ')
          ..write('comprobacionDisco: $comprobacionDisco, ')
          ..write('qaEstresTermico: $qaEstresTermico, ')
          ..write('qaPuertos: $qaPuertos, ')
          ..write('qaConectividad: $qaConectividad, ')
          ..write('qaBateria: $qaBateria, ')
          ..write('qaTecladoTouchpad: $qaTecladoTouchpad, ')
          ..write('costoManoObra: $costoManoObra')
          ..write(')'))
        .toString();
  }
}

class $RepuestosOrdenTableTable extends RepuestosOrdenTable
    with TableInfo<$RepuestosOrdenTableTable, RepuestosOrdenTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepuestosOrdenTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _referenciaMeta = const VerificationMeta(
    'referencia',
  );
  @override
  late final GeneratedColumn<String> referencia = GeneratedColumn<String>(
    'referencia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ordenId,
    referencia,
    cantidad,
    precioUnitario,
    subtotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repuestos_orden_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepuestosOrdenTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('referencia')) {
      context.handle(
        _referenciaMeta,
        referencia.isAcceptableOrUnknown(data['referencia']!, _referenciaMeta),
      );
    } else if (isInserting) {
      context.missing(_referenciaMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepuestosOrdenTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepuestosOrdenTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden_id'],
      )!,
      referencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
    );
  }

  @override
  $RepuestosOrdenTableTable createAlias(String alias) {
    return $RepuestosOrdenTableTable(attachedDatabase, alias);
  }
}

class RepuestosOrdenTableData extends DataClass
    implements Insertable<RepuestosOrdenTableData> {
  final int id;
  final int ordenId;
  final String referencia;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  const RepuestosOrdenTableData({
    required this.id,
    required this.ordenId,
    required this.referencia,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['referencia'] = Variable<String>(referencia);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['subtotal'] = Variable<double>(subtotal);
    return map;
  }

  RepuestosOrdenTableCompanion toCompanion(bool nullToAbsent) {
    return RepuestosOrdenTableCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      referencia: Value(referencia),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
      subtotal: Value(subtotal),
    );
  }

  factory RepuestosOrdenTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepuestosOrdenTableData(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      referencia: serializer.fromJson<String>(json['referencia']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'referencia': serializer.toJson<String>(referencia),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'subtotal': serializer.toJson<double>(subtotal),
    };
  }

  RepuestosOrdenTableData copyWith({
    int? id,
    int? ordenId,
    String? referencia,
    int? cantidad,
    double? precioUnitario,
    double? subtotal,
  }) => RepuestosOrdenTableData(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    referencia: referencia ?? this.referencia,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    subtotal: subtotal ?? this.subtotal,
  );
  RepuestosOrdenTableData copyWithCompanion(RepuestosOrdenTableCompanion data) {
    return RepuestosOrdenTableData(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      referencia: data.referencia.present
          ? data.referencia.value
          : this.referencia,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosOrdenTableData(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('referencia: $referencia, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ordenId, referencia, cantidad, precioUnitario, subtotal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepuestosOrdenTableData &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.referencia == this.referencia &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario &&
          other.subtotal == this.subtotal);
}

class RepuestosOrdenTableCompanion
    extends UpdateCompanion<RepuestosOrdenTableData> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<String> referencia;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<double> subtotal;
  const RepuestosOrdenTableCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.referencia = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.subtotal = const Value.absent(),
  });
  RepuestosOrdenTableCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    required String referencia,
    this.cantidad = const Value.absent(),
    required double precioUnitario,
    required double subtotal,
  }) : ordenId = Value(ordenId),
       referencia = Value(referencia),
       precioUnitario = Value(precioUnitario),
       subtotal = Value(subtotal);
  static Insertable<RepuestosOrdenTableData> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<String>? referencia,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
    Expression<double>? subtotal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (referencia != null) 'referencia': referencia,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (subtotal != null) 'subtotal': subtotal,
    });
  }

  RepuestosOrdenTableCompanion copyWith({
    Value<int>? id,
    Value<int>? ordenId,
    Value<String>? referencia,
    Value<int>? cantidad,
    Value<double>? precioUnitario,
    Value<double>? subtotal,
  }) {
    return RepuestosOrdenTableCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      referencia: referencia ?? this.referencia,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (referencia.present) {
      map['referencia'] = Variable<String>(referencia.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosOrdenTableCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('referencia: $referencia, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }
}

class $FormatoActaEntregaTableTable extends FormatoActaEntregaTable
    with TableInfo<$FormatoActaEntregaTableTable, FormatoActaEntregaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormatoActaEntregaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _estadoOperatividadMeta =
      const VerificationMeta('estadoOperatividad');
  @override
  late final GeneratedColumn<String> estadoOperatividad =
      GeneratedColumn<String>(
        'estado_operatividad',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recomendacionesCuidadoMeta =
      const VerificationMeta('recomendacionesCuidado');
  @override
  late final GeneratedColumn<String> recomendacionesCuidado =
      GeneratedColumn<String>(
        'recomendaciones_cuidado',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _garantiaDiasMeta = const VerificationMeta(
    'garantiaDias',
  );
  @override
  late final GeneratedColumn<String> garantiaDias = GeneratedColumn<String>(
    'garantia_dias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personaRecibeNombreMeta =
      const VerificationMeta('personaRecibeNombre');
  @override
  late final GeneratedColumn<String> personaRecibeNombre =
      GeneratedColumn<String>(
        'persona_recibe_nombre',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _personaRecibeDocumentoMeta =
      const VerificationMeta('personaRecibeDocumento');
  @override
  late final GeneratedColumn<String> personaRecibeDocumento =
      GeneratedColumn<String>(
        'persona_recibe_documento',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _checkConformidadMeta = const VerificationMeta(
    'checkConformidad',
  );
  @override
  late final GeneratedColumn<bool> checkConformidad = GeneratedColumn<bool>(
    'check_conformidad',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("check_conformidad" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fechaEntregaMeta = const VerificationMeta(
    'fechaEntrega',
  );
  @override
  late final GeneratedColumn<DateTime> fechaEntrega = GeneratedColumn<DateTime>(
    'fecha_entrega',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ordenId,
    estadoOperatividad,
    observaciones,
    recomendacionesCuidado,
    garantiaDias,
    personaRecibeNombre,
    personaRecibeDocumento,
    checkConformidad,
    fechaEntrega,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'formato_acta_entrega_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormatoActaEntregaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('estado_operatividad')) {
      context.handle(
        _estadoOperatividadMeta,
        estadoOperatividad.isAcceptableOrUnknown(
          data['estado_operatividad']!,
          _estadoOperatividadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estadoOperatividadMeta);
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    if (data.containsKey('recomendaciones_cuidado')) {
      context.handle(
        _recomendacionesCuidadoMeta,
        recomendacionesCuidado.isAcceptableOrUnknown(
          data['recomendaciones_cuidado']!,
          _recomendacionesCuidadoMeta,
        ),
      );
    }
    if (data.containsKey('garantia_dias')) {
      context.handle(
        _garantiaDiasMeta,
        garantiaDias.isAcceptableOrUnknown(
          data['garantia_dias']!,
          _garantiaDiasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_garantiaDiasMeta);
    }
    if (data.containsKey('persona_recibe_nombre')) {
      context.handle(
        _personaRecibeNombreMeta,
        personaRecibeNombre.isAcceptableOrUnknown(
          data['persona_recibe_nombre']!,
          _personaRecibeNombreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personaRecibeNombreMeta);
    }
    if (data.containsKey('persona_recibe_documento')) {
      context.handle(
        _personaRecibeDocumentoMeta,
        personaRecibeDocumento.isAcceptableOrUnknown(
          data['persona_recibe_documento']!,
          _personaRecibeDocumentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personaRecibeDocumentoMeta);
    }
    if (data.containsKey('check_conformidad')) {
      context.handle(
        _checkConformidadMeta,
        checkConformidad.isAcceptableOrUnknown(
          data['check_conformidad']!,
          _checkConformidadMeta,
        ),
      );
    }
    if (data.containsKey('fecha_entrega')) {
      context.handle(
        _fechaEntregaMeta,
        fechaEntrega.isAcceptableOrUnknown(
          data['fecha_entrega']!,
          _fechaEntregaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormatoActaEntregaTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormatoActaEntregaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden_id'],
      )!,
      estadoOperatividad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado_operatividad'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      ),
      recomendacionesCuidado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recomendaciones_cuidado'],
      ),
      garantiaDias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garantia_dias'],
      )!,
      personaRecibeNombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}persona_recibe_nombre'],
      )!,
      personaRecibeDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}persona_recibe_documento'],
      )!,
      checkConformidad: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}check_conformidad'],
      )!,
      fechaEntrega: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_entrega'],
      )!,
    );
  }

  @override
  $FormatoActaEntregaTableTable createAlias(String alias) {
    return $FormatoActaEntregaTableTable(attachedDatabase, alias);
  }
}

class FormatoActaEntregaTableData extends DataClass
    implements Insertable<FormatoActaEntregaTableData> {
  final int id;
  final int ordenId;
  final String estadoOperatividad;
  final String? observaciones;
  final String? recomendacionesCuidado;
  final String garantiaDias;
  final String personaRecibeNombre;
  final String personaRecibeDocumento;
  final bool checkConformidad;
  final DateTime fechaEntrega;
  const FormatoActaEntregaTableData({
    required this.id,
    required this.ordenId,
    required this.estadoOperatividad,
    this.observaciones,
    this.recomendacionesCuidado,
    required this.garantiaDias,
    required this.personaRecibeNombre,
    required this.personaRecibeDocumento,
    required this.checkConformidad,
    required this.fechaEntrega,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['estado_operatividad'] = Variable<String>(estadoOperatividad);
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    if (!nullToAbsent || recomendacionesCuidado != null) {
      map['recomendaciones_cuidado'] = Variable<String>(recomendacionesCuidado);
    }
    map['garantia_dias'] = Variable<String>(garantiaDias);
    map['persona_recibe_nombre'] = Variable<String>(personaRecibeNombre);
    map['persona_recibe_documento'] = Variable<String>(personaRecibeDocumento);
    map['check_conformidad'] = Variable<bool>(checkConformidad);
    map['fecha_entrega'] = Variable<DateTime>(fechaEntrega);
    return map;
  }

  FormatoActaEntregaTableCompanion toCompanion(bool nullToAbsent) {
    return FormatoActaEntregaTableCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      estadoOperatividad: Value(estadoOperatividad),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      recomendacionesCuidado: recomendacionesCuidado == null && nullToAbsent
          ? const Value.absent()
          : Value(recomendacionesCuidado),
      garantiaDias: Value(garantiaDias),
      personaRecibeNombre: Value(personaRecibeNombre),
      personaRecibeDocumento: Value(personaRecibeDocumento),
      checkConformidad: Value(checkConformidad),
      fechaEntrega: Value(fechaEntrega),
    );
  }

  factory FormatoActaEntregaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormatoActaEntregaTableData(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      estadoOperatividad: serializer.fromJson<String>(
        json['estadoOperatividad'],
      ),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      recomendacionesCuidado: serializer.fromJson<String?>(
        json['recomendacionesCuidado'],
      ),
      garantiaDias: serializer.fromJson<String>(json['garantiaDias']),
      personaRecibeNombre: serializer.fromJson<String>(
        json['personaRecibeNombre'],
      ),
      personaRecibeDocumento: serializer.fromJson<String>(
        json['personaRecibeDocumento'],
      ),
      checkConformidad: serializer.fromJson<bool>(json['checkConformidad']),
      fechaEntrega: serializer.fromJson<DateTime>(json['fechaEntrega']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'estadoOperatividad': serializer.toJson<String>(estadoOperatividad),
      'observaciones': serializer.toJson<String?>(observaciones),
      'recomendacionesCuidado': serializer.toJson<String?>(
        recomendacionesCuidado,
      ),
      'garantiaDias': serializer.toJson<String>(garantiaDias),
      'personaRecibeNombre': serializer.toJson<String>(personaRecibeNombre),
      'personaRecibeDocumento': serializer.toJson<String>(
        personaRecibeDocumento,
      ),
      'checkConformidad': serializer.toJson<bool>(checkConformidad),
      'fechaEntrega': serializer.toJson<DateTime>(fechaEntrega),
    };
  }

  FormatoActaEntregaTableData copyWith({
    int? id,
    int? ordenId,
    String? estadoOperatividad,
    Value<String?> observaciones = const Value.absent(),
    Value<String?> recomendacionesCuidado = const Value.absent(),
    String? garantiaDias,
    String? personaRecibeNombre,
    String? personaRecibeDocumento,
    bool? checkConformidad,
    DateTime? fechaEntrega,
  }) => FormatoActaEntregaTableData(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    estadoOperatividad: estadoOperatividad ?? this.estadoOperatividad,
    observaciones: observaciones.present
        ? observaciones.value
        : this.observaciones,
    recomendacionesCuidado: recomendacionesCuidado.present
        ? recomendacionesCuidado.value
        : this.recomendacionesCuidado,
    garantiaDias: garantiaDias ?? this.garantiaDias,
    personaRecibeNombre: personaRecibeNombre ?? this.personaRecibeNombre,
    personaRecibeDocumento:
        personaRecibeDocumento ?? this.personaRecibeDocumento,
    checkConformidad: checkConformidad ?? this.checkConformidad,
    fechaEntrega: fechaEntrega ?? this.fechaEntrega,
  );
  FormatoActaEntregaTableData copyWithCompanion(
    FormatoActaEntregaTableCompanion data,
  ) {
    return FormatoActaEntregaTableData(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      estadoOperatividad: data.estadoOperatividad.present
          ? data.estadoOperatividad.value
          : this.estadoOperatividad,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      recomendacionesCuidado: data.recomendacionesCuidado.present
          ? data.recomendacionesCuidado.value
          : this.recomendacionesCuidado,
      garantiaDias: data.garantiaDias.present
          ? data.garantiaDias.value
          : this.garantiaDias,
      personaRecibeNombre: data.personaRecibeNombre.present
          ? data.personaRecibeNombre.value
          : this.personaRecibeNombre,
      personaRecibeDocumento: data.personaRecibeDocumento.present
          ? data.personaRecibeDocumento.value
          : this.personaRecibeDocumento,
      checkConformidad: data.checkConformidad.present
          ? data.checkConformidad.value
          : this.checkConformidad,
      fechaEntrega: data.fechaEntrega.present
          ? data.fechaEntrega.value
          : this.fechaEntrega,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormatoActaEntregaTableData(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('estadoOperatividad: $estadoOperatividad, ')
          ..write('observaciones: $observaciones, ')
          ..write('recomendacionesCuidado: $recomendacionesCuidado, ')
          ..write('garantiaDias: $garantiaDias, ')
          ..write('personaRecibeNombre: $personaRecibeNombre, ')
          ..write('personaRecibeDocumento: $personaRecibeDocumento, ')
          ..write('checkConformidad: $checkConformidad, ')
          ..write('fechaEntrega: $fechaEntrega')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ordenId,
    estadoOperatividad,
    observaciones,
    recomendacionesCuidado,
    garantiaDias,
    personaRecibeNombre,
    personaRecibeDocumento,
    checkConformidad,
    fechaEntrega,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormatoActaEntregaTableData &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.estadoOperatividad == this.estadoOperatividad &&
          other.observaciones == this.observaciones &&
          other.recomendacionesCuidado == this.recomendacionesCuidado &&
          other.garantiaDias == this.garantiaDias &&
          other.personaRecibeNombre == this.personaRecibeNombre &&
          other.personaRecibeDocumento == this.personaRecibeDocumento &&
          other.checkConformidad == this.checkConformidad &&
          other.fechaEntrega == this.fechaEntrega);
}

class FormatoActaEntregaTableCompanion
    extends UpdateCompanion<FormatoActaEntregaTableData> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<String> estadoOperatividad;
  final Value<String?> observaciones;
  final Value<String?> recomendacionesCuidado;
  final Value<String> garantiaDias;
  final Value<String> personaRecibeNombre;
  final Value<String> personaRecibeDocumento;
  final Value<bool> checkConformidad;
  final Value<DateTime> fechaEntrega;
  const FormatoActaEntregaTableCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.estadoOperatividad = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.recomendacionesCuidado = const Value.absent(),
    this.garantiaDias = const Value.absent(),
    this.personaRecibeNombre = const Value.absent(),
    this.personaRecibeDocumento = const Value.absent(),
    this.checkConformidad = const Value.absent(),
    this.fechaEntrega = const Value.absent(),
  });
  FormatoActaEntregaTableCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    required String estadoOperatividad,
    this.observaciones = const Value.absent(),
    this.recomendacionesCuidado = const Value.absent(),
    required String garantiaDias,
    required String personaRecibeNombre,
    required String personaRecibeDocumento,
    this.checkConformidad = const Value.absent(),
    this.fechaEntrega = const Value.absent(),
  }) : ordenId = Value(ordenId),
       estadoOperatividad = Value(estadoOperatividad),
       garantiaDias = Value(garantiaDias),
       personaRecibeNombre = Value(personaRecibeNombre),
       personaRecibeDocumento = Value(personaRecibeDocumento);
  static Insertable<FormatoActaEntregaTableData> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<String>? estadoOperatividad,
    Expression<String>? observaciones,
    Expression<String>? recomendacionesCuidado,
    Expression<String>? garantiaDias,
    Expression<String>? personaRecibeNombre,
    Expression<String>? personaRecibeDocumento,
    Expression<bool>? checkConformidad,
    Expression<DateTime>? fechaEntrega,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (estadoOperatividad != null) 'estado_operatividad': estadoOperatividad,
      if (observaciones != null) 'observaciones': observaciones,
      if (recomendacionesCuidado != null)
        'recomendaciones_cuidado': recomendacionesCuidado,
      if (garantiaDias != null) 'garantia_dias': garantiaDias,
      if (personaRecibeNombre != null)
        'persona_recibe_nombre': personaRecibeNombre,
      if (personaRecibeDocumento != null)
        'persona_recibe_documento': personaRecibeDocumento,
      if (checkConformidad != null) 'check_conformidad': checkConformidad,
      if (fechaEntrega != null) 'fecha_entrega': fechaEntrega,
    });
  }

  FormatoActaEntregaTableCompanion copyWith({
    Value<int>? id,
    Value<int>? ordenId,
    Value<String>? estadoOperatividad,
    Value<String?>? observaciones,
    Value<String?>? recomendacionesCuidado,
    Value<String>? garantiaDias,
    Value<String>? personaRecibeNombre,
    Value<String>? personaRecibeDocumento,
    Value<bool>? checkConformidad,
    Value<DateTime>? fechaEntrega,
  }) {
    return FormatoActaEntregaTableCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      estadoOperatividad: estadoOperatividad ?? this.estadoOperatividad,
      observaciones: observaciones ?? this.observaciones,
      recomendacionesCuidado:
          recomendacionesCuidado ?? this.recomendacionesCuidado,
      garantiaDias: garantiaDias ?? this.garantiaDias,
      personaRecibeNombre: personaRecibeNombre ?? this.personaRecibeNombre,
      personaRecibeDocumento:
          personaRecibeDocumento ?? this.personaRecibeDocumento,
      checkConformidad: checkConformidad ?? this.checkConformidad,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (estadoOperatividad.present) {
      map['estado_operatividad'] = Variable<String>(estadoOperatividad.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (recomendacionesCuidado.present) {
      map['recomendaciones_cuidado'] = Variable<String>(
        recomendacionesCuidado.value,
      );
    }
    if (garantiaDias.present) {
      map['garantia_dias'] = Variable<String>(garantiaDias.value);
    }
    if (personaRecibeNombre.present) {
      map['persona_recibe_nombre'] = Variable<String>(
        personaRecibeNombre.value,
      );
    }
    if (personaRecibeDocumento.present) {
      map['persona_recibe_documento'] = Variable<String>(
        personaRecibeDocumento.value,
      );
    }
    if (checkConformidad.present) {
      map['check_conformidad'] = Variable<bool>(checkConformidad.value);
    }
    if (fechaEntrega.present) {
      map['fecha_entrega'] = Variable<DateTime>(fechaEntrega.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormatoActaEntregaTableCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('estadoOperatividad: $estadoOperatividad, ')
          ..write('observaciones: $observaciones, ')
          ..write('recomendacionesCuidado: $recomendacionesCuidado, ')
          ..write('garantiaDias: $garantiaDias, ')
          ..write('personaRecibeNombre: $personaRecibeNombre, ')
          ..write('personaRecibeDocumento: $personaRecibeDocumento, ')
          ..write('checkConformidad: $checkConformidad, ')
          ..write('fechaEntrega: $fechaEntrega')
          ..write(')'))
        .toString();
  }
}

class $FotosEvidenciaTableTable extends FotosEvidenciaTable
    with TableInfo<$FotosEvidenciaTableTable, FotosEvidenciaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FotosEvidenciaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ordenIdMeta = const VerificationMeta(
    'ordenId',
  );
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
    'orden_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordenes_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _etapaMeta = const VerificationMeta('etapa');
  @override
  late final GeneratedColumn<String> etapa = GeneratedColumn<String>(
    'etapa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutaOBytesBase64Meta = const VerificationMeta(
    'rutaOBytesBase64',
  );
  @override
  late final GeneratedColumn<String> rutaOBytesBase64 = GeneratedColumn<String>(
    'ruta_o_bytes_base64',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notaTecnicaMeta = const VerificationMeta(
    'notaTecnica',
  );
  @override
  late final GeneratedColumn<String> notaTecnica = GeneratedColumn<String>(
    'nota_tecnica',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaCapturaMeta = const VerificationMeta(
    'fechaCaptura',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCaptura = GeneratedColumn<DateTime>(
    'fecha_captura',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ordenId,
    etapa,
    rutaOBytesBase64,
    notaTecnica,
    fechaCaptura,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fotos_evidencia_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FotosEvidenciaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(
        _ordenIdMeta,
        ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('etapa')) {
      context.handle(
        _etapaMeta,
        etapa.isAcceptableOrUnknown(data['etapa']!, _etapaMeta),
      );
    } else if (isInserting) {
      context.missing(_etapaMeta);
    }
    if (data.containsKey('ruta_o_bytes_base64')) {
      context.handle(
        _rutaOBytesBase64Meta,
        rutaOBytesBase64.isAcceptableOrUnknown(
          data['ruta_o_bytes_base64']!,
          _rutaOBytesBase64Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rutaOBytesBase64Meta);
    }
    if (data.containsKey('nota_tecnica')) {
      context.handle(
        _notaTecnicaMeta,
        notaTecnica.isAcceptableOrUnknown(
          data['nota_tecnica']!,
          _notaTecnicaMeta,
        ),
      );
    }
    if (data.containsKey('fecha_captura')) {
      context.handle(
        _fechaCapturaMeta,
        fechaCaptura.isAcceptableOrUnknown(
          data['fecha_captura']!,
          _fechaCapturaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FotosEvidenciaTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FotosEvidenciaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ordenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden_id'],
      )!,
      etapa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etapa'],
      )!,
      rutaOBytesBase64: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruta_o_bytes_base64'],
      )!,
      notaTecnica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota_tecnica'],
      ),
      fechaCaptura: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_captura'],
      )!,
    );
  }

  @override
  $FotosEvidenciaTableTable createAlias(String alias) {
    return $FotosEvidenciaTableTable(attachedDatabase, alias);
  }
}

class FotosEvidenciaTableData extends DataClass
    implements Insertable<FotosEvidenciaTableData> {
  final int id;
  final int ordenId;
  final String etapa;
  final String rutaOBytesBase64;
  final String? notaTecnica;
  final DateTime fechaCaptura;
  const FotosEvidenciaTableData({
    required this.id,
    required this.ordenId,
    required this.etapa,
    required this.rutaOBytesBase64,
    this.notaTecnica,
    required this.fechaCaptura,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['etapa'] = Variable<String>(etapa);
    map['ruta_o_bytes_base64'] = Variable<String>(rutaOBytesBase64);
    if (!nullToAbsent || notaTecnica != null) {
      map['nota_tecnica'] = Variable<String>(notaTecnica);
    }
    map['fecha_captura'] = Variable<DateTime>(fechaCaptura);
    return map;
  }

  FotosEvidenciaTableCompanion toCompanion(bool nullToAbsent) {
    return FotosEvidenciaTableCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      etapa: Value(etapa),
      rutaOBytesBase64: Value(rutaOBytesBase64),
      notaTecnica: notaTecnica == null && nullToAbsent
          ? const Value.absent()
          : Value(notaTecnica),
      fechaCaptura: Value(fechaCaptura),
    );
  }

  factory FotosEvidenciaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FotosEvidenciaTableData(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      etapa: serializer.fromJson<String>(json['etapa']),
      rutaOBytesBase64: serializer.fromJson<String>(json['rutaOBytesBase64']),
      notaTecnica: serializer.fromJson<String?>(json['notaTecnica']),
      fechaCaptura: serializer.fromJson<DateTime>(json['fechaCaptura']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'etapa': serializer.toJson<String>(etapa),
      'rutaOBytesBase64': serializer.toJson<String>(rutaOBytesBase64),
      'notaTecnica': serializer.toJson<String?>(notaTecnica),
      'fechaCaptura': serializer.toJson<DateTime>(fechaCaptura),
    };
  }

  FotosEvidenciaTableData copyWith({
    int? id,
    int? ordenId,
    String? etapa,
    String? rutaOBytesBase64,
    Value<String?> notaTecnica = const Value.absent(),
    DateTime? fechaCaptura,
  }) => FotosEvidenciaTableData(
    id: id ?? this.id,
    ordenId: ordenId ?? this.ordenId,
    etapa: etapa ?? this.etapa,
    rutaOBytesBase64: rutaOBytesBase64 ?? this.rutaOBytesBase64,
    notaTecnica: notaTecnica.present ? notaTecnica.value : this.notaTecnica,
    fechaCaptura: fechaCaptura ?? this.fechaCaptura,
  );
  FotosEvidenciaTableData copyWithCompanion(FotosEvidenciaTableCompanion data) {
    return FotosEvidenciaTableData(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      etapa: data.etapa.present ? data.etapa.value : this.etapa,
      rutaOBytesBase64: data.rutaOBytesBase64.present
          ? data.rutaOBytesBase64.value
          : this.rutaOBytesBase64,
      notaTecnica: data.notaTecnica.present
          ? data.notaTecnica.value
          : this.notaTecnica,
      fechaCaptura: data.fechaCaptura.present
          ? data.fechaCaptura.value
          : this.fechaCaptura,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FotosEvidenciaTableData(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('etapa: $etapa, ')
          ..write('rutaOBytesBase64: $rutaOBytesBase64, ')
          ..write('notaTecnica: $notaTecnica, ')
          ..write('fechaCaptura: $fechaCaptura')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ordenId,
    etapa,
    rutaOBytesBase64,
    notaTecnica,
    fechaCaptura,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FotosEvidenciaTableData &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.etapa == this.etapa &&
          other.rutaOBytesBase64 == this.rutaOBytesBase64 &&
          other.notaTecnica == this.notaTecnica &&
          other.fechaCaptura == this.fechaCaptura);
}

class FotosEvidenciaTableCompanion
    extends UpdateCompanion<FotosEvidenciaTableData> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<String> etapa;
  final Value<String> rutaOBytesBase64;
  final Value<String?> notaTecnica;
  final Value<DateTime> fechaCaptura;
  const FotosEvidenciaTableCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.etapa = const Value.absent(),
    this.rutaOBytesBase64 = const Value.absent(),
    this.notaTecnica = const Value.absent(),
    this.fechaCaptura = const Value.absent(),
  });
  FotosEvidenciaTableCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    required String etapa,
    required String rutaOBytesBase64,
    this.notaTecnica = const Value.absent(),
    this.fechaCaptura = const Value.absent(),
  }) : ordenId = Value(ordenId),
       etapa = Value(etapa),
       rutaOBytesBase64 = Value(rutaOBytesBase64);
  static Insertable<FotosEvidenciaTableData> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<String>? etapa,
    Expression<String>? rutaOBytesBase64,
    Expression<String>? notaTecnica,
    Expression<DateTime>? fechaCaptura,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (etapa != null) 'etapa': etapa,
      if (rutaOBytesBase64 != null) 'ruta_o_bytes_base64': rutaOBytesBase64,
      if (notaTecnica != null) 'nota_tecnica': notaTecnica,
      if (fechaCaptura != null) 'fecha_captura': fechaCaptura,
    });
  }

  FotosEvidenciaTableCompanion copyWith({
    Value<int>? id,
    Value<int>? ordenId,
    Value<String>? etapa,
    Value<String>? rutaOBytesBase64,
    Value<String?>? notaTecnica,
    Value<DateTime>? fechaCaptura,
  }) {
    return FotosEvidenciaTableCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      etapa: etapa ?? this.etapa,
      rutaOBytesBase64: rutaOBytesBase64 ?? this.rutaOBytesBase64,
      notaTecnica: notaTecnica ?? this.notaTecnica,
      fechaCaptura: fechaCaptura ?? this.fechaCaptura,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (etapa.present) {
      map['etapa'] = Variable<String>(etapa.value);
    }
    if (rutaOBytesBase64.present) {
      map['ruta_o_bytes_base64'] = Variable<String>(rutaOBytesBase64.value);
    }
    if (notaTecnica.present) {
      map['nota_tecnica'] = Variable<String>(notaTecnica.value);
    }
    if (fechaCaptura.present) {
      map['fecha_captura'] = Variable<DateTime>(fechaCaptura.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FotosEvidenciaTableCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('etapa: $etapa, ')
          ..write('rutaOBytesBase64: $rutaOBytesBase64, ')
          ..write('notaTecnica: $notaTecnica, ')
          ..write('fechaCaptura: $fechaCaptura')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracionEmpresaTableTable extends ConfiguracionEmpresaTable
    with
        TableInfo<
          $ConfiguracionEmpresaTableTable,
          ConfiguracionEmpresaTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracionEmpresaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreEmpresaMeta = const VerificationMeta(
    'nombreEmpresa',
  );
  @override
  late final GeneratedColumn<String> nombreEmpresa = GeneratedColumn<String>(
    'nombre_empresa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Centro de Soporte & Mantenimiento'),
  );
  static const VerificationMeta _sloganMeta = const VerificationMeta('slogan');
  @override
  late final GeneratedColumn<String> slogan = GeneratedColumn<String>(
    'slogan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Para un equipo saludable CONTACTANOS'),
  );
  static const VerificationMeta _nitMeta = const VerificationMeta('nit');
  @override
  late final GeneratedColumn<String> nit = GeneratedColumn<String>(
    'nit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('900.000.000-1'),
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('+57 310 000 0000'),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('soporte@empresa.com'),
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Avenida Principal # 12-34'),
  );
  static const VerificationMeta _ciudadMeta = const VerificationMeta('ciudad');
  @override
  late final GeneratedColumn<String> ciudad = GeneratedColumn<String>(
    'ciudad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Colombia'),
  );
  static const VerificationMeta _logoBase64Meta = const VerificationMeta(
    'logoBase64',
  );
  @override
  late final GeneratedColumn<String> logoBase64 = GeneratedColumn<String>(
    'logo_base64',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _smtpHostMeta = const VerificationMeta(
    'smtpHost',
  );
  @override
  late final GeneratedColumn<String> smtpHost = GeneratedColumn<String>(
    'smtp_host',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _smtpPortMeta = const VerificationMeta(
    'smtpPort',
  );
  @override
  late final GeneratedColumn<int> smtpPort = GeneratedColumn<int>(
    'smtp_port',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _smtpUserMeta = const VerificationMeta(
    'smtpUser',
  );
  @override
  late final GeneratedColumn<String> smtpUser = GeneratedColumn<String>(
    'smtp_user',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _smtpPassMeta = const VerificationMeta(
    'smtpPass',
  );
  @override
  late final GeneratedColumn<String> smtpPass = GeneratedColumn<String>(
    'smtp_pass',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorPrimarioMeta = const VerificationMeta(
    'colorPrimario',
  );
  @override
  late final GeneratedColumn<String> colorPrimario = GeneratedColumn<String>(
    'color_primario',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#1E3A8A'),
  );
  static const VerificationMeta _colorSecundarioMeta = const VerificationMeta(
    'colorSecundario',
  );
  @override
  late final GeneratedColumn<String> colorSecundario = GeneratedColumn<String>(
    'color_secundario',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#0284C7'),
  );
  static const VerificationMeta _isSetupCompletedMeta = const VerificationMeta(
    'isSetupCompleted',
  );
  @override
  late final GeneratedColumn<bool> isSetupCompleted = GeneratedColumn<bool>(
    'is_setup_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_setup_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombreEmpresa,
    slogan,
    nit,
    telefono,
    email,
    direccion,
    ciudad,
    logoBase64,
    smtpHost,
    smtpPort,
    smtpUser,
    smtpPass,
    colorPrimario,
    colorSecundario,
    isSetupCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracion_empresa_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfiguracionEmpresaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre_empresa')) {
      context.handle(
        _nombreEmpresaMeta,
        nombreEmpresa.isAcceptableOrUnknown(
          data['nombre_empresa']!,
          _nombreEmpresaMeta,
        ),
      );
    }
    if (data.containsKey('slogan')) {
      context.handle(
        _sloganMeta,
        slogan.isAcceptableOrUnknown(data['slogan']!, _sloganMeta),
      );
    }
    if (data.containsKey('nit')) {
      context.handle(
        _nitMeta,
        nit.isAcceptableOrUnknown(data['nit']!, _nitMeta),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    if (data.containsKey('ciudad')) {
      context.handle(
        _ciudadMeta,
        ciudad.isAcceptableOrUnknown(data['ciudad']!, _ciudadMeta),
      );
    }
    if (data.containsKey('logo_base64')) {
      context.handle(
        _logoBase64Meta,
        logoBase64.isAcceptableOrUnknown(data['logo_base64']!, _logoBase64Meta),
      );
    }
    if (data.containsKey('smtp_host')) {
      context.handle(
        _smtpHostMeta,
        smtpHost.isAcceptableOrUnknown(data['smtp_host']!, _smtpHostMeta),
      );
    }
    if (data.containsKey('smtp_port')) {
      context.handle(
        _smtpPortMeta,
        smtpPort.isAcceptableOrUnknown(data['smtp_port']!, _smtpPortMeta),
      );
    }
    if (data.containsKey('smtp_user')) {
      context.handle(
        _smtpUserMeta,
        smtpUser.isAcceptableOrUnknown(data['smtp_user']!, _smtpUserMeta),
      );
    }
    if (data.containsKey('smtp_pass')) {
      context.handle(
        _smtpPassMeta,
        smtpPass.isAcceptableOrUnknown(data['smtp_pass']!, _smtpPassMeta),
      );
    }
    if (data.containsKey('color_primario')) {
      context.handle(
        _colorPrimarioMeta,
        colorPrimario.isAcceptableOrUnknown(
          data['color_primario']!,
          _colorPrimarioMeta,
        ),
      );
    }
    if (data.containsKey('color_secundario')) {
      context.handle(
        _colorSecundarioMeta,
        colorSecundario.isAcceptableOrUnknown(
          data['color_secundario']!,
          _colorSecundarioMeta,
        ),
      );
    }
    if (data.containsKey('is_setup_completed')) {
      context.handle(
        _isSetupCompletedMeta,
        isSetupCompleted.isAcceptableOrUnknown(
          data['is_setup_completed']!,
          _isSetupCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracionEmpresaTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracionEmpresaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombreEmpresa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_empresa'],
      )!,
      slogan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slogan'],
      )!,
      nit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nit'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      ciudad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ciudad'],
      )!,
      logoBase64: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_base64'],
      ),
      smtpHost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}smtp_host'],
      ),
      smtpPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}smtp_port'],
      ),
      smtpUser: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}smtp_user'],
      ),
      smtpPass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}smtp_pass'],
      ),
      colorPrimario: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_primario'],
      )!,
      colorSecundario: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_secundario'],
      )!,
      isSetupCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_setup_completed'],
      )!,
    );
  }

  @override
  $ConfiguracionEmpresaTableTable createAlias(String alias) {
    return $ConfiguracionEmpresaTableTable(attachedDatabase, alias);
  }
}

class ConfiguracionEmpresaTableData extends DataClass
    implements Insertable<ConfiguracionEmpresaTableData> {
  final int id;
  final String nombreEmpresa;
  final String slogan;
  final String nit;
  final String telefono;
  final String email;
  final String direccion;
  final String ciudad;
  final String? logoBase64;
  final String? smtpHost;
  final int? smtpPort;
  final String? smtpUser;
  final String? smtpPass;
  final String colorPrimario;
  final String colorSecundario;
  final bool isSetupCompleted;
  const ConfiguracionEmpresaTableData({
    required this.id,
    required this.nombreEmpresa,
    required this.slogan,
    required this.nit,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.ciudad,
    this.logoBase64,
    this.smtpHost,
    this.smtpPort,
    this.smtpUser,
    this.smtpPass,
    required this.colorPrimario,
    required this.colorSecundario,
    required this.isSetupCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre_empresa'] = Variable<String>(nombreEmpresa);
    map['slogan'] = Variable<String>(slogan);
    map['nit'] = Variable<String>(nit);
    map['telefono'] = Variable<String>(telefono);
    map['email'] = Variable<String>(email);
    map['direccion'] = Variable<String>(direccion);
    map['ciudad'] = Variable<String>(ciudad);
    if (!nullToAbsent || logoBase64 != null) {
      map['logo_base64'] = Variable<String>(logoBase64);
    }
    if (!nullToAbsent || smtpHost != null) {
      map['smtp_host'] = Variable<String>(smtpHost);
    }
    if (!nullToAbsent || smtpPort != null) {
      map['smtp_port'] = Variable<int>(smtpPort);
    }
    if (!nullToAbsent || smtpUser != null) {
      map['smtp_user'] = Variable<String>(smtpUser);
    }
    if (!nullToAbsent || smtpPass != null) {
      map['smtp_pass'] = Variable<String>(smtpPass);
    }
    map['color_primario'] = Variable<String>(colorPrimario);
    map['color_secundario'] = Variable<String>(colorSecundario);
    map['is_setup_completed'] = Variable<bool>(isSetupCompleted);
    return map;
  }

  ConfiguracionEmpresaTableCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracionEmpresaTableCompanion(
      id: Value(id),
      nombreEmpresa: Value(nombreEmpresa),
      slogan: Value(slogan),
      nit: Value(nit),
      telefono: Value(telefono),
      email: Value(email),
      direccion: Value(direccion),
      ciudad: Value(ciudad),
      logoBase64: logoBase64 == null && nullToAbsent
          ? const Value.absent()
          : Value(logoBase64),
      smtpHost: smtpHost == null && nullToAbsent
          ? const Value.absent()
          : Value(smtpHost),
      smtpPort: smtpPort == null && nullToAbsent
          ? const Value.absent()
          : Value(smtpPort),
      smtpUser: smtpUser == null && nullToAbsent
          ? const Value.absent()
          : Value(smtpUser),
      smtpPass: smtpPass == null && nullToAbsent
          ? const Value.absent()
          : Value(smtpPass),
      colorPrimario: Value(colorPrimario),
      colorSecundario: Value(colorSecundario),
      isSetupCompleted: Value(isSetupCompleted),
    );
  }

  factory ConfiguracionEmpresaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracionEmpresaTableData(
      id: serializer.fromJson<int>(json['id']),
      nombreEmpresa: serializer.fromJson<String>(json['nombreEmpresa']),
      slogan: serializer.fromJson<String>(json['slogan']),
      nit: serializer.fromJson<String>(json['nit']),
      telefono: serializer.fromJson<String>(json['telefono']),
      email: serializer.fromJson<String>(json['email']),
      direccion: serializer.fromJson<String>(json['direccion']),
      ciudad: serializer.fromJson<String>(json['ciudad']),
      logoBase64: serializer.fromJson<String?>(json['logoBase64']),
      smtpHost: serializer.fromJson<String?>(json['smtpHost']),
      smtpPort: serializer.fromJson<int?>(json['smtpPort']),
      smtpUser: serializer.fromJson<String?>(json['smtpUser']),
      smtpPass: serializer.fromJson<String?>(json['smtpPass']),
      colorPrimario: serializer.fromJson<String>(json['colorPrimario']),
      colorSecundario: serializer.fromJson<String>(json['colorSecundario']),
      isSetupCompleted: serializer.fromJson<bool>(json['isSetupCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombreEmpresa': serializer.toJson<String>(nombreEmpresa),
      'slogan': serializer.toJson<String>(slogan),
      'nit': serializer.toJson<String>(nit),
      'telefono': serializer.toJson<String>(telefono),
      'email': serializer.toJson<String>(email),
      'direccion': serializer.toJson<String>(direccion),
      'ciudad': serializer.toJson<String>(ciudad),
      'logoBase64': serializer.toJson<String?>(logoBase64),
      'smtpHost': serializer.toJson<String?>(smtpHost),
      'smtpPort': serializer.toJson<int?>(smtpPort),
      'smtpUser': serializer.toJson<String?>(smtpUser),
      'smtpPass': serializer.toJson<String?>(smtpPass),
      'colorPrimario': serializer.toJson<String>(colorPrimario),
      'colorSecundario': serializer.toJson<String>(colorSecundario),
      'isSetupCompleted': serializer.toJson<bool>(isSetupCompleted),
    };
  }

  ConfiguracionEmpresaTableData copyWith({
    int? id,
    String? nombreEmpresa,
    String? slogan,
    String? nit,
    String? telefono,
    String? email,
    String? direccion,
    String? ciudad,
    Value<String?> logoBase64 = const Value.absent(),
    Value<String?> smtpHost = const Value.absent(),
    Value<int?> smtpPort = const Value.absent(),
    Value<String?> smtpUser = const Value.absent(),
    Value<String?> smtpPass = const Value.absent(),
    String? colorPrimario,
    String? colorSecundario,
    bool? isSetupCompleted,
  }) => ConfiguracionEmpresaTableData(
    id: id ?? this.id,
    nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
    slogan: slogan ?? this.slogan,
    nit: nit ?? this.nit,
    telefono: telefono ?? this.telefono,
    email: email ?? this.email,
    direccion: direccion ?? this.direccion,
    ciudad: ciudad ?? this.ciudad,
    logoBase64: logoBase64.present ? logoBase64.value : this.logoBase64,
    smtpHost: smtpHost.present ? smtpHost.value : this.smtpHost,
    smtpPort: smtpPort.present ? smtpPort.value : this.smtpPort,
    smtpUser: smtpUser.present ? smtpUser.value : this.smtpUser,
    smtpPass: smtpPass.present ? smtpPass.value : this.smtpPass,
    colorPrimario: colorPrimario ?? this.colorPrimario,
    colorSecundario: colorSecundario ?? this.colorSecundario,
    isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
  );
  ConfiguracionEmpresaTableData copyWithCompanion(
    ConfiguracionEmpresaTableCompanion data,
  ) {
    return ConfiguracionEmpresaTableData(
      id: data.id.present ? data.id.value : this.id,
      nombreEmpresa: data.nombreEmpresa.present
          ? data.nombreEmpresa.value
          : this.nombreEmpresa,
      slogan: data.slogan.present ? data.slogan.value : this.slogan,
      nit: data.nit.present ? data.nit.value : this.nit,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      ciudad: data.ciudad.present ? data.ciudad.value : this.ciudad,
      logoBase64: data.logoBase64.present
          ? data.logoBase64.value
          : this.logoBase64,
      smtpHost: data.smtpHost.present ? data.smtpHost.value : this.smtpHost,
      smtpPort: data.smtpPort.present ? data.smtpPort.value : this.smtpPort,
      smtpUser: data.smtpUser.present ? data.smtpUser.value : this.smtpUser,
      smtpPass: data.smtpPass.present ? data.smtpPass.value : this.smtpPass,
      colorPrimario: data.colorPrimario.present
          ? data.colorPrimario.value
          : this.colorPrimario,
      colorSecundario: data.colorSecundario.present
          ? data.colorSecundario.value
          : this.colorSecundario,
      isSetupCompleted: data.isSetupCompleted.present
          ? data.isSetupCompleted.value
          : this.isSetupCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionEmpresaTableData(')
          ..write('id: $id, ')
          ..write('nombreEmpresa: $nombreEmpresa, ')
          ..write('slogan: $slogan, ')
          ..write('nit: $nit, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('ciudad: $ciudad, ')
          ..write('logoBase64: $logoBase64, ')
          ..write('smtpHost: $smtpHost, ')
          ..write('smtpPort: $smtpPort, ')
          ..write('smtpUser: $smtpUser, ')
          ..write('smtpPass: $smtpPass, ')
          ..write('colorPrimario: $colorPrimario, ')
          ..write('colorSecundario: $colorSecundario, ')
          ..write('isSetupCompleted: $isSetupCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombreEmpresa,
    slogan,
    nit,
    telefono,
    email,
    direccion,
    ciudad,
    logoBase64,
    smtpHost,
    smtpPort,
    smtpUser,
    smtpPass,
    colorPrimario,
    colorSecundario,
    isSetupCompleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracionEmpresaTableData &&
          other.id == this.id &&
          other.nombreEmpresa == this.nombreEmpresa &&
          other.slogan == this.slogan &&
          other.nit == this.nit &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.direccion == this.direccion &&
          other.ciudad == this.ciudad &&
          other.logoBase64 == this.logoBase64 &&
          other.smtpHost == this.smtpHost &&
          other.smtpPort == this.smtpPort &&
          other.smtpUser == this.smtpUser &&
          other.smtpPass == this.smtpPass &&
          other.colorPrimario == this.colorPrimario &&
          other.colorSecundario == this.colorSecundario &&
          other.isSetupCompleted == this.isSetupCompleted);
}

class ConfiguracionEmpresaTableCompanion
    extends UpdateCompanion<ConfiguracionEmpresaTableData> {
  final Value<int> id;
  final Value<String> nombreEmpresa;
  final Value<String> slogan;
  final Value<String> nit;
  final Value<String> telefono;
  final Value<String> email;
  final Value<String> direccion;
  final Value<String> ciudad;
  final Value<String?> logoBase64;
  final Value<String?> smtpHost;
  final Value<int?> smtpPort;
  final Value<String?> smtpUser;
  final Value<String?> smtpPass;
  final Value<String> colorPrimario;
  final Value<String> colorSecundario;
  final Value<bool> isSetupCompleted;
  const ConfiguracionEmpresaTableCompanion({
    this.id = const Value.absent(),
    this.nombreEmpresa = const Value.absent(),
    this.slogan = const Value.absent(),
    this.nit = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.logoBase64 = const Value.absent(),
    this.smtpHost = const Value.absent(),
    this.smtpPort = const Value.absent(),
    this.smtpUser = const Value.absent(),
    this.smtpPass = const Value.absent(),
    this.colorPrimario = const Value.absent(),
    this.colorSecundario = const Value.absent(),
    this.isSetupCompleted = const Value.absent(),
  });
  ConfiguracionEmpresaTableCompanion.insert({
    this.id = const Value.absent(),
    this.nombreEmpresa = const Value.absent(),
    this.slogan = const Value.absent(),
    this.nit = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.logoBase64 = const Value.absent(),
    this.smtpHost = const Value.absent(),
    this.smtpPort = const Value.absent(),
    this.smtpUser = const Value.absent(),
    this.smtpPass = const Value.absent(),
    this.colorPrimario = const Value.absent(),
    this.colorSecundario = const Value.absent(),
    this.isSetupCompleted = const Value.absent(),
  });
  static Insertable<ConfiguracionEmpresaTableData> custom({
    Expression<int>? id,
    Expression<String>? nombreEmpresa,
    Expression<String>? slogan,
    Expression<String>? nit,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? direccion,
    Expression<String>? ciudad,
    Expression<String>? logoBase64,
    Expression<String>? smtpHost,
    Expression<int>? smtpPort,
    Expression<String>? smtpUser,
    Expression<String>? smtpPass,
    Expression<String>? colorPrimario,
    Expression<String>? colorSecundario,
    Expression<bool>? isSetupCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombreEmpresa != null) 'nombre_empresa': nombreEmpresa,
      if (slogan != null) 'slogan': slogan,
      if (nit != null) 'nit': nit,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (direccion != null) 'direccion': direccion,
      if (ciudad != null) 'ciudad': ciudad,
      if (logoBase64 != null) 'logo_base64': logoBase64,
      if (smtpHost != null) 'smtp_host': smtpHost,
      if (smtpPort != null) 'smtp_port': smtpPort,
      if (smtpUser != null) 'smtp_user': smtpUser,
      if (smtpPass != null) 'smtp_pass': smtpPass,
      if (colorPrimario != null) 'color_primario': colorPrimario,
      if (colorSecundario != null) 'color_secundario': colorSecundario,
      if (isSetupCompleted != null) 'is_setup_completed': isSetupCompleted,
    });
  }

  ConfiguracionEmpresaTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nombreEmpresa,
    Value<String>? slogan,
    Value<String>? nit,
    Value<String>? telefono,
    Value<String>? email,
    Value<String>? direccion,
    Value<String>? ciudad,
    Value<String?>? logoBase64,
    Value<String?>? smtpHost,
    Value<int?>? smtpPort,
    Value<String?>? smtpUser,
    Value<String?>? smtpPass,
    Value<String>? colorPrimario,
    Value<String>? colorSecundario,
    Value<bool>? isSetupCompleted,
  }) {
    return ConfiguracionEmpresaTableCompanion(
      id: id ?? this.id,
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      slogan: slogan ?? this.slogan,
      nit: nit ?? this.nit,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      logoBase64: logoBase64 ?? this.logoBase64,
      smtpHost: smtpHost ?? this.smtpHost,
      smtpPort: smtpPort ?? this.smtpPort,
      smtpUser: smtpUser ?? this.smtpUser,
      smtpPass: smtpPass ?? this.smtpPass,
      colorPrimario: colorPrimario ?? this.colorPrimario,
      colorSecundario: colorSecundario ?? this.colorSecundario,
      isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombreEmpresa.present) {
      map['nombre_empresa'] = Variable<String>(nombreEmpresa.value);
    }
    if (slogan.present) {
      map['slogan'] = Variable<String>(slogan.value);
    }
    if (nit.present) {
      map['nit'] = Variable<String>(nit.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (ciudad.present) {
      map['ciudad'] = Variable<String>(ciudad.value);
    }
    if (logoBase64.present) {
      map['logo_base64'] = Variable<String>(logoBase64.value);
    }
    if (smtpHost.present) {
      map['smtp_host'] = Variable<String>(smtpHost.value);
    }
    if (smtpPort.present) {
      map['smtp_port'] = Variable<int>(smtpPort.value);
    }
    if (smtpUser.present) {
      map['smtp_user'] = Variable<String>(smtpUser.value);
    }
    if (smtpPass.present) {
      map['smtp_pass'] = Variable<String>(smtpPass.value);
    }
    if (colorPrimario.present) {
      map['color_primario'] = Variable<String>(colorPrimario.value);
    }
    if (colorSecundario.present) {
      map['color_secundario'] = Variable<String>(colorSecundario.value);
    }
    if (isSetupCompleted.present) {
      map['is_setup_completed'] = Variable<bool>(isSetupCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionEmpresaTableCompanion(')
          ..write('id: $id, ')
          ..write('nombreEmpresa: $nombreEmpresa, ')
          ..write('slogan: $slogan, ')
          ..write('nit: $nit, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('ciudad: $ciudad, ')
          ..write('logoBase64: $logoBase64, ')
          ..write('smtpHost: $smtpHost, ')
          ..write('smtpPort: $smtpPort, ')
          ..write('smtpUser: $smtpUser, ')
          ..write('smtpPass: $smtpPass, ')
          ..write('colorPrimario: $colorPrimario, ')
          ..write('colorSecundario: $colorSecundario, ')
          ..write('isSetupCompleted: $isSetupCompleted')
          ..write(')'))
        .toString();
  }
}

class $NotificacionesAuditoriaTableTable extends NotificacionesAuditoriaTable
    with
        TableInfo<
          $NotificacionesAuditoriaTableTable,
          NotificacionesAuditoriaTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificacionesAuditoriaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _destinatarioMeta = const VerificationMeta(
    'destinatario',
  );
  @override
  late final GeneratedColumn<String> destinatario = GeneratedColumn<String>(
    'destinatario',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _asuntoMeta = const VerificationMeta('asunto');
  @override
  late final GeneratedColumn<String> asunto = GeneratedColumn<String>(
    'asunto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventoMeta = const VerificationMeta('evento');
  @override
  late final GeneratedColumn<String> evento = GeneratedColumn<String>(
    'evento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaEnvioMeta = const VerificationMeta(
    'fechaEnvio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaEnvio = GeneratedColumn<DateTime>(
    'fecha_envio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    destinatario,
    asunto,
    evento,
    estado,
    fechaEnvio,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notificaciones_auditoria_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificacionesAuditoriaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('destinatario')) {
      context.handle(
        _destinatarioMeta,
        destinatario.isAcceptableOrUnknown(
          data['destinatario']!,
          _destinatarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinatarioMeta);
    }
    if (data.containsKey('asunto')) {
      context.handle(
        _asuntoMeta,
        asunto.isAcceptableOrUnknown(data['asunto']!, _asuntoMeta),
      );
    } else if (isInserting) {
      context.missing(_asuntoMeta);
    }
    if (data.containsKey('evento')) {
      context.handle(
        _eventoMeta,
        evento.isAcceptableOrUnknown(data['evento']!, _eventoMeta),
      );
    } else if (isInserting) {
      context.missing(_eventoMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('fecha_envio')) {
      context.handle(
        _fechaEnvioMeta,
        fechaEnvio.isAcceptableOrUnknown(data['fecha_envio']!, _fechaEnvioMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificacionesAuditoriaTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificacionesAuditoriaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      destinatario: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destinatario'],
      )!,
      asunto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asunto'],
      )!,
      evento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evento'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      fechaEnvio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_envio'],
      )!,
    );
  }

  @override
  $NotificacionesAuditoriaTableTable createAlias(String alias) {
    return $NotificacionesAuditoriaTableTable(attachedDatabase, alias);
  }
}

class NotificacionesAuditoriaTableData extends DataClass
    implements Insertable<NotificacionesAuditoriaTableData> {
  final int id;
  final String destinatario;
  final String asunto;
  final String evento;
  final String estado;
  final DateTime fechaEnvio;
  const NotificacionesAuditoriaTableData({
    required this.id,
    required this.destinatario,
    required this.asunto,
    required this.evento,
    required this.estado,
    required this.fechaEnvio,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['destinatario'] = Variable<String>(destinatario);
    map['asunto'] = Variable<String>(asunto);
    map['evento'] = Variable<String>(evento);
    map['estado'] = Variable<String>(estado);
    map['fecha_envio'] = Variable<DateTime>(fechaEnvio);
    return map;
  }

  NotificacionesAuditoriaTableCompanion toCompanion(bool nullToAbsent) {
    return NotificacionesAuditoriaTableCompanion(
      id: Value(id),
      destinatario: Value(destinatario),
      asunto: Value(asunto),
      evento: Value(evento),
      estado: Value(estado),
      fechaEnvio: Value(fechaEnvio),
    );
  }

  factory NotificacionesAuditoriaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificacionesAuditoriaTableData(
      id: serializer.fromJson<int>(json['id']),
      destinatario: serializer.fromJson<String>(json['destinatario']),
      asunto: serializer.fromJson<String>(json['asunto']),
      evento: serializer.fromJson<String>(json['evento']),
      estado: serializer.fromJson<String>(json['estado']),
      fechaEnvio: serializer.fromJson<DateTime>(json['fechaEnvio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'destinatario': serializer.toJson<String>(destinatario),
      'asunto': serializer.toJson<String>(asunto),
      'evento': serializer.toJson<String>(evento),
      'estado': serializer.toJson<String>(estado),
      'fechaEnvio': serializer.toJson<DateTime>(fechaEnvio),
    };
  }

  NotificacionesAuditoriaTableData copyWith({
    int? id,
    String? destinatario,
    String? asunto,
    String? evento,
    String? estado,
    DateTime? fechaEnvio,
  }) => NotificacionesAuditoriaTableData(
    id: id ?? this.id,
    destinatario: destinatario ?? this.destinatario,
    asunto: asunto ?? this.asunto,
    evento: evento ?? this.evento,
    estado: estado ?? this.estado,
    fechaEnvio: fechaEnvio ?? this.fechaEnvio,
  );
  NotificacionesAuditoriaTableData copyWithCompanion(
    NotificacionesAuditoriaTableCompanion data,
  ) {
    return NotificacionesAuditoriaTableData(
      id: data.id.present ? data.id.value : this.id,
      destinatario: data.destinatario.present
          ? data.destinatario.value
          : this.destinatario,
      asunto: data.asunto.present ? data.asunto.value : this.asunto,
      evento: data.evento.present ? data.evento.value : this.evento,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaEnvio: data.fechaEnvio.present
          ? data.fechaEnvio.value
          : this.fechaEnvio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificacionesAuditoriaTableData(')
          ..write('id: $id, ')
          ..write('destinatario: $destinatario, ')
          ..write('asunto: $asunto, ')
          ..write('evento: $evento, ')
          ..write('estado: $estado, ')
          ..write('fechaEnvio: $fechaEnvio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, destinatario, asunto, evento, estado, fechaEnvio);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificacionesAuditoriaTableData &&
          other.id == this.id &&
          other.destinatario == this.destinatario &&
          other.asunto == this.asunto &&
          other.evento == this.evento &&
          other.estado == this.estado &&
          other.fechaEnvio == this.fechaEnvio);
}

class NotificacionesAuditoriaTableCompanion
    extends UpdateCompanion<NotificacionesAuditoriaTableData> {
  final Value<int> id;
  final Value<String> destinatario;
  final Value<String> asunto;
  final Value<String> evento;
  final Value<String> estado;
  final Value<DateTime> fechaEnvio;
  const NotificacionesAuditoriaTableCompanion({
    this.id = const Value.absent(),
    this.destinatario = const Value.absent(),
    this.asunto = const Value.absent(),
    this.evento = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaEnvio = const Value.absent(),
  });
  NotificacionesAuditoriaTableCompanion.insert({
    this.id = const Value.absent(),
    required String destinatario,
    required String asunto,
    required String evento,
    required String estado,
    this.fechaEnvio = const Value.absent(),
  }) : destinatario = Value(destinatario),
       asunto = Value(asunto),
       evento = Value(evento),
       estado = Value(estado);
  static Insertable<NotificacionesAuditoriaTableData> custom({
    Expression<int>? id,
    Expression<String>? destinatario,
    Expression<String>? asunto,
    Expression<String>? evento,
    Expression<String>? estado,
    Expression<DateTime>? fechaEnvio,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (destinatario != null) 'destinatario': destinatario,
      if (asunto != null) 'asunto': asunto,
      if (evento != null) 'evento': evento,
      if (estado != null) 'estado': estado,
      if (fechaEnvio != null) 'fecha_envio': fechaEnvio,
    });
  }

  NotificacionesAuditoriaTableCompanion copyWith({
    Value<int>? id,
    Value<String>? destinatario,
    Value<String>? asunto,
    Value<String>? evento,
    Value<String>? estado,
    Value<DateTime>? fechaEnvio,
  }) {
    return NotificacionesAuditoriaTableCompanion(
      id: id ?? this.id,
      destinatario: destinatario ?? this.destinatario,
      asunto: asunto ?? this.asunto,
      evento: evento ?? this.evento,
      estado: estado ?? this.estado,
      fechaEnvio: fechaEnvio ?? this.fechaEnvio,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (destinatario.present) {
      map['destinatario'] = Variable<String>(destinatario.value);
    }
    if (asunto.present) {
      map['asunto'] = Variable<String>(asunto.value);
    }
    if (evento.present) {
      map['evento'] = Variable<String>(evento.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (fechaEnvio.present) {
      map['fecha_envio'] = Variable<DateTime>(fechaEnvio.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificacionesAuditoriaTableCompanion(')
          ..write('id: $id, ')
          ..write('destinatario: $destinatario, ')
          ..write('asunto: $asunto, ')
          ..write('evento: $evento, ')
          ..write('estado: $estado, ')
          ..write('fechaEnvio: $fechaEnvio')
          ..write(')'))
        .toString();
  }
}

class $TiposFallaTableTable extends TiposFallaTable
    with TableInfo<$TiposFallaTableTable, TiposFallaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TiposFallaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tipoServicioMeta = const VerificationMeta(
    'tipoServicio',
  );
  @override
  late final GeneratedColumn<String> tipoServicio = GeneratedColumn<String>(
    'tipo_servicio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'UNIQUE',
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipoServicio,
    nombre,
    descripcion,
    activo,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tipos_falla_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TiposFallaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo_servicio')) {
      context.handle(
        _tipoServicioMeta,
        tipoServicio.isAcceptableOrUnknown(
          data['tipo_servicio']!,
          _tipoServicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoServicioMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TiposFallaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TiposFallaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipoServicio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_servicio'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TiposFallaTableTable createAlias(String alias) {
    return $TiposFallaTableTable(attachedDatabase, alias);
  }
}

class TiposFallaTableData extends DataClass
    implements Insertable<TiposFallaTableData> {
  final int id;
  final String tipoServicio;
  final String nombre;
  final String? descripcion;
  final bool activo;
  final DateTime createdAt;
  const TiposFallaTableData({
    required this.id,
    required this.tipoServicio,
    required this.nombre,
    this.descripcion,
    required this.activo,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tipo_servicio'] = Variable<String>(tipoServicio);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['activo'] = Variable<bool>(activo);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TiposFallaTableCompanion toCompanion(bool nullToAbsent) {
    return TiposFallaTableCompanion(
      id: Value(id),
      tipoServicio: Value(tipoServicio),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      activo: Value(activo),
      createdAt: Value(createdAt),
    );
  }

  factory TiposFallaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TiposFallaTableData(
      id: serializer.fromJson<int>(json['id']),
      tipoServicio: serializer.fromJson<String>(json['tipoServicio']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      activo: serializer.fromJson<bool>(json['activo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipoServicio': serializer.toJson<String>(tipoServicio),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'activo': serializer.toJson<bool>(activo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TiposFallaTableData copyWith({
    int? id,
    String? tipoServicio,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    bool? activo,
    DateTime? createdAt,
  }) => TiposFallaTableData(
    id: id ?? this.id,
    tipoServicio: tipoServicio ?? this.tipoServicio,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    activo: activo ?? this.activo,
    createdAt: createdAt ?? this.createdAt,
  );
  TiposFallaTableData copyWithCompanion(TiposFallaTableCompanion data) {
    return TiposFallaTableData(
      id: data.id.present ? data.id.value : this.id,
      tipoServicio: data.tipoServicio.present
          ? data.tipoServicio.value
          : this.tipoServicio,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      activo: data.activo.present ? data.activo.value : this.activo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TiposFallaTableData(')
          ..write('id: $id, ')
          ..write('tipoServicio: $tipoServicio, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tipoServicio, nombre, descripcion, activo, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TiposFallaTableData &&
          other.id == this.id &&
          other.tipoServicio == this.tipoServicio &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.activo == this.activo &&
          other.createdAt == this.createdAt);
}

class TiposFallaTableCompanion extends UpdateCompanion<TiposFallaTableData> {
  final Value<int> id;
  final Value<String> tipoServicio;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<bool> activo;
  final Value<DateTime> createdAt;
  const TiposFallaTableCompanion({
    this.id = const Value.absent(),
    this.tipoServicio = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TiposFallaTableCompanion.insert({
    this.id = const Value.absent(),
    required String tipoServicio,
    required String nombre,
    this.descripcion = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : tipoServicio = Value(tipoServicio),
       nombre = Value(nombre);
  static Insertable<TiposFallaTableData> custom({
    Expression<int>? id,
    Expression<String>? tipoServicio,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<bool>? activo,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipoServicio != null) 'tipo_servicio': tipoServicio,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (activo != null) 'activo': activo,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TiposFallaTableCompanion copyWith({
    Value<int>? id,
    Value<String>? tipoServicio,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<bool>? activo,
    Value<DateTime>? createdAt,
  }) {
    return TiposFallaTableCompanion(
      id: id ?? this.id,
      tipoServicio: tipoServicio ?? this.tipoServicio,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipoServicio.present) {
      map['tipo_servicio'] = Variable<String>(tipoServicio.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TiposFallaTableCompanion(')
          ..write('id: $id, ')
          ..write('tipoServicio: $tipoServicio, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuariosTableTable usuariosTable = $UsuariosTableTable(this);
  late final $ClientesTableTable clientesTable = $ClientesTableTable(this);
  late final $EquiposTableTable equiposTable = $EquiposTableTable(this);
  late final $OrdenesTableTable ordenesTable = $OrdenesTableTable(this);
  late final $FormatoOtTableTable formatoOtTable = $FormatoOtTableTable(this);
  late final $FormatoActividadesTableTable formatoActividadesTable =
      $FormatoActividadesTableTable(this);
  late final $RepuestosOrdenTableTable repuestosOrdenTable =
      $RepuestosOrdenTableTable(this);
  late final $FormatoActaEntregaTableTable formatoActaEntregaTable =
      $FormatoActaEntregaTableTable(this);
  late final $FotosEvidenciaTableTable fotosEvidenciaTable =
      $FotosEvidenciaTableTable(this);
  late final $ConfiguracionEmpresaTableTable configuracionEmpresaTable =
      $ConfiguracionEmpresaTableTable(this);
  late final $NotificacionesAuditoriaTableTable notificacionesAuditoriaTable =
      $NotificacionesAuditoriaTableTable(this);
  late final $TiposFallaTableTable tiposFallaTable = $TiposFallaTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usuariosTable,
    clientesTable,
    equiposTable,
    ordenesTable,
    formatoOtTable,
    formatoActividadesTable,
    repuestosOrdenTable,
    formatoActaEntregaTable,
    fotosEvidenciaTable,
    configuracionEmpresaTable,
    notificacionesAuditoriaTable,
    tiposFallaTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'clientes_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('equipos_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ordenes_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('formato_ot_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ordenes_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('formato_actividades_table', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ordenes_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('repuestos_orden_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ordenes_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('formato_acta_entrega_table', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ordenes_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('fotos_evidencia_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UsuariosTableTableCreateCompanionBuilder =
    UsuariosTableCompanion Function({
      Value<int> id,
      required String nombre,
      required String email,
      required String password,
      required String documento,
      required String telefono,
      required String rol,
      Value<bool> activo,
      Value<DateTime> createdAt,
    });
typedef $$UsuariosTableTableUpdateCompanionBuilder =
    UsuariosTableCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> email,
      Value<String> password,
      Value<String> documento,
      Value<String> telefono,
      Value<String> rol,
      Value<bool> activo,
      Value<DateTime> createdAt,
    });

class $$UsuariosTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTableTable> {
  $$UsuariosTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documento => $composableBuilder(
    column: $table.documento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsuariosTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTableTable> {
  $$UsuariosTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documento => $composableBuilder(
    column: $table.documento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsuariosTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTableTable> {
  $$UsuariosTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get documento =>
      $composableBuilder(column: $table.documento, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get rol =>
      $composableBuilder(column: $table.rol, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsuariosTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsuariosTableTable,
          UsuariosTableData,
          $$UsuariosTableTableFilterComposer,
          $$UsuariosTableTableOrderingComposer,
          $$UsuariosTableTableAnnotationComposer,
          $$UsuariosTableTableCreateCompanionBuilder,
          $$UsuariosTableTableUpdateCompanionBuilder,
          (
            UsuariosTableData,
            BaseReferences<
              _$AppDatabase,
              $UsuariosTableTable,
              UsuariosTableData
            >,
          ),
          UsuariosTableData,
          PrefetchHooks Function()
        > {
  $$UsuariosTableTableTableManager(_$AppDatabase db, $UsuariosTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> documento = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> rol = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsuariosTableCompanion(
                id: id,
                nombre: nombre,
                email: email,
                password: password,
                documento: documento,
                telefono: telefono,
                rol: rol,
                activo: activo,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String email,
                required String password,
                required String documento,
                required String telefono,
                required String rol,
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsuariosTableCompanion.insert(
                id: id,
                nombre: nombre,
                email: email,
                password: password,
                documento: documento,
                telefono: telefono,
                rol: rol,
                activo: activo,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsuariosTableTable, UsuariosTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UsuariosTableTable,
                    UsuariosTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsuariosTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsuariosTableTable,
      UsuariosTableData,
      $$UsuariosTableTableFilterComposer,
      $$UsuariosTableTableOrderingComposer,
      $$UsuariosTableTableAnnotationComposer,
      $$UsuariosTableTableCreateCompanionBuilder,
      $$UsuariosTableTableUpdateCompanionBuilder,
      (
        UsuariosTableData,
        BaseReferences<_$AppDatabase, $UsuariosTableTable, UsuariosTableData>,
      ),
      UsuariosTableData,
      PrefetchHooks Function()
    >;
typedef $$ClientesTableTableCreateCompanionBuilder =
    ClientesTableCompanion Function({
      Value<int> id,
      required String tipoDocumento,
      required String numeroDocumento,
      required String nombreCompleto,
      required String telefono,
      Value<String?> email,
      required String direccion,
      Value<DateTime> createdAt,
    });
typedef $$ClientesTableTableUpdateCompanionBuilder =
    ClientesTableCompanion Function({
      Value<int> id,
      Value<String> tipoDocumento,
      Value<String> numeroDocumento,
      Value<String> nombreCompleto,
      Value<String> telefono,
      Value<String?> email,
      Value<String> direccion,
      Value<DateTime> createdAt,
    });

final class $$ClientesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ClientesTableTable, ClientesTableData> {
  $$ClientesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$EquiposTableTable, List<EquiposTableData>>
  _equiposTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.equiposTable,
    aliasName: 'clientes_table__id__equipos_table__cliente_id',
  );

  $$EquiposTableTableProcessedTableManager get equiposTableRefs {
    final manager = $$EquiposTableTableTableManager(
      $_db,
      $_db.equiposTable,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_equiposTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrdenesTableTable, List<OrdenesTableData>>
  _ordenesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ordenesTable,
    aliasName: 'clientes_table__id__ordenes_table__cliente_id',
  );

  $$OrdenesTableTableProcessedTableManager get ordenesTableRefs {
    final manager = $$OrdenesTableTableTableManager(
      $_db,
      $_db.ordenesTable,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordenesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTableTable> {
  $$ClientesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoDocumento => $composableBuilder(
    column: $table.tipoDocumento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroDocumento => $composableBuilder(
    column: $table.numeroDocumento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> equiposTableRefs(
    Expression<bool> Function($$EquiposTableTableFilterComposer f) f,
  ) {
    final $$EquiposTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equiposTable,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableTableFilterComposer(
            $db: $db,
            $table: $db.equiposTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordenesTableRefs(
    Expression<bool> Function($$OrdenesTableTableFilterComposer f) f,
  ) {
    final $$OrdenesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableFilterComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTableTable> {
  $$ClientesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoDocumento => $composableBuilder(
    column: $table.tipoDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroDocumento => $composableBuilder(
    column: $table.numeroDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTableTable> {
  $$ClientesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipoDocumento => $composableBuilder(
    column: $table.tipoDocumento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numeroDocumento => $composableBuilder(
    column: $table.numeroDocumento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> equiposTableRefs<T extends Object>(
    Expression<T> Function($$EquiposTableTableAnnotationComposer a) f,
  ) {
    final $$EquiposTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equiposTable,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableTableAnnotationComposer(
            $db: $db,
            $table: $db.equiposTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ordenesTableRefs<T extends Object>(
    Expression<T> Function($$OrdenesTableTableAnnotationComposer a) f,
  ) {
    final $$OrdenesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTableTable,
          ClientesTableData,
          $$ClientesTableTableFilterComposer,
          $$ClientesTableTableOrderingComposer,
          $$ClientesTableTableAnnotationComposer,
          $$ClientesTableTableCreateCompanionBuilder,
          $$ClientesTableTableUpdateCompanionBuilder,
          (ClientesTableData, $$ClientesTableTableReferences),
          ClientesTableData,
          PrefetchHooks Function({bool equiposTableRefs, bool ordenesTableRefs})
        > {
  $$ClientesTableTableTableManager(_$AppDatabase db, $ClientesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tipoDocumento = const Value.absent(),
                Value<String> numeroDocumento = const Value.absent(),
                Value<String> nombreCompleto = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ClientesTableCompanion(
                id: id,
                tipoDocumento: tipoDocumento,
                numeroDocumento: numeroDocumento,
                nombreCompleto: nombreCompleto,
                telefono: telefono,
                email: email,
                direccion: direccion,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tipoDocumento,
                required String numeroDocumento,
                required String nombreCompleto,
                required String telefono,
                Value<String?> email = const Value.absent(),
                required String direccion,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ClientesTableCompanion.insert(
                id: id,
                tipoDocumento: tipoDocumento,
                numeroDocumento: numeroDocumento,
                nombreCompleto: nombreCompleto,
                telefono: telefono,
                email: email,
                direccion: direccion,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClientesTableTable, ClientesTableData>(table),
                  $$ClientesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({equiposTableRefs = false, ordenesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (equiposTableRefs) db.equiposTable,
                    if (ordenesTableRefs) db.ordenesTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (equiposTableRefs)
                        await $_getPrefetchedData<
                          ClientesTableData,
                          $ClientesTableTable,
                          EquiposTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableTableReferences
                              ._equiposTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).equiposTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ordenesTableRefs)
                        await $_getPrefetchedData<
                          ClientesTableData,
                          $ClientesTableTable,
                          OrdenesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ClientesTableTableReferences
                              ._ordenesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).ordenesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTableTable,
      ClientesTableData,
      $$ClientesTableTableFilterComposer,
      $$ClientesTableTableOrderingComposer,
      $$ClientesTableTableAnnotationComposer,
      $$ClientesTableTableCreateCompanionBuilder,
      $$ClientesTableTableUpdateCompanionBuilder,
      (ClientesTableData, $$ClientesTableTableReferences),
      ClientesTableData,
      PrefetchHooks Function({bool equiposTableRefs, bool ordenesTableRefs})
    >;
typedef $$EquiposTableTableCreateCompanionBuilder =
    EquiposTableCompanion Function({
      Value<int> id,
      required int clienteId,
      required String tipoEquipo,
      required String marca,
      required String modelo,
      required String numeroSerie,
      Value<String?> sistemaOperativo,
      Value<String?> procesador,
      Value<String?> memoriaRam,
      Value<String?> almacenamiento,
      Value<String?> tarjetaGrafica,
      Value<String> estadoEquipo,
      Value<DateTime> createdAt,
    });
typedef $$EquiposTableTableUpdateCompanionBuilder =
    EquiposTableCompanion Function({
      Value<int> id,
      Value<int> clienteId,
      Value<String> tipoEquipo,
      Value<String> marca,
      Value<String> modelo,
      Value<String> numeroSerie,
      Value<String?> sistemaOperativo,
      Value<String?> procesador,
      Value<String?> memoriaRam,
      Value<String?> almacenamiento,
      Value<String?> tarjetaGrafica,
      Value<String> estadoEquipo,
      Value<DateTime> createdAt,
    });

final class $$EquiposTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $EquiposTableTable, EquiposTableData> {
  $$EquiposTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTableTable _clienteIdTable(_$AppDatabase db) => db
      .clientesTable
      .createAlias('equipos_table__cliente_id__clientes_table__id');

  $$ClientesTableTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableTableManager(
      $_db,
      $_db.clientesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrdenesTableTable, List<OrdenesTableData>>
  _ordenesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ordenesTable,
    aliasName: 'equipos_table__id__ordenes_table__equipo_id',
  );

  $$OrdenesTableTableProcessedTableManager get ordenesTableRefs {
    final manager = $$OrdenesTableTableTableManager(
      $_db,
      $_db.ordenesTable,
    ).filter((f) => f.equipoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordenesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquiposTableTableFilterComposer
    extends Composer<_$AppDatabase, $EquiposTableTable> {
  $$EquiposTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoEquipo => $composableBuilder(
    column: $table.tipoEquipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroSerie => $composableBuilder(
    column: $table.numeroSerie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sistemaOperativo => $composableBuilder(
    column: $table.sistemaOperativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get procesador => $composableBuilder(
    column: $table.procesador,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memoriaRam => $composableBuilder(
    column: $table.memoriaRam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get almacenamiento => $composableBuilder(
    column: $table.almacenamiento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tarjetaGrafica => $composableBuilder(
    column: $table.tarjetaGrafica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estadoEquipo => $composableBuilder(
    column: $table.estadoEquipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableTableFilterComposer get clienteId {
    final $$ClientesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableTableFilterComposer(
            $db: $db,
            $table: $db.clientesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ordenesTableRefs(
    Expression<bool> Function($$OrdenesTableTableFilterComposer f) f,
  ) {
    final $$OrdenesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableFilterComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquiposTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EquiposTableTable> {
  $$EquiposTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoEquipo => $composableBuilder(
    column: $table.tipoEquipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroSerie => $composableBuilder(
    column: $table.numeroSerie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sistemaOperativo => $composableBuilder(
    column: $table.sistemaOperativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get procesador => $composableBuilder(
    column: $table.procesador,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memoriaRam => $composableBuilder(
    column: $table.memoriaRam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get almacenamiento => $composableBuilder(
    column: $table.almacenamiento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tarjetaGrafica => $composableBuilder(
    column: $table.tarjetaGrafica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoEquipo => $composableBuilder(
    column: $table.estadoEquipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableTableOrderingComposer get clienteId {
    final $$ClientesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableTableOrderingComposer(
            $db: $db,
            $table: $db.clientesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EquiposTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquiposTableTable> {
  $$EquiposTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipoEquipo => $composableBuilder(
    column: $table.tipoEquipo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get modelo =>
      $composableBuilder(column: $table.modelo, builder: (column) => column);

  GeneratedColumn<String> get numeroSerie => $composableBuilder(
    column: $table.numeroSerie,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sistemaOperativo => $composableBuilder(
    column: $table.sistemaOperativo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get procesador => $composableBuilder(
    column: $table.procesador,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memoriaRam => $composableBuilder(
    column: $table.memoriaRam,
    builder: (column) => column,
  );

  GeneratedColumn<String> get almacenamiento => $composableBuilder(
    column: $table.almacenamiento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tarjetaGrafica => $composableBuilder(
    column: $table.tarjetaGrafica,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estadoEquipo => $composableBuilder(
    column: $table.estadoEquipo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ClientesTableTableAnnotationComposer get clienteId {
    final $$ClientesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.clientesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ordenesTableRefs<T extends Object>(
    Expression<T> Function($$OrdenesTableTableAnnotationComposer a) f,
  ) {
    final $$OrdenesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.equipoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquiposTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquiposTableTable,
          EquiposTableData,
          $$EquiposTableTableFilterComposer,
          $$EquiposTableTableOrderingComposer,
          $$EquiposTableTableAnnotationComposer,
          $$EquiposTableTableCreateCompanionBuilder,
          $$EquiposTableTableUpdateCompanionBuilder,
          (EquiposTableData, $$EquiposTableTableReferences),
          EquiposTableData,
          PrefetchHooks Function({bool clienteId, bool ordenesTableRefs})
        > {
  $$EquiposTableTableTableManager(_$AppDatabase db, $EquiposTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquiposTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquiposTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquiposTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<String> tipoEquipo = const Value.absent(),
                Value<String> marca = const Value.absent(),
                Value<String> modelo = const Value.absent(),
                Value<String> numeroSerie = const Value.absent(),
                Value<String?> sistemaOperativo = const Value.absent(),
                Value<String?> procesador = const Value.absent(),
                Value<String?> memoriaRam = const Value.absent(),
                Value<String?> almacenamiento = const Value.absent(),
                Value<String?> tarjetaGrafica = const Value.absent(),
                Value<String> estadoEquipo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EquiposTableCompanion(
                id: id,
                clienteId: clienteId,
                tipoEquipo: tipoEquipo,
                marca: marca,
                modelo: modelo,
                numeroSerie: numeroSerie,
                sistemaOperativo: sistemaOperativo,
                procesador: procesador,
                memoriaRam: memoriaRam,
                almacenamiento: almacenamiento,
                tarjetaGrafica: tarjetaGrafica,
                estadoEquipo: estadoEquipo,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clienteId,
                required String tipoEquipo,
                required String marca,
                required String modelo,
                required String numeroSerie,
                Value<String?> sistemaOperativo = const Value.absent(),
                Value<String?> procesador = const Value.absent(),
                Value<String?> memoriaRam = const Value.absent(),
                Value<String?> almacenamiento = const Value.absent(),
                Value<String?> tarjetaGrafica = const Value.absent(),
                Value<String> estadoEquipo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EquiposTableCompanion.insert(
                id: id,
                clienteId: clienteId,
                tipoEquipo: tipoEquipo,
                marca: marca,
                modelo: modelo,
                numeroSerie: numeroSerie,
                sistemaOperativo: sistemaOperativo,
                procesador: procesador,
                memoriaRam: memoriaRam,
                almacenamiento: almacenamiento,
                tarjetaGrafica: tarjetaGrafica,
                estadoEquipo: estadoEquipo,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EquiposTableTable, EquiposTableData>(table),
                  $$EquiposTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({clienteId = false, ordenesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ordenesTableRefs) db.ordenesTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clienteId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.clienteId,
                            referencedTable: $$EquiposTableTableReferences
                                ._clienteIdTable(db),
                            referencedColumn: $$EquiposTableTableReferences
                                ._clienteIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ordenesTableRefs)
                        await $_getPrefetchedData<
                          EquiposTableData,
                          $EquiposTableTable,
                          OrdenesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$EquiposTableTableReferences
                              ._ordenesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquiposTableTableReferences(
                                db,
                                table,
                                p0,
                              ).ordenesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EquiposTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquiposTableTable,
      EquiposTableData,
      $$EquiposTableTableFilterComposer,
      $$EquiposTableTableOrderingComposer,
      $$EquiposTableTableAnnotationComposer,
      $$EquiposTableTableCreateCompanionBuilder,
      $$EquiposTableTableUpdateCompanionBuilder,
      (EquiposTableData, $$EquiposTableTableReferences),
      EquiposTableData,
      PrefetchHooks Function({bool clienteId, bool ordenesTableRefs})
    >;
typedef $$OrdenesTableTableCreateCompanionBuilder =
    OrdenesTableCompanion Function({
      Value<int> id,
      required String codigoOrden,
      required int clienteId,
      required int equipoId,
      Value<int?> tecnicoId,
      Value<int?> solicitanteId,
      required String tipoServicio,
      required String categoriaFalla,
      required String prioridad,
      required String titulo,
      required String descripcion,
      Value<String> estado,
      Value<DateTime> fechaIngreso,
      Value<DateTime?> fechaLimiteSla,
      Value<DateTime?> fechaCierre,
    });
typedef $$OrdenesTableTableUpdateCompanionBuilder =
    OrdenesTableCompanion Function({
      Value<int> id,
      Value<String> codigoOrden,
      Value<int> clienteId,
      Value<int> equipoId,
      Value<int?> tecnicoId,
      Value<int?> solicitanteId,
      Value<String> tipoServicio,
      Value<String> categoriaFalla,
      Value<String> prioridad,
      Value<String> titulo,
      Value<String> descripcion,
      Value<String> estado,
      Value<DateTime> fechaIngreso,
      Value<DateTime?> fechaLimiteSla,
      Value<DateTime?> fechaCierre,
    });

final class $$OrdenesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $OrdenesTableTable, OrdenesTableData> {
  $$OrdenesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTableTable _clienteIdTable(_$AppDatabase db) => db
      .clientesTable
      .createAlias('ordenes_table__cliente_id__clientes_table__id');

  $$ClientesTableTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableTableManager(
      $_db,
      $_db.clientesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquiposTableTable _equipoIdTable(_$AppDatabase db) => db.equiposTable
      .createAlias('ordenes_table__equipo_id__equipos_table__id');

  $$EquiposTableTableProcessedTableManager get equipoId {
    final $_column = $_itemColumn<int>('equipo_id')!;

    final manager = $$EquiposTableTableTableManager(
      $_db,
      $_db.equiposTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsuariosTableTable _tecnicoIdTable(_$AppDatabase db) => db
      .usuariosTable
      .createAlias('ordenes_table__tecnico_id__usuarios_table__id');

  $$UsuariosTableTableProcessedTableManager? get tecnicoId {
    final $_column = $_itemColumn<int>('tecnico_id');
    if ($_column == null) return null;
    final manager = $$UsuariosTableTableTableManager(
      $_db,
      $_db.usuariosTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tecnicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsuariosTableTable _solicitanteIdTable(_$AppDatabase db) => db
      .usuariosTable
      .createAlias('ordenes_table__solicitante_id__usuarios_table__id');

  $$UsuariosTableTableProcessedTableManager? get solicitanteId {
    final $_column = $_itemColumn<int>('solicitante_id');
    if ($_column == null) return null;
    final manager = $$UsuariosTableTableTableManager(
      $_db,
      $_db.usuariosTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_solicitanteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FormatoOtTableTable, List<FormatoOtTableData>>
  _formatoOtTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.formatoOtTable,
    aliasName: 'ordenes_table__id__formato_ot_table__orden_id',
  );

  $$FormatoOtTableTableProcessedTableManager get formatoOtTableRefs {
    final manager = $$FormatoOtTableTableTableManager(
      $_db,
      $_db.formatoOtTable,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_formatoOtTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FormatoActividadesTableTable,
    List<FormatoActividadesTableData>
  >
  _formatoActividadesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.formatoActividadesTable,
        aliasName: 'ordenes_table__id__formato_actividades_table__orden_id',
      );

  $$FormatoActividadesTableTableProcessedTableManager
  get formatoActividadesTableRefs {
    final manager = $$FormatoActividadesTableTableTableManager(
      $_db,
      $_db.formatoActividadesTable,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _formatoActividadesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RepuestosOrdenTableTable,
    List<RepuestosOrdenTableData>
  >
  _repuestosOrdenTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.repuestosOrdenTable,
        aliasName: 'ordenes_table__id__repuestos_orden_table__orden_id',
      );

  $$RepuestosOrdenTableTableProcessedTableManager get repuestosOrdenTableRefs {
    final manager = $$RepuestosOrdenTableTableTableManager(
      $_db,
      $_db.repuestosOrdenTable,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _repuestosOrdenTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FormatoActaEntregaTableTable,
    List<FormatoActaEntregaTableData>
  >
  _formatoActaEntregaTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.formatoActaEntregaTable,
        aliasName: 'ordenes_table__id__formato_acta_entrega_table__orden_id',
      );

  $$FormatoActaEntregaTableTableProcessedTableManager
  get formatoActaEntregaTableRefs {
    final manager = $$FormatoActaEntregaTableTableTableManager(
      $_db,
      $_db.formatoActaEntregaTable,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _formatoActaEntregaTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FotosEvidenciaTableTable,
    List<FotosEvidenciaTableData>
  >
  _fotosEvidenciaTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.fotosEvidenciaTable,
        aliasName: 'ordenes_table__id__fotos_evidencia_table__orden_id',
      );

  $$FotosEvidenciaTableTableProcessedTableManager get fotosEvidenciaTableRefs {
    final manager = $$FotosEvidenciaTableTableTableManager(
      $_db,
      $_db.fotosEvidenciaTable,
    ).filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _fotosEvidenciaTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdenesTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrdenesTableTable> {
  $$OrdenesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoOrden => $composableBuilder(
    column: $table.codigoOrden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoServicio => $composableBuilder(
    column: $table.tipoServicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoriaFalla => $composableBuilder(
    column: $table.categoriaFalla,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaIngreso => $composableBuilder(
    column: $table.fechaIngreso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaLimiteSla => $composableBuilder(
    column: $table.fechaLimiteSla,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableTableFilterComposer get clienteId {
    final $$ClientesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableTableFilterComposer(
            $db: $db,
            $table: $db.clientesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableTableFilterComposer get equipoId {
    final $$EquiposTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equiposTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableTableFilterComposer(
            $db: $db,
            $table: $db.equiposTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableTableFilterComposer get tecnicoId {
    final $$UsuariosTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tecnicoId,
      referencedTable: $db.usuariosTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableTableFilterComposer(
            $db: $db,
            $table: $db.usuariosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableTableFilterComposer get solicitanteId {
    final $$UsuariosTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.solicitanteId,
      referencedTable: $db.usuariosTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableTableFilterComposer(
            $db: $db,
            $table: $db.usuariosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> formatoOtTableRefs(
    Expression<bool> Function($$FormatoOtTableTableFilterComposer f) f,
  ) {
    final $$FormatoOtTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.formatoOtTable,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormatoOtTableTableFilterComposer(
            $db: $db,
            $table: $db.formatoOtTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> formatoActividadesTableRefs(
    Expression<bool> Function($$FormatoActividadesTableTableFilterComposer f) f,
  ) {
    final $$FormatoActividadesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.formatoActividadesTable,
          getReferencedColumn: (t) => t.ordenId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FormatoActividadesTableTableFilterComposer(
                $db: $db,
                $table: $db.formatoActividadesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> repuestosOrdenTableRefs(
    Expression<bool> Function($$RepuestosOrdenTableTableFilterComposer f) f,
  ) {
    final $$RepuestosOrdenTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repuestosOrdenTable,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepuestosOrdenTableTableFilterComposer(
            $db: $db,
            $table: $db.repuestosOrdenTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> formatoActaEntregaTableRefs(
    Expression<bool> Function($$FormatoActaEntregaTableTableFilterComposer f) f,
  ) {
    final $$FormatoActaEntregaTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.formatoActaEntregaTable,
          getReferencedColumn: (t) => t.ordenId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FormatoActaEntregaTableTableFilterComposer(
                $db: $db,
                $table: $db.formatoActaEntregaTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> fotosEvidenciaTableRefs(
    Expression<bool> Function($$FotosEvidenciaTableTableFilterComposer f) f,
  ) {
    final $$FotosEvidenciaTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fotosEvidenciaTable,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FotosEvidenciaTableTableFilterComposer(
            $db: $db,
            $table: $db.fotosEvidenciaTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdenesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdenesTableTable> {
  $$OrdenesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoOrden => $composableBuilder(
    column: $table.codigoOrden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoServicio => $composableBuilder(
    column: $table.tipoServicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoriaFalla => $composableBuilder(
    column: $table.categoriaFalla,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaIngreso => $composableBuilder(
    column: $table.fechaIngreso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaLimiteSla => $composableBuilder(
    column: $table.fechaLimiteSla,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableTableOrderingComposer get clienteId {
    final $$ClientesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableTableOrderingComposer(
            $db: $db,
            $table: $db.clientesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableTableOrderingComposer get equipoId {
    final $$EquiposTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equiposTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableTableOrderingComposer(
            $db: $db,
            $table: $db.equiposTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableTableOrderingComposer get tecnicoId {
    final $$UsuariosTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tecnicoId,
      referencedTable: $db.usuariosTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableTableOrderingComposer(
            $db: $db,
            $table: $db.usuariosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableTableOrderingComposer get solicitanteId {
    final $$UsuariosTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.solicitanteId,
      referencedTable: $db.usuariosTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableTableOrderingComposer(
            $db: $db,
            $table: $db.usuariosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdenesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdenesTableTable> {
  $$OrdenesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigoOrden => $composableBuilder(
    column: $table.codigoOrden,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipoServicio => $composableBuilder(
    column: $table.tipoServicio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoriaFalla => $composableBuilder(
    column: $table.categoriaFalla,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prioridad =>
      $composableBuilder(column: $table.prioridad, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaIngreso => $composableBuilder(
    column: $table.fechaIngreso,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaLimiteSla => $composableBuilder(
    column: $table.fechaLimiteSla,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => column,
  );

  $$ClientesTableTableAnnotationComposer get clienteId {
    final $$ClientesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.clientesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquiposTableTableAnnotationComposer get equipoId {
    final $$EquiposTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipoId,
      referencedTable: $db.equiposTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquiposTableTableAnnotationComposer(
            $db: $db,
            $table: $db.equiposTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableTableAnnotationComposer get tecnicoId {
    final $$UsuariosTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tecnicoId,
      referencedTable: $db.usuariosTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableTableAnnotationComposer(
            $db: $db,
            $table: $db.usuariosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsuariosTableTableAnnotationComposer get solicitanteId {
    final $$UsuariosTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.solicitanteId,
      referencedTable: $db.usuariosTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableTableAnnotationComposer(
            $db: $db,
            $table: $db.usuariosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> formatoOtTableRefs<T extends Object>(
    Expression<T> Function($$FormatoOtTableTableAnnotationComposer a) f,
  ) {
    final $$FormatoOtTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.formatoOtTable,
      getReferencedColumn: (t) => t.ordenId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormatoOtTableTableAnnotationComposer(
            $db: $db,
            $table: $db.formatoOtTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> formatoActividadesTableRefs<T extends Object>(
    Expression<T> Function($$FormatoActividadesTableTableAnnotationComposer a)
    f,
  ) {
    final $$FormatoActividadesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.formatoActividadesTable,
          getReferencedColumn: (t) => t.ordenId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FormatoActividadesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.formatoActividadesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> repuestosOrdenTableRefs<T extends Object>(
    Expression<T> Function($$RepuestosOrdenTableTableAnnotationComposer a) f,
  ) {
    final $$RepuestosOrdenTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.repuestosOrdenTable,
          getReferencedColumn: (t) => t.ordenId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RepuestosOrdenTableTableAnnotationComposer(
                $db: $db,
                $table: $db.repuestosOrdenTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> formatoActaEntregaTableRefs<T extends Object>(
    Expression<T> Function($$FormatoActaEntregaTableTableAnnotationComposer a)
    f,
  ) {
    final $$FormatoActaEntregaTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.formatoActaEntregaTable,
          getReferencedColumn: (t) => t.ordenId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FormatoActaEntregaTableTableAnnotationComposer(
                $db: $db,
                $table: $db.formatoActaEntregaTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> fotosEvidenciaTableRefs<T extends Object>(
    Expression<T> Function($$FotosEvidenciaTableTableAnnotationComposer a) f,
  ) {
    final $$FotosEvidenciaTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.fotosEvidenciaTable,
          getReferencedColumn: (t) => t.ordenId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FotosEvidenciaTableTableAnnotationComposer(
                $db: $db,
                $table: $db.fotosEvidenciaTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrdenesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdenesTableTable,
          OrdenesTableData,
          $$OrdenesTableTableFilterComposer,
          $$OrdenesTableTableOrderingComposer,
          $$OrdenesTableTableAnnotationComposer,
          $$OrdenesTableTableCreateCompanionBuilder,
          $$OrdenesTableTableUpdateCompanionBuilder,
          (OrdenesTableData, $$OrdenesTableTableReferences),
          OrdenesTableData,
          PrefetchHooks Function({
            bool clienteId,
            bool equipoId,
            bool tecnicoId,
            bool solicitanteId,
            bool formatoOtTableRefs,
            bool formatoActividadesTableRefs,
            bool repuestosOrdenTableRefs,
            bool formatoActaEntregaTableRefs,
            bool fotosEvidenciaTableRefs,
          })
        > {
  $$OrdenesTableTableTableManager(_$AppDatabase db, $OrdenesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdenesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdenesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdenesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigoOrden = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<int> equipoId = const Value.absent(),
                Value<int?> tecnicoId = const Value.absent(),
                Value<int?> solicitanteId = const Value.absent(),
                Value<String> tipoServicio = const Value.absent(),
                Value<String> categoriaFalla = const Value.absent(),
                Value<String> prioridad = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> fechaIngreso = const Value.absent(),
                Value<DateTime?> fechaLimiteSla = const Value.absent(),
                Value<DateTime?> fechaCierre = const Value.absent(),
              }) => OrdenesTableCompanion(
                id: id,
                codigoOrden: codigoOrden,
                clienteId: clienteId,
                equipoId: equipoId,
                tecnicoId: tecnicoId,
                solicitanteId: solicitanteId,
                tipoServicio: tipoServicio,
                categoriaFalla: categoriaFalla,
                prioridad: prioridad,
                titulo: titulo,
                descripcion: descripcion,
                estado: estado,
                fechaIngreso: fechaIngreso,
                fechaLimiteSla: fechaLimiteSla,
                fechaCierre: fechaCierre,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigoOrden,
                required int clienteId,
                required int equipoId,
                Value<int?> tecnicoId = const Value.absent(),
                Value<int?> solicitanteId = const Value.absent(),
                required String tipoServicio,
                required String categoriaFalla,
                required String prioridad,
                required String titulo,
                required String descripcion,
                Value<String> estado = const Value.absent(),
                Value<DateTime> fechaIngreso = const Value.absent(),
                Value<DateTime?> fechaLimiteSla = const Value.absent(),
                Value<DateTime?> fechaCierre = const Value.absent(),
              }) => OrdenesTableCompanion.insert(
                id: id,
                codigoOrden: codigoOrden,
                clienteId: clienteId,
                equipoId: equipoId,
                tecnicoId: tecnicoId,
                solicitanteId: solicitanteId,
                tipoServicio: tipoServicio,
                categoriaFalla: categoriaFalla,
                prioridad: prioridad,
                titulo: titulo,
                descripcion: descripcion,
                estado: estado,
                fechaIngreso: fechaIngreso,
                fechaLimiteSla: fechaLimiteSla,
                fechaCierre: fechaCierre,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrdenesTableTable, OrdenesTableData>(table),
                  $$OrdenesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteId = false,
                equipoId = false,
                tecnicoId = false,
                solicitanteId = false,
                formatoOtTableRefs = false,
                formatoActividadesTableRefs = false,
                repuestosOrdenTableRefs = false,
                formatoActaEntregaTableRefs = false,
                fotosEvidenciaTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (formatoOtTableRefs) db.formatoOtTable,
                    if (formatoActividadesTableRefs) db.formatoActividadesTable,
                    if (repuestosOrdenTableRefs) db.repuestosOrdenTable,
                    if (formatoActaEntregaTableRefs) db.formatoActaEntregaTable,
                    if (fotosEvidenciaTableRefs) db.fotosEvidenciaTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clienteId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.clienteId,
                            referencedTable: $$OrdenesTableTableReferences
                                ._clienteIdTable(db),
                            referencedColumn: $$OrdenesTableTableReferences
                                ._clienteIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (equipoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.equipoId,
                            referencedTable: $$OrdenesTableTableReferences
                                ._equipoIdTable(db),
                            referencedColumn: $$OrdenesTableTableReferences
                                ._equipoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (tecnicoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.tecnicoId,
                            referencedTable: $$OrdenesTableTableReferences
                                ._tecnicoIdTable(db),
                            referencedColumn: $$OrdenesTableTableReferences
                                ._tecnicoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (solicitanteId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.solicitanteId,
                            referencedTable: $$OrdenesTableTableReferences
                                ._solicitanteIdTable(db),
                            referencedColumn: $$OrdenesTableTableReferences
                                ._solicitanteIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (formatoOtTableRefs)
                        await $_getPrefetchedData<
                          OrdenesTableData,
                          $OrdenesTableTable,
                          FormatoOtTableData
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesTableTableReferences
                              ._formatoOtTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).formatoOtTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ordenId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (formatoActividadesTableRefs)
                        await $_getPrefetchedData<
                          OrdenesTableData,
                          $OrdenesTableTable,
                          FormatoActividadesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesTableTableReferences
                              ._formatoActividadesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).formatoActividadesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ordenId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (repuestosOrdenTableRefs)
                        await $_getPrefetchedData<
                          OrdenesTableData,
                          $OrdenesTableTable,
                          RepuestosOrdenTableData
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesTableTableReferences
                              ._repuestosOrdenTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).repuestosOrdenTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ordenId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (formatoActaEntregaTableRefs)
                        await $_getPrefetchedData<
                          OrdenesTableData,
                          $OrdenesTableTable,
                          FormatoActaEntregaTableData
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesTableTableReferences
                              ._formatoActaEntregaTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).formatoActaEntregaTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ordenId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (fotosEvidenciaTableRefs)
                        await $_getPrefetchedData<
                          OrdenesTableData,
                          $OrdenesTableTable,
                          FotosEvidenciaTableData
                        >(
                          currentTable: table,
                          referencedTable: $$OrdenesTableTableReferences
                              ._fotosEvidenciaTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdenesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).fotosEvidenciaTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ordenId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdenesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdenesTableTable,
      OrdenesTableData,
      $$OrdenesTableTableFilterComposer,
      $$OrdenesTableTableOrderingComposer,
      $$OrdenesTableTableAnnotationComposer,
      $$OrdenesTableTableCreateCompanionBuilder,
      $$OrdenesTableTableUpdateCompanionBuilder,
      (OrdenesTableData, $$OrdenesTableTableReferences),
      OrdenesTableData,
      PrefetchHooks Function({
        bool clienteId,
        bool equipoId,
        bool tecnicoId,
        bool solicitanteId,
        bool formatoOtTableRefs,
        bool formatoActividadesTableRefs,
        bool repuestosOrdenTableRefs,
        bool formatoActaEntregaTableRefs,
        bool fotosEvidenciaTableRefs,
      })
    >;
typedef $$FormatoOtTableTableCreateCompanionBuilder =
    FormatoOtTableCompanion Function({
      Value<int> id,
      required int ordenId,
      Value<String?> diagnosticoPreliminar,
      Value<String> herramientasChips,
      Value<DateTime?> tiempoEstimadoEntrega,
      Value<bool> accesorioCargador,
      Value<bool> accesorioCablePoder,
      Value<bool> accesorioMouse,
      Value<bool> accesorioMaletin,
      Value<bool> encendidoInicial,
      Value<String?> estadoCarcasa,
      Value<String?> pinContrasena,
    });
typedef $$FormatoOtTableTableUpdateCompanionBuilder =
    FormatoOtTableCompanion Function({
      Value<int> id,
      Value<int> ordenId,
      Value<String?> diagnosticoPreliminar,
      Value<String> herramientasChips,
      Value<DateTime?> tiempoEstimadoEntrega,
      Value<bool> accesorioCargador,
      Value<bool> accesorioCablePoder,
      Value<bool> accesorioMouse,
      Value<bool> accesorioMaletin,
      Value<bool> encendidoInicial,
      Value<String?> estadoCarcasa,
      Value<String?> pinContrasena,
    });

final class $$FormatoOtTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FormatoOtTableTable,
          FormatoOtTableData
        > {
  $$FormatoOtTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdenesTableTable _ordenIdTable(_$AppDatabase db) => db.ordenesTable
      .createAlias('formato_ot_table__orden_id__ordenes_table__id');

  $$OrdenesTableTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager = $$OrdenesTableTableTableManager(
      $_db,
      $_db.ordenesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FormatoOtTableTableFilterComposer
    extends Composer<_$AppDatabase, $FormatoOtTableTable> {
  $$FormatoOtTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diagnosticoPreliminar => $composableBuilder(
    column: $table.diagnosticoPreliminar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get herramientasChips => $composableBuilder(
    column: $table.herramientasChips,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tiempoEstimadoEntrega => $composableBuilder(
    column: $table.tiempoEstimadoEntrega,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get accesorioCargador => $composableBuilder(
    column: $table.accesorioCargador,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get accesorioCablePoder => $composableBuilder(
    column: $table.accesorioCablePoder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get accesorioMouse => $composableBuilder(
    column: $table.accesorioMouse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get accesorioMaletin => $composableBuilder(
    column: $table.accesorioMaletin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get encendidoInicial => $composableBuilder(
    column: $table.encendidoInicial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estadoCarcasa => $composableBuilder(
    column: $table.estadoCarcasa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinContrasena => $composableBuilder(
    column: $table.pinContrasena,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesTableTableFilterComposer get ordenId {
    final $$OrdenesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableFilterComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormatoOtTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FormatoOtTableTable> {
  $$FormatoOtTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diagnosticoPreliminar => $composableBuilder(
    column: $table.diagnosticoPreliminar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get herramientasChips => $composableBuilder(
    column: $table.herramientasChips,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tiempoEstimadoEntrega => $composableBuilder(
    column: $table.tiempoEstimadoEntrega,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get accesorioCargador => $composableBuilder(
    column: $table.accesorioCargador,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get accesorioCablePoder => $composableBuilder(
    column: $table.accesorioCablePoder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get accesorioMouse => $composableBuilder(
    column: $table.accesorioMouse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get accesorioMaletin => $composableBuilder(
    column: $table.accesorioMaletin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get encendidoInicial => $composableBuilder(
    column: $table.encendidoInicial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoCarcasa => $composableBuilder(
    column: $table.estadoCarcasa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinContrasena => $composableBuilder(
    column: $table.pinContrasena,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesTableTableOrderingComposer get ordenId {
    final $$OrdenesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableOrderingComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormatoOtTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormatoOtTableTable> {
  $$FormatoOtTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get diagnosticoPreliminar => $composableBuilder(
    column: $table.diagnosticoPreliminar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get herramientasChips => $composableBuilder(
    column: $table.herramientasChips,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tiempoEstimadoEntrega => $composableBuilder(
    column: $table.tiempoEstimadoEntrega,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get accesorioCargador => $composableBuilder(
    column: $table.accesorioCargador,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get accesorioCablePoder => $composableBuilder(
    column: $table.accesorioCablePoder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get accesorioMouse => $composableBuilder(
    column: $table.accesorioMouse,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get accesorioMaletin => $composableBuilder(
    column: $table.accesorioMaletin,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get encendidoInicial => $composableBuilder(
    column: $table.encendidoInicial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estadoCarcasa => $composableBuilder(
    column: $table.estadoCarcasa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pinContrasena => $composableBuilder(
    column: $table.pinContrasena,
    builder: (column) => column,
  );

  $$OrdenesTableTableAnnotationComposer get ordenId {
    final $$OrdenesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormatoOtTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FormatoOtTableTable,
          FormatoOtTableData,
          $$FormatoOtTableTableFilterComposer,
          $$FormatoOtTableTableOrderingComposer,
          $$FormatoOtTableTableAnnotationComposer,
          $$FormatoOtTableTableCreateCompanionBuilder,
          $$FormatoOtTableTableUpdateCompanionBuilder,
          (FormatoOtTableData, $$FormatoOtTableTableReferences),
          FormatoOtTableData,
          PrefetchHooks Function({bool ordenId})
        > {
  $$FormatoOtTableTableTableManager(
    _$AppDatabase db,
    $FormatoOtTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormatoOtTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormatoOtTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FormatoOtTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ordenId = const Value.absent(),
                Value<String?> diagnosticoPreliminar = const Value.absent(),
                Value<String> herramientasChips = const Value.absent(),
                Value<DateTime?> tiempoEstimadoEntrega = const Value.absent(),
                Value<bool> accesorioCargador = const Value.absent(),
                Value<bool> accesorioCablePoder = const Value.absent(),
                Value<bool> accesorioMouse = const Value.absent(),
                Value<bool> accesorioMaletin = const Value.absent(),
                Value<bool> encendidoInicial = const Value.absent(),
                Value<String?> estadoCarcasa = const Value.absent(),
                Value<String?> pinContrasena = const Value.absent(),
              }) => FormatoOtTableCompanion(
                id: id,
                ordenId: ordenId,
                diagnosticoPreliminar: diagnosticoPreliminar,
                herramientasChips: herramientasChips,
                tiempoEstimadoEntrega: tiempoEstimadoEntrega,
                accesorioCargador: accesorioCargador,
                accesorioCablePoder: accesorioCablePoder,
                accesorioMouse: accesorioMouse,
                accesorioMaletin: accesorioMaletin,
                encendidoInicial: encendidoInicial,
                estadoCarcasa: estadoCarcasa,
                pinContrasena: pinContrasena,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ordenId,
                Value<String?> diagnosticoPreliminar = const Value.absent(),
                Value<String> herramientasChips = const Value.absent(),
                Value<DateTime?> tiempoEstimadoEntrega = const Value.absent(),
                Value<bool> accesorioCargador = const Value.absent(),
                Value<bool> accesorioCablePoder = const Value.absent(),
                Value<bool> accesorioMouse = const Value.absent(),
                Value<bool> accesorioMaletin = const Value.absent(),
                Value<bool> encendidoInicial = const Value.absent(),
                Value<String?> estadoCarcasa = const Value.absent(),
                Value<String?> pinContrasena = const Value.absent(),
              }) => FormatoOtTableCompanion.insert(
                id: id,
                ordenId: ordenId,
                diagnosticoPreliminar: diagnosticoPreliminar,
                herramientasChips: herramientasChips,
                tiempoEstimadoEntrega: tiempoEstimadoEntrega,
                accesorioCargador: accesorioCargador,
                accesorioCablePoder: accesorioCablePoder,
                accesorioMouse: accesorioMouse,
                accesorioMaletin: accesorioMaletin,
                encendidoInicial: encendidoInicial,
                estadoCarcasa: estadoCarcasa,
                pinContrasena: pinContrasena,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FormatoOtTableTable, FormatoOtTableData>(table),
                  $$FormatoOtTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable: $$FormatoOtTableTableReferences
                            ._ordenIdTable(db),
                        referencedColumn: $$FormatoOtTableTableReferences
                            ._ordenIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FormatoOtTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FormatoOtTableTable,
      FormatoOtTableData,
      $$FormatoOtTableTableFilterComposer,
      $$FormatoOtTableTableOrderingComposer,
      $$FormatoOtTableTableAnnotationComposer,
      $$FormatoOtTableTableCreateCompanionBuilder,
      $$FormatoOtTableTableUpdateCompanionBuilder,
      (FormatoOtTableData, $$FormatoOtTableTableReferences),
      FormatoOtTableData,
      PrefetchHooks Function({bool ordenId})
    >;
typedef $$FormatoActividadesTableTableCreateCompanionBuilder =
    FormatoActividadesTableCompanion Function({
      Value<int> id,
      required int ordenId,
      Value<String?> procedimientosRealizados,
      Value<bool> pastaTermica,
      Value<bool> alcoholIsopropilico,
      Value<bool> sopleteadoContactos,
      Value<bool> brochaAntiestatica,
      Value<bool> panoMicrofibra,
      Value<bool> depuracionTemporales,
      Value<bool> optimizacionInicio,
      Value<bool> escaneoMalware,
      Value<bool> actualizacionDrivers,
      Value<bool> comprobacionDisco,
      Value<bool> qaEstresTermico,
      Value<bool> qaPuertos,
      Value<bool> qaConectividad,
      Value<bool> qaBateria,
      Value<bool> qaTecladoTouchpad,
      Value<double> costoManoObra,
    });
typedef $$FormatoActividadesTableTableUpdateCompanionBuilder =
    FormatoActividadesTableCompanion Function({
      Value<int> id,
      Value<int> ordenId,
      Value<String?> procedimientosRealizados,
      Value<bool> pastaTermica,
      Value<bool> alcoholIsopropilico,
      Value<bool> sopleteadoContactos,
      Value<bool> brochaAntiestatica,
      Value<bool> panoMicrofibra,
      Value<bool> depuracionTemporales,
      Value<bool> optimizacionInicio,
      Value<bool> escaneoMalware,
      Value<bool> actualizacionDrivers,
      Value<bool> comprobacionDisco,
      Value<bool> qaEstresTermico,
      Value<bool> qaPuertos,
      Value<bool> qaConectividad,
      Value<bool> qaBateria,
      Value<bool> qaTecladoTouchpad,
      Value<double> costoManoObra,
    });

final class $$FormatoActividadesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FormatoActividadesTableTable,
          FormatoActividadesTableData
        > {
  $$FormatoActividadesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdenesTableTable _ordenIdTable(_$AppDatabase db) => db.ordenesTable
      .createAlias('formato_actividades_table__orden_id__ordenes_table__id');

  $$OrdenesTableTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager = $$OrdenesTableTableTableManager(
      $_db,
      $_db.ordenesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FormatoActividadesTableTableFilterComposer
    extends Composer<_$AppDatabase, $FormatoActividadesTableTable> {
  $$FormatoActividadesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get procedimientosRealizados => $composableBuilder(
    column: $table.procedimientosRealizados,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pastaTermica => $composableBuilder(
    column: $table.pastaTermica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alcoholIsopropilico => $composableBuilder(
    column: $table.alcoholIsopropilico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sopleteadoContactos => $composableBuilder(
    column: $table.sopleteadoContactos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get brochaAntiestatica => $composableBuilder(
    column: $table.brochaAntiestatica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get panoMicrofibra => $composableBuilder(
    column: $table.panoMicrofibra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get depuracionTemporales => $composableBuilder(
    column: $table.depuracionTemporales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get optimizacionInicio => $composableBuilder(
    column: $table.optimizacionInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get escaneoMalware => $composableBuilder(
    column: $table.escaneoMalware,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get actualizacionDrivers => $composableBuilder(
    column: $table.actualizacionDrivers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get comprobacionDisco => $composableBuilder(
    column: $table.comprobacionDisco,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get qaEstresTermico => $composableBuilder(
    column: $table.qaEstresTermico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get qaPuertos => $composableBuilder(
    column: $table.qaPuertos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get qaConectividad => $composableBuilder(
    column: $table.qaConectividad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get qaBateria => $composableBuilder(
    column: $table.qaBateria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get qaTecladoTouchpad => $composableBuilder(
    column: $table.qaTecladoTouchpad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costoManoObra => $composableBuilder(
    column: $table.costoManoObra,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesTableTableFilterComposer get ordenId {
    final $$OrdenesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableFilterComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormatoActividadesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FormatoActividadesTableTable> {
  $$FormatoActividadesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get procedimientosRealizados => $composableBuilder(
    column: $table.procedimientosRealizados,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pastaTermica => $composableBuilder(
    column: $table.pastaTermica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alcoholIsopropilico => $composableBuilder(
    column: $table.alcoholIsopropilico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sopleteadoContactos => $composableBuilder(
    column: $table.sopleteadoContactos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get brochaAntiestatica => $composableBuilder(
    column: $table.brochaAntiestatica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get panoMicrofibra => $composableBuilder(
    column: $table.panoMicrofibra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get depuracionTemporales => $composableBuilder(
    column: $table.depuracionTemporales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get optimizacionInicio => $composableBuilder(
    column: $table.optimizacionInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get escaneoMalware => $composableBuilder(
    column: $table.escaneoMalware,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get actualizacionDrivers => $composableBuilder(
    column: $table.actualizacionDrivers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get comprobacionDisco => $composableBuilder(
    column: $table.comprobacionDisco,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get qaEstresTermico => $composableBuilder(
    column: $table.qaEstresTermico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get qaPuertos => $composableBuilder(
    column: $table.qaPuertos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get qaConectividad => $composableBuilder(
    column: $table.qaConectividad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get qaBateria => $composableBuilder(
    column: $table.qaBateria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get qaTecladoTouchpad => $composableBuilder(
    column: $table.qaTecladoTouchpad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costoManoObra => $composableBuilder(
    column: $table.costoManoObra,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesTableTableOrderingComposer get ordenId {
    final $$OrdenesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableOrderingComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormatoActividadesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormatoActividadesTableTable> {
  $$FormatoActividadesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get procedimientosRealizados => $composableBuilder(
    column: $table.procedimientosRealizados,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pastaTermica => $composableBuilder(
    column: $table.pastaTermica,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get alcoholIsopropilico => $composableBuilder(
    column: $table.alcoholIsopropilico,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sopleteadoContactos => $composableBuilder(
    column: $table.sopleteadoContactos,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get brochaAntiestatica => $composableBuilder(
    column: $table.brochaAntiestatica,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get panoMicrofibra => $composableBuilder(
    column: $table.panoMicrofibra,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get depuracionTemporales => $composableBuilder(
    column: $table.depuracionTemporales,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get optimizacionInicio => $composableBuilder(
    column: $table.optimizacionInicio,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get escaneoMalware => $composableBuilder(
    column: $table.escaneoMalware,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get actualizacionDrivers => $composableBuilder(
    column: $table.actualizacionDrivers,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get comprobacionDisco => $composableBuilder(
    column: $table.comprobacionDisco,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get qaEstresTermico => $composableBuilder(
    column: $table.qaEstresTermico,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get qaPuertos =>
      $composableBuilder(column: $table.qaPuertos, builder: (column) => column);

  GeneratedColumn<bool> get qaConectividad => $composableBuilder(
    column: $table.qaConectividad,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get qaBateria =>
      $composableBuilder(column: $table.qaBateria, builder: (column) => column);

  GeneratedColumn<bool> get qaTecladoTouchpad => $composableBuilder(
    column: $table.qaTecladoTouchpad,
    builder: (column) => column,
  );

  GeneratedColumn<double> get costoManoObra => $composableBuilder(
    column: $table.costoManoObra,
    builder: (column) => column,
  );

  $$OrdenesTableTableAnnotationComposer get ordenId {
    final $$OrdenesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormatoActividadesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FormatoActividadesTableTable,
          FormatoActividadesTableData,
          $$FormatoActividadesTableTableFilterComposer,
          $$FormatoActividadesTableTableOrderingComposer,
          $$FormatoActividadesTableTableAnnotationComposer,
          $$FormatoActividadesTableTableCreateCompanionBuilder,
          $$FormatoActividadesTableTableUpdateCompanionBuilder,
          (
            FormatoActividadesTableData,
            $$FormatoActividadesTableTableReferences,
          ),
          FormatoActividadesTableData,
          PrefetchHooks Function({bool ordenId})
        > {
  $$FormatoActividadesTableTableTableManager(
    _$AppDatabase db,
    $FormatoActividadesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormatoActividadesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FormatoActividadesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FormatoActividadesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ordenId = const Value.absent(),
                Value<String?> procedimientosRealizados = const Value.absent(),
                Value<bool> pastaTermica = const Value.absent(),
                Value<bool> alcoholIsopropilico = const Value.absent(),
                Value<bool> sopleteadoContactos = const Value.absent(),
                Value<bool> brochaAntiestatica = const Value.absent(),
                Value<bool> panoMicrofibra = const Value.absent(),
                Value<bool> depuracionTemporales = const Value.absent(),
                Value<bool> optimizacionInicio = const Value.absent(),
                Value<bool> escaneoMalware = const Value.absent(),
                Value<bool> actualizacionDrivers = const Value.absent(),
                Value<bool> comprobacionDisco = const Value.absent(),
                Value<bool> qaEstresTermico = const Value.absent(),
                Value<bool> qaPuertos = const Value.absent(),
                Value<bool> qaConectividad = const Value.absent(),
                Value<bool> qaBateria = const Value.absent(),
                Value<bool> qaTecladoTouchpad = const Value.absent(),
                Value<double> costoManoObra = const Value.absent(),
              }) => FormatoActividadesTableCompanion(
                id: id,
                ordenId: ordenId,
                procedimientosRealizados: procedimientosRealizados,
                pastaTermica: pastaTermica,
                alcoholIsopropilico: alcoholIsopropilico,
                sopleteadoContactos: sopleteadoContactos,
                brochaAntiestatica: brochaAntiestatica,
                panoMicrofibra: panoMicrofibra,
                depuracionTemporales: depuracionTemporales,
                optimizacionInicio: optimizacionInicio,
                escaneoMalware: escaneoMalware,
                actualizacionDrivers: actualizacionDrivers,
                comprobacionDisco: comprobacionDisco,
                qaEstresTermico: qaEstresTermico,
                qaPuertos: qaPuertos,
                qaConectividad: qaConectividad,
                qaBateria: qaBateria,
                qaTecladoTouchpad: qaTecladoTouchpad,
                costoManoObra: costoManoObra,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ordenId,
                Value<String?> procedimientosRealizados = const Value.absent(),
                Value<bool> pastaTermica = const Value.absent(),
                Value<bool> alcoholIsopropilico = const Value.absent(),
                Value<bool> sopleteadoContactos = const Value.absent(),
                Value<bool> brochaAntiestatica = const Value.absent(),
                Value<bool> panoMicrofibra = const Value.absent(),
                Value<bool> depuracionTemporales = const Value.absent(),
                Value<bool> optimizacionInicio = const Value.absent(),
                Value<bool> escaneoMalware = const Value.absent(),
                Value<bool> actualizacionDrivers = const Value.absent(),
                Value<bool> comprobacionDisco = const Value.absent(),
                Value<bool> qaEstresTermico = const Value.absent(),
                Value<bool> qaPuertos = const Value.absent(),
                Value<bool> qaConectividad = const Value.absent(),
                Value<bool> qaBateria = const Value.absent(),
                Value<bool> qaTecladoTouchpad = const Value.absent(),
                Value<double> costoManoObra = const Value.absent(),
              }) => FormatoActividadesTableCompanion.insert(
                id: id,
                ordenId: ordenId,
                procedimientosRealizados: procedimientosRealizados,
                pastaTermica: pastaTermica,
                alcoholIsopropilico: alcoholIsopropilico,
                sopleteadoContactos: sopleteadoContactos,
                brochaAntiestatica: brochaAntiestatica,
                panoMicrofibra: panoMicrofibra,
                depuracionTemporales: depuracionTemporales,
                optimizacionInicio: optimizacionInicio,
                escaneoMalware: escaneoMalware,
                actualizacionDrivers: actualizacionDrivers,
                comprobacionDisco: comprobacionDisco,
                qaEstresTermico: qaEstresTermico,
                qaPuertos: qaPuertos,
                qaConectividad: qaConectividad,
                qaBateria: qaBateria,
                qaTecladoTouchpad: qaTecladoTouchpad,
                costoManoObra: costoManoObra,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $FormatoActividadesTableTable,
                    FormatoActividadesTableData
                  >(table),
                  $$FormatoActividadesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable:
                            $$FormatoActividadesTableTableReferences
                                ._ordenIdTable(db),
                        referencedColumn:
                            $$FormatoActividadesTableTableReferences
                                ._ordenIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FormatoActividadesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FormatoActividadesTableTable,
      FormatoActividadesTableData,
      $$FormatoActividadesTableTableFilterComposer,
      $$FormatoActividadesTableTableOrderingComposer,
      $$FormatoActividadesTableTableAnnotationComposer,
      $$FormatoActividadesTableTableCreateCompanionBuilder,
      $$FormatoActividadesTableTableUpdateCompanionBuilder,
      (FormatoActividadesTableData, $$FormatoActividadesTableTableReferences),
      FormatoActividadesTableData,
      PrefetchHooks Function({bool ordenId})
    >;
typedef $$RepuestosOrdenTableTableCreateCompanionBuilder =
    RepuestosOrdenTableCompanion Function({
      Value<int> id,
      required int ordenId,
      required String referencia,
      Value<int> cantidad,
      required double precioUnitario,
      required double subtotal,
    });
typedef $$RepuestosOrdenTableTableUpdateCompanionBuilder =
    RepuestosOrdenTableCompanion Function({
      Value<int> id,
      Value<int> ordenId,
      Value<String> referencia,
      Value<int> cantidad,
      Value<double> precioUnitario,
      Value<double> subtotal,
    });

final class $$RepuestosOrdenTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RepuestosOrdenTableTable,
          RepuestosOrdenTableData
        > {
  $$RepuestosOrdenTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdenesTableTable _ordenIdTable(_$AppDatabase db) => db.ordenesTable
      .createAlias('repuestos_orden_table__orden_id__ordenes_table__id');

  $$OrdenesTableTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager = $$OrdenesTableTableTableManager(
      $_db,
      $_db.ordenesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RepuestosOrdenTableTableFilterComposer
    extends Composer<_$AppDatabase, $RepuestosOrdenTableTable> {
  $$RepuestosOrdenTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesTableTableFilterComposer get ordenId {
    final $$OrdenesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableFilterComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepuestosOrdenTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RepuestosOrdenTableTable> {
  $$RepuestosOrdenTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesTableTableOrderingComposer get ordenId {
    final $$OrdenesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableOrderingComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepuestosOrdenTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepuestosOrdenTableTable> {
  $$RepuestosOrdenTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  $$OrdenesTableTableAnnotationComposer get ordenId {
    final $$OrdenesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepuestosOrdenTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepuestosOrdenTableTable,
          RepuestosOrdenTableData,
          $$RepuestosOrdenTableTableFilterComposer,
          $$RepuestosOrdenTableTableOrderingComposer,
          $$RepuestosOrdenTableTableAnnotationComposer,
          $$RepuestosOrdenTableTableCreateCompanionBuilder,
          $$RepuestosOrdenTableTableUpdateCompanionBuilder,
          (RepuestosOrdenTableData, $$RepuestosOrdenTableTableReferences),
          RepuestosOrdenTableData,
          PrefetchHooks Function({bool ordenId})
        > {
  $$RepuestosOrdenTableTableTableManager(
    _$AppDatabase db,
    $RepuestosOrdenTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepuestosOrdenTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepuestosOrdenTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RepuestosOrdenTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ordenId = const Value.absent(),
                Value<String> referencia = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
              }) => RepuestosOrdenTableCompanion(
                id: id,
                ordenId: ordenId,
                referencia: referencia,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                subtotal: subtotal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ordenId,
                required String referencia,
                Value<int> cantidad = const Value.absent(),
                required double precioUnitario,
                required double subtotal,
              }) => RepuestosOrdenTableCompanion.insert(
                id: id,
                ordenId: ordenId,
                referencia: referencia,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                subtotal: subtotal,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $RepuestosOrdenTableTable,
                    RepuestosOrdenTableData
                  >(table),
                  $$RepuestosOrdenTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable: $$RepuestosOrdenTableTableReferences
                            ._ordenIdTable(db),
                        referencedColumn: $$RepuestosOrdenTableTableReferences
                            ._ordenIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RepuestosOrdenTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepuestosOrdenTableTable,
      RepuestosOrdenTableData,
      $$RepuestosOrdenTableTableFilterComposer,
      $$RepuestosOrdenTableTableOrderingComposer,
      $$RepuestosOrdenTableTableAnnotationComposer,
      $$RepuestosOrdenTableTableCreateCompanionBuilder,
      $$RepuestosOrdenTableTableUpdateCompanionBuilder,
      (RepuestosOrdenTableData, $$RepuestosOrdenTableTableReferences),
      RepuestosOrdenTableData,
      PrefetchHooks Function({bool ordenId})
    >;
typedef $$FormatoActaEntregaTableTableCreateCompanionBuilder =
    FormatoActaEntregaTableCompanion Function({
      Value<int> id,
      required int ordenId,
      required String estadoOperatividad,
      Value<String?> observaciones,
      Value<String?> recomendacionesCuidado,
      required String garantiaDias,
      required String personaRecibeNombre,
      required String personaRecibeDocumento,
      Value<bool> checkConformidad,
      Value<DateTime> fechaEntrega,
    });
typedef $$FormatoActaEntregaTableTableUpdateCompanionBuilder =
    FormatoActaEntregaTableCompanion Function({
      Value<int> id,
      Value<int> ordenId,
      Value<String> estadoOperatividad,
      Value<String?> observaciones,
      Value<String?> recomendacionesCuidado,
      Value<String> garantiaDias,
      Value<String> personaRecibeNombre,
      Value<String> personaRecibeDocumento,
      Value<bool> checkConformidad,
      Value<DateTime> fechaEntrega,
    });

final class $$FormatoActaEntregaTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FormatoActaEntregaTableTable,
          FormatoActaEntregaTableData
        > {
  $$FormatoActaEntregaTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdenesTableTable _ordenIdTable(_$AppDatabase db) => db.ordenesTable
      .createAlias('formato_acta_entrega_table__orden_id__ordenes_table__id');

  $$OrdenesTableTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager = $$OrdenesTableTableTableManager(
      $_db,
      $_db.ordenesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FormatoActaEntregaTableTableFilterComposer
    extends Composer<_$AppDatabase, $FormatoActaEntregaTableTable> {
  $$FormatoActaEntregaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estadoOperatividad => $composableBuilder(
    column: $table.estadoOperatividad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recomendacionesCuidado => $composableBuilder(
    column: $table.recomendacionesCuidado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get garantiaDias => $composableBuilder(
    column: $table.garantiaDias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personaRecibeNombre => $composableBuilder(
    column: $table.personaRecibeNombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personaRecibeDocumento => $composableBuilder(
    column: $table.personaRecibeDocumento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checkConformidad => $composableBuilder(
    column: $table.checkConformidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesTableTableFilterComposer get ordenId {
    final $$OrdenesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableFilterComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormatoActaEntregaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FormatoActaEntregaTableTable> {
  $$FormatoActaEntregaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoOperatividad => $composableBuilder(
    column: $table.estadoOperatividad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recomendacionesCuidado => $composableBuilder(
    column: $table.recomendacionesCuidado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get garantiaDias => $composableBuilder(
    column: $table.garantiaDias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personaRecibeNombre => $composableBuilder(
    column: $table.personaRecibeNombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personaRecibeDocumento => $composableBuilder(
    column: $table.personaRecibeDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checkConformidad => $composableBuilder(
    column: $table.checkConformidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesTableTableOrderingComposer get ordenId {
    final $$OrdenesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableOrderingComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormatoActaEntregaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormatoActaEntregaTableTable> {
  $$FormatoActaEntregaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get estadoOperatividad => $composableBuilder(
    column: $table.estadoOperatividad,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recomendacionesCuidado => $composableBuilder(
    column: $table.recomendacionesCuidado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get garantiaDias => $composableBuilder(
    column: $table.garantiaDias,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personaRecibeNombre => $composableBuilder(
    column: $table.personaRecibeNombre,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personaRecibeDocumento => $composableBuilder(
    column: $table.personaRecibeDocumento,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get checkConformidad => $composableBuilder(
    column: $table.checkConformidad,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => column,
  );

  $$OrdenesTableTableAnnotationComposer get ordenId {
    final $$OrdenesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormatoActaEntregaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FormatoActaEntregaTableTable,
          FormatoActaEntregaTableData,
          $$FormatoActaEntregaTableTableFilterComposer,
          $$FormatoActaEntregaTableTableOrderingComposer,
          $$FormatoActaEntregaTableTableAnnotationComposer,
          $$FormatoActaEntregaTableTableCreateCompanionBuilder,
          $$FormatoActaEntregaTableTableUpdateCompanionBuilder,
          (
            FormatoActaEntregaTableData,
            $$FormatoActaEntregaTableTableReferences,
          ),
          FormatoActaEntregaTableData,
          PrefetchHooks Function({bool ordenId})
        > {
  $$FormatoActaEntregaTableTableTableManager(
    _$AppDatabase db,
    $FormatoActaEntregaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormatoActaEntregaTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FormatoActaEntregaTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FormatoActaEntregaTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ordenId = const Value.absent(),
                Value<String> estadoOperatividad = const Value.absent(),
                Value<String?> observaciones = const Value.absent(),
                Value<String?> recomendacionesCuidado = const Value.absent(),
                Value<String> garantiaDias = const Value.absent(),
                Value<String> personaRecibeNombre = const Value.absent(),
                Value<String> personaRecibeDocumento = const Value.absent(),
                Value<bool> checkConformidad = const Value.absent(),
                Value<DateTime> fechaEntrega = const Value.absent(),
              }) => FormatoActaEntregaTableCompanion(
                id: id,
                ordenId: ordenId,
                estadoOperatividad: estadoOperatividad,
                observaciones: observaciones,
                recomendacionesCuidado: recomendacionesCuidado,
                garantiaDias: garantiaDias,
                personaRecibeNombre: personaRecibeNombre,
                personaRecibeDocumento: personaRecibeDocumento,
                checkConformidad: checkConformidad,
                fechaEntrega: fechaEntrega,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ordenId,
                required String estadoOperatividad,
                Value<String?> observaciones = const Value.absent(),
                Value<String?> recomendacionesCuidado = const Value.absent(),
                required String garantiaDias,
                required String personaRecibeNombre,
                required String personaRecibeDocumento,
                Value<bool> checkConformidad = const Value.absent(),
                Value<DateTime> fechaEntrega = const Value.absent(),
              }) => FormatoActaEntregaTableCompanion.insert(
                id: id,
                ordenId: ordenId,
                estadoOperatividad: estadoOperatividad,
                observaciones: observaciones,
                recomendacionesCuidado: recomendacionesCuidado,
                garantiaDias: garantiaDias,
                personaRecibeNombre: personaRecibeNombre,
                personaRecibeDocumento: personaRecibeDocumento,
                checkConformidad: checkConformidad,
                fechaEntrega: fechaEntrega,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $FormatoActaEntregaTableTable,
                    FormatoActaEntregaTableData
                  >(table),
                  $$FormatoActaEntregaTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable:
                            $$FormatoActaEntregaTableTableReferences
                                ._ordenIdTable(db),
                        referencedColumn:
                            $$FormatoActaEntregaTableTableReferences
                                ._ordenIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FormatoActaEntregaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FormatoActaEntregaTableTable,
      FormatoActaEntregaTableData,
      $$FormatoActaEntregaTableTableFilterComposer,
      $$FormatoActaEntregaTableTableOrderingComposer,
      $$FormatoActaEntregaTableTableAnnotationComposer,
      $$FormatoActaEntregaTableTableCreateCompanionBuilder,
      $$FormatoActaEntregaTableTableUpdateCompanionBuilder,
      (FormatoActaEntregaTableData, $$FormatoActaEntregaTableTableReferences),
      FormatoActaEntregaTableData,
      PrefetchHooks Function({bool ordenId})
    >;
typedef $$FotosEvidenciaTableTableCreateCompanionBuilder =
    FotosEvidenciaTableCompanion Function({
      Value<int> id,
      required int ordenId,
      required String etapa,
      required String rutaOBytesBase64,
      Value<String?> notaTecnica,
      Value<DateTime> fechaCaptura,
    });
typedef $$FotosEvidenciaTableTableUpdateCompanionBuilder =
    FotosEvidenciaTableCompanion Function({
      Value<int> id,
      Value<int> ordenId,
      Value<String> etapa,
      Value<String> rutaOBytesBase64,
      Value<String?> notaTecnica,
      Value<DateTime> fechaCaptura,
    });

final class $$FotosEvidenciaTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FotosEvidenciaTableTable,
          FotosEvidenciaTableData
        > {
  $$FotosEvidenciaTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdenesTableTable _ordenIdTable(_$AppDatabase db) => db.ordenesTable
      .createAlias('fotos_evidencia_table__orden_id__ordenes_table__id');

  $$OrdenesTableTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager = $$OrdenesTableTableTableManager(
      $_db,
      $_db.ordenesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FotosEvidenciaTableTableFilterComposer
    extends Composer<_$AppDatabase, $FotosEvidenciaTableTable> {
  $$FotosEvidenciaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etapa => $composableBuilder(
    column: $table.etapa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutaOBytesBase64 => $composableBuilder(
    column: $table.rutaOBytesBase64,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notaTecnica => $composableBuilder(
    column: $table.notaTecnica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCaptura => $composableBuilder(
    column: $table.fechaCaptura,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdenesTableTableFilterComposer get ordenId {
    final $$OrdenesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableFilterComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FotosEvidenciaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FotosEvidenciaTableTable> {
  $$FotosEvidenciaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etapa => $composableBuilder(
    column: $table.etapa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutaOBytesBase64 => $composableBuilder(
    column: $table.rutaOBytesBase64,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notaTecnica => $composableBuilder(
    column: $table.notaTecnica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCaptura => $composableBuilder(
    column: $table.fechaCaptura,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdenesTableTableOrderingComposer get ordenId {
    final $$OrdenesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableOrderingComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FotosEvidenciaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FotosEvidenciaTableTable> {
  $$FotosEvidenciaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get etapa =>
      $composableBuilder(column: $table.etapa, builder: (column) => column);

  GeneratedColumn<String> get rutaOBytesBase64 => $composableBuilder(
    column: $table.rutaOBytesBase64,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notaTecnica => $composableBuilder(
    column: $table.notaTecnica,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaCaptura => $composableBuilder(
    column: $table.fechaCaptura,
    builder: (column) => column,
  );

  $$OrdenesTableTableAnnotationComposer get ordenId {
    final $$OrdenesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordenId,
      referencedTable: $db.ordenesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdenesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.ordenesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FotosEvidenciaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FotosEvidenciaTableTable,
          FotosEvidenciaTableData,
          $$FotosEvidenciaTableTableFilterComposer,
          $$FotosEvidenciaTableTableOrderingComposer,
          $$FotosEvidenciaTableTableAnnotationComposer,
          $$FotosEvidenciaTableTableCreateCompanionBuilder,
          $$FotosEvidenciaTableTableUpdateCompanionBuilder,
          (FotosEvidenciaTableData, $$FotosEvidenciaTableTableReferences),
          FotosEvidenciaTableData,
          PrefetchHooks Function({bool ordenId})
        > {
  $$FotosEvidenciaTableTableTableManager(
    _$AppDatabase db,
    $FotosEvidenciaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FotosEvidenciaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FotosEvidenciaTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FotosEvidenciaTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ordenId = const Value.absent(),
                Value<String> etapa = const Value.absent(),
                Value<String> rutaOBytesBase64 = const Value.absent(),
                Value<String?> notaTecnica = const Value.absent(),
                Value<DateTime> fechaCaptura = const Value.absent(),
              }) => FotosEvidenciaTableCompanion(
                id: id,
                ordenId: ordenId,
                etapa: etapa,
                rutaOBytesBase64: rutaOBytesBase64,
                notaTecnica: notaTecnica,
                fechaCaptura: fechaCaptura,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ordenId,
                required String etapa,
                required String rutaOBytesBase64,
                Value<String?> notaTecnica = const Value.absent(),
                Value<DateTime> fechaCaptura = const Value.absent(),
              }) => FotosEvidenciaTableCompanion.insert(
                id: id,
                ordenId: ordenId,
                etapa: etapa,
                rutaOBytesBase64: rutaOBytesBase64,
                notaTecnica: notaTecnica,
                fechaCaptura: fechaCaptura,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $FotosEvidenciaTableTable,
                    FotosEvidenciaTableData
                  >(table),
                  $$FotosEvidenciaTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordenId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ordenId,
                        referencedTable: $$FotosEvidenciaTableTableReferences
                            ._ordenIdTable(db),
                        referencedColumn: $$FotosEvidenciaTableTableReferences
                            ._ordenIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FotosEvidenciaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FotosEvidenciaTableTable,
      FotosEvidenciaTableData,
      $$FotosEvidenciaTableTableFilterComposer,
      $$FotosEvidenciaTableTableOrderingComposer,
      $$FotosEvidenciaTableTableAnnotationComposer,
      $$FotosEvidenciaTableTableCreateCompanionBuilder,
      $$FotosEvidenciaTableTableUpdateCompanionBuilder,
      (FotosEvidenciaTableData, $$FotosEvidenciaTableTableReferences),
      FotosEvidenciaTableData,
      PrefetchHooks Function({bool ordenId})
    >;
typedef $$ConfiguracionEmpresaTableTableCreateCompanionBuilder =
    ConfiguracionEmpresaTableCompanion Function({
      Value<int> id,
      Value<String> nombreEmpresa,
      Value<String> slogan,
      Value<String> nit,
      Value<String> telefono,
      Value<String> email,
      Value<String> direccion,
      Value<String> ciudad,
      Value<String?> logoBase64,
      Value<String?> smtpHost,
      Value<int?> smtpPort,
      Value<String?> smtpUser,
      Value<String?> smtpPass,
      Value<String> colorPrimario,
      Value<String> colorSecundario,
      Value<bool> isSetupCompleted,
    });
typedef $$ConfiguracionEmpresaTableTableUpdateCompanionBuilder =
    ConfiguracionEmpresaTableCompanion Function({
      Value<int> id,
      Value<String> nombreEmpresa,
      Value<String> slogan,
      Value<String> nit,
      Value<String> telefono,
      Value<String> email,
      Value<String> direccion,
      Value<String> ciudad,
      Value<String?> logoBase64,
      Value<String?> smtpHost,
      Value<int?> smtpPort,
      Value<String?> smtpUser,
      Value<String?> smtpPass,
      Value<String> colorPrimario,
      Value<String> colorSecundario,
      Value<bool> isSetupCompleted,
    });

class $$ConfiguracionEmpresaTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConfiguracionEmpresaTableTable> {
  $$ConfiguracionEmpresaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreEmpresa => $composableBuilder(
    column: $table.nombreEmpresa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slogan => $composableBuilder(
    column: $table.slogan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nit => $composableBuilder(
    column: $table.nit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ciudad => $composableBuilder(
    column: $table.ciudad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoBase64 => $composableBuilder(
    column: $table.logoBase64,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smtpHost => $composableBuilder(
    column: $table.smtpHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get smtpPort => $composableBuilder(
    column: $table.smtpPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smtpUser => $composableBuilder(
    column: $table.smtpUser,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smtpPass => $composableBuilder(
    column: $table.smtpPass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorPrimario => $composableBuilder(
    column: $table.colorPrimario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorSecundario => $composableBuilder(
    column: $table.colorSecundario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSetupCompleted => $composableBuilder(
    column: $table.isSetupCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfiguracionEmpresaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfiguracionEmpresaTableTable> {
  $$ConfiguracionEmpresaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreEmpresa => $composableBuilder(
    column: $table.nombreEmpresa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slogan => $composableBuilder(
    column: $table.slogan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nit => $composableBuilder(
    column: $table.nit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ciudad => $composableBuilder(
    column: $table.ciudad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoBase64 => $composableBuilder(
    column: $table.logoBase64,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smtpHost => $composableBuilder(
    column: $table.smtpHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get smtpPort => $composableBuilder(
    column: $table.smtpPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smtpUser => $composableBuilder(
    column: $table.smtpUser,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smtpPass => $composableBuilder(
    column: $table.smtpPass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorPrimario => $composableBuilder(
    column: $table.colorPrimario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorSecundario => $composableBuilder(
    column: $table.colorSecundario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSetupCompleted => $composableBuilder(
    column: $table.isSetupCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfiguracionEmpresaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfiguracionEmpresaTableTable> {
  $$ConfiguracionEmpresaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreEmpresa => $composableBuilder(
    column: $table.nombreEmpresa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slogan =>
      $composableBuilder(column: $table.slogan, builder: (column) => column);

  GeneratedColumn<String> get nit =>
      $composableBuilder(column: $table.nit, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get ciudad =>
      $composableBuilder(column: $table.ciudad, builder: (column) => column);

  GeneratedColumn<String> get logoBase64 => $composableBuilder(
    column: $table.logoBase64,
    builder: (column) => column,
  );

  GeneratedColumn<String> get smtpHost =>
      $composableBuilder(column: $table.smtpHost, builder: (column) => column);

  GeneratedColumn<int> get smtpPort =>
      $composableBuilder(column: $table.smtpPort, builder: (column) => column);

  GeneratedColumn<String> get smtpUser =>
      $composableBuilder(column: $table.smtpUser, builder: (column) => column);

  GeneratedColumn<String> get smtpPass =>
      $composableBuilder(column: $table.smtpPass, builder: (column) => column);

  GeneratedColumn<String> get colorPrimario => $composableBuilder(
    column: $table.colorPrimario,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorSecundario => $composableBuilder(
    column: $table.colorSecundario,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSetupCompleted => $composableBuilder(
    column: $table.isSetupCompleted,
    builder: (column) => column,
  );
}

class $$ConfiguracionEmpresaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfiguracionEmpresaTableTable,
          ConfiguracionEmpresaTableData,
          $$ConfiguracionEmpresaTableTableFilterComposer,
          $$ConfiguracionEmpresaTableTableOrderingComposer,
          $$ConfiguracionEmpresaTableTableAnnotationComposer,
          $$ConfiguracionEmpresaTableTableCreateCompanionBuilder,
          $$ConfiguracionEmpresaTableTableUpdateCompanionBuilder,
          (
            ConfiguracionEmpresaTableData,
            BaseReferences<
              _$AppDatabase,
              $ConfiguracionEmpresaTableTable,
              ConfiguracionEmpresaTableData
            >,
          ),
          ConfiguracionEmpresaTableData,
          PrefetchHooks Function()
        > {
  $$ConfiguracionEmpresaTableTableTableManager(
    _$AppDatabase db,
    $ConfiguracionEmpresaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracionEmpresaTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ConfiguracionEmpresaTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ConfiguracionEmpresaTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombreEmpresa = const Value.absent(),
                Value<String> slogan = const Value.absent(),
                Value<String> nit = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> ciudad = const Value.absent(),
                Value<String?> logoBase64 = const Value.absent(),
                Value<String?> smtpHost = const Value.absent(),
                Value<int?> smtpPort = const Value.absent(),
                Value<String?> smtpUser = const Value.absent(),
                Value<String?> smtpPass = const Value.absent(),
                Value<String> colorPrimario = const Value.absent(),
                Value<String> colorSecundario = const Value.absent(),
                Value<bool> isSetupCompleted = const Value.absent(),
              }) => ConfiguracionEmpresaTableCompanion(
                id: id,
                nombreEmpresa: nombreEmpresa,
                slogan: slogan,
                nit: nit,
                telefono: telefono,
                email: email,
                direccion: direccion,
                ciudad: ciudad,
                logoBase64: logoBase64,
                smtpHost: smtpHost,
                smtpPort: smtpPort,
                smtpUser: smtpUser,
                smtpPass: smtpPass,
                colorPrimario: colorPrimario,
                colorSecundario: colorSecundario,
                isSetupCompleted: isSetupCompleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombreEmpresa = const Value.absent(),
                Value<String> slogan = const Value.absent(),
                Value<String> nit = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> ciudad = const Value.absent(),
                Value<String?> logoBase64 = const Value.absent(),
                Value<String?> smtpHost = const Value.absent(),
                Value<int?> smtpPort = const Value.absent(),
                Value<String?> smtpUser = const Value.absent(),
                Value<String?> smtpPass = const Value.absent(),
                Value<String> colorPrimario = const Value.absent(),
                Value<String> colorSecundario = const Value.absent(),
                Value<bool> isSetupCompleted = const Value.absent(),
              }) => ConfiguracionEmpresaTableCompanion.insert(
                id: id,
                nombreEmpresa: nombreEmpresa,
                slogan: slogan,
                nit: nit,
                telefono: telefono,
                email: email,
                direccion: direccion,
                ciudad: ciudad,
                logoBase64: logoBase64,
                smtpHost: smtpHost,
                smtpPort: smtpPort,
                smtpUser: smtpUser,
                smtpPass: smtpPass,
                colorPrimario: colorPrimario,
                colorSecundario: colorSecundario,
                isSetupCompleted: isSetupCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ConfiguracionEmpresaTableTable,
                    ConfiguracionEmpresaTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ConfiguracionEmpresaTableTable,
                    ConfiguracionEmpresaTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfiguracionEmpresaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfiguracionEmpresaTableTable,
      ConfiguracionEmpresaTableData,
      $$ConfiguracionEmpresaTableTableFilterComposer,
      $$ConfiguracionEmpresaTableTableOrderingComposer,
      $$ConfiguracionEmpresaTableTableAnnotationComposer,
      $$ConfiguracionEmpresaTableTableCreateCompanionBuilder,
      $$ConfiguracionEmpresaTableTableUpdateCompanionBuilder,
      (
        ConfiguracionEmpresaTableData,
        BaseReferences<
          _$AppDatabase,
          $ConfiguracionEmpresaTableTable,
          ConfiguracionEmpresaTableData
        >,
      ),
      ConfiguracionEmpresaTableData,
      PrefetchHooks Function()
    >;
typedef $$NotificacionesAuditoriaTableTableCreateCompanionBuilder =
    NotificacionesAuditoriaTableCompanion Function({
      Value<int> id,
      required String destinatario,
      required String asunto,
      required String evento,
      required String estado,
      Value<DateTime> fechaEnvio,
    });
typedef $$NotificacionesAuditoriaTableTableUpdateCompanionBuilder =
    NotificacionesAuditoriaTableCompanion Function({
      Value<int> id,
      Value<String> destinatario,
      Value<String> asunto,
      Value<String> evento,
      Value<String> estado,
      Value<DateTime> fechaEnvio,
    });

class $$NotificacionesAuditoriaTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotificacionesAuditoriaTableTable> {
  $$NotificacionesAuditoriaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinatario => $composableBuilder(
    column: $table.destinatario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get asunto => $composableBuilder(
    column: $table.asunto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evento => $composableBuilder(
    column: $table.evento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaEnvio => $composableBuilder(
    column: $table.fechaEnvio,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificacionesAuditoriaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificacionesAuditoriaTableTable> {
  $$NotificacionesAuditoriaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinatario => $composableBuilder(
    column: $table.destinatario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get asunto => $composableBuilder(
    column: $table.asunto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evento => $composableBuilder(
    column: $table.evento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaEnvio => $composableBuilder(
    column: $table.fechaEnvio,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificacionesAuditoriaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificacionesAuditoriaTableTable> {
  $$NotificacionesAuditoriaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get destinatario => $composableBuilder(
    column: $table.destinatario,
    builder: (column) => column,
  );

  GeneratedColumn<String> get asunto =>
      $composableBuilder(column: $table.asunto, builder: (column) => column);

  GeneratedColumn<String> get evento =>
      $composableBuilder(column: $table.evento, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaEnvio => $composableBuilder(
    column: $table.fechaEnvio,
    builder: (column) => column,
  );
}

class $$NotificacionesAuditoriaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificacionesAuditoriaTableTable,
          NotificacionesAuditoriaTableData,
          $$NotificacionesAuditoriaTableTableFilterComposer,
          $$NotificacionesAuditoriaTableTableOrderingComposer,
          $$NotificacionesAuditoriaTableTableAnnotationComposer,
          $$NotificacionesAuditoriaTableTableCreateCompanionBuilder,
          $$NotificacionesAuditoriaTableTableUpdateCompanionBuilder,
          (
            NotificacionesAuditoriaTableData,
            BaseReferences<
              _$AppDatabase,
              $NotificacionesAuditoriaTableTable,
              NotificacionesAuditoriaTableData
            >,
          ),
          NotificacionesAuditoriaTableData,
          PrefetchHooks Function()
        > {
  $$NotificacionesAuditoriaTableTableTableManager(
    _$AppDatabase db,
    $NotificacionesAuditoriaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificacionesAuditoriaTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificacionesAuditoriaTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificacionesAuditoriaTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> destinatario = const Value.absent(),
                Value<String> asunto = const Value.absent(),
                Value<String> evento = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> fechaEnvio = const Value.absent(),
              }) => NotificacionesAuditoriaTableCompanion(
                id: id,
                destinatario: destinatario,
                asunto: asunto,
                evento: evento,
                estado: estado,
                fechaEnvio: fechaEnvio,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String destinatario,
                required String asunto,
                required String evento,
                required String estado,
                Value<DateTime> fechaEnvio = const Value.absent(),
              }) => NotificacionesAuditoriaTableCompanion.insert(
                id: id,
                destinatario: destinatario,
                asunto: asunto,
                evento: evento,
                estado: estado,
                fechaEnvio: fechaEnvio,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $NotificacionesAuditoriaTableTable,
                    NotificacionesAuditoriaTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NotificacionesAuditoriaTableTable,
                    NotificacionesAuditoriaTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificacionesAuditoriaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificacionesAuditoriaTableTable,
      NotificacionesAuditoriaTableData,
      $$NotificacionesAuditoriaTableTableFilterComposer,
      $$NotificacionesAuditoriaTableTableOrderingComposer,
      $$NotificacionesAuditoriaTableTableAnnotationComposer,
      $$NotificacionesAuditoriaTableTableCreateCompanionBuilder,
      $$NotificacionesAuditoriaTableTableUpdateCompanionBuilder,
      (
        NotificacionesAuditoriaTableData,
        BaseReferences<
          _$AppDatabase,
          $NotificacionesAuditoriaTableTable,
          NotificacionesAuditoriaTableData
        >,
      ),
      NotificacionesAuditoriaTableData,
      PrefetchHooks Function()
    >;
typedef $$TiposFallaTableTableCreateCompanionBuilder =
    TiposFallaTableCompanion Function({
      Value<int> id,
      required String tipoServicio,
      required String nombre,
      Value<String?> descripcion,
      Value<bool> activo,
      Value<DateTime> createdAt,
    });
typedef $$TiposFallaTableTableUpdateCompanionBuilder =
    TiposFallaTableCompanion Function({
      Value<int> id,
      Value<String> tipoServicio,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<bool> activo,
      Value<DateTime> createdAt,
    });

class $$TiposFallaTableTableFilterComposer
    extends Composer<_$AppDatabase, $TiposFallaTableTable> {
  $$TiposFallaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoServicio => $composableBuilder(
    column: $table.tipoServicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TiposFallaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TiposFallaTableTable> {
  $$TiposFallaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoServicio => $composableBuilder(
    column: $table.tipoServicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TiposFallaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TiposFallaTableTable> {
  $$TiposFallaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipoServicio => $composableBuilder(
    column: $table.tipoServicio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TiposFallaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TiposFallaTableTable,
          TiposFallaTableData,
          $$TiposFallaTableTableFilterComposer,
          $$TiposFallaTableTableOrderingComposer,
          $$TiposFallaTableTableAnnotationComposer,
          $$TiposFallaTableTableCreateCompanionBuilder,
          $$TiposFallaTableTableUpdateCompanionBuilder,
          (
            TiposFallaTableData,
            BaseReferences<
              _$AppDatabase,
              $TiposFallaTableTable,
              TiposFallaTableData
            >,
          ),
          TiposFallaTableData,
          PrefetchHooks Function()
        > {
  $$TiposFallaTableTableTableManager(
    _$AppDatabase db,
    $TiposFallaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TiposFallaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TiposFallaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TiposFallaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tipoServicio = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TiposFallaTableCompanion(
                id: id,
                tipoServicio: tipoServicio,
                nombre: nombre,
                descripcion: descripcion,
                activo: activo,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tipoServicio,
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TiposFallaTableCompanion.insert(
                id: id,
                tipoServicio: tipoServicio,
                nombre: nombre,
                descripcion: descripcion,
                activo: activo,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TiposFallaTableTable, TiposFallaTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $TiposFallaTableTable,
                    TiposFallaTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TiposFallaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TiposFallaTableTable,
      TiposFallaTableData,
      $$TiposFallaTableTableFilterComposer,
      $$TiposFallaTableTableOrderingComposer,
      $$TiposFallaTableTableAnnotationComposer,
      $$TiposFallaTableTableCreateCompanionBuilder,
      $$TiposFallaTableTableUpdateCompanionBuilder,
      (
        TiposFallaTableData,
        BaseReferences<
          _$AppDatabase,
          $TiposFallaTableTable,
          TiposFallaTableData
        >,
      ),
      TiposFallaTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuariosTableTableTableManager get usuariosTable =>
      $$UsuariosTableTableTableManager(_db, _db.usuariosTable);
  $$ClientesTableTableTableManager get clientesTable =>
      $$ClientesTableTableTableManager(_db, _db.clientesTable);
  $$EquiposTableTableTableManager get equiposTable =>
      $$EquiposTableTableTableManager(_db, _db.equiposTable);
  $$OrdenesTableTableTableManager get ordenesTable =>
      $$OrdenesTableTableTableManager(_db, _db.ordenesTable);
  $$FormatoOtTableTableTableManager get formatoOtTable =>
      $$FormatoOtTableTableTableManager(_db, _db.formatoOtTable);
  $$FormatoActividadesTableTableTableManager get formatoActividadesTable =>
      $$FormatoActividadesTableTableTableManager(
        _db,
        _db.formatoActividadesTable,
      );
  $$RepuestosOrdenTableTableTableManager get repuestosOrdenTable =>
      $$RepuestosOrdenTableTableTableManager(_db, _db.repuestosOrdenTable);
  $$FormatoActaEntregaTableTableTableManager get formatoActaEntregaTable =>
      $$FormatoActaEntregaTableTableTableManager(
        _db,
        _db.formatoActaEntregaTable,
      );
  $$FotosEvidenciaTableTableTableManager get fotosEvidenciaTable =>
      $$FotosEvidenciaTableTableTableManager(_db, _db.fotosEvidenciaTable);
  $$ConfiguracionEmpresaTableTableTableManager get configuracionEmpresaTable =>
      $$ConfiguracionEmpresaTableTableTableManager(
        _db,
        _db.configuracionEmpresaTable,
      );
  $$NotificacionesAuditoriaTableTableTableManager
  get notificacionesAuditoriaTable =>
      $$NotificacionesAuditoriaTableTableTableManager(
        _db,
        _db.notificacionesAuditoriaTable,
      );
  $$TiposFallaTableTableTableManager get tiposFallaTable =>
      $$TiposFallaTableTableTableManager(_db, _db.tiposFallaTable);
}
