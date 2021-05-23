-- GROUP BY - HAVING

-- Ejercicio 1

select sum(com.importe_comision)
from comisiones com
inner join contratos con on com.nro_contrato=con.nro_contrato
inner join empresas emp on emp.cuit=con.cuit
where emp.razon_social='Traigame eso'
and com.fecha_pago is not null;

-- Ejercicio 2

select emp.cuit, emp.razon_social, sum(com.importe_comision)
from comisiones com
inner join contratos con on com.nro_contrato=con.nro_contrato
inner join empresas emp on emp.cuit=con.cuit
where com.fecha_pago is not null
group by emp.cuit, emp.razon_social
-- having sum(com.importe_comision) < 1000
;

-- Ejercicio 3

select ent.nombre_entrevistador, entv.cod_evaluacion, avg(entv.resultado) Promedio, round(std(entv.resultado), 3) "Desviacion estandar"
from entrevistas ent
inner join entrevistas_evaluaciones entv on entv.nro_entrevista=ent.nro_entrevista
group by ent.nombre_entrevistador, entv.cod_evaluacion
order by avg(entv.resultado) asc, std(entv.resultado) desc;

-- Ejercicio 4

select ent.nombre_entrevistador, entv.cod_evaluacion, avg(entv.resultado) Promedio, round(std(entv.resultado), 3) "Desviacion estandar"
from entrevistas ent
inner join entrevistas_evaluaciones entv on entv.nro_entrevista=ent.nro_entrevista
where ent.nombre_entrevistador="Angelica Doria"
group by ent.nombre_entrevistador, entv.cod_evaluacion
having avg(entv.resultado) > 71 
order by cod_evaluacion 
;

-- Ejercicio 5
select * from entrevistas;
select ent.nombre_entrevistador, count(*) 
from entrevistas ent
group by ent.nombre_entrevistador, ent.fecha_entrevista
having (year(ent.fecha_entrevista)=2014 and month(ent.fecha_entrevista)=10)
;

-- Ejercicio 6

select ent.nombre_entrevistador, entv.cod_evaluacion, count(entv.cod_evaluacion), avg(entv.resultado) Promedio, std(entv.resultado)
from entrevistas ent
inner join entrevistas_evaluaciones entv on entv.nro_entrevista=ent.nro_entrevista
group by ent.nombre_entrevistador, entv.cod_evaluacion
having avg(entv.resultado) > 71
order by count(entv.cod_evaluacion)
;

-- Ejercicio 7

select ent.nombre_entrevistador, entv.cod_evaluacion, count(entv.cod_evaluacion), avg(entv.resultado) Promedio, std(entv.resultado)
from entrevistas ent
inner join entrevistas_evaluaciones entv on entv.nro_entrevista=ent.nro_entrevista
group by ent.nombre_entrevistador, entv.cod_evaluacion
having entv.cod_evaluacion > 1
order by ent.nombre_entrevistador desc, entv.cod_evaluacion asc
;

-- Ejercicio 8

select con.nro_contrato, count(*) Total, count(com.fecha_pago) "Total pagado", count(*) - count(com.fecha_pago) "Total a pagar"
from contratos con
inner join comisiones com on com.nro_contrato=con.nro_contrato
group by con.nro_contrato;

-- Ejercicio 9

select con.nro_contrato, count(*) Total, (count(com.fecha_pago)/count(*)*100) "Pagadas", ((count(*) - count(com.fecha_pago))/count(*))*100 "A pagar"
from contratos con
inner join comisiones com on com.nro_contrato=con.nro_contrato
group by con.nro_contrato;

-- Ejercicio 10

select  count(distinct emp.razon_social) Cantidad, (count(*)-count(distinct emp.razon_social)) Diferencia
from empresas emp
inner join solicitudes_empresas sole on sole.cuit=emp.cuit;

-- Ejercicio 11

select  emp.cuit, emp.razon_social, count(*)
from empresas emp
inner join solicitudes_empresas sole on sole.cuit=emp.cuit
group by emp.cuit;

-- Ejercicio 12

select emp.cuit, emp.razon_social, sole.cod_cargo, count(*)
from empresas emp
inner join solicitudes_empresas sole on sole.cuit=emp.cuit
group by emp.cuit, sole.cod_cargo;

-- Ejercicio 13

select emp.cuit, emp.razon_social, count(ant.dni)
from empresas emp
left join antecedentes ant on ant.cuit=emp.cuit
group by emp.cuit
;

-- Ejercicio 14

select  car.cod_cargo, car.desc_cargo, count(sole.fecha_solicitud)
from cargos car
left join solicitudes_empresas sole on sole.cod_cargo=car.cod_cargo
group by car.cod_cargo
order by count(sole.fecha_solicitud) desc
;

-- Ejercicio 15

select  car.cod_cargo, car.desc_cargo, count(sole.fecha_solicitud)
from cargos car
left join solicitudes_empresas sole on sole.cod_cargo=car.cod_cargo
group by car.cod_cargo
having count(sole.fecha_solicitud) < 2 
order by count(sole.fecha_solicitud) desc
;




