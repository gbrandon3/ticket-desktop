const { getRecoveryCode, recoveryFile } = require('./recovery');

console.log('Clave de recuperación del servidor:');
console.log(getRecoveryCode());
console.log(`Guardada en: ${recoveryFile}`);
console.log('Consérvela en un lugar privado. Permite restablecer contraseñas desde el login.');
