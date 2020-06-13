USE [GD1C2020]
GO

-- DROP SCHEMA COVID_20
------------------------------------------------------CREAR SCHEMA

CREATE SCHEMA  [COVID_20]
GO


------------------------------------------------------DROPS
/*	TABLAS
BEGIN TRANSACTION	
	DROP TABLE [COVID_20].[FACTURA] 
	DROP TABLE [COVID_20].[SUCURSAL] 
	DROP TABLE [COVID_20].[CLIENTE]
	DROP TABLE [COVID_20].[PASAJE]
	DROP TABLE [COVID_20].[VUELO]
	DROP TABLE [COVID_20].[BUTACA]
	DROP TABLE [COVID_20].[TIPO_BUTACA] 
	DROP TABLE [COVID_20].[AVION] 
	DROP TABLE [COVID_20].[RUTA_AEREA]     
	DROP TABLE [COVID_20].[CIUDAD] 
		 
	DROP TABLE [COVID_20].[ESTADIA] 
	DROP TABLE [COVID_20].[HABITACION] 
	DROP TABLE [COVID_20].[TIPO_HABITACION]
	DROP TABLE [COVID_20].[HOTEL] 
	
	DROP TABLE [COVID_20].[COMPRA]
	DROP TABLE [COVID_20].[EMPRESA]
COMMIT TRANSACTION
*/
------------------------------------------------------CREAR TABLES

CREATE TABLE [COVID_20].[ESTADIA] (
  [Estadia_ID] bigint not null,
  [Estadia_Costo] numeric(10,2),
  [Estadia_Precio] numeric(10,2),
  [Compra_NRO] decimal(18, 0),
  [Estadia_Inicio] datetime,
  [Estadia_Noches] int,
  [Estadia_Checkin] datetime,
  [Estadia_Checout] datetime,
  [Habitacion_ID] int,
  [Hotel_ID] int
);
 
CREATE TABLE [COVID_20].[FACTURA] (
  [Factura_NRO] bigint not null,
  [Factura_Fecha] datetime,
  [Factura_Importe] numeric(10,2),
  [Pasaje_ID] decimal(18, 0),
  [Estadia_ID] bigint,
  [Cliente_ID] bigint,
  [Sucursal_ID] bigint
);


CREATE TABLE [COVID_20].[COMPRA] (
  [Compra_NRO] decimal(18, 0) not null,
  [Compra_Fecha] datetime,
  [Empresa_ID] int
);


CREATE TABLE [COVID_20].[EMPRESA] (
  [Empresa_ID] int identity(1,1) not null,
  [Empresa_RS] varchar(50)
);

CREATE TABLE [COVID_20].[TIPO_HABITACION] (
  [THabitacion_ID] int not null,
  [THabitacion_Descripcion] varchar(50)
);

CREATE TABLE [COVID_20].[HABITACION] (
  [Habitacion_ID] int not null,
  [Habitacion_NRO] int,
  [Habitacion_Piso] int,
  [Habitacion_Frente] char(1),
  [Hotel_ID] int,
  [THabitacion_ID] int
);


CREATE TABLE [COVID_20].[CLIENTE] (
  [Cliente_ID] bigint identity(1,1) not null,
  [Cliente_DNI] bigint not null,
  [Cliente_Nombre] varchar(50),
  [Cliente_Apellido] varchar(50),
  [Cliente_Fecha_Nac] datetime,
  [Cliente_Mail] varchar(100),
  [Cliente_Telefono] int
);


CREATE TABLE [COVID_20].[HOTEL] (
  [Hotel_ID] int not null,
  [Hotel_Calle] varchar(50),
  [Hotel_NRO] int,
  [Hotel_Estrellas] int
);

CREATE TABLE [COVID_20].[SUCURSAL] (
  [Sucursal_ID] bigint identity(1,1) not null,
  [Sucursal_Direccion] varchar(100),
  [Sucursal_Mail] varchar(100),
  [Sucursal_Telefono] int
);

CREATE TABLE [COVID_20].[TIPO_BUTACA] (
  [TButaca_ID] int IDENTITY(1,1) not null,
  [TButaca_Descripcion] varchar(50)
);

CREATE TABLE [COVID_20].[AVION] (
  [Avion_ID] nvarchar(50) not null,
  [Avion_Modelo] varchar(30)
);

CREATE TABLE [COVID_20].[BUTACA] (
  [Butaca_ID] int identity(1,1) not null,
  [Butaca_NRO] decimal(18, 0) NOT NULL,
  [Avion_ID] nvarchar(50) not null,
  [TButaca_ID] int
);

CREATE TABLE [COVID_20].[CIUDAD] (
  [Ciudad_ID] int IDENTITY(1,1) not null,
  [Ciudad_Nombre] varchar(50)
);

CREATE TABLE [COVID_20].[RUTA_AEREA] (
  [Ruta_ID] int identity(1,1) not null,
  [Ruta_Codigo] decimal(18, 0),
  [Ruta_Ciudad_Origen] int,
  [Ruta_Ciudad_Destino] int
);

CREATE TABLE [COVID_20].[VUELO] (
  [Vuelo_ID] bigint not null,
  [Avion_ID] nvarchar(50) not null,
  [Ruta_ID] int NOT NULL,
  [Vuelo_Fecha_Salida] datetime,
  [Vuelo_Fecha_Llegada] datetime,
);

CREATE TABLE [COVID_20].[PASAJE] (
  [Pasaje_ID] decimal(18, 0)  NOT NULL,
  [Vuelo_ID] bigint not null,
  [Butaca_ID] int  not null,
  [Compra_NRO] decimal(18, 0) NOT NULL,
  [Pasaje_Costo] decimal(18, 2) NOT NULL,
  [Pasaje_Precio] numeric(10,2) ,
);

------------------------------------------------------CREAR PK
BEGIN TRANSACTION
	ALTER TABLE [COVID_20].[SUCURSAL] ADD CONSTRAINT PK_Sucursal PRIMARY KEY (Sucursal_ID)	
	ALTER TABLE [COVID_20].[ESTADIA] ADD CONSTRAINT PK_Estadia PRIMARY KEY (Estadia_ID)
	ALTER TABLE [COVID_20].[FACTURA] ADD CONSTRAINT PK_Factura PRIMARY KEY (Factura_NRO)
	ALTER TABLE [COVID_20].[COMPRA] ADD CONSTRAINT PK_Compra PRIMARY KEY (Compra_NRO)
	ALTER TABLE [COVID_20].[HOTEL] ADD CONSTRAINT PK_Hotel PRIMARY KEY (Hotel_ID)
	ALTER TABLE [COVID_20].[CLIENTE] ADD CONSTRAINT PK_Cliente PRIMARY KEY (Cliente_ID)
	ALTER TABLE [COVID_20].[HABITACION] ADD CONSTRAINT PK_Habitacion PRIMARY KEY (Habitacion_ID)
	ALTER TABLE [COVID_20].[TIPO_HABITACION] ADD CONSTRAINT PK_TipoHabitacion PRIMARY KEY (THabitacion_ID)
	ALTER TABLE [COVID_20].[EMPRESA] ADD CONSTRAINT PK_Empresa PRIMARY KEY (Empresa_ID)
	ALTER TABLE [COVID_20].[TIPO_BUTACA] ADD CONSTRAINT PK_TipoButaca PRIMARY KEY (TButaca_ID)
	ALTER TABLE [COVID_20].[AVION] ADD CONSTRAINT PK_Avion PRIMARY KEY (Avion_ID)
	ALTER TABLE [COVID_20].[BUTACA] ADD CONSTRAINT PK_Butaca PRIMARY KEY (Butaca_ID); 
	ALTER TABLE [COVID_20].[CIUDAD] ADD CONSTRAINT PK_Ciudad PRIMARY KEY (Ciudad_ID)
	ALTER TABLE [COVID_20].[RUTA_AEREA] ADD CONSTRAINT PK_RutaAerea PRIMARY KEY (Ruta_ID)
	ALTER TABLE [COVID_20].[VUELO] ADD CONSTRAINT PK_Vuelo PRIMARY KEY (Vuelo_ID)
	ALTER TABLE [COVID_20].[PASAJE] ADD CONSTRAINT PK_Pasaje PRIMARY KEY (Pasaje_ID)
COMMIT TRANSACTION
------------------------------------------------------CREAR FK

BEGIN TRANSACTION
	--Habitacion
	ALTER TABLE [COVID_20].[HABITACION] 
		ADD CONSTRAINT FK_Habitacion_HotelID
		FOREIGN KEY (Hotel_ID) REFERENCES COVID_20.HOTEL(Hotel_ID)
	ALTER TABLE [COVID_20].[HABITACION] 
		ADD CONSTRAINT FK_Habitacion_ThabitacionID
		FOREIGN KEY (THabitacion_ID) REFERENCES COVID_20.TIPO_HABITACION(THabitacion_ID)
	--Compra
	ALTER TABLE [COVID_20].[COMPRA] 
		ADD CONSTRAINT FK_Compra_EmpresaID
		FOREIGN KEY (Empresa_ID) REFERENCES COVID_20.EMPRESA(Empresa_ID)
	--Factura
	ALTER TABLE [COVID_20].[FACTURA] 
		ADD CONSTRAINT FK_Factura_PasajeID 
		FOREIGN KEY (Pasaje_ID) REFERENCES COVID_20.PASAJE(Pasaje_ID)
	ALTER TABLE [COVID_20].[FACTURA] 
		ADD CONSTRAINT FK_Factura_EstadiaID 
		FOREIGN KEY (Estadia_ID) REFERENCES COVID_20.ESTADIA(Estadia_ID)
	ALTER TABLE [COVID_20].[FACTURA] 
		ADD CONSTRAINT FK_Factura_ClienteID 
		FOREIGN KEY (Cliente_ID) REFERENCES COVID_20.CLIENTE(Cliente_ID)
	ALTER TABLE [COVID_20].[FACTURA] 
		ADD CONSTRAINT FK_Factura_SucursalID 
		FOREIGN KEY (Sucursal_ID) REFERENCES COVID_20.SUCURSAL(Sucursal_ID)
	--Estadia
	ALTER TABLE [COVID_20].[ESTADIA] 
		ADD CONSTRAINT FK_Estadia_CompraNumero 
		FOREIGN KEY (Compra_NRO) REFERENCES COVID_20.COMPRA(Compra_NRO)
	ALTER TABLE [COVID_20].[ESTADIA] 
		ADD CONSTRAINT FK_Estadia_HabitacionID  
		FOREIGN KEY (Habitacion_ID) REFERENCES COVID_20.HABITACION(Habitacion_ID)
	ALTER TABLE [COVID_20].[ESTADIA] 
		ADD CONSTRAINT FK_Estadia_HotelID 
		FOREIGN KEY (Hotel_ID) REFERENCES COVID_20.HOTEL(Hotel_ID)
	--Butaca
	ALTER TABLE [COVID_20].[BUTACA] 
		ADD CONSTRAINT FK_Butaca_AvionID
		FOREIGN KEY (Avion_ID) REFERENCES COVID_20.AVION(Avion_ID)
	ALTER TABLE [COVID_20].[BUTACA] 
		ADD CONSTRAINT FK_Butaca_TButaca_ID
		FOREIGN KEY (TButaca_ID) REFERENCES COVID_20.TIPO_BUTACA(TButaca_ID)
	--Ruta AEREA
	ALTER TABLE [COVID_20].[RUTA_AEREA] 
		ADD CONSTRAINT FK_RutaAerea_CiudadOrigen 
		FOREIGN KEY (Ruta_Ciudad_Origen) REFERENCES COVID_20.CIUDAD(Ciudad_ID)
	ALTER TABLE [COVID_20].[RUTA_AEREA] 
		ADD CONSTRAINT FK_RutaAerea_CiudadDestino
		FOREIGN KEY (Ruta_Ciudad_Destino) REFERENCES COVID_20.CIUDAD(Ciudad_ID)
	--Vuelo
	ALTER TABLE [COVID_20].[VUELO] 
		ADD CONSTRAINT FK_Vuelo_RutaID 
		FOREIGN KEY (Ruta_ID) REFERENCES COVID_20.RUTA_AEREA(Ruta_ID)
	ALTER TABLE [COVID_20].[VUELO] 
		ADD CONSTRAINT FK_Vuelo_AvionID 
		FOREIGN KEY (Avion_ID) REFERENCES COVID_20.AVION(Avion_ID)
	--Pasaje
	ALTER TABLE [COVID_20].[PASAJE] 
		ADD CONSTRAINT FK_Pasaje_CompraNumero
		FOREIGN KEY (Compra_NRO) REFERENCES COVID_20.COMPRA(Compra_NRO)
	ALTER TABLE [COVID_20].[PASAJE] 
		ADD CONSTRAINT FK_Pasaje_ButacaID
		FOREIGN KEY (Butaca_ID) REFERENCES COVID_20.BUTACA(Butaca_ID)   
	ALTER TABLE [COVID_20].[PASAJE] 
		ADD CONSTRAINT FK_Pasaje_VueloID
		FOREIGN KEY (Vuelo_ID) REFERENCES COVID_20.VUELO(Vuelo_ID)
COMMIT TRANSACTION
 
-- CONSTRAINT
BEGIN TRANSACTION
	ALTER TABLE  [COVID_20].[BUTACA] ADD CONSTRAINT Uk_Nro_Avion_Tipo UNIQUE (Butaca_NRO,Avion_ID,TButaca_ID);
	ALTER TABLE  [COVID_20].[CIUDAD] ADD CONSTRAINT Uk_Ciudad UNIQUE (Ciudad_Nombre);
	ALTER TABLE  [COVID_20].[BUTACA] ADD CONSTRAINT Uk_ButacaAvion UNIQUE (Butaca_NRO,Avion_ID,TButaca_ID);
	ALTER TABLE  [COVID_20].[RUTA_AEREA] ADD CONSTRAINT Uk_Ruta_Aerea UNIQUE (Ruta_Codigo,Ruta_Ciudad_Origen,Ruta_Ciudad_Destino);
	ALTER TABLE  [COVID_20].[VUELO] ADD CONSTRAINT Uk_Vuelo_Avion_Ruta UNIQUE (Vuelo_ID,Avion_ID,Ruta_ID);
COMMIT TRANSACTION

----------------------------INSERTS--------------------------
---------------------------------------------- TIPO_BUTACA
INSERT INTO COVID_20.TIPO_BUTACA (TButaca_Descripcion)
	SELECT DISTINCT BUTACA_TIPO
	FROM gd_esquema.Maestra 
	WHERE BUTACA_NUMERO  IS NOT NULL ;

---------------------------------------------- AVION 
INSERT INTO COVID_20.AVION (Avion_ID,Avion_Modelo)
	SELECT DISTINCT AVION_IDENTIFICADOR, AVION_MODELO 
	FROM gd_esquema.Maestra
	WHERE AVION_IDENTIFICADOR IS NOT NULL ;

---------------------------------------------- BUTACA
INSERT INTO COVID_20.BUTACA (Butaca_NRO,Avion_ID,TButaca_ID)
	SELECT DISTINCT BUTACA_NUMERO, Avion_Id,  TButaca_ID 
	FROM  gd_esquema.Maestra 
	join COVID_20.TIPO_BUTACA on TButaca_Descripcion = BUTACA_TIPO
	JOIN COVID_20.AVION ON Avion_ID = AVION_IDENTIFICADOR 
		
---------------------------------------------- CIUDAD
INSERT INTO COVID_20.CIUDAD (Ciudad_Nombre)
	SELECT distinct RUTA_AEREA_CIU_DEST 
		FROM gd_esquema.Maestra 
		WHERE RUTA_AEREA_CIU_DEST is not null
	UNION
	SELECT distinct RUTA_AEREA_CIU_ORIG 
		FROM gd_esquema.Maestra 
		WHERE RUTA_AEREA_CIU_ORIG is not null
		order by 1
---------------------------------------------- RUTA AEREA
INSERT INTO COVID_20.RUTA_AEREA (Ruta_Codigo,Ruta_Ciudad_Origen,Ruta_Ciudad_Destino)
	SELECT DISTINCT RUTA_AEREA_CODIGO, C1.Ciudad_ID as origen , C2.Ciudad_ID as destino
	FROM gd_esquema.Maestra
	JOIN COVID_20.CIUDAD C1 ON C1.Ciudad_Nombre = RUTA_AEREA_CIU_ORIG
	JOIN COVID_20.CIUDAD C2 ON C2.Ciudad_Nombre = RUTA_AEREA_CIU_DEST

---------------------------------------------- VUELO
INSERT INTO COVID_20.VUELO (Vuelo_ID,Avion_ID,Ruta_ID,Vuelo_Fecha_Salida,Vuelo_Fecha_Llegada)
	SELECT DISTINCT  VUELO_CODIGO, AVION_IDENTIFICADOR,Ruta_ID,VUELO_FECHA_SALUDA, VUELO_FECHA_LLEGADA
	FROM gd_esquema.Maestra
	JOIN COVID_20.RUTA_AEREA ON Ruta_Codigo = RUTA_AEREA_CODIGO
	JOIN COVID_20.CIUDAD C1 ON C1.Ciudad_ID = Ruta_Ciudad_Origen
					AND C1.Ciudad_Nombre = RUTA_AEREA_CIU_ORIG
	JOIN COVID_20.CIUDAD C2 ON C2.Ciudad_ID = Ruta_Ciudad_Destino 
					AND C2.Ciudad_Nombre = RUTA_AEREA_CIU_DEST

----------------------------------------------  TIPO_HABITACION
INSERT INTO COVID_20.TIPO_HABITACION (THabitacion_ID,THabitacion_Descripcion)
	SELECT DISTINCT TIPO_HABITACION_CODIGO,TIPO_HABITACION_DESC 
	FROM gd_esquema.Maestra
	WHERE TIPO_HABITACION_CODIGO IS NOT NULL;

---------------------------------------------- HOTEL
INSERT INTO COVID_20.HOTEL (Hotel_ID,Hotel_Calle,Hotel_NRO,Hotel_Estrellas)
	SELECT ROW_NUMBER() OVER (ORDER BY HOTEL_CALLE,HOTEL_NRO_CALLE)
		,HOTEL_CALLE
		,HOTEL_NRO_CALLE
		,HOTEL_CANTIDAD_ESTRELLAS
	FROM gd_esquema.Maestra
	WHERE HOTEL_CALLE IS NOT NULL
	GROUP BY HOTEL_CALLE
		,HOTEL_NRO_CALLE
		,HOTEL_CANTIDAD_ESTRELLAS 

---------------------------------------------- HABITACION
INSERT INTO COVID_20.HABITACION (Habitacion_ID,Habitacion_NRO,Habitacion_Piso,Habitacion_Frente,Hotel_ID,THabitacion_ID)
	SELECT ROW_NUMBER() OVER (ORDER BY H.Hotel_id,HABITACION_PISO,HABITACION_NUMERO,HABITACION_FRENTE)
		,HABITACION_NUMERO
		,HABITACION_PISO
		,HABITACION_FRENTE
		,H.Hotel_id
		,TH.Thabitacion_id
	FROM gd_esquema.Maestra M
	INNER JOIN COVID_20.TIPO_HABITACION TH ON M.TIPO_HABITACION_DESC = TH.THabitacion_Descripcion
	INNER JOIN COVID_20.HOTEL H ON H.Hotel_Calle = M.Hotel_calle 
										AND H.Hotel_NRO = M.Hotel_nro_calle 
										AND H.Hotel_Estrellas = M.Hotel_Cantidad_Estrellas
	WHERE M.HABITACION_NUMERO IS NOT NULL
	GROUP BY M.HABITACION_NUMERO
		,M.HABITACION_PISO
		,M.HABITACION_FRENTE
		,H.Hotel_id
		,TH.Thabitacion_id
	
---------------------------------------------- EMPRESA
--SELECT * FROM COVID_20.EMPRESA
INSERT INTO COVID_20.EMPRESA (Empresa_RS) 
	SELECT DISTINCT EMPRESA_RAZON_SOCIAL 
		FROM gd_esquema.Maestra
---------------------------------------------- SUCURSAL
INSERT INTO COVID_20.SUCURSAL (Sucursal_Direccion, Sucursal_Mail, Sucursal_Telefono)
	SELECT DISTINCT SUCURSAL_DIR, SUCURSAL_MAIL, SUCURSAL_TELEFONO 
		FROM gd_esquema.Maestra
		WHERE SUCURSAL_DIR is not null
---------------------------------------------- CLIENTE
INSERT INTO COVID_20.CLIENTE (Cliente_DNI, Cliente_Nombre, Cliente_Apellido, 
							  Cliente_Fecha_Nac, Cliente_Mail, Cliente_Telefono)
	SELECT distinct CLIENTE_DNI, CLIENTE_NOMBRE, CLIENTE_APELLIDO, 
				    CLIENTE_FECHA_NAC, CLIENTE_MAIL, CLIENTE_TELEFONO
		FROM gd_esquema.Maestra
		WHERE CLIENTE_DNI is not null

---------------------------------------------- COMPRA
INSERT INTO COVID_20.COMPRA (Compra_NRO, Compra_Fecha, Empresa_ID)
	SELECT DISTINCT COMPRA_NUMERO,COMPRA_FECHA, Empresa_ID
		FROM gd_esquema.Maestra
		JOIN COVID_20.EMPRESA ON EMPRESA_RAZON_SOCIAL = Empresa_RS
		WHERE FACTURA_NRO is null
		order by 1

---------------------------------------------- PASAJE
INSERT INTO COVID_20.PASAJE (Pasaje_ID, Vuelo_ID, Butaca_ID, Compra_NRO, Pasaje_Costo, Pasaje_Precio)
	SELECT DISTINCT PASAJE_CODIGO, VUELO_CODIGO, Butaca_id, COMPRA_NUMERO,PASAJE_COSTO, PASAJE_PRECIO
	FROM gd_esquema.Maestra
	JOIN COVID_20.TIPO_BUTACA ON TButaca_Descripcion = BUTACA_TIPO
	JOIN COVID_20.BUTACA ON  Butaca_NRO = BUTACA_NUMERO
				AND Avion_ID = AVION_IDENTIFICADOR
				AND BUTACA.TButaca_ID  = TIPO_BUTACA.TButaca_ID

---------------------------------------------- ESTADIA
INSERT INTO COVID_20.ESTADIA (Estadia_ID,Estadia_Costo,Estadia_Precio,Compra_NRO,Estadia_Inicio,Estadia_Noches,Estadia_Checkin,Estadia_Checout,Habitacion_ID,Hotel_ID)
	SELECT DISTINCT
		ESTADIA_CODIGO
		,HABITACION_COSTO
		,HABITACION_PRECIO
		,COMPRA_NUMERO
		,ESTADIA_FECHA_INI
		,ESTADIA_CANTIDAD_NOCHES
		,ESTADIA_FECHA_INI AS Estadia_checkin
		,DATEADD(day,ESTADIA_CANTIDAD_NOCHES,ESTADIA_FECHA_INI) AS Estadia_checkout
		,HA.Habitacion_ID
		,H.Hotel_ID
	FROM gd_esquema.Maestra M
	INNER JOIN COVID_20.TIPO_HABITACION TH ON M.TIPO_HABITACION_DESC = TH.THabitacion_Descripcion
	INNER JOIN COVID_20.HOTEL H ON H.Hotel_Calle = M.Hotel_calle 
									AND H.Hotel_NRO = M.Hotel_nro_calle 
									AND H.Hotel_Estrellas = M.Hotel_Cantidad_Estrellas
	INNER JOIN COVID_20.HABITACION HA ON HA.Habitacion_Piso = M.HABITACION_PISO
										AND HA.Habitacion_NRO = M.HABITACION_NUMERO
										AND HA.Habitacion_Frente = M.HABITACION_FRENTE
										AND HA.Hotel_ID = H.Hotel_ID
										AND HA.THabitacion_ID = TH.THabitacion_ID
	WHERE M.ESTADIA_CODIGO IS NOT NULL AND M.FACTURA_NRO IS NOT NULL


---------------------------------------------- FACTURA 

-- ESTADIA
INSERT INTO COVID_20.FACTURA (Factura_NRO, Factura_Fecha, Factura_Importe,
							  Estadia_ID, Cliente_ID, Sucursal_ID)
	SELECT FACTURA_NRO, FACTURA_FECHA, HABITACION_PRECIO, 
		   ESTADIA_CODIGO, c.Cliente_ID, s.Sucursal_ID
		FROM gd_esquema.Maestra m
		JOIN COVID_20.CLIENTE c ON m.CLIENTE_DNI = c.Cliente_DNI AND
									m.CLIENTE_APELLIDO = c.Cliente_Apellido
		JOIN COVID_20.SUCURSAL s  ON m.SUCURSAL_DIR = s.Sucursal_Direccion AND
									 m.SUCURSAL_MAIL = s.Sucursal_Mail AND
									 m.SUCURSAL_TELEFONO = s.Sucursal_Telefono
		where FACTURA_NRO is not null AND 
			  ESTADIA_CODIGO is not null

-- PASAJE		  
INSERT INTO COVID_20.FACTURA (Factura_NRO, Factura_Fecha, Factura_Importe,
							  Pasaje_ID, Cliente_ID, Sucursal_ID)
	SELECT FACTURA_NRO, FACTURA_FECHA, PASAJE_PRECIO, 
		   PASAJE_CODIGO, c.Cliente_ID, s.Sucursal_ID
		FROM gd_esquema.Maestra m
		JOIN COVID_20.CLIENTE c ON m.CLIENTE_DNI = c.Cliente_DNI AND
								   m.CLIENTE_APELLIDO = c.Cliente_Apellido AND
								   m.CLIENTE_NOMBRE = c.Cliente_Nombre
		JOIN COVID_20.SUCURSAL s  ON m.SUCURSAL_DIR = s.Sucursal_Direccion AND
									 m.SUCURSAL_MAIL = s.Sucursal_Mail AND
									 m.SUCURSAL_TELEFONO = s.Sucursal_Telefono
	where FACTURA_NRO is not null AND 
		  PASAJE_CODIGO is not null 
		order by 1

/*
select * from COVID_20.AVION
select * from COVID_20.BUTACA
select * from COVID_20.CIUDAD
select * from COVID_20.CLIENTE
select * from COVID_20.COMPRA
select * from COVID_20.EMPRESA
select * from COVID_20.ESTADIA
select * from COVID_20.FACTURA
select * from COVID_20.HABITACION
select * from COVID_20.HOTEL
select * from COVID_20.PASAJE
select * from COVID_20.RUTA_AEREA
select * from COVID_20.SUCURSAL
select * from COVID_20.TIPO_BUTACA
select * from COVID_20.TIPO_HABITACION
select * from COVID_20.VUELO	
*/