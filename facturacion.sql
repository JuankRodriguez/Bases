/*
	Manejo de Bases de Datos 2020-II
	Primer Parcial
	Script de creación de modelo de datos de facturación y template de respuestas
*/

-- SENTENCIAS DDL
CREATE TABLE cliente
(
    id_cliente SMALLINT NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    apellido VARCHAR(45) NOT NULL,
    PRIMARY KEY (id_cliente)
);
CREATE TABLE producto
(
    id_producto SMALLINT NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    unidades_disponibles SMALLINT NOT NULL,
    precio_unitario SMALLINT NOT NULL,
    PRIMARY KEY (id_producto)
);
CREATE TABLE factura 
( 
	numero_factura SERIAL NOT NULL , 
	fecha       DATE NOT NULL , 
	valor_total SMALLINT NOT NULL , 
	id_cliente  SMALLINT , 
	PRIMARY KEY (numero_factura), 
	FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente) 
);
CREATE TABLE factura_producto 
( 
	id_factura_producto SERIAL NOT NULL , 
	cantidad       SMALLINT NOT NULL , 
	valor_unitario SMALLINT NOT NULL , 
	valor_total    SMALLINT NOT NULL , 
	id_producto    SMALLINT , 
	numero_factura INTEGER , 
	PRIMARY KEY (id_factura_producto), 
	FOREIGN KEY (id_producto) REFERENCES producto (id_producto), 
	FOREIGN KEY (numero_factura) REFERENCES factura (numero_factura) 
);

-- Sentencias DML

INSERT INTO cliente (id_cliente, nombre, apellido) 
VALUES (10, 'Clark', 'Kent');
INSERT INTO cliente (id_cliente, nombre, apellido) 
VALUES (20, 'Bruce', 'Wayne');
INSERT INTO cliente (id_cliente, nombre, apellido) 
VALUES (30, 'Petter', 'Parker');

INSERT INTO producto (id_producto, nombre, unidades_disponibles, precio_unitario) 
VALUES (100, 'Cuaderno', 250, 3500);
INSERT INTO producto (id_producto, nombre, unidades_disponibles, precio_unitario) 
VALUES (200, 'Marcador', 120, 2800);
INSERT INTO producto (id_producto, nombre, unidades_disponibles, precio_unitario) 
VALUES (300, 'CD', 85, 750);
INSERT INTO producto (id_producto, nombre, unidades_disponibles, precio_unitario) 
VALUES (400, 'Lapiz', 800, 500);

----------------------------------- PUNTO 1 -----------------------------------
π cliente.nombre, cliente.apellido, factura.fecha, factura.valor_total (σ factura.id_cliente = cliente.id_cliente(cliente x factura))
----------------------------------- PUNTO 2 -----------------------------------
INSERT INTO factura  (fecha, valor_total, id_cliente)
VALUES (now()::DATE,3500*3,10);
--SELECT * FROM factura;
INSERT INTO factura_producto (cantidad, valor_unitario, valor_total,id_producto,numero_factura)
VALUES (3,3500,3500*3,100,1);
--SELECT * FROM factura_producto;
UPDATE producto SET unidades_disponibles = 250-3 WHERE id_producto = 100;
--SELECT * FROM producto;
SELECT f.numero_factura, 
	   f.fecha, 
	   f.valor_total, 
	   f.id_cliente,
	   cl.nombre ||' '||
	   cl.apellido AS Nombre_cliente,
	   fp.id_factura_producto, 
	   fp.cantidad, 
	   fp.valor_unitario, 
	   --fp.valor_total, 
	   fp.id_producto  
FROM factura_producto AS fp JOIN factura AS f ON fp.numero_factura = f.numero_factura
JOIN cliente AS cl ON cl.id_cliente = f.id_cliente;
----------------------------------- PUNTO 3 -----------------------------------
CREATE VIEW todas_las_facturas AS
SELECT f.numero_factura, 
	   f.fecha, 
	   f.valor_total, 
	   f.id_cliente,
	   cl.nombre ||' '||
	   cl.apellido AS Nombre_cliente
FROM factura AS f JOIN cliente AS cl ON cl.id_cliente = f.id_cliente;

SELECT * FROM todas_las_facturas; -- Para que se vea bien chevere ejecute las sentencias de agregacion del punto 4 ;)
----------------------------------- PUNTO 4 -----------------------------------
INSERT INTO factura (fecha, valor_total, id_cliente) 
VALUES (now()::DATE,0,20);
INSERT INTO factura_producto (cantidad, valor_unitario, valor_total,id_producto,numero_factura) 
VALUES (2,3500,3500*2,100,2);
UPDATE producto SET unidades_disponibles = unidades_disponibles - 2 WHERE id_producto = 100; 
UPDATE factura SET valor_total = 7000 WHERE numero_factura = 2;

INSERT INTO factura (fecha, valor_total, id_cliente) 
VALUES (now()::DATE,0,20);
INSERT INTO factura_producto (cantidad, valor_unitario, valor_total,id_producto,numero_factura) 
VALUES (2,500,500*2,400,3);
UPDATE producto SET unidades_disponibles = unidades_disponibles - 2 WHERE id_producto = 400; 
UPDATE factura SET valor_total = 1000 WHERE numero_factura = 3;

CREATE VIEW facturas_sin_restriccion AS 
SELECT cl.nombre, 
	   cl.apellido, 
	   COUNT(f.numero_factura) AS numero_de_facturas,
	   SUM(f.valor_total) AS valor_total_facturado
FROM cliente AS cl JOIN factura AS f ON f.id_cliente = cl.id_cliente GROUP BY cl.id_cliente;

SELECT * FROM facturas_sin_restriccion WHERE numero_de_facturas > 1;

----------------------------------- PUNTO 5 -----------------------------------


----------------------------------- PUNTO 6 -----------------------------------
CREATE OR REPLACE FUNCTION productos_cliente (a INT) RETURNS SETOF factura_producto AS $$
BEGIN
	RETURN QUERY SELECT * FROM factura_producto AS fp JOIN factura AS f ON fp.numero_factura = f.numero_factura
													  JOIN cliente AS cl ON cL.id_cliente = f.id_cliente
				 WHERE cl.id_cliente = $1;
END;
$$ LANGUAGE plpgsql;

SELECT productos_cliente(10);
SELECT productos_cliente(20);
----------------------------------- PUNTO 7 -----------------------------------
/*
	La funcion genera una insercion de una nueva tupla en la tabla factura donde donde el cliente con el id = 10 realiza
	una compra con un valor de 100000$, luego elimina todos los datos de el cliente con el id = 10 en la tabla cliente
	y por ultimo vuelve a crear una tupla pero esta vez en la tabla cliente con id = 10, nombre 'Super' y apellido 'Man'.
*/
