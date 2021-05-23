-- Practica 8

-- Ejercicio 1

start transaction;
insert into instructores
values ('44-44444444-4', 'Daniel', 'Tapia', 444-444444, 'dotapia@gmail.com', 'Ayacucho 4444', null);
select * from instructores;
-- rollback;
commit;

-- Ejercicio 2

start transaction;
insert into plan_capacitacion
values ('Administrador de BD', 'Instalación y configuración MySQL. Lenguaje
SQL. Usuarios y permisos', 300, 'Presencial');
select * from plan_capacitacion;
commit;

start transaction;
insert into plan_temas
values 
('Administrador de BD', '1- Instalación MySQL', 'Distintas configuraciones de instalación'),
('Administrador de BD', '2- Configuración DBMS', 'Variables de entorno, su uso y configuración'),
('Administrador de BD', '3- Lenguaje SQL', 'DML, DDL y TCL'),
('Administrador de BD', '4- Usuarios y Permisos', 'Permisos de usuarios y DCL');
select * from plan_temas;
commit;

start transaction;
insert into examenes
values  ('Administrador de BD', 1),
		('Administrador de BD', 2),
        ('Administrador de BD', 3),
        ('Administrador de BD', 4);
select * from examenes;
commit;

start transaction;
insert into examenes_temas
values  ('Administrador de BD', '1- Instalación MySQL', 1),
		('Administrador de BD', '2- Configuración DBMS', 2),
        ('Administrador de BD', '3- Lenguaje SQL', 3),
        ('Administrador de BD', '4- Usuarios y Permisos', 4);
select * from examenes_temas;
commit;

start transaction;
insert into materiales_plan (nom_plan, cod_material)
values  ('Administrador de BD', 'UT-001'),
		('Administrador de BD', 'UT-002'),
		('Administrador de BD', 'UT-003'),
        ('Administrador de BD', 'UT-004');
select * from materiales_plan;
commit;

start transaction;
insert into materiales (cod_material, desc_material, url_descarga, autores, tamanio, fecha_creacion)
values  ('AP-010', 'DBA en MySQL', 'www.afatse.com.ar/apuntes?', 'José Román', 2048, '2009-03-01'),
		('AP-011', 'SQL en MySQL', 'www.afatse.com.ar/apuntes?', 'Juan López', 3072, '2009-04-01');
select * from materiales;
commit;

start transaction;
insert into valores_plan
values ('Administrador de BD','2009-02-01', 150);
select * from valores_plan;
commit;

-- Ejercicio 3

start transaction;
update cursos c
inner join plan_capacitacion p on p.nom_plan=c.nom_plan
set cupo=cupo*1.25
where p.modalidad in ('Presencial', 'Semipresencial')
and c.cupo>=20;

update cursos c
inner join plan_capacitacion p on p.nom_plan=c.nom_plan
set cupo=cupo*1.5
where p.modalidad in ('Presencial', 'Semipresencial')
and c.cupo<20;
commit;

-- Ejercicio 4

 -- 44-44444444-4 Daniel Tapia
 -- 55-55555555-5 Henri Amiel
 -- 66-66666666-6 Franz Kafka
 start transaction;
 update instructores i
 set i.cuil_supervisor='44-44444444-4'
 where i.cuil in ('55-55555555-5', '66-66666666-6');
 commit;
 
 -- Ejercicio 5

select i.cuil into @AmielHenriC
from instructores i
where  i.apellido='Amiel' and i.nombre='Henri';
select i.cuil into @FranzKafkaC
from instructores i
where i.apellido='Kafka' and i.nombre='Franz';
select i.cuil into @DanielTapiaC
from instructores i
where (i.apellido='Tapia' and i.nombre='Daniel');

start transaction;
update instructores i
set i.cuil_supervisor=@DanielTapiaC
where i.cuil in (@FranzKakfaC, @AmielHenriC);
commit;

-- Ejercicio 6

select dni into @dni
from alumnos a
where a.apellido='Hugo' and a.nombre='Victor';
select @dni;

start transaction;
update alumnos a
set a.direccion='Italia 2323', a.tel='3232323'
where a.dni=@dni
;
select * from alumnos;
commit;

-- Ejercicio 7

start transaction;
delete from valores_plan where nom_plan='Administrador de BD';
delete from plan_temas where nom_plan='Administrador de BD';
delete from materiales_plan where nom_plan='Administrador de BD';
delete from examenes_temas where nom_plan='Administrador de BD';
delete from examenes where nom_plan='Administrador de BD';
delete from plan_capacitacion where nom_plan='Administrador de BD';
commit;

-- Ejercicio 8

start transaction;
delete from materiales where cod_material between 'AP-008' and 'AP-009' ;
commit;

-- Ejercicio 9

start transaction;
update instructores
set cuil_supervisor = null
where cuil_supervisor = '44-44444444-4';
select * from instructores;
select * from cursos_instructores;
select * from evaluaciones;
delete from instructores where cuil='44-44444444-4';
commit;

-- Ejercicio 10

select * from inscripciones;
start transaction;
delete from inscripciones where nom_plan='Marketing 3' and nro_curso=1;
commit;

-- Ejercicio 11

select * 
from cursos_instructores c
where c.cuil in (
select i.cuil
from instructores i
where i.cuil_supervisor='99-99999999-9')
;

start transaction;
delete from instructores where cuil_supervisor='99-99999999-9';
commit;

-- Ejercicio 12

select i.cuil into @cuil
from instructores i
where i.apellido='Yanes' and i.nombre='Elias';

start transaction;
delete from instructores where cuil_supervisor=@cuil;
commit;

-- Ejercicio 13

start transaction;
delete
from materiales_plan mp
where mp.cod_material in(
select m.cod_material 
from materiales m
where m.autores like '%Erica de Forifregoro%');
rollback;

start transaction;
delete from materiales_plan where cod_material='AP-006';
delete from materiales where autores like '%Erica de Forifregoro%';
commit;