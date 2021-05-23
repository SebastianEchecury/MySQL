-- Update con inner

select cur.nom_plan, cur.nro_curso, cur.cupo, cupo*1.5, modalidad
from cursos cur
inner join plan_capacitacion pl on pl.nom_plan= cur.nom_plan
where modalidad in ('Semipresencial', 'Presencial')
and cupo>=20
;

start transaction;

update cursos cur
inner join plan_capacitacion pl on pl.nom_plan= cur.nom_plan
set cupo=cupo*1.25
where modalidad in ('Semipresencial', 'Presencial')
and cupo>=20;

update cursos cur
inner join plan_capacitacion pl on pl.nom_plan= cur.nom_plan
set cupo=cupo*1.50
where modalidad in ('Semipresencial', 'Presencial')
and cupo<20;

select * from cursos;

-- rollback;
-- commit;

-- Incrementar valores actuales en 1.20

create temporary table fechaActual
select nom_plan, max(fecha_desde_plan) maxi
from valores_plan
where fecha_desde_plan<=current_date()
group by nom_plan;

start transaction;

insert into valores_plan (
select vp.nom_plan, current_date(), vp.valor_plan*1.2
from fechaActual fe
inner join valores_plan vp on vp.nom_plan=fe.nom_plan
						   and vp.fecha_desde_plan=fe.maxi)
;                           

select * from valores_plan;

commit;

rollback;