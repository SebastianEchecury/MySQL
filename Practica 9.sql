-- Ejercicio 1

create temporary table fechasPlanes
select vp.nom_plan, max(vp.fecha_desde_plan) maxiF
from valores_plan vp
where vp.fecha_desde_plan<=current_date()
group by vp.nom_plan;

select * from fechasPlanes;

start transaction;
insert into valores_plan (
select vp.nom_plan, current_date(), vp.valor_plan*1.20
from fechasPlanes fp
inner join valores_plan vp on fp.nom_plan=vp.nom_plan
						   and fp.maxiF=vp.fecha_desde_plan);
commit;

select * from valores_plan;

-- Ejercicio 2

create temporary table ultFecha
select vp.nom_plan, max(vp.fecha_desde_plan) maxiFecha
from valores_plan vp
where vp.fecha_desde_plan<=current_date()
group by vp.nom_plan;

start transaction;
insert into valores_plan (
select vp.nom_plan, current_date(), vp.valor_plan*0.12
from valores_plan vp 
inner join ultFecha u on u.maxiFecha=vp.fecha_desde_plan
					  and u.nom_plan=vp.nom_plan
where vp.valor_plan>=90);
insert into valores_plan (
select vp.nom_plan, current_date(), vp.valor_plan*0.2
from valores_plan vp 
inner join ultFecha u on u.maxiFecha=vp.fecha_desde_plan
					  and u.nom_plan=vp.nom_plan
where vp.valor_plan<90);
commit;

-- Ejercicio 3

start transaction;

insert into plan_capacitacion (
select 'Marketing 1 Presen', pl.desc_plan, pl.hs, 'Presencial'
from plan_capacitacion pl 
where pl.nom_plan='Marketing 1');

insert into plan_temas(
select 'Marketing 1 Presen', pt.titulo, pt.detalle
from plan_temas pt
where pt.nom_plan='Marketing 1');

insert into examenes_temas(
select 'Marketing 1 Presen', et.titulo, et.nro_examen
from examenes_temas et 
where et.nom_plan='Marketing 1');

insert into examenes(
select 'Marketing 1 Presen', e.nro_examen
from examenes e 
where e.nom_plan='Marketing 1');

insert into materiales_plan(
select 'Marketing 1 Presen', mp.cod_material, mp.cant_entrega
from materiales_plan mp
where mp.nom_plan='Marketing 1');

drop temporary table if exists maxfecha;
create temporary table maxfecha
select nom_plan, max(fecha_desde_plan) maxif
from valores_plan vp
where fecha_desde_plan<=current_date()
and nom_plan='Marketing 1'
group by nom_plan;

insert into valores_plan(
select 'Marketing 1 Presen', current_date(), vp.valor_plan*1.5
from valores_plan vp
inner join maxfecha mf where mf.maxif=vp.fecha_desde_plan
and mf.nom_plan=vp.nom_plan
);

rollback;
commit;

-- Ejercicio 4

start transaction;
update instructores i
inner join cursos_instructores ci
set i.cuil_supervisor='66-66666666-6'
where ci.nom_plan='Reparac PC avanzada';
rollback;
commit;

-- Ejercicio 5

start transaction;
update cursos_horarios ch
inner join cursos_instructores ci on ch.nom_plan=ci.nom_plan
and ch.nro_curso=ci.nro_curso
set ch.hora_inicio = addtime(ch.hora_inicio,-010000),
ch.hora_fin = addtime(ch.hora_fin,-010000)
where ci.cuil='66-66666666-6'
and ch.hora_inicio='160000';
rollback;
commit;

-- Ejercicio 6  (Falta)

create temporary table examen
select nom_plan, nro_examen, avg(nota) prom
from evaluaciones
group by nom_plan, nro_examen
having avg(nota)<=5.5;

start transaction;
delete et, ev
from evaluaciones ev
inner join examenes_temas et on ev.nom_plan=et.nom_plan
						     and ev.nro_examen=et.nro_examen
inner join examen e on et.nom_plan=e.nom_plan
				    and et.nro_examen=e.nom_plan;
                    
delete e2
from examen e
inner join examenes e2 on e2.nom_plan=e.nom_plan
					   and e2.nro_examen=e.nro_examen;
rollback;
commit;

/*
7) Eliminar las inscripciones a los cursos de este año de los alumnos que adeuden cuotas
impagas del año pasado.
*/

create temporary table alumnos_deudores
select dni
from cuotas
where fecha_pago is null
and year(fecha_emision)=year(current_date())-1
group by dni;

start transaction;
delete i
from inscripciones i
inner join alumnos_deudores ad on ad.dni=i.dni
where year(i.fecha_inscripcion)=year(current_date());
rollback;
commit;