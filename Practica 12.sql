/*
1)Crear un procedimiento almacenado llamado plan_lista_precios_actual que devuelva los
planes de capacitación indicando:
nom_plan	modalidad	valor_actual

CREATE DEFINER=`root`@`localhost` PROCEDURE `plan_lista_precios_actual`()
BEGIN
create temporary table maxifecha
select nom_plan, max(fecha_desde_plan) maxif
from valores_plan
where fecha_desde_plan<=current_date()
group by nom_plan;

select vp.nom_plan 'Nombre plan', pc.modalidad Modalidad, vp.valor_plan Valor
from maxifecha mf
inner join valores_plan vp on vp.nom_plan=mf.nom_plan
                           and vp.fecha_desde_plan=mf.maxif
inner join plan_capacitacion pc on pc.nom_plan=vp.nom_plan
;
drop temporary table if exists maxifecha;
END
*/

call plan_lista_precios_actual();

/*
2)Crear un procedimiento almacenado llamado plan_lista_precios_a_fecha que dada una
fecha devuelva los planes de capacitación indicando:
nombre_plan		modalidad	valor_a_fecha

CREATE DEFINER=`root`@`localhost` PROCEDURE `plan_lista_precios_a_fecha`(in fecha_hasta date)
BEGIN
create temporary table maxifecha
select nom_plan, max(fecha_desde_plan) maxif
from valores_plan
where fecha_desde_plan<=fecha_hasta
group by nom_plan;

select vp.nom_plan 'Nombre plan', pc.modalidad Modalidad, vp.valor_plan Valor
from maxifecha mf
inner join valores_plan vp on vp.nom_plan=mf.nom_plan
                           and vp.fecha_desde_plan=mf.maxif
inner join plan_capacitacion pc on pc.nom_plan=vp.nom_plan;
drop temporary table if exists maxifecha;
END
*/

call plan_lista_precios_a_fecha('20140101');

/*4)Crear una función llamada plan_valor que reciba el nombre del plan y una fecha y
devuelva el valor de dicho plan a esa fecha.

CREATE DEFINER=`root`@`localhost` FUNCTION `plan_valor`(nombre_p varchar(20), fecha_hasta date) RETURNS decimal(9,3)
BEGIN
declare valor_a_fecha decimal(9,3);
create temporary table ultfecha
select nom_plan, max(fecha_desde_plan) maxif
from valores_plan
where fecha_desde_plan<=fecha_hasta
group by nom_plan;
select vp.valor_plan into valor_a_fecha
from valores_plan vp
inner join ultfecha u on u.nom_plan=vp.nom_plan
			          and u.maxif=vp.fecha_desde_plan
where vp.nom_plan=nombre_p;
drop temporary table if exists ultfecha;
RETURN valor_a_fecha;
END
*/

select plan_valor('Marketing 1', current_date());

/*
5)Modifique el procedimiento almacenado creado en 2) para que internamente utilice la
función creada en 4)

CREATE DEFINER=`root`@`localhost` PROCEDURE `plan_lista_precios_a_fecha2`(in nombre_pa varchar (20), in fecha_hasta date)
BEGIN
select plan_valor(nombre_pa, fecha_hasta);
END
*/

call plan_lista_precios_a_fecha2('Marketing 1', current_date());

/*6)Crear un procedimiento almacenado llamado alumnos_pagos_deudas_a_fecha que dada
una fecha y un alumno indique cuanto ha pagado hasta esa fecha y cuantas cuotas
adeudaba a dicha fecha (cuotas emitidas y no pagadas). Devolver los resultados en
parámetros de salida

CREATE DEFINER=`root`@`localhost` PROCEDURE `alumnos_pagos_deudas_a_fecha`(in dni_a integer, in fecha_hasta date, out suma decimal (9,3), out cant integer)
BEGIN
set suma := (select sum(importe_pagado)
from cuotas
where fecha_pago<=fecha_hasta
and dni=dni_a
group by dni);

set cant := (select count(*) 
from cuotas
where fecha_pago is null
	  and fecha_emision<=fecha_hasta
      and dni=dni_a);
END*/

call alumnos_pagos_deudas_a_fecha(24242424, current_date(), @total, @canti);
select @total, @canti;

/*7)Crear una función llamada alumnos_deudas_a_fecha que dado un alumno y una fecha
indique cuantas cuotas adeuda a la fecha.

CREATE FUNCTION `alumnos_deudas_a_fecha2` (dni_a integer, fecha_hasta date)
RETURNS INTEGER
BEGIN
declare cant_deudas integer;
select count(*) into cant_deudas
from cuotas
where fecha_emision<=fecha_hasta
and fecha_pago is null
and dni=dni_a
group by dni;
RETURN cant_deudas;
END*/

select alumnos_deudas_a_fecha2(24242424, current_date());

select c.dni, a.apellido, a.nombre, alumnos_deudas_a_fecha2 (c.dni, current_date())
from cuotas c
inner join alumnos a on a.dni=c.dni
group by c.dni;

/*8)Crear un procedimiento almacenado llamado alumno_inscripcion que dados los datos de
un alumno y un curso lo inscriba en dicho curso el día de hoy y genere la primera cuota con
fecha de emisión hoy para el mes próximo.

CREATE DEFINER=`root`@`localhost` PROCEDURE `alumno_inscripcion`(in nombre_p char(20), in nro_c integer, in dni_a integer)
BEGIN
insert into inscripciones
values (nombre_p, nro_c, dni_a, current_date());
select adddate(current_date(), interval 1 month) into @fecha;
insert into cuotas
values (nombre_p, nro_c, dni_a, year(@fecha), month(@fecha),@fecha, null, null);
END*/

start transaction;
call alumno_inscripcion ('Marketing 1', 1, 24242424);
rollback;

/*9) Modificar el procedimiento almacenado creado en 8) para que antes de inscribir a un
alumno valide que el mismo no esté ya inscripto.

CREATE DEFINER=`root`@`localhost` PROCEDURE `alumno_inscripcionel9`(in nombre_p char(20), in nro_c integer, in dni_a integer)
BEGIN
select dni into @dnia
from inscripciones 
where nom_plan=nombre_p and nro_curso=nro_c and dni=dni_a;
if @dnia is not null then
	insert into inscripciones
	values (nombre_p, nro_c, dni_a, current_date());
	select adddate(current_date(), interval 1 month) into @fecha;
	insert into cuotas
	values (nombre_p, nro_c, dni_a, year(@fecha), month(@fecha),@fecha, null, null);
end if;
END
*/

start transaction;
call alumno_inscripcionej9('Marketing 1', 1, 13131313);
rollback;
select * from inscripciones;

/*10) Modificar el procedimiento almacenado editado en 9) para que realice el proceso en una
transacción. Además luego de inscribirlo y generar la cuota verificar si la cantidad de
inscriptos supera el cupo, en ese caso realizar un ROLLBACK. Si la cantidad de inscriptos es
correcta ejecutar un COMMIT

CREATE PROCEDURE `alumno_inscripcionej10` (in nombre_p char(20), in nro_c integer, in dni_a integer)
BEGIN
start transaction;
select dni into @dnia
from inscripciones 
where nom_plan=nombre_p and nro_curso=nro_c and dni=dni_a;
if @dnia is not null then
	insert into inscripciones
	values (nombre_p, nro_c, dni_a, current_date());
	select adddate(current_date(), interval 1 month) into @fecha;
	insert into cuotas
	values (nombre_p, nro_c, dni_a, year(@fecha), month(@fecha),@fecha, null, null);
end if;
select (cupo-cant_inscriptos) into @cupo_libre
from cursos
where nom_plan=nombre_p and nro_curso=nro_c;
if (@cupo_libre>0) then 
	commit;
	else rollback;
end if;
END*/

/*11) Crear dos procedimientos almacenados, aplicando conceptos de reutilización de código:
stock_ingreso dado el código de material y la cantidad ingresada (número positivo) que
realice un ingreso de mercadería.
stock_egreso dado el código de material y la cantidad egresada (número positivo) que
realice un ingreso de mercadería.
Ambos procedimiento deberán devolver la cantidad restante en stock.
Realizar las validaciones pertinentes.

CREATE DEFINER=`root`@`localhost` PROCEDURE `stock_movimiento`(in cod_ingresado char (6), in cant_ingresada int)
BEGIN
start transaction;
select url_descarga into @url
from materiales 
where cod_material=cod_ingresado;
if @url is not null then
	update materiales
    set cant_disponible=cant_disponible+cant_ingresada;
end if;
select cant_disponible into @canti
from materiales 
where cod_material=cod_ingresado;
if (@canti>=0) then 
	commit;
	else rollback;
end if;
END

CREATE DEFINER=`root`@`localhost` PROCEDURE `stock_ingreso`(in cod_ingresado char (6), in cant_ingresada int)
BEGIN
call stock_movimiento(cod_ingresado, cant_ingresada);
END

CREATE DEFINER=`root`@`localhost` PROCEDURE `stock_egreso`(in cod_ingresado char (6), in cant_ingresada int)
BEGIN
set cant_ingresada = -cant_ingresada;
call stock_movimiento(cod_ingresado, cant_ingresada);
END
*/





