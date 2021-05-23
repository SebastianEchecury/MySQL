-- Practica 5

-- Ejercicio 1 (Con subconsulta)

select *
from personas pe
inner join contratos co on pe.dni=co.dni
where co.cuit in
(select distinct con.cuit
from contratos con
inner join personas per on con.dni=per.dni
where per.nombre like'Stefan_a' and per.apellido like 'L_pez')
and pe.nombre not like 'Stefan_a' and pe.apellido not like 'L_pez';

-- Ejercicio 2 (Con variable)

select max(con.sueldo), min(con.sueldo), count(*) into @maxi,  @mini,  @cant
from contratos con
inner join empresas em on con.cuit=em.cuit
where em.razon_social='Viejos amigos';

select @maxi;

select *
from personas per
inner join contratos co on co.dni=per.dni
where co.sueldo<@maxi;

-- Con subconsulta

select *
from personas per
inner join contratos co on co.dni=per.dni
where co.sueldo<
(select max(con.sueldo)
from contratos con
inner join empresas em on con.cuit=em.cuit
where em.razon_social='Viejos amigos');

-- Ejercicio 3 (Con variable)

select avg(com.importe_comision) into @prome 
from empresas emp
inner join contratos con on con.cuit=emp.cuit
inner join comisiones com on com.nro_contrato=con.nro_contrato
where emp.razon_social like 'Traigame eso';

select @prome;

select emp.cuit ,emp.razon_social, avg(com.importe_comision) 
from empresas emp
inner join contratos con on con.cuit=emp.cuit
inner join comisiones com on com.nro_contrato=con.nro_contrato
group by emp.cuit
having avg(com.importe_comision) > @prome;

-- Con subconsulta

select em.cuit ,em.razon_social, avg(comi.importe_comision) 
from empresas em
inner join contratos co on co.cuit=em.cuit
inner join comisiones comi on comi.nro_contrato=co.nro_contrato
group by em.cuit
having avg(comi.importe_comision) >
(select avg(com.importe_comision) 
from empresas emp
inner join contratos con on con.cuit=emp.cuit
inner join comisiones com on com.nro_contrato=con.nro_contrato
where emp.razon_social like 'Traigame eso') ;

-- Ejercicio 4 con variable

select avg(com.importe_comision) into @promed
from empresas emp
inner join contratos con on con.cuit=emp.cuit
inner join comisiones com on com.nro_contrato=con.nro_contrato;

select @promed;

select emp.razon_social, per.apellido, per.nombre, con.nro_contrato, com.mes_contrato, com.anio_contrato, com.importe_comision
from empresas emp
inner join contratos con on con.cuit=emp.cuit
inner join comisiones com on com.nro_contrato=con.nro_contrato
inner join personas per on per.dni=con.dni
where com.importe_comision<@promed and com.fecha_pago is not null;

-- Ejercicio 5

create temporary table prome
select emp.cuit, avg(com.importe_comision) cprom
from empresas emp
inner join contratos con on con.cuit=emp.cuit
inner join comisiones com on com.nro_contrato=con.nro_contrato
group by emp.cuit;

select max(prome.cprom) into @maxprom
from prome;

select * 
from prome
where prome.cprom=@maxprom;

-- Ejercicio 6

select *
from personas per
where per.dni not in
(select pe.dni
from personas pe
inner join personas_titulos pet on pet.dni=pe.dni
inner join titulos titu on titu.cod_titulo=pet.cod_titulo
where titu.desc_titulo='Educacion no formal' or titu.desc_titulo='Terciario')
;

-- Ejercicio 7

create temporary table promesueldos
select emp.cuit,emp.razon_social, avg(con.sueldo) prom
from empresas emp
inner join contratos con on con.cuit=emp.cuit
group by emp.cuit;

select per.dni, per.apellido, per.nombre
from personas per
inner join contratos con on con.dni=per.dni
inner join promesueldos pro on con.cuit=pro.cuit
where con.sueldo>pro.prom;

-- Ejercicio 8 

create temporary table comisionesprom
select emp.cuit, emp.razon_social, avg(com.importe_comision) prom
from empresas emp
inner join contratos con on con.cuit=emp.cuit
inner join comisiones com on com.nro_contrato=con.nro_contrato
group by emp.cuit;

select max(prom) into @maxi
from comisionesprom;
select @maxi;

select min(prom) into @minim
from comisionesprom;
select @minim;

select cp.razon_social, cp.prom
from comisionesprom cp
where cp.prom=@minim or cp.prom=@maxi;

-- Ejercicio 9

select count(*) into @cantinsc
from alumnos alu
inner join inscripciones ins on ins.dni=alu.dni
where alu.dni=13131313;

select alu.dni, alu.apellido, alu.nombre, alu.direccion, alu.email, alu. tel, count(*) 'Cantidad cursos inscripto', count(*)-@cantinsc 'Cant mas que Antoine'
from alumnos alu
inner join inscripciones ins on ins.dni=alu.dni
group by alu.dni
having count(*)>@cantinsc;

-- Ejercicio 10

select count(*) into @cantalu
from inscripciones
where year(inscripciones.fecha_inscripcion)=2014;

select pla.nom_plan, count(*), ((count(*)*100) / @cantalu) '% Total'
from plan_capacitacion pla
inner join inscripciones ins on ins.nom_plan=pla.nom_plan
where year(ins.fecha_inscripcion)=2014
group by pla.nom_plan
;

-- Ejercicio 11

create temporary table maxfechas
select val.nom_plan, max(val.fecha_desde_plan) maxi
from valores_plan val
where val.fecha_desde_plan<=current_date()
group by val.nom_plan;

select val.nom_plan, val.fecha_desde_plan, val.valor_plan
from valores_plan val 
inner join maxfechas maxf on maxf.nom_plan=val.nom_plan
						  and maxf.maxi=val.fecha_desde_plan;
                          
-- Ejercicio 12

create temporary table maxifecha		
select nom_plan, max(fecha_desde_plan) maxif
from valores_plan
where fecha_desde_plan<= current_date()
group by nom_plan;

create temporary table valoractual
select vp.nom_plan, vp.fecha_desde_plan, vp.valor_plan
from valores_plan vp
inner join maxifecha mf on mf.nom_plan=vp.nom_plan 
					    and mf.maxif=vp.fecha_desde_plan
;

select min(valor_plan) into @mini
from valoractual ;

select @mini;

select pc.*, va.valor_plan
from valoractual va
inner join plan_capacitacion pc on va.nom_plan=pc.nom_plan
where va.valor_plan=@mini;

-- Ejercicio 13

select ins.cuil
from instructores ins
inner join cursos_instructores cursi on cursi.cuil=ins.cuil
inner join cursos cur on cur.nom_plan= cursi.nom_plan and cur.nro_curso=cursi.nro_curso
where cursi.nom_plan='Marketing 1' and year(cur.fecha_fin)=2014 
and ins.cuil not in 
(select inst.cuil
from instructores inst
inner join cursos_instructores c on c.cuil=inst.cuil
inner join cursos curs on curs.nom_plan=c.nom_plan and curs.nro_curso=c.nro_curso
where c.nom_plan='Marketing 1' and year(curs.fecha_fin)=2015)
;

-- Ejercicio 14

select distinct alu.dni, alu.apellido, alu.nombre
from alumnos alu
inner join inscripciones ins on ins.dni=alu.dni
inner join cuotas cuo on cuo.nom_plan=ins.nom_plan
					  and cuo.nro_curso=ins.nro_curso
where alu.dni not in
(select distinct dni 
from cuotas
where fecha_pago is null);

-- Ejercicio 15

-- drop temporary table if exists notasprom;
create temporary table notasprom
select nom_plan, nro_curso, avg(nota) prom
from evaluaciones
group by nom_plan, nro_curso;

select * from notasprom;

select ev.dni, alu.apellido, alu.nombre, avg(ev.nota), prom
from evaluaciones ev
inner join alumnos alu on alu.dni=ev.dni
inner join notasprom notas on notas.nom_plan=ev.nom_plan
						   and notas.nro_curso=ev.nro_curso
group by ev.dni
having avg(ev.nota)>prom
;

-- Ejercicio 16

create temporary table inscriptos
select nom_plan ,nro_curso ,count(dni) cantInsc
from inscripciones
where fecha_inscripcion>'2014-04-01'
group by nom_plan
;

select cur.nom_plan, cur.nro_curso, cur.salon, cur.cupo ,ins.cantInsc, cur.fecha_ini, ((ins.cantInsc*100)/cur.cupo) '% Inscriptos'
from cursos cur
inner join inscriptos ins on ins.nom_plan=cur.nom_plan
						  and ins.nro_curso=cur.nro_curso
where cur.cupo>ins.cantInsc and ((ins.cantInsc*100)/cur.cupo)<=20
group by cur.nom_plan, cur.nro_curso
;

-- Ejercicio 17

create temporary table fechaActual
select vp.nom_plan, max(vp.fecha_desde_plan) maxi
from valores_plan vp
where vp.fecha_desde_plan<=current_date()
group by 1;

create temporary table valorActual
select vp.*
from valores_plan vp
inner join fechaActual fa on fa.nom_plan=vp.nom_plan
					      and fa.maxi=vp.fecha_desde_plan
;

create temporary table fechaAnterior
select vp.nom_plan, max(vp.fecha_desde_plan) ante
from valores_plan vp
inner join fechaActual fa on fa.nom_plan=vp.nom_plan
where vp.fecha_desde_plan<fa.maxi
group by vp.nom_plan;

create temporary table valorAnterior
select vp.*
from valores_plan vp
inner join fechaAnterior fa on fa.nom_plan=vp.nom_plan
					      and fa.ante=vp.fecha_desde_plan
;

select vact.nom_plan, vact.fecha_desde_plan 'Fecha actual', vact.valor_plan 'Valor actual', vant.fecha_desde_plan 'Fecha anterior', vant.valor_plan 'Valor anterior', (vact.valor_plan-vant.valor_plan) Diferencia
from valorActual vact
left join valorAnterior vant on vant.nom_plan=vact.nom_plan
;