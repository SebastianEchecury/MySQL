/*1) a) Crear una tabla para registrar el histórico de cambios en los datos de los alumnos con
el siguiente script: */

CREATE TABLE `alumnos_historico` (
`dni` int(11) NOT NULL,
`fecha_hora_cambio` datetime NOT NULL,
`nombre` varchar(20) default NULL,
`apellido` varchar(20) default NULL,
`tel` varchar(20) default NULL,
`email` varchar(50) default NULL,
`direccion` varchar(50) default NULL,
`usuario_modificacion` varchar(50) default NULL,
PRIMARY KEY (`dni`,`fecha_hora_cambio`),
CONSTRAINT `alumnos_historico_alumnos_fk` FOREIGN KEY (`dni`) REFERENCES
`alumnos` (`dni`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*b)Luego crear TRIGGERS para insertar los nuevos valores en archivo_historico cuando los
alumnos sean ingresados o sus datos sean modificados. Registrar la fecha y hora actual
con CURRENT_TIMESTAMP y el usuario actual con CURRENT_USER.

CREATE DEFINER=`root`@`localhost` TRIGGER `alumnos_AFTER_INSERT` AFTER INSERT ON `alumnos` FOR EACH ROW BEGIN
insert into alumnos_historico
values (new.dni, current_timestamp(), new.nombre, new.apellido, new.tel, new.email, new.direccion, current_user());
END

CREATE DEFINER = CURRENT_USER TRIGGER `afatse`.`alumnos_AFTER_UPDATE` AFTER UPDATE ON `alumnos` FOR EACH ROW
BEGIN
insert into alumnos_historico
values (old.dni, current_timestamp(), old.nombre, old.apellido, old.tel, old.email, old.direccion, current_user());
END

c)Probarlo ejecutando INSERTS y UPDATES dentro de transacciones. Probar con
ROLLBACK y luego con COMMIT.*/


/*2)a)Crear la tabla stock_movimientos para registrar las cambios en las existencias de
artículos con el siguiente script:*/

CREATE TABLE `stock_movimientos` (
`cod_material` char(6) NOT NULL,
`fecha_movimiento` timestamp NOT NULL default CURRENT_TIMESTAMP on update
CURRENT_TIMESTAMP,
`cantidad_movida` int(11) NOT NULL,
`cantidad_restante` int(11) NOT NULL,
`usuario_movimiento` varchar(50) NOT NULL,
PRIMARY KEY (`cod_material`,`fecha_movimiento`),
 CONSTRAINT `stock_movimientos_fk` FOREIGN KEY (`cod_material`) REFERENCES
`materiales` (`cod_material`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Aclaración: En este caso utilizamos el tipo de datos timestamp en lugar de datetime
para registrar la fecha y hora de la modificación.
En el ejercicio anterior utilizamos el tipo de dato datetime pero entonces debemos
registrar el dato a nosotros (en ese caso lo hicimos con CURRENT_TIMESTAMP). En los
casos donde queremos hacer históricos o asegurarnos de que se registra el momento
exacto en que se inserta un dato es mejor utilizar el tipo de dato timestamp que hace
esto automáticamente pero en los INSERT que realicemos sobre las tablas con estos
datos deberemos omitir este campo.

b)Crear TRIGGERS para registrar los movimientos en las cantidades de los materiales en
la tabla del histórico. En el caso de un nuevo material se debe registrar la cantidad
inicial como la cantidad movida y SÓLO en el caso de un cambio en la cantidad
registrar el cambio.

CREATE DEFINER = CURRENT_USER TRIGGER `afatse`.`materiales_AFTER_INSERT` AFTER INSERT ON `materiales` FOR EACH ROW
BEGIN
if new.cant_disponible is not null then
insert into stock_movimientos values (new.cod_material, current_timestamp(), new.cant_disponible,
new.cant_disponible, current_user());
end if;
END

CREATE DEFINER=`root`@`localhost` TRIGGER `materiales_AFTER_UPDATE` AFTER UPDATE ON `materiales` FOR EACH ROW BEGIN

if new.cant_disponible is not null then
	set @cant_movida=new.cant_disponible-old.cant_disponible;
    if @cant_movida != 0 then
		insert into stock_movimientos values (old.cod_material, current_timestamp(), @cant_movida,
		new.cant_disponible, current_user());
	end if;
end if;
END

c)Probarlo ejecutando INSERTS y UPDATES dentro de transacciones. Probar con
ROLLBACK y luego con COMMIT.*/

start transaction;
insert into materiales values ('A', 'Libro 1', null, null, null, null, 10, null, null);
select * from materiales;
select * from stock_movimientos;
update materiales
set cant_disponible = 50
where cod_material = 'A';
rollback;

/*3)a) Modificar la tabla cursos, agregarle una columna llamada cant_inscriptos que será un
atributo calculado de la cantidad de inscriptos al curso con el siguiente script:*/

alter table `cursos`
add column cant_inscriptos int(11) default null;

/*b) Completar el campo con la cantidad actual de inscriptos con el script:*/

START TRANSACTION;
drop temporary table if exists insc_curso;
create temporary table insc_curso
select c.`nom_plan`, c.`nro_curso`, count(i.`nro_curso`) cant
from cursos c left join `inscripciones` i
on c.`nom_plan`=i.`nom_plan` and c.`nro_curso`=i.`nro_curso`
group by c.`nom_plan`,c.`nro_curso`;
update cursos c inner join insc_curso ic on c.`nom_plan`=ic.`nom_plan`
and c.`nro_curso`=ic.`nro_curso`
set c.`cant_inscriptos`=ic.cant;
commit;

/*c) Hacer obligatorio el campo cant_inscriptos con el script:*/

alter table `cursos`
modify cant_inscriptos int(11) not null;

/*d) Crear los TRIGGERS necesarios para actualizar la cantidad de inscriptos del curso, los
mismos deberán dispararse al inscribir un nuevo alumno y al eliminar una inscripción.

CREATE DEFINER = CURRENT_USER TRIGGER `afatse`.`inscripciones_AFTER_INSERT` AFTER INSERT ON `inscripciones` FOR EACH ROW
BEGIN
update cursos
set cant_inscriptos=cant_inscriptos+1
where nom_plan=new.nom_plan and nro_curso=new.nro_curso;
END

CREATE DEFINER = CURRENT_USER TRIGGER `afatse`.`inscripciones_AFTER_DELETE` AFTER DELETE ON `inscripciones` FOR EACH ROW
BEGIN
update cursos
set cant_inscriptos=cant_inscriptos-1
where nom_plan=old.nom_plan and nro_curso=old.nro_curso;
END

e) Probarlo inscribiendo y anulando inscripciones dentro de transacciones. Realizar las
pruebas con ROLLBACK y con COMMIT.*/

/*4)a) Agregar la columna usuario_alta a la tabla valores_plan con el siguiente script:*/

alter table `valores_plan` add column usuario_alta varchar(50);

/*b) Crear un TRIGGER que una vez insertado el nuevo precio registre el usuario que lo ingresó.

CREATE DEFINER=`root`@`localhost` TRIGGER `valores_plan_BEFORE_INSERT` BEFORE INSERT ON `valores_plan` FOR EACH ROW BEGIN
set new.usuario_alta=current_user();
END

c)Probar el TRIGGER dentro de una transacción. Realizar las pruebas con ROLLABACK yCOMMIT.*/

start transaction;
insert into valores_plan 
values ('Marketing 1', current_date(), 200, null);
select * from valores_plan;
rollback;