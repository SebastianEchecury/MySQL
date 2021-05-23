/*1)Crear el usuario ‘usuario’ con contraseña ‘entre’.*/

create user 'usuario'@'localhost' identified by 'entre';

/*2)Cambiar la contraseña de usuario a ‘entrar’*/

SET PASSWORD FOR 'usuario'@'localhost' = 'entrar';

/*3)Darle permisos a usuario para realizar SELECT de todas las tablas de AGENCIA_PERSONAL.*/

grant select on agencia_personal.*  to'usuario'@'localhost';

/*4)Darle permisos al usuario para realizar (INSERT, UPDATE y DELETE) los datos de la tabla PERSONAS.*/

grant insert, update, delete on agencia_personal.personas to 'usuario'@'localhost';

/*5)Quitarle todos los permisos a usuario.*/

REVOKE SELECT, INSERT, UPDATE, DELETE ON agencia_personal.* FROM 'usuario'@'localhost';

/*6)Darle permisos a usuario de realizar SELECT, INSERT y UPDATE sobre la vista vw_contratos.*/

GRANT UPDATE ON agencia_personal.vw_contratos to usuario@localhost;
GRANT INSERT ON agencia_personal.vw_contratos to usuario@localhost;
GRANT DELETE ON agencia_personal.vw_contratos to usuario@localhost;

/*7)Quitarle a usuario todos los permisos.*/

REVOKE update, insert, delete ON agencia_personal.vw_contratos FROM 'usuario@localhost';

show grants for 'usuario'@'localhost';