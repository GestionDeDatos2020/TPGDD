USE GD1C2020
------------------------------------------------------LISTADOS DE DROPS
/*
BEGIN TRANSACTION
	DROP TABLE [COVID_20].[Fact_Table_Estadias]
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

CREATE TABLE [COVID_20].[Fact_Table_Estadias](
	Dim_Tiempo_Anio numeric(4) NOT NULL,
	Dim_Tiempo_Mes numeric(2) NOT NULL,
	Dim_Hotel_RS varchar(50) NOT NULL,
	Dim_Clie_Edad int NOT NULL,
	Dim_THabitacion_Tipo varchar(50) NOT NULL,
	Fact_Precio_Promedio_Compra numeric(10,2),
	Fact_Precio_Promedio_Venta numeric(10,2),
	Fact_Cantidad_Vendida int,
	Fact_Ganancia numeric(10,2),
	Fact_Cantidad_Camas int,
	Fact_Cantidad_Habitaciones int
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

ALTER TABLE [COVID_20].[Fact_Table_Estadias]
	ADD CONSTRAINT PK_BI_Fact_Estadias PRIMARY KEY (Dim_Tiempo_Anio ,Dim_Tiempo_Mes, Dim_Hotel_RS, Dim_Clie_Edad, Dim_THabitacion_Tipo)


------------------------------------------------------CREACION DE LAS CLAVES FORANEAS (FK)

ALTER TABLE [COVID_20].[Fact_Table_Estadias] 
	ADD CONSTRAINT FK_BI_Dimencion_Tiempo_Anio
	FOREIGN KEY (Dim_Tiempo_Anio,Dim_Tiempo_Mes) REFERENCES Covid_20.Dimencion_Tiempo(Tiempo_Anio,Tiempo_Mes)

ALTER TABLE [COVID_20].[Fact_Table_Estadias] 
	ADD CONSTRAINT FK_BI_Dimencion_Empresa_Hotelera
	FOREIGN KEY (Dim_Hotel_RS) REFERENCES Covid_20.Dimencion_Empresa_Hotelera(Hotel_RS)

ALTER TABLE [COVID_20].[Fact_Table_Estadias] 
	ADD CONSTRAINT FK_BI_Dimencion_Tipo_Habitacion
	FOREIGN KEY (Dim_THabitacion_Tipo) REFERENCES Covid_20.Dimencion_Tipo_Habitacion(THabitacion_Tipo)

ALTER TABLE [COVID_20].[Fact_Table_Estadias] 
	ADD CONSTRAINT FK_BI_Clientes_Estadias
	FOREIGN KEY (Dim_Clie_Edad) REFERENCES Covid_20.Dimencion_Clientes_Estadias(Clie_Edad)


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
INSERT INTO COVID_20.Dimencion_Tipo_Habitacion (THabitacion_Tipo,THabitacion_Cantidad_Camas ) 
			Values ('Base Simple', 1 )
INSERT INTO COVID_20.Dimencion_Tipo_Habitacion (THabitacion_Tipo,THabitacion_Cantidad_Camas ) 
			Values ('Base Doble', 2)
INSERT INTO COVID_20.Dimencion_Tipo_Habitacion (THabitacion_Tipo,THabitacion_Cantidad_Camas ) 
			Values ('Base Triple', 3)
INSERT INTO COVID_20.Dimencion_Tipo_Habitacion (THabitacion_Tipo,THabitacion_Cantidad_Camas ) 
			Values ('Base Cuadruple', 4)
INSERT INTO COVID_20.Dimencion_Tipo_Habitacion (THabitacion_Tipo,THabitacion_Cantidad_Camas ) 
			Values ('King', 1)

 



---------------------------------------------- MIGRACIOS DE LA FACT TABLE DE ESTADIAS
 
	 
	 
	
	 
	
	 
	 
	 
	 
	
INSERT INTO COVID_20.Fact_Table_Estadias (Dim_Tiempo_Anio,
										  Dim_Tiempo_Mes,
										  Dim_Hotel_RS,
										  Dim_Clie_Edad,
										  Dim_THabitacion_Tipo,
										  Fact_Precio_Promedio_Compra,
										  Fact_Precio_Promedio_Venta, 
										  Fact_Cantidad_Vendida, 
										  Fact_Ganancia, 
										  Fact_Cantidad_Camas, 
										  Fact_Cantidad_Habitaciones)
SELECT DATEPART(YEAR,F.Factura_Fecha) AS Año
	,DATEPART(MONTH,F.Factura_Fecha) AS Mes
	,EMP.Empresa_RS AS RS_Hotel
	,DATEDIFF(YEAR,CLIE.Cliente_Fecha_Nac,GETDATE()) AS Edad
	,TH.THabitacion_Descripcion AS Tipo_Habitacion
	,AVG(E.Estadia_Costo) AS Precio_Promedio_Compra
	,AVG(E.Estadia_Precio) AS Precio_Promedio_Venta
	,COUNT(DISTINCT F.Factura_NRO) AS Cantidad_Vendida
	,SUM(E.Estadia_Precio) - SUM(E.Estadia_Costo) AS Ganancia
	,SUM(CASE WHEN TH.THabitacion_Descripcion = 'Base Simple' THEN 1
			  WHEN TH.THabitacion_Descripcion = 'Base Doble' THEN 2
			  WHEN TH.THabitacion_Descripcion = 'Base Triple' THEN 3
			  WHEN TH.THabitacion_Descripcion = 'Base Cuadruple' THEN 4
			  WHEN TH.THabitacion_Descripcion = 'King' THEN 1
			  END) AS Cantidad_Camas
	,COUNT(DISTINCT HAB.Habitacion_ID) AS Cantidad_Habitacion
FROM COVID_20.FACTURA F
INNER JOIN COVID_20.ESTADIA E ON F.Estadia_ID = E.Estadia_ID
INNER JOIN COVID_20.COMPRA C ON C.Compra_NRO = E.Compra_NRO
INNER JOIN COVID_20.EMPRESA EMP ON EMP.Empresa_ID = C.Empresa_ID
INNER JOIN COVID_20.HOTEL H ON H.Hotel_ID = E.Hotel_ID
INNER JOIN COVID_20.HABITACION HAB ON HAB.Habitacion_ID = E.Habitacion_ID AND H.Hotel_ID = HAB.Hotel_ID
INNER JOIN COVID_20.TIPO_HABITACION TH ON TH.THabitacion_ID = HAB.THabitacion_ID
INNER JOIN COVID_20.CLIENTE CLIE ON CLIE.Cliente_ID = F.Cliente_ID
INNER JOIN COVID_20.SUCURSAL S ON S.Sucursal_ID = F.Sucursal_ID
GROUP BY DATEPART(YEAR,F.Factura_Fecha)
	,DATEPART(MONTH,F.Factura_Fecha)
	,EMP.Empresa_RS
	,DATEDIFF(YEAR,CLIE.Cliente_Fecha_Nac,GETDATE())
	,TH.THabitacion_Descripcion
order by 1 DESC,2 ASC, 3, 4, 5

/*
	SELECT * FROM COVID_20.Dimencion_Tiempo
	SELECT * FROM COVID_20.Dimencion_Empresa_Hotelera
	SELECT * FROM COVID_20.Dimencion_Clientes_Estadias
	SELECT * FROM COVID_20.Dimencion_Tipo_Habitacion	
	SELECT * FROM COVID_20.Fact_Table_Estadias
*/
