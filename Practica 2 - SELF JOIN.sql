-- SELF JOIN

-- Ejercicio 14.a

select ins.cuil, ins.nombre, ins.apellido, ins.cuil_supervisor, sup.nombre, sup.apellido
from instructores ins
inner join instructores sup on ins.cuil_supervisor=sup.cuil;

-- Ejercicio 15

select ins.cuil, ins.nombre, ins.apellido, ins.cuil_supervisor, sup.nombre, sup.apellido
from instructores ins
left join instructores sup on ins.cuil_supervisor=sup.cuil;

-- Ejercicio 16

select ifnull(sup.cuil, " ") "Cuil supervisor", ifnull(sup.nombre,"") "Nombre supervisor",
ifnull(sup.apellido,"") "Apellido supervisor", ins.nombre "Nombre instructor", ins.apellido "Apellido instructor",
cins.nom_plan, cins.nro_curso, alu.nombre, alu.apellido, eva.nro_examen, eva.fecha_evaluacion, eva.nota
from instructores ins
left join instructores sup on ins.cuil_supervisor=sup.cuil
inner join cursos_instructores cins on cins.cuil=ins.cuil
inner join evaluaciones eva on (eva.nom_plan=cins.nom_plan and eva.nro_curso=cins.nro_curso and eva.cuil=ins.cuil)
inner join alumnos alu on alu.dni=eva.dni
where year(eva.fecha_evaluacion)=2014
order by sup.nombre asc,
		 sup.apellido asc,
         eva.fecha_evaluacion desc;