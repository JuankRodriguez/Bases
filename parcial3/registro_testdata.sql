
CREATE TABLE public.estudiante (
	codigo serial NOT NULL,
	nombre varchar(45) NOT NULL,
	apellido varchar(45) NOT NULL,
	fecha_nacimiento date NOT NULL,
	genero char NOT NULL,
	id_departamento integer,
	CONSTRAINT estudiante_pk PRIMARY KEY (codigo)

);

CREATE TABLE public.facultad (
	id serial NOT NULL,
	nombre varchar(45) NOT NULL,
	CONSTRAINT facultad_pk PRIMARY KEY (id)

);

CREATE TABLE public.departamento (
	id serial NOT NULL,
	nombre varchar(45) NOT NULL,
	id_facultad integer,
	CONSTRAINT departamento_pk PRIMARY KEY (id)

);

ALTER TABLE public.departamento ADD CONSTRAINT facultad_fk FOREIGN KEY (id_facultad)
REFERENCES public.facultad (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.estudiante ADD CONSTRAINT departamento_fk FOREIGN KEY (id_departamento)
REFERENCES public.departamento (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE public.curso (
	id serial NOT NULL,
	nombre varchar(45) NOT NULL,
	creditos smallint NOT NULL,
	id_departamento integer,
	CONSTRAINT curso_pk PRIMARY KEY (id)

);

ALTER TABLE public.curso ADD CONSTRAINT departamento_fk FOREIGN KEY (id_departamento)
REFERENCES public.departamento (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE public.profesor (
	id serial NOT NULL,
	nombre varchar(45) NOT NULL,
	apellido varchar(45) NOT NULL,
	id_departamento integer,
	CONSTRAINT profesor_pk PRIMARY KEY (id)

);

CREATE TABLE public.grupo (
	id serial NOT NULL,
	nombre varchar NOT NULL,
	anio smallint NOT NULL,
	periodo smallint NOT NULL,
	id_curso integer,
	id_profesor integer,
	CONSTRAINT grupo_pk PRIMARY KEY (id)

);

ALTER TABLE public.grupo ADD CONSTRAINT curso_fk FOREIGN KEY (id_curso)
REFERENCES public.curso (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.grupo ADD CONSTRAINT profesor_fk FOREIGN KEY (id_profesor)
REFERENCES public.profesor (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE public.inscripcion (
	id serial NOT NULL,
	calificacion smallint NOT NULL DEFAULT 0,
	codigo_estudiante integer,
	id_grupo integer,
	CONSTRAINT inscripcion_pk PRIMARY KEY (id)

);

ALTER TABLE public.inscripcion ADD CONSTRAINT estudiante_fk FOREIGN KEY (codigo_estudiante)
REFERENCES public.estudiante (codigo) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.inscripcion ADD CONSTRAINT grupo_fk FOREIGN KEY (id_grupo)
REFERENCES public.grupo (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.profesor ADD CONSTRAINT departamento_fk FOREIGN KEY (id_departamento)
REFERENCES public.departamento (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE public.horario (
	id serial NOT NULL,
	dia smallint NOT NULL,
	hora_inicio smallint NOT NULL,
	hora_fin smallint NOT NULL,
	id_grupo integer,
	id_salon integer,
	CONSTRAINT horario_pk PRIMARY KEY (id)

);

ALTER TABLE public.horario ADD CONSTRAINT grupo_fk FOREIGN KEY (id_grupo)
REFERENCES public.grupo (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE public.edificio (
	id serial NOT NULL,
	nombre varchar(45) NOT NULL,
	CONSTRAINT edificio_pk PRIMARY KEY (id)

);

CREATE TABLE public.salon (
	id serial NOT NULL,
	nombre varchar(45) NOT NULL,
	id_edificio integer,
	CONSTRAINT salon_pk PRIMARY KEY (id)

);

ALTER TABLE public.salon ADD CONSTRAINT edificio_fk FOREIGN KEY (id_edificio)
REFERENCES public.edificio (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.horario ADD CONSTRAINT salon_fk FOREIGN KEY (id_salon)
REFERENCES public.salon (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;


INSERT INTO facultad (nombre) VALUES ('Ciencias Naturales y Matemáticas'),('Jurisprudencia');

INSERT INTO departamento (nombre, id_facultad) VALUES ('MACC',1);

INSERT INTO profesor (nombre, apellido, id_departamento)
VALUES ('Miguel', 'Orjuela', 1), ('Hector', 'Florez',1);

INSERT INTO curso (nombre, creditos, id_departamento) 
VALUES ('Manejo de bases de datos',4, 1), 
('Cálculo 1',3, 1), 
('Algoritmos y estructuras de eatos',3, 1);

INSERT INTO edificio (nombre) VALUES
('Casur'),('Torre 1'),('Torre 2'),('Torre 3');

INSERT INTO salon (nombre, id_edificio) VALUES
('Aula 204',1),
('Aula 205',1),
('Aula 206',2),
('Sala Lovelace',3),
('Laboratorio Tesla',3),
('Aula 502',4);

INSERT INTO grupo (nombre, anio, periodo, id_curso, id_profesor) VALUES
('Grupo 1',2020,2,1,1),
('Grupo 2',2020,2,1,2),
('Grupo 3',2020,2,1,1),
('Grupo 4',2020,2,1,2);

INSERT INTO horario (dia, hora_inicio, hora_fin, id_grupo, id_salon)
VALUES
(2,13,15,1,6),
(3,15,18,1,5),
(4,13,15,2,4),
(5,15,18,2,4),
(1,16,18,3,3),
(2,8,11,3,3),
(3,13,15,4,1),
(5,15,17,4,3);

INSERT INTO estudiante (nombre, apellido, fecha_nacimiento, genero, id_departamento) VALUES
('Abel','Rojas','1999-10-10','M',1),
('Andrea','Rojas','1999-10-10','F',1),
('Diana','Cruz','1999-10-10','F',1),
('Carlos','Sanchez','1999-10-10','M',1),
('Ginna','Arias','1999-10-10','F',1),
('Catalina','Zambrano','1999-10-10','F',1),
('Carolina','Rios','1999-10-10','F',1),
('Juan','Duarte','1999-10-10','M',1),
('Camilo','Ortega','1999-10-10','M',1),
('Leonardo','Diaz','1999-10-10','M',1)
;

INSERT INTO inscripcion (calificacion, codigo_estudiante, id_grupo)
VALUES
(0,1,1),
(0,2,1),
(0,3,1),
(0,4,2),
(0,5,2),
(0,6,2),
(0,7,3),
(0,8,4),
(0,9,3),
(0,10,4);


