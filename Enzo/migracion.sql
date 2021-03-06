------------------------------------------------ESTADIAS

USE GD1C2020;

-- TIPO_HABITACION
INSERT INTO COVID_20.TIPO_HABITACION (THabitacion_ID,THabitacion_Descripcion)
SELECT DISTINCT TIPO_HABITACION_CODIGO,TIPO_HABITACION_DESC FROM gd_esquema.Maestra
WHERE TIPO_HABITACION_CODIGO IS NOT NULL;

-- HOTEL
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

-- HABITACION
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
	
	
-- ESTADIA
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
	
	
	

