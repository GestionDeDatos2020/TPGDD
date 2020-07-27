USE GD1C2020
/*
DROP TABLE [COVID_20].[Dimencion_Tiempo]
DROP TABLE [COVID_20].[Dimension_Empresa];
DROP TABLE [COVID_20].[Dimension_Sucursal_Pasajes];
DROP TABLE [COVID_20].[Dimension_Ciudad];
DROP TABLE [COVID_20].[Dimension_Tipo_Butaca];
DROP TABLE [COVID_20].[Dimension_Clientes_Edad]
DROP TABLE [COVID_20].[Dimension_Clientes_Pasaje];

DROP TABLE [COVID_20].[Fact_Table_Pasaje];
*/
----------- CREATE TABLE DIMENSIONES
BEGIN TRANSACTION

CREATE TABLE [COVID_20].[Dimension_Tiempo](
	Tiempo_Anio numeric(4) NOT NULL,
	Tiempo_Mes numeric(2) NOT NULL
);


CREATE TABLE [COVID_20].[Dimension_Empresa](
	Empresa_ID int Not Null,
	Empresa_RS varchar(50)
);


Create Table [COVID_20].[Dimension_Sucursal_Pasajes](
	Sucursal_ID int  NOT NULL,
    Sucursal_Direccion VARCHAR(100) NOT NULL,
    Sucursal_Mail VARCHAR(100) NOT NULL,
    Sucursal_Telefono int 
);

CREATE TABLE [COVID_20].[Dimension_Ciudad] (
  Ciudad_ID  int not null,
  Ciudad_Nombre  varchar(50) not null 
);

CREATE TABLE [COVID_20].[Dimension_Tipo_Butaca](
	TButaca_ID int NOT NULL,
	TButaca_Descripcion VARCHAR(50) NOT NULL,
);

CREATE TABLE [COVID_20].[Dimension_Clientes_Edad](
	Clie_Edad int NOT NULL,
	Clie_Descripcion VARCHAR(50)
);

CREATE TABLE [COVID_20].[Dimension_Clientes_Pasaje] (
  [Clie_ID] bigint  not null,
  [Clie_Edad] int not null,
  [Clie_DNI] bigint not null,
  [Clie_Nombre] varchar(50),
  [Clie_Apellido] varchar(50),
  [Clie_Fecha_Nac] datetime not null,
  [Clie_Mail] varchar(100),
  [Clie_Telefono] int
);



----------- FACT_TABLE_PASAJES  CREATE TABLE

CREATE TABLE [COVID_20].[Fact_Table_Pasaje] (
    Anio numeric(4) NOT NULL,
	Mes numeric(2) NOT NULL,
    Empresa_ID INT  NOT NULL,
    Clie_Edad INT  NOT NULL,
    Sucursal_ID INT  NOT NULL,
    TButaca_ID int  NOT NULL,
    Ciudad_ID int   NOT NULL,
    Precio_Promedio_Venta decimal(18, 2)  NOT NULL,
    Precio_Promedio_Compra decimal(18, 2)   NOT NULL,
    Cantidad_Vendida    decimal(18, 0)  NOT NULL,
    Precio_Venta_Total decimal(18, 2)  NOT NULL,
    Precio_Compra_Total decimal(18, 2)  NOT NULL,
    Ganancia decimal(18, 2)   NOT NULL,
);


----------- CREATE PK

ALTER TABLE [COVID_20].[Dimension_Empresa]
		ADD CONSTRAINT PK_DIM_Empresa PRIMARY KEY (Empresa_ID);

ALTER TABLE [COVID_20].[Dimension_Sucursal_Pasajes]
	ADD CONSTRAINT PK_BI_Sucursal PRIMARY KEY (Sucursal_ID);

ALTER TABLE [COVID_20].[Dimension_Ciudad]
		ADD CONSTRAINT PK_BI_Ciudad PRIMARY KEY (Ciudad_ID);

ALTER TABLE [COVID_20].[Dimension_Tipo_Butaca]
		ADD CONSTRAINT PK_BI_Tipo_Butaca PRIMARY KEY (TButaca_ID);

ALTER TABLE [COVID_20].[Dimension_Clientes_Edad]
		ADD CONSTRAINT PK_BI_Clientes_Edad PRIMARY KEY (Clie_Edad);

ALTER TABLE [COVID_20].[Dimension_Clientes_Pasaje]
		ADD CONSTRAINT PK_BI_Clientes_ID PRIMARY KEY (Clie_ID);

ALTER TABLE [COVID_20].[Fact_Table_Pasaje] ADD CONSTRAINT PK_Fact_Pasaje 
PRIMARY KEY (Anio,Mes,Empresa_ID,Clie_Edad,Sucursal_ID,TButaca_ID,Ciudad_ID);


----------- CREATE FK

ALTER TABLE [COVID_20].[Dimension_Tiempo]
		ADD CONSTRAINT PK_BI_Tiempo PRIMARY KEY (Tiempo_Anio, Tiempo_Mes)

ALTER TABLE [COVID_20].[Fact_Table_Pasaje] 
    ADD CONSTRAINT FK_BI_Dimension_Tiempo_Anio_mes
    FOREIGN KEY (Anio,Mes) REFERENCES Covid_20.Dimension_Tiempo(Tiempo_Anio,Tiempo_Mes)

ALTER TABLE [COVID_20].[Fact_Table_Pasaje] 
		ADD CONSTRAINT FK_BI_Empresa
		FOREIGN KEY (Empresa_ID) REFERENCES [COVID_20].[Dimension_Empresa](Empresa_ID);

ALTER TABLE [COVID_20].[Fact_Table_Pasaje] 
    ADD CONSTRAINT FK_BI_Sucursal
    FOREIGN KEY (Sucursal_ID) REFERENCES COVID_20.Dimension_Sucursal_Pasajes(Sucursal_ID);

ALTER TABLE [COVID_20].[Fact_Table_Pasaje] 
    ADD CONSTRAINT FK_BI_Ciudad
    FOREIGN KEY (Ciudad_ID) REFERENCES Covid_20.Dimension_Ciudad(Ciudad_ID);

ALTER TABLE [COVID_20].[Fact_Table_Pasaje] 
    ADD CONSTRAINT FK_BI_Tipo_Pasaje
    FOREIGN KEY (TButaca_ID) REFERENCES [COVID_20].[Dimension_Tipo_Butaca](TButaca_ID);

ALTER TABLE [COVID_20].[Fact_Table_Pasaje] 
    ADD CONSTRAINT FK_BI_Cliente_Pasaje
    FOREIGN KEY (Clie_Edad) REFERENCES COVID_20.Dimension_Clientes_edad(Clie_Edad);

ALTER TABLE [COVID_20].[Dimension_Clientes_Pasaje] 
    ADD CONSTRAINT FK_BI_Cliente_Edad
    FOREIGN KEY (Clie_Edad) REFERENCES COVID_20.Dimension_Clientes_edad(Clie_Edad);

---------------------------------------------- MIGRACIOS DE LA TABLA TIEMPO 

INSERT INTO COVID_20.Dimension_Tiempo (Tiempo_Anio,Tiempo_Mes) 
	SELECT cast(YEAR(Factura_Fecha) as numeric(4)), cast(MONTH(Factura_Fecha) as numeric (2))
	FROM COVID_20.FACTURA
	GROUP BY YEAR(Factura_Fecha), MONTH(Factura_Fecha)
	UNION
	SELECT cast(YEAR(Compra_Fecha) as numeric(4)), cast(MONTH(Compra_Fecha) as numeric (2))
	FROM COVID_20.COMPRA
	GROUP BY YEAR(Compra_Fecha), MONTH(Compra_Fecha)

--------- MIGRACION Dimension_Tipo_Butaca
INSERT INTO  COVID_20.Dimension_Tipo_Butaca (TButaca_ID,TButaca_Descripcion)
SELECT TButaca_ID,TButaca_Descripcion
FROM COVID_20.TIPO_BUTACA ;

----------- MIGRACION Dimension_Sucursal_Pasajes
INSERT INTO  COVID_20.Dimension_Sucursal_Pasajes(Sucursal_ID, Sucursal_Direccion, Sucursal_Mail, Sucursal_Telefono)
SELECT Sucursal_ID, Sucursal_Direccion, Sucursal_Mail, Sucursal_Telefono
FROM COVID_20.SUCURSAL ;

-----------       MIGRACION Dimension_Ciudad
INSERT INTO COVID_20.Dimension_Ciudad(Ciudad_ID,Ciudad_Nombre)
SELECT Ciudad_ID,Ciudad_Nombre
FROM COVID_20.CIUDAD

---------       MIGRACION Dimension_Empresa
INSERT INTO COVID_20.Dimension_Empresa(Empresa_ID,Empresa_RS)
SELECT *
FROM COVID_20.EMPRESA;

-----------       MIGRACION Dimension_Clientes_edad

INSERT INTO  COVID_20.Dimension_Clientes_Edad(Clie_Edad,Clie_Descripcion)
SELECT 
	DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE())-
	(CASE   
		WHEN DATEADD(YY,DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE()),
			c.Cliente_Fecha_Nac)>GETDATE() 
		THEN  1  ELSE   0  END) 
	as Edad
    ,CONCAT(DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE())-
	(CASE   
		WHEN DATEADD(YY,DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE()),
			c.Cliente_Fecha_Nac)>GETDATE() 
		THEN  1  ELSE   0  END) ,' Años')
FROM COVID_20.FACTURA f
JOIN COVID_20.CLIENTE c ON f.Cliente_ID = c.Cliente_ID 
WHERE Estadia_ID IS NULL
group by DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE())-
	(CASE   
		WHEN DATEADD(YY,DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE()),
			c.Cliente_Fecha_Nac)>GETDATE() 
		THEN  1  ELSE   0  END) 
Order by 1;

--       MIGRACION Dimension_Clientes

INSERT INTO [COVID_20].[Dimension_Clientes_Pasaje] (Clie_ID, Clie_Edad,Clie_DNI,Clie_Nombre,Clie_Apellido,Clie_Fecha_Nac,Clie_Mail,Clie_Telefono)
SELECT c.Cliente_ID, DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE()), Cliente_DNI, Cliente_Nombre, Cliente_Apellido,Cliente_Fecha_Nac,Cliente_Mail,Cliente_Telefono
FROM COVID_20.CLIENTE c
JOIN COVID_20.FACTURA f on f.Cliente_ID = c.Cliente_ID
WHERE Estadia_ID IS NULL
COMMIT


-- FACT_TABLE_PASAJES MIGRACION DATOS
INSERT INTO  COVID_20.Fact_Table_Pasaje (Anio,Mes,Empresa_ID,Clie_Edad,Sucursal_ID,TButaca_ID,Ciudad_ID,Precio_Promedio_Compra,Precio_Compra_Total,Precio_Promedio_Venta,Cantidad_Vendida,Precio_Venta_Total,Ganancia)

SELECT YEAR(Compra_Fecha) as Anio, MONTH(Compra_Fecha)AS Mes, C.Empresa_ID
,DATEDIFF(YEAR,CLIE.Cliente_Fecha_Nac,GETDATE()) AS Edad
,S.Sucursal_ID, B.TButaca_ID, RA.Ruta_Ciudad_Destino,
AVG(Pasaje_Costo) Precio_Promedio_Compra,  AVG(Factura_Importe) Precio_Promedio_Venta,
COUNT(DISTINCT F.Pasaje_ID) as Cantidad_Vendida,
SUM(F.Factura_Importe) Precio_Venta_Total, SUM(P.Pasaje_Costo) Precio_Compra_Total,
SUM(F.Factura_Importe) - SUM(P.Pasaje_Costo) as Ganancia
FROM COVID_20.COMPRA C
JOIN COVID_20.EMPRESA EM ON EM.Empresa_ID = C.Empresa_ID
JOIN COVID_20.PASAJE P ON P.Compra_NRO = C.Compra_NRO
JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P.Pasaje_ID
JOIN COVID_20.SUCURSAL S ON S.Sucursal_ID = F.Sucursal_ID
JOIN COVID_20.CLIENTE CLIE ON CLIE.Cliente_ID = F.Cliente_ID
JOIN COVID_20.VUELO v ON v.Vuelo_ID = p.Vuelo_ID
JOIN COVID_20.AVION A ON A.Avion_ID = V.Avion_ID
JOIN COVID_20.BUTACA B ON B.Butaca_ID = P.Butaca_ID AND B.Avion_ID = A.Avion_ID
JOIN COVID_20.RUTA_AEREA RA ON RA.Ruta_ID = v.Ruta_ID
GROUP BY YEAR(Compra_Fecha)  , MONTH(Compra_Fecha),C.Empresa_ID,
DATEDIFF(YEAR,CLIE.Cliente_Fecha_Nac,GETDATE()), F.Sucursal_ID,S.Sucursal_ID,B.TButaca_ID, RA.Ruta_Ciudad_Destino





