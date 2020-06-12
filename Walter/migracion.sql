
USE GD1C2020;
-- TIPO_BUTACA
INSERT INTO COVID_20.TIPO_BUTACA (TButaca_Descripcion)
SELECT DISTINCT BUTACA_TIPO
FROM gd_esquema.Maestra 
WHERE BUTACA_NUMERO  IS NOT NULL ;

-- AVION
INSERT INTO COVID_20.AVION (Avion_ID,Avion_Modelo)
SELECT DISTINCT AVION_IDENTIFICADOR, AVION_MODELO FROM gd_esquema.Maestra
WHERE AVION_IDENTIFICADOR IS NOT NULL ;

-- BUTACA
INSERT INTO COVID_20.BUTACA (Butaca_NRO,Avion_ID,TButaca_ID)
SELECT DISTINCT BUTACA_NUMERO, Avion_Id,  TButaca_ID 
FROM  gd_esquema.Maestra 
join COVID_20.TIPO_BUTACA on TButaca_Descripcion = BUTACA_TIPO
JOIN COVID_20.AVION ON Avion_ID = AVION_IDENTIFICADOR 


-- CIUDAD
INSERT INTO COVID_20.CIUDAD (Ciudad_Nombre)
SELECT M1.RUTA_AEREA_CIU_ORIG AS CIUDAD
FROM gd_esquema.Maestra M1, gd_esquema.Maestra M2
WHERE  M1.RUTA_AEREA_CIU_DEST is not null and M1.RUTA_AEREA_CIU_DEST != M2.RUTA_AEREA_CIU_ORIG
UNION
SELECT M2.RUTA_AEREA_CIU_DEST AS CIUDAD
FROM gd_esquema.Maestra M1, gd_esquema.Maestra M2
WHERE M2.RUTA_AEREA_CIU_DEST is not null and M2.RUTA_AEREA_CIU_DEST != M1.RUTA_AEREA_CIU_ORIG;

-- RUTA AEREA
INSERT INTO COVID_20.RUTA_AEREA (Ruta_Codigo,Ruta_Ciudad_Origen,Ruta_Ciudad_Destino)
SELECT DISTINCT RUTA_AEREA_CODIGO, C1.Ciudad_ID as origen , C2.Ciudad_ID as destino
FROM gd_esquema.Maestra
JOIN COVID_20.CIUDAD C1 ON C1.Ciudad_Nombre = RUTA_AEREA_CIU_ORIG
JOIN COVID_20.CIUDAD C2 ON C2.Ciudad_Nombre = RUTA_AEREA_CIU_DEST

-- VUELO
INSERT INTO COVID_20.VUELO (Vuelo_ID,Avion_ID,Ruta_ID,Vuelo_Fecha_Salida,Vuelo_Fecha_Llegada)
SELECT DISTINCT  VUELO_CODIGO, AVION_IDENTIFICADOR,Ruta_ID,VUELO_FECHA_SALUDA, VUELO_FECHA_LLEGADA
FROM gd_esquema.Maestra
JOIN COVID_20.RUTA_AEREA ON Ruta_Codigo = RUTA_AEREA_CODIGO
JOIN COVID_20.CIUDAD C1 ON C1.Ciudad_ID = Ruta_Ciudad_Origen
                AND C1.Ciudad_Nombre = RUTA_AEREA_CIU_ORIG
JOIN COVID_20.CIUDAD C2 ON C2.Ciudad_ID = Ruta_Ciudad_Destino 
                AND C2.Ciudad_Nombre = RUTA_AEREA_CIU_DEST

-- PASAJE
INSERT INTO COVID_20.PASAJE (Pasaje_ID, Vuelo_ID, Butaca_ID, Compra_NRO, Pasaje_Costo)
SELECT DISTINCT PASAJE_CODIGO, VUELO_CODIGO, Butaca_id, COMPRA_NUMERO,PASAJE_COSTO
FROM gd_esquema.Maestra
JOIN COVID_20.TIPO_BUTACA ON TButaca_Descripcion = BUTACA_TIPO
JOIN COVID_20.BUTACA ON  Butaca_NRO = BUTACA_NUMERO
            AND Avion_ID = AVION_IDENTIFICADOR
            AND BUTACA.TButaca_ID  = TIPO_BUTACA.TButaca_ID

--


