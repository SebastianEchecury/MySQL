-- Practica 3

-- Ejercicio 1

select nro_contrato, fecha_incorporacion, fecha_finalizacion_contrato, adddate(fecha_solicitud, interval 30 day)
from contratos
where fecha_caducidad is not null;

-- Ejercicio 3

select con.nro_contrato, datediff(fecha_finalizacion_contrato, fecha_caducidad) "Dias antes"
from contratos con
where fecha_caducidad<fecha_finalizacion_contrato;

-- Ejercicio 4

select emp.cuit, emp.razon_social, emp.direccion, com.anio_contrato,
com.mes_contrato, com.importe_comision, adddate(curdate(), interval +2 month) "Fecha vto"
from empresas emp
inner join contratos con on con.cuit=emp.cuit
inner join comisiones com on com.nro_contrato=con.nro_contrato
where com.fecha_pago is null;

-- Ejercicio 5

select concat(apellido, ' ', nombre) "Nombre y apellido", fecha_nacimiento, year(fecha_nacimiento) Año, month(fecha_nacimiento) Mes, day(fecha_nacimiento) Dia
from personas;
