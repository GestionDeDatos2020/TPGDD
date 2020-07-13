USE GD1C2020
------------------------------------------------------LISTADOS DE DROPS
/*
BEGIN TRANSACTION
	DROP TABLE [COVID_20].[Dimencion_Tiempo]
	DROP TABLE [COVID_20].[Dimencion_Clientes_Estadias]
	DROP TABLE [COVID_20].[Dimencion_Empresa_Hotelera]
	DROP TABLE [COVID_20].[Dimencion_Tipo_Habitacion]
COMMIT TRANSACTION
*/
------------------------------------------------------CREACIONES DE TABLAS

CREATE TABLE [COVID_20].[Dimencion_Tiempo](
	Tiempo_Anio numeric(4) NOT NULL,
	Tiempo_Mes numeric(2) NOT NULL
)

CREATE TABLE [COVID_20].[Dimencion_Clientes_Estadias](
	Clie_Edad int NOT NULL,
	Clie_Cantidad bigint
)

CREATE TABLE [COVID_20].[Dimencion_Empresa_Hotelera](
	Hotel_RS varchar(50) NOT NULL,
	Hotel_Cantidad_Sucursales bigint,
)

CREATE TABLE [COVID_20].[Dimencion_Tipo_Habitacion](
	THabitacion_Tipo varchar(50) NOT NULL,
	THabitacion_Cantidad_Camas bigint
)

------------------------------------------------------CREACION DE LAS CLAVES PRIMARIAS (PK)

ALTER TABLE [COVID_20].[Dimencion_Tiempo]
	ADD CONSTRAINT PK_BI_Tiempo PRIMARY KEY (Tiempo_Anio, Tiempo_Mes)

ALTER TABLE [COVID_20].[Dimencion_Clientes_Estadias]
	ADD CONSTRAINT PK_BI_Cliente_Estadias PRIMARY KEY (Clie_Edad)

ALTER TABLE [COVID_20].[Dimencion_Empresa_Hotelera]
	ADD CONSTRAINT PK_BI_Hotel PRIMARY KEY (Hotel_RS)

ALTER TABLE [COVID_20].[Dimencion_Tipo_Habitacion]
	ADD CONSTRAINT PK_BI_THabitacion PRIMARY KEY (THabitacion_Tipo)
------------------------------------------------------CREACION DE LAS CLAVES FORANEAS (FK)




---------------------- MIGRACIOS DE DATOS DESDE EL MODELO OLTP ---------------------




---------------------------------------------- MIGRACIOS DE LA TABLA TIEMPO 

INSERT INTO COVID_20.Dimencion_Tiempo (Tiempo_Anio,Tiempo_Mes) 
	SELECT cast(YEAR(Factura_Fecha) as numeric(4)), cast(MONTH(Factura_Fecha) as numeric (2))
	FROM COVID_20.FACTURA
	GROUP BY YEAR(Factura_Fecha), MONTH(Factura_Fecha)




---------------------------------------------- MIGRACIOS DE LA TABLA CLIENTES
INSERT INTO COVID_20.Dimencion_Clientes_Estadias (Clie_Edad,Clie_Cantidad) 
SELECT 
	DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE())-
	(CASE   
		WHEN DATEADD(YY,DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE()),
			c.Cliente_Fecha_Nac)>GETDATE() 
		THEN  1  ELSE   0  END) 
	as Edad,
	count(*)
FROM COVID_20.FACTURA f
	JOIN COVID_20.CLIENTE c ON f.Cliente_ID = c.Cliente_ID 
WHERE Pasaje_ID IS NULL
group by DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE())-
	(CASE   
		WHEN DATEADD(YY,DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE()),
			c.Cliente_Fecha_Nac)>GETDATE() 
		THEN  1  ELSE   0  END)
Order by 1 DESC





---------------------------------------------- MIGRACIOS DE LA TABLA EMPRESAS
INSERT INTO COVID_20.Dimencion_Empresa_Hotelera (Hotel_RS,Hotel_Cantidad_Sucursales)
SELECT Empresa_RS, count(distinct es.Hotel_ID)
FROM COVID_20.EMPRESA e
	JOIN COVID_20.COMPRA c ON e.Empresa_ID = c.Empresa_ID
	JOIN COVID_20.ESTADIA es ON c.Compra_NRO = es.Compra_NRO
	JOIN COVID_20.HOTEL h ON es.Hotel_ID = h.Hotel_ID
Group by Empresa_RS






---------------------------------------------- MIGRACIOS DE LA TABLA HABITACION
INSERT INTO COVID_20.Dimencion_Tipo_Habitacion

SELECT *
FROM COVID_20.TIPO_HABITACION



/*
SELECT * FROM COVID_20.Dimencion_Tiempo
*/