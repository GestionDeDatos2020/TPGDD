USE [GD1C2020]
GO

------------------------------------------------------DROPS
/*	TABLAS

DROP TABLE [COVID_20].[SUCURSAL] 
DROP TABLE [COVID_20].[VUELO] 
DROP TABLE [COVID_20].[AVION] 
DROP TABLE [COVID_20].[CIUDAD] 
DROP TABLE [COVID_20].[ESTADIA] 
DROP TABLE [COVID_20].[FACTURA] 
DROP TABLE [COVID_20].[COMPRA] 
DROP TABLE [COVID_20].[EMPRESA] 
DROP TABLE [COVID_20].[TIPO HABITACION] 
DROP TABLE [COVID_20].[HABITACION] 
DROP TABLE [COVID_20].[CLIENTE] 
DROP TABLE [COVID_20].[PASAJE] 
DROP TABLE [COVID_20].[BUTACA] 
DROP TABLE [COVID_20].[RUTA AEREA] 
DROP TABLE [COVID_20].[TIPO BUTACA] 
DROP TABLE [COVID_20].[HOTEL] 

*/

------------------------------------------------------CREAR SCHEMA
--CREATE SCHEMA [COVID_20]
--GO



------------------------------------------------------CREAR TABLES
CREATE TABLE [COVID_20].[SUCURSAL] (
  [Sucursal_ID] bigint not null,
  [Sucursal_Direccion] varchar(100),
  [Sucursal_Mail] varchar(100),
  [Sucursal_Telefono] int
);


CREATE TABLE [COVID_20].[VUELO] (
  [Vuelo_Codigo] bigint not null,
  [Vuelo_Fecha_Salida] datetime,
  [Vuelo_Fecha_Llegada] datetime,
  [Ruta_Cod] int,
  [Avion_ID] varchar(30)
);


CREATE TABLE [COVID_20].[AVION] (
  [Avion_ID] varchar(30) not null,
  [Avion_Modelo] varchar(30)
);


CREATE TABLE [COVID_20].[CIUDAD] (
  [Ciudad_ID] int not null,
  [Ciudad_Nombre] varchar(50)
);

CREATE TABLE [COVID_20].[ESTADIA] (
  [Estadia_Cod] bigint not null,
  [Estadia_Costo] numeric(10,2),
  [Estadia_Precio] numeric(10,2),
  [Compra_Numero] bigint,
  [Estadia_Inicio] datetime,
  [Estadia_Noches] int,
  [Estadia_Checkin] datetime,
  [Estadia_Checout] datetime,
  [Habitacion_ID] int,
  [Hotel_ID] int
);
 
CREATE TABLE [COVID_20].[FACTURA] (
  [Factura_Numero] bigint not null,
  [Factura_Fecha] datetime,
  [Factura_Importe] numeric(10,2),
  [Pasaje_Cod] bigint,
  [Estadia_Cod] bigint,
  [Cliente_DNI] bigint,
  [Sucursal_Cod] bigint
);


CREATE TABLE [COVID_20].[COMPRA] (
  [Compra_NRO] bigint not null,
  [Compra_Fecha] datetime,
  [Empresa_ID] int
);


CREATE TABLE [COVID_20].[EMPRESA] (
  [Empresa_ID] int not null,
  [Empresa_RS] varchar(50)
);

CREATE TABLE [COVID_20].[TIPO HABITACION] (
  [THabitacion_Cod] int not null,
  [THabitacion_Descripcion] varchar(50)
);

CREATE TABLE [COVID_20].[HABITACION] (
  [Habitacion_ID] int not null,
  [Habitacion_Nro] int,
  [Habitacion_Piso] int,
  [Habitacion_Frente] char(1),
  [Hotel_ID] int,
  [THabitacion_Cod] int
);


CREATE TABLE [COVID_20].[CLIENTE] (
  [Cliente_DNI] bigint not null,
  [Cliente_Nombre] varchar(50),
  [Cliente_Apellido] varchar(50),
  [Cliente_Fecha_Nac] datetime,
  [Cliente_Mail] varchar(100),
  [Cliente_Telefono] int
);

CREATE TABLE [COVID_20].[PASAJE] (
  [Pasaje_Cod] bigint not null,
  [Pasaje_Costo] numeric(10,2),
  [Pasaje_Precio] numeric(10,2),
  [Compra_Numero] bigint,
  [Vuelo_Codigo] bigint,
  [Butaca_ID] int
);


CREATE TABLE [COVID_20].[BUTACA] (
  [Butaca_ID] int not null,
  [Butaca_Nro] int,
  [Vuelo_Codigo] bigint,
  [TButaca_ID] int
);


CREATE TABLE [COVID_20].[RUTA AEREA] (
  [Ruta_Codigo] int not null,
  [Ciudad_ID_Origen] varchar(50),
  [Ciudad_ID_Destino] varchar(50)
);


CREATE TABLE [COVID_20].[TIPO BUTACA] (
  [TButaca_ID] int not null,
  [TButaca_Descripcion] varchar(50)
);

CREATE TABLE [COVID_20].[HOTEL] (
  [Hotel_ID] int not null,
  [Hotel_Calle] varchar(50),
  [Hotel_Nro] int,
  [Hotel_Estrellas] int
);


------------------------------------------------------CREAR PK
BEGIN TRANSACTION
	ALTER TABLE [COVID_20].[SUCURSAL]ADD CONSTRAINT PK_Sucursal PRIMARY KEY (Sucursal_ID)
	ALTER TABLE [COVID_20].[VUELO]ADD CONSTRAINT PK_Vuelo PRIMARY KEY (Vuelo_Codigo)
	ALTER TABLE [COVID_20].[AVION]ADD CONSTRAINT PK_Avion PRIMARY KEY (Avion_ID)
	ALTER TABLE [COVID_20].[CIUDAD]ADD CONSTRAINT PK_Ciudad PRIMARY KEY (Ciudad_ID)
	ALTER TABLE [COVID_20].[ESTADIA]ADD CONSTRAINT PK_Estadia PRIMARY KEY (Estadia_Cod)
	ALTER TABLE [COVID_20].[FACTURA]ADD CONSTRAINT PK_Factura PRIMARY KEY (Factura_Numero)
	ALTER TABLE [COVID_20].[COMPRA]ADD CONSTRAINT PK_Compra PRIMARY KEY (Compra_NRO)
	ALTER TABLE [COVID_20].[HOTEL]ADD CONSTRAINT PK_Hotel PRIMARY KEY (Hotel_ID)
	ALTER TABLE [COVID_20].[TIPO BUTACA]ADD CONSTRAINT PK_TipoButaca PRIMARY KEY (TButaca_ID)
	ALTER TABLE [COVID_20].[RUTA AEREA]ADD CONSTRAINT PK_RutaAerea PRIMARY KEY (Ruta_Codigo)
	ALTER TABLE [COVID_20].[BUTACA]ADD CONSTRAINT PK_Butaca PRIMARY KEY (Butaca_ID)
	ALTER TABLE [COVID_20].[PASAJE]ADD CONSTRAINT PK_Pasaje PRIMARY KEY (Pasaje_Cod)
	ALTER TABLE [COVID_20].[CLIENTE]ADD CONSTRAINT PK_Cliente PRIMARY KEY (Cliente_DNI)
	ALTER TABLE [COVID_20].[HABITACION]ADD CONSTRAINT PK_Habitacion PRIMARY KEY (Habitacion_ID)
	ALTER TABLE [COVID_20].[TIPO HABITACION]ADD CONSTRAINT PK_TipoHabitacion PRIMARY KEY (THabitacion_Cod)
	ALTER TABLE [COVID_20].[EMPRESA]ADD CONSTRAINT PK_Empresa PRIMARY KEY (Empresa_ID)
COMMIT TRANSACTION
------------------------------------------------------CREAR FK
--Ejemplo--ALTER TABLE OrdersADD CONSTRAINT FK_PersonOrderFOREIGN KEY (PersonID) REFERENCES Persons(PersonID)

Ruta aerea 
	[Ciudad_ID_Origen] 
	[Ciudad_ID_Destino]
ALTER TABLE [COVID_20].[RUTA AEREA] ADD CONSTRAINT FK_RutaAerea_
ALTER TABLE [COVID_20].[RUTA AEREA] ADD CONSTRAINT FK_RutaAerea_
Butaca 
	[Vuelo_Codigo] 
	[TButaca_ID] 
ALTER TABLE [COVID_20].[BUTACA] ADD CONSTRAINT FK_Butaca_
ALTER TABLE [COVID_20].[BUTACA] ADD CONSTRAINT FK_Butaca_

Pasaje 
	[Compra_Numero] 
	[Vuelo_Codigo] 
	[Butaca_ID] 
ALTER TABLE [COVID_20].[PASAJE] ADD CONSTRAINT FK_Pasaje_
ALTER TABLE [COVID_20].[PASAJE] ADD CONSTRAINT FK_Pasaje_
ALTER TABLE [COVID_20].[PASAJE] ADD CONSTRAINT FK_Pasaje_
Habitacion 
	[Hotel_ID] 
	[THabitacion_Cod] 
ALTER TABLE [COVID_20].[HABITACION] ADD CONSTRAINT FK_Habitacion_
ALTER TABLE [COVID_20].[HABITACION] ADD CONSTRAINT FK_Habitacion_
Compra 
	[Empresa_ID]
ALTER TABLE [COVID_20].[COMPRA] ADD CONSTRAINT FK_Compra_
Factura 
	[Pasaje_Cod] 
	[Estadia_Cod]
	[Cliente_DNI] 
	[Sucursal_Cod] 
ALTER TABLE [COVID_20].[FACTURA] ADD CONSTRAINT FK_Factura_
ALTER TABLE [COVID_20].[FACTURA] ADD CONSTRAINT FK_Factura_
ALTER TABLE [COVID_20].[FACTURA] ADD CONSTRAINT FK_Factura_
ALTER TABLE [COVID_20].[FACTURA] ADD CONSTRAINT FK_Factura_
Estadia	
	[Compra_Numero] 
	[Habitacion_ID] 
	[Hotel_ID]
ALTER TABLE [COVID_20].[ESTADIA] ADD CONSTRAINT FK_Estadia_
ALTER TABLE [COVID_20].[ESTADIA] ADD CONSTRAINT FK_Estadia_
ALTER TABLE [COVID_20].[ESTADIA] ADD CONSTRAINT FK_Estadia_
vuelo
	[Ruta_Cod] 
	[Avion_ID]
ALTER TABLE [COVID_20].[VUELO] ADD CONSTRAINT FK_Vuelo_
ALTER TABLE [COVID_20].[VUELO] ADD CONSTRAINT FK_Vuelo_

 





 






