-- Ejercicio 1

select p.apellido, p.nombre, con.sueldo, p.dni 
from personas p
inner join contratos con on con.dni = p.dni
where con.nro_contrato = 5;

-- Ejercicio 2

select con.dni, con.nro_contrato, con.fecha_incorporacion, con.fecha_solicitud, ifnull (con.fecha_caducidad , 'Sin fecha')
from empresas emp
inner join contratos con on emp.cuit = con.cuit
where (emp.razon_social = 'Viejos Amigos' or emp.razon_social = 'Traigame eso');

-- Ejercicio 3

select emp.razon_social, emp.direccion, emp.e_mail, car.desc_cargo, sol.anios_experiencia 
from solicitudes_empresas sol
inner join empresas emp on  sol.cuit = emp.cuit
inner join cargos car on car.cod_cargo = sol.cod_cargo
order by sol.fecha_solicitud, car.desc_cargo;

-- Ejercicio 4

select per.dni, per.apellido, per.nombre, tit.desc_titulo
from personas per
inner join personas_titulos pet on per.dni = pet.dni
inner join titulos tit on tit.cod_titulo = pet.cod_titulo
where tit.desc_titulo = 'Bachiller' or tit.tipo_titulo = 'Educacion no formal'
order by per.dni;

-- Ejercicio 5

select per.apellido, per.nombre, tit.desc_titulo
from personas per
inner join personas_titulos pet on per.dni = pet.dni
inner join titulos tit on tit.cod_titulo = pet.cod_titulo;

-- Ejercicio 6 

select * from personas;
select * from antecedentes;
select concat(pe.apellido, " ", pe.nombre, " tiene como referencia a ", ifnull(an.persona_contacto, "No tiene contacto"), " cuando trabajo en ", em.razon_social) Listado
from personas pe
inner join antecedentes an on pe.dni=an.dni
inner join empresas em on em.cuit=an.cuit
where (an.persona_contacto is null or an.persona_contacto='Felipe Rojas' or an.persona_contacto='Armando Esteban Quito')
;

-- Ejercicio 7

select emp.razon_social Empresa, sol.fecha_solicitud 'Fecha solicitud', car.desc_cargo Cargo, ifnull(sol.edad_minima, 'Sin especificar') 'Edad minima', ifnull(sol.edad_maxima, 'Sin especificar')  'Edad maxima', ent.resultado_final
from empresas emp
inner join solicitudes_empresas sol on sol.cuit=emp.cuit
inner join cargos car on car.cod_cargo=sol.cod_cargo
inner join entrevistas ent on ent.cuit=sol.cuit and ent.cod_cargo=car.cod_cargo
where emp.razon_social='Viejos Amigos';

-- Ejercicio 8

select concat(pe.apellido, " ",pe.nombre) Postulante, car.desc_cargo
from personas pe
inner join antecedentes an on pe.dni = an.dni
inner join cargos car on car.cod_cargo = an.cod_cargo;

-- Ejercicio 9

select emp.razon_social Empresa, car.desc_cargo Cargo, eva.desc_evaluacion Desc_evaluacion, entrevistas_evaluaciones.resultado Resultado
from empresas emp
inner join entrevistas ent on emp.cuit = ent.cuit
inner join cargos car on car.cod_cargo = ent.cod_cargo
inner join entrevistas_evaluaciones on entrevistas_evaluaciones.nro_entrevista = ent.nro_entrevista
inner join evaluaciones eva on eva.cod_evaluacion = entrevistas_evaluaciones.cod_evaluacion
order by emp.razon_social asc, car.desc_cargo desc;

-- LEFT/RIGHT JOIN

-- Ejercicio 10

select em.cuit, em.razon_social, ifnull(sol.fecha_solicitud, "Sin solicitud") "Fecha Solicitud" , ifnull(car.desc_cargo, "Sin solicitud") Cargo
from empresas em
left join solicitudes_empresas sol on em.cuit = sol.cuit
left join cargos car on car.cod_cargo = sol.cod_cargo;

-- Ejercicio 11

select em.cuit, em.razon_social, car.desc_cargo, ifnull(per.dni, "sin contrato") DNI, ifnull(per.apellido,"sin contrato") Apellido, ifnull(per.nombre,"sin contrato") Nombre
from empresas em
inner join solicitudes_empresas sol on sol.cuit=em.cuit
inner join cargos car on car.cod_cargo=sol.cod_cargo
left join contratos con on (con.cuit = em.cuit and con.cod_cargo = car.cod_cargo)
left join personas per on per.dni = con.dni; 

-- Ejercicio 12

select em.cuit, em.razon_social, car.desc_cargo
from empresas em
inner join solicitudes_empresas sol on sol.cuit=em.cuit
inner join cargos car on car.cod_cargo=sol.cod_cargo
left join contratos con on (con.cuit=em.cuit and con.cod_cargo=sol.cod_cargo)
where nro_contrato is null;

-- Ejercicio 13

select car.desc_cargo Cargo, ifnull(pe.dni, 'Sin antecedentes') DNI, ifnull(pe.apellido, 'Sin antecedentes') Apellido, em.razon_social
from cargos car
left join antecedentes an on an.cod_cargo=car.cod_cargo
left join personas pe on pe.dni=an.dni
left join empresas em on em.cuit=an.cuit;


