USE [GD1C2020]
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

------------------------------------------------------CREAR SCHEMA
--CREATE SCHEMA [COVID_20]
--GO



------------------------------------------------------CREAR TABLES
CREATE TABLE [COVID_20].[SUCURSAL] (
  [Sucursal_ID] bigint identity(1,1) not null,
  [Sucursal_Direccion] varchar(100),
  [Sucursal_Mail] varchar(100),
  [Sucursal_Telefono] int
);


CREATE TABLE [COVID_20].[VUELO] (
  [Vuelo_ID] bigint not null,
  [Vuelo_Fecha_Salida] datetime,
  [Vuelo_Fecha_Llegada] datetime,
  [Ruta_ID] int,
  [Avion_ID] char(12)
);


CREATE TABLE [COVID_20].[AVION] (
  [Avion_ID] char(12) not null,
  [Avion_Modelo] varchar(30)
);


CREATE TABLE [COVID_20].[CIUDAD] (
  [Ciudad_ID] int not null,
  [Ciudad_Nombre] varchar(50)
);

CREATE TABLE [COVID_20].[ESTADIA] (
  [Estadia_ID] bigint not null,
  [Estadia_Costo] numeric(10,2),
  [Estadia_Precio] numeric(10,2),
  [Compra_NRO] bigint,
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
  [Pasaje_ID] bigint,
  [Estadia_ID] bigint,
  [Cliente_DNI] bigint,
  [Sucursal_ID] bigint
);


CREATE TABLE [COVID_20].[COMPRA] (
  [Compra_NRO] bigint not null,
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

CREATE TABLE [COVID_20].[PASAJE] (
  [Pasaje_ID] bigint not null,
  [Pasaje_Costo] numeric(10,2),
  [Pasaje_Precio] numeric(10,2),
  [Compra_NRO] bigint,
  [Vuelo_ID] bigint,
  [Butaca_ID] int
);


CREATE TABLE [COVID_20].[BUTACA] (
  [Butaca_ID] int not null,
  [Butaca_NRO] int,
  [Avion_ID] char(12),
  [TButaca_ID] int
);


CREATE TABLE [COVID_20].[RUTA_AEREA] (
  [Ruta_ID] int not null,
  [Ciudad_ID_Origen] int,
  [Ciudad_ID_Destino] int
);


CREATE TABLE [COVID_20].[TIPO_BUTACA] (
  [TButaca_ID] int not null,
  [TButaca_Descripcion] varchar(50)
);

CREATE TABLE [COVID_20].[HOTEL] (
  [Hotel_ID] int not null,
  [Hotel_Calle] varchar(50),
  [Hotel_NRO] int,
  [Hotel_Estrellas] int
);


------------------------------------------------------CREAR PK
BEGIN TRANSACTION
	ALTER TABLE [COVID_20].[SUCURSAL]ADD CONSTRAINT PK_Sucursal PRIMARY KEY (Sucursal_ID)
	ALTER TABLE [COVID_20].[VUELO]ADD CONSTRAINT PK_Vuelo PRIMARY KEY (Vuelo_ID)
	ALTER TABLE [COVID_20].[AVION]ADD CONSTRAINT PK_Avion PRIMARY KEY (Avion_ID)
	ALTER TABLE [COVID_20].[CIUDAD]ADD CONSTRAINT PK_Ciudad PRIMARY KEY (Ciudad_ID)
	ALTER TABLE [COVID_20].[ESTADIA]ADD CONSTRAINT PK_Estadia PRIMARY KEY (Estadia_ID)
	ALTER TABLE [COVID_20].[FACTURA]ADD CONSTRAINT PK_Factura PRIMARY KEY (Factura_Numero)
	ALTER TABLE [COVID_20].[COMPRA]ADD CONSTRAINT PK_Compra PRIMARY KEY (Compra_NRO)
	ALTER TABLE [COVID_20].[HOTEL]ADD CONSTRAINT PK_Hotel PRIMARY KEY (Hotel_ID)
	ALTER TABLE [COVID_20].[TIPO_BUTACA]ADD CONSTRAINT PK_TipoButaca PRIMARY KEY (TButaca_ID)
	ALTER TABLE [COVID_20].[RUTA_AEREA]ADD CONSTRAINT PK_RutaAerea PRIMARY KEY (Ruta_ID)
	ALTER TABLE [COVID_20].[BUTACA]ADD CONSTRAINT PK_Butaca PRIMARY KEY (Butaca_ID)
	ALTER TABLE [COVID_20].[PASAJE]ADD CONSTRAINT PK_Pasaje PRIMARY KEY (Pasaje_ID)
	ALTER TABLE [COVID_20].[CLIENTE]ADD CONSTRAINT PK_Cliente PRIMARY KEY (Cliente_ID)
	ALTER TABLE [COVID_20].[HABITACION]ADD CONSTRAINT PK_Habitacion PRIMARY KEY (Habitacion_ID)
	ALTER TABLE [COVID_20].[TIPO_HABITACION]ADD CONSTRAINT PK_TipoHabitacion PRIMARY KEY (THabitacion_ID)
	ALTER TABLE [COVID_20].[EMPRESA]ADD CONSTRAINT PK_Empresa PRIMARY KEY (Empresa_ID)
COMMIT TRANSACTION
------------------------------------------------------CREAR FK

BEGIN TRANSACTION
	--Ruta AEREA
	ALTER TABLE [COVID_20].[RUTA_AEREA] 
		ADD CONSTRAINT FK_RutaAerea_CiudadOrigen 
		FOREIGN KEY (Ciudad_ID_Origen) REFERENCES COVID_20.CIUDAD(Ciudad_ID)
	ALTER TABLE [COVID_20].[RUTA_AEREA] 
		ADD CONSTRAINT FK_RutaAerea_CiudadDestino
		FOREIGN KEY (Ciudad_ID_Destino) REFERENCES COVID_20.CIUDAD(Ciudad_ID)
	--Butaca
	ALTER TABLE [COVID_20].[BUTACA] 
		ADD CONSTRAINT FK_Butaca_AvionID
		FOREIGN KEY (Avion_ID) REFERENCES COVID_20.AVION(Avion_ID)
	ALTER TABLE [COVID_20].[BUTACA] 
		ADD CONSTRAINT FK_Butaca_TButaca_ID
		FOREIGN KEY (TButaca_ID) REFERENCES COVID_20.TIPO_BUTACA(TButaca_ID)
	--Pasaje
	ALTER TABLE [COVID_20].[PASAJE] 
		ADD CONSTRAINT FK_Pasaje_CompraNumero
		FOREIGN KEY (Compra_NRO) REFERENCES COVID_20.COMPRA(Compra_NRO)
	ALTER TABLE [COVID_20].[PASAJE] 
		ADD CONSTRAINT FK_Pasaje_VueloID
		FOREIGN KEY (Vuelo_ID) REFERENCES COVID_20.VUELO(Vuelo_ID)
	ALTER TABLE [COVID_20].[PASAJE] 
		ADD CONSTRAINT FK_Pasaje_ButacaID
		FOREIGN KEY (Butaca_ID) REFERENCES COVID_20.BUTACA(Butaca_ID)
	--Habitacion
	ALTER TABLE [COVID_20].[HABITACION] 
		ADD CONSTRAINT FK_Habitacion_HotelID
		FOREIGN KEY (Hotel_ID) REFERENCES COVID_20.HOTEL(Hotel_ID)
	ALTER TABLE [COVID_20].[HABITACION] 
		ADD CONSTRAINT FK_Habitacion_ThabitacionID
		FOREIGN KEY (THabitacion_ID) REFERENCES COVID_20.TIPO_HABITACION(THabitacion_ID)
	--Compra
	ALTER TABLE [COVID_20].[COMPRA] 
		ADD CONSTRAINT FK_Compra_EmpresaID
		FOREIGN KEY (Empresa_ID) REFERENCES COVID_20.EMPRESA(Empresa_ID)
	--Factura
	ALTER TABLE [COVID_20].[FACTURA] 
		ADD CONSTRAINT FK_Factura_PasajeID 
		FOREIGN KEY (Pasaje_ID) REFERENCES COVID_20.PASAJE(Pasaje_ID)
	ALTER TABLE [COVID_20].[FACTURA] 
		ADD CONSTRAINT FK_Factura_EstadiaID 
		FOREIGN KEY (Estadia_ID) REFERENCES COVID_20.ESTADIA(Estadia_ID)
	ALTER TABLE [COVID_20].[FACTURA] 
		ADD CONSTRAINT FK_Factura_ClienteID 
		FOREIGN KEY (Cliente_ID) REFERENCES COVID_20.CLIENTE(Cliente_ID)
	ALTER TABLE [COVID_20].[FACTURA] 
		ADD CONSTRAINT FK_Factura_SucursalID 
		FOREIGN KEY (Sucursal_ID) REFERENCES COVID_20.SUCURSAL(Sucursal_ID)
	--Estadia
	ALTER TABLE [COVID_20].[ESTADIA] 
		ADD CONSTRAINT FK_Estadia_CompraNumero 
		FOREIGN KEY (Compra_NRO) REFERENCES COVID_20.COMPRA(Compra_NRO)
	ALTER TABLE [COVID_20].[ESTADIA] 
		ADD CONSTRAINT FK_Estadia_HabitacionID  
		FOREIGN KEY (Habitacion_ID) REFERENCES COVID_20.HABITACION(Habitacion_ID)
	ALTER TABLE [COVID_20].[ESTADIA] 
		ADD CONSTRAINT FK_Estadia_HotelID 
		FOREIGN KEY (Hotel_ID) REFERENCES COVID_20.HOTEL(Hotel_ID)
	--Vuelo
	ALTER TABLE [COVID_20].[VUELO] 
		ADD CONSTRAINT FK_Vuelo_RutaID 
		FOREIGN KEY (Ruta_ID) REFERENCES COVID_20.RUTA_AEREA(Ruta_ID)
	ALTER TABLE [COVID_20].[VUELO] 
		ADD CONSTRAINT FK_Vuelo_AvionID 
		FOREIGN KEY (Avion_ID) REFERENCES COVID_20.AVION(Avion_ID)
COMMIT TRANSACTION
 

--------------------------------------------MIGRACIONES


----------------------EMPRESA
--SELECT * FROM COVID_20.EMPRESA
INSERT INTO COVID_20.EMPRESA (Empresa_RS) 
	SELECT DISTINCT EMPRESA_RAZON_SOCIAL 
		FROM gd_esquema.Maestra
----------------------SUCURSAL
--SELECT * FROM COVID_20.SUCURSAL
INSERT INTO COVID_20.SUCURSAL (Sucursal_Direccion, Sucursal_Mail, Sucursal_Telefono)
	SELECT DISTINCT SUCURSAL_DIR, SUCURSAL_MAIL, SUCURSAL_TELEFONO 
		FROM gd_esquema.Maestra
		WHERE SUCURSAL_DIR is not null
----------------------CLIENTE
--SELECT * FROM COVID_20.CLIENTE
INSERT INTO COVID_20.CLIENTE (Cliente_DNI, Cliente_Nombre, Cliente_Apellido, 
							  Cliente_Fecha_Nac, Cliente_Mail, Cliente_Telefono)
	SELECT distinct CLIENTE_DNI, CLIENTE_NOMBRE, CLIENTE_APELLIDO, 
				    CLIENTE_FECHA_NAC, CLIENTE_MAIL, CLIENTE_TELEFONO
		FROM gd_esquema.Maestra
		WHERE CLIENTE_DNI is not null

----------------------COMPRA
----------------------FACTURA

