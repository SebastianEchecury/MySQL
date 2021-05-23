-- Practica 6

-- Ejercicio 1

select * from antecedentes;
select * from contratos;

select a.cuit, e.razon_social, p.dni, p.apellido, p.nombre, a.cod_cargo, c.desc_cargo, 'Antecedente'
from personas p
inner join antecedentes a on a.dni=p.dni
inner join empresas e on e.cuit=a.cuit
inner join cargos c on c.cod_cargo=a.cod_cargo
union
select c.cuit, e.razon_social, p.dni, p.apellido, p.nombre, c.cod_cargo, car.desc_cargo, 'Contrato'
from personas p
inner join contratos c on c.dni=p.dni
inner join empresas e on e.cuit=c.cuit
inner join cargos car on car.cod_cargo=c.cod_cargo;

-- Ejercicio 2

select count(*) into @cantP
from personas;
select @cantP;
drop temporary table if exists contactos;
create temporary table contactos
select e.cuit, e.razon_social, count(distinct c.dni) canti, "Contrato" Tipo
from empresas e
left join contratos c on c.cuit=e.cuit
group by e.cuit
union
select e.cuit, e.razon_social, count(distinct a.dni) canti, "Antecedente" Tipo
from empresas e
left join antecedentes a on a.cuit=e.cuit
group by e.cuit
;

select * from contactos;

select  cuit, razon_social, canti, canti/@cantP, tipo
from contactos;

-- Ejercicio 3 (Falta)

select * -- ifnull(e.cuit, 'Cargo no solicitado'), ifnull(e.razon_social, 'Sin solicitudes'), ifnull(s.fecha_solicitud, 'Sin solicitudes'), c.desc_cargo
from cargos c
left join solicitudes_empresas s on s.cod_cargo=c.cod_cargo
left join empresas e on e.cuit=s.cuit
;

-- Ejercicio 4

select distinct p.dni, p.apellido, p.nombre
from personas p
inner join contratos c on c.dni=p.dni
where p.dni in (
select distinct per.dni
from personas per
inner join antecedentes a on per.dni=a.dni)
;