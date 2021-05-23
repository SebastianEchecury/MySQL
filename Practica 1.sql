-- EJERCICIO 1

describe empresas;
select * from empresas;

-- EJERCICIO 2

describe personas;
select apellido, nombre, fecha_registro_agencia
from personas;

-- EJERCICIO 4

select concat(apellido, ' ',nombre) "Apellido y Nombre", fecha_nacimiento, Telefono, direccion
from personas
where dni = 28675888;

-- EJERCICIO 5

select concat(apellido, ' ',nombre) "Apellido y Nombre", fecha_nacimiento, Telefono, direccion
from personas
-- where dni = 27890765 or dni = 29345777 or dni = 31345778
where dni in (27890765, 29345777, 31345778)
order by fecha_nacimiento;

-- EJERCICIO 6

select * 
from personas
where apellido like "G%";

-- EJERCICIO 7

select apellido, nombre, fecha_nacimiento
from personas
where year(fecha_nacimiento) >= 1980 and year(fecha_nacimiento) <= 2000;

-- EJERCICIO 8

select * from solicitudes_empresas
order by fecha_solicitud;

-- EJERCICIO 9

select * from antecedentes
where fecha_hasta is null
order by fecha_desde;

-- EJERCICIO 10

select * from antecedentes
where (fecha_hasta is not null) 
and (fecha_hasta < 2013-06-01) and (fecha_hasta > 2013-12-31);

-- EJERCICIO 11

select nro_contrato "Nro Contrato", dni DNI, sueldo Salario, cuit CUIT
from contratos 
where sueldo > 2000 and cuit = "30-10504876-5" or cuit = "30-21098732-4";

-- EJERCICIO 12

select * from titulos
where desc_titulo like "%Tecnico%";

-- EJERCICIO 13

select * from solicitudes_empresas
where ((fecha_solicitud>2013-09-21) and (cod_cargo=6)) or sexo = "Femenino";

-- EJERCICIO 14

select * from contratos
where sueldo > 2000 and fecha_caducidad is null;