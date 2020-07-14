CREATE TABLE [COVID_20].[Fact_Table_Productos](
	Dim_Tiempo_Anio numeric(4) NOT NULL,
	Dim_Tiempo_Mes numeric(2) NOT NULL,
	Dim_Producto_ID int NOT NULL,
	Dim_Proveedor_ID int NOT NULL,
	Dim_Sucursal_ID int NOT NULL,
	Fact_Precio_Promedio_Compra numeric(10,2),
	Fact_Precio_Promedio_Venta numeric(10,2),
	Fact_Cantidad_Vendida int,
	Fact_Ganancia numeric(10,2),
)








CREATE TABLE  [COVID_20].[Hecho_pasaje] (
	Dim_Tiempo_Anio numeric(4) NOT NULL,
	Dim_Tiempo_Mes numeric(2) NOT NULL,
	Dim_Clie_Edad int NOT NULL,
	Dim_Sucursal_ID int NOT NULL,
	Dim_Tipo_Pasaje_ID int NOT NULL,
	Dim_Ciudad_ID int NOT NULL,
	Fact_Monto_Venta numeric(10,2),
)





CREATE TABLE [COVID_20].[Dimension_Tiempo](
	Tiempo_Anio numeric(4) NOT NULL,
	Tiempo_Mes numeric(2) NOT NULL
)


CREATE TABLE [COVID_20].[Dimension_Clientes_Pasaje](
	Clie_Edad int NOT NULL,
	Clie_Cantidad bigint
)

CREATE TABLE [COVID_20].[Dimension_Tipo_Butaca](
	TButaca_ID int NOT NULL,
	TButaca_Cantidad bigint,
)
CREATE TABLE [COVID_20].[Dimension_Empresa_Pasajes](
	Empresa_ID int Not Null,
	Empresa_Cantdad bigint
)

Create Table [COVID_20].[Dimension_Sucursal_Pasajes](
	Sucursal_ID int  NOT NULL,
	Sucursal_Cantidad bigint,
)

 CREATE TABLE [COVID_20].[Dimension_Ciudad] (
  Ciudad_ID  int not null,
  Ciudad_Cantidad bigint
    
)
---------------------------------------------------- PK
ALTER TABLE [COVID_20].[Fact_Table_Productos]
	ADD CONSTRAINT PK_BI_Hecho_pasaje PRIMARY KEY (Dim_Tiempo_Anio,Dim_Tiempo_Mes,Dim_Producto_ID,Dim_Proveedor_ID, Dim_Sucursal_ID)


ALTER TABLE [COVID_20].[Hecho_pasaje]
	ADD CONSTRAINT PK_BI_Hecho_pasaje PRIMARY KEY (Dim_Tiempo_Anio,Dim_Tiempo_Mes,Dim_Clie_Edad, Dim_Sucursal_ID, Dim_Tipo_Pasaje_ID,Dim_Ciudad_ID)

----------------------------------------------------------------------- PK
ALTER TABLE [COVID_20].[Dimension_Clientes_Pasaje]
	ADD CONSTRAINT PK_BI_Clientes_Pasaje PRIMARY KEY (Clie_Edad)

ALTER TABLE [COVID_20].[Dimension_Tipo_Butaca]
	ADD CONSTRAINT PK_BI_Tipo_Butaca PRIMARY KEY (TButaca_ID)

ALTER TABLE [COVID_20].[Dimension_Empresa_Pasajes]
	ADD CONSTRAINT PK_BI_Empresa PRIMARY KEY (Empresa_ID)

ALTER TABLE [COVID_20].[Dimension_Sucursal_Pasajes]
	ADD CONSTRAINT PK_BI_Sucursal PRIMARY KEY (Sucursal_ID)


ALTER TABLE [COVID_20].[Dimension_Ciudad]
	ADD CONSTRAINT PK_BI_Ciudad PRIMARY KEY (Ciudad_Nombre)


------------------------------------------------------CREACION DE LAS CLAVES FORANEAS (FK)

ALTER TABLE [COVID_20].[Hecho_pasaje] 
	ADD CONSTRAINT FK_BI_Dimension_Tiempo_Anio
	FOREIGN KEY (Dim_Tiempo_Anio,Dim_Tiempo_Mes) REFERENCES Covid_20.Dimension_Tiempo(Tiempo_Anio,Tiempo_Mes)

ALTER TABLE [COVID_20].[Hecho_pasaje] 
	ADD CONSTRAINT FK_BI_Cliente_Pasaje
	FOREIGN KEY (Dim_Clie_Edad) REFERENCES Covid_20.Dimension_Clientes_Pasaje(Clie_Edad)

ALTER TABLE [COVID_20].[Hecho_pasaje] 
	ADD CONSTRAINT FK_BI_Sucursal
	FOREIGN KEY (Dim_Sucursal_ID) REFERENCES Covid_20.Dimension_Sucursal_Pasajes(Sucursal_ID)

ALTER TABLE [COVID_20].[Hecho_pasaje] 
	ADD CONSTRAINT FK_BI_Tipo_Pasaje
	FOREIGN KEY (Dim_Tipo_Pasaje_ID) REFERENCES Covid_20.Dimension_Tipo_Butaca(TButaca_ID)


ALTER TABLE [COVID_20].[Hecho_pasaje] 
	ADD CONSTRAINT FK_BI_Ciudad
	FOREIGN KEY (Dim_Ciudad_ID) REFERENCES Covid_20.Dimension_Ciudad(Ciudad_ID)

-----------------------------

ALTER TABLE [COVID_20].[Fact_Table_Productos] 
	ADD CONSTRAINT FK_BI_Dimension_Tiempo_Anio
	FOREIGN KEY (Dim_Tiempo_Anio,Dim_Tiempo_Mes) REFERENCES Covid_20.Dimension_Tiempo(Tiempo_Anio,Tiempo_Mes)

ALTER TABLE [COVID_20].[Fact_Table_Productos] 
	ADD CONSTRAINT FK_BI_Cliente_Pasaje
	FOREIGN KEY (Dim_Proveedor_ID) REFERENCES Covid_20.Dimension_Empresa_Pasajes(Empresa_ID)

ALTER TABLE [COVID_20].[Hecho_pasaje] 
	ADD CONSTRAINT FK_BI_Sucursal
	FOREIGN KEY (Dim_Sucursal_ID) REFERENCES Covid_20.Dimension_Sucursal_Pasajes(Sucursal_ID)



---------------------- MIGRACIOS DE DATOS DESDE EL MODELO OLTP ---------------------


INSERT INTO COVID_20.Fact_Table_Productos (Dim_Tiempo_Anio,Dim_Tiempo_Mes,Dim_Producto_ID,Dim_Proveedor_ID,Dim_Sucursal_ID,Fact_Precio_Promedio_Compra,Fact_Precio_Promedio_Venta,Fact_Cantidad_Vendida,Fact_Ganancia)
SELECT YEAR(Compra_Fecha) as Anio, MONTH(Compra_Fecha)AS Mes,1 as fk_producto , C.Empresa_ID,F.Sucursal_ID,
AVG(Pasaje_Costo) Precio_Promedio_Compra,  AVG(Factura_Importe) Precio_Promedio_Venta,
COUNT(DISTINCT F.Pasaje_ID) as Cantidad_Vendida,
(
    SELECT SUM(F.Factura_Importe)
    FROM COVID_20.COMPRA C1
    JOIN COVID_20.PASAJE P1 ON P1.Compra_NRO = C1.Compra_NRO
    JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P1.Pasaje_ID
    WHERE YEAR(C1.Compra_Fecha) = YEAR(C.Compra_Fecha)
        AND MONTH(C1.Compra_Fecha) = MONTH(C.Compra_Fecha)
        AND C1.Empresa_ID = C.Empresa_ID
) -(
    SELECT SUM(P1.Pasaje_Costo)
    FROM COVID_20.COMPRA C1
    JOIN COVID_20.PASAJE P1 ON P1.Compra_NRO = C1.Compra_NRO
    JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P1.Pasaje_ID
    WHERE YEAR(C1.Compra_Fecha) = YEAR(C.Compra_Fecha)
        AND MONTH(C1.Compra_Fecha) = MONTH(C.Compra_Fecha) 
        AND C1.Empresa_ID = C.Empresa_ID 
)  as Ganancia
FROM COVID_20.COMPRA C
JOIN COVID_20.EMPRESA EM ON EM.Empresa_ID = C.Empresa_ID
JOIN COVID_20.PASAJE P ON P.Compra_NRO = C.Compra_NRO
JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P.Pasaje_ID
GROUP BY YEAR(Compra_Fecha)  , MONTH(Compra_Fecha),C.Empresa_ID, F.Sucursal_ID
ORDER BY 1, 2

INSERT INTO COVID_20.Hecho_pasaje(Dim_Tiempo_Anio, Dim_Tiempo_Mes, Dim_Clie_Edad, Dim_Sucursal_ID,Dim_Tipo_Pasaje_ID, Dim_Ciudad_ID,Fact_Monto_Venta )
SELECT YEAR(Factura_Fecha) Anio  , MONTH(Factura_Fecha) Mes,
DATEDIFF ( YEAR ,CL.Cliente_Fecha_Nac, GETDATE()  )  Edad,
S.Sucursal_ID, B.TButaca_ID Tipo_Pasaje_ID ,  
 RA.Ruta_Ciudad_Destino AS Ciudad_ID ,
 SUM(F.Factura_Importe) Monto_Venta
FROM COVID_20.FACTURA F
JOIN COVID_20.SUCURSAL S ON S.Sucursal_ID = F.Sucursal_ID
JOIN COVID_20.PASAJE P ON P.Pasaje_ID =  F.Pasaje_ID  
JOIN COVID_20.CLIENTE CL ON CL.Cliente_ID = F.Cliente_ID
JOIN COVID_20.VUELO v ON v.Vuelo_ID = p.Vuelo_ID
JOIN COVID_20.AVION A ON A.Avion_ID = V.Avion_ID
JOIN COVID_20.BUTACA B ON B.Butaca_ID = P.Butaca_ID AND B.Avion_ID = A.Avion_ID
JOIN COVID_20.RUTA_AEREA RA ON RA.Ruta_ID = V.Ruta_ID
GROUP BY YEAR(Factura_Fecha)  , MONTH(Factura_Fecha), 
(DATEDIFF ( YEAR ,CL.Cliente_Fecha_Nac, GETDATE()  )  ),S.Sucursal_ID, B.TButaca_ID , RA.Ruta_Ciudad_Destino 
ORDER BY 1, 2




INSERT INTO COVID_20.Dimension_Ciudad(Ciudad_ID, Ciudad_Cantidad)
Select Ciudad_ID, count(*)
FROM COVID_20.CIUDAD c
	JOIN COVID_20.RUTA_AEREA r ON r.Ruta_Ciudad_Destino = c.Ciudad_ID
	JOIN COVID_20.VUELO v ON v.Ruta_ID = r.Ruta_ID
	JOIN COVID_20.PASAJE p ON p.Vuelo_ID = v.Vuelo_ID
	JOIN COVID_20.FACTURA f on f.Pasaje_ID = p.Pasaje_ID
group by Ciudad_Nombre


INSERT INTO COVID_20.Dimension_Clientes_Pasaje(Clie_Edad,Clie_Cantidad)
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
WHERE Estadia_ID IS NULL
group by DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE())-
	(CASE   
		WHEN DATEADD(YY,DATEDIFF(YEAR,c.Cliente_Fecha_Nac,GETDATE()),
			c.Cliente_Fecha_Nac)>GETDATE() 
		THEN  1  ELSE   0  END)
Order by 1 DESC

INSERT INTO COVID_20.Dimension_Empresa_Pasajes(Empresa_ID,Empresa_Cantdad)
Select e.Empresa_ID, count(*)
FROM COVID_20.EMPRESA e
	JOIN COVID_20.COMPRA c ON c.Empresa_ID =e.Empresa_ID
	JOIN COVID_20.PASAJE p ON p.Compra_NRO = c.Compra_NRO
	JOIN COVID_20.FACTURA f ON f.Pasaje_ID = p.Pasaje_ID
group by e.Empresa_ID

INSERT INTO COVID_20.Dimension_Sucursal_Pasajes(Sucursal_ID,Sucursal_Cantidad)
Select s.Sucursal_ID, count(*)
FROM COVID_20.SUCURSAL s
	JOIN COVID_20.FACTURA f ON f.Sucursal_ID =s.Sucursal_ID
group by s.Sucursal_ID


INSERT INTO COVID_20.Dimension_Tipo_Butaca (TButaca_ID,TButaca_Cantidad)
SELECT tb.TButaca_ID, count(*)
FROM COVID_20.TIPO_BUTACA tb
	JOIN COVID_20.BUTACA b ON b.TButaca_ID = tb.TButaca_ID
	JOIN COVID_20.PASAJE p ON p.Butaca_ID = b.Butaca_ID
	JOIN COVID_20.FACTURA f ON f.Pasaje_ID = p.Pasaje_ID
Group by tb.TButaca_ID
