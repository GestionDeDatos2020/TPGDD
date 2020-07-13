/**
anio , mes, aerolinea , tipo_pasaje , edad , ciudad
aviones
precio_promedio_compra
compra
precio_promedio_venta
cantidad_vendida
ganancia
cantidad_de_vuelos
cuales son las ciudades de origen donde mas se compraron
cuales son las ciudades destinos mas vendidos
cantidad de aviones
p
*/

USE GD1C2020;

/*INSERT INTO Fact_Table_Costos (Anio,Mes,Producto_ID,Proveedor_ID,Sucursal_ID,Precio_Promedio_Compra,Precio_Promedio_Venta,Cantidad_Comprada,Cantidad_Vendida,Ganancia)
*/
SELECT YEAR(Compra_Fecha) as Anio, MONTH(Compra_Fecha)AS Mes,1 as fk_producto , C.Empresa_ID, FAC.Sucursal_ID,
(
    SELECT AVG(Pasaje_Costo)
    FROM COVID_20.COMPRA C1
    JOIN COVID_20.PASAJE P1 ON P1.Compra_NRO = C1.Compra_NRO
    JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P1.Pasaje_ID
    WHERE YEAR(C1.Compra_Fecha) = YEAR(C.Compra_Fecha)
        AND MONTH(C1.Compra_Fecha) = MONTH(C.Compra_Fecha) 
        AND F.Sucursal_ID = FAC.Sucursal_ID 
        AND C1.Empresa_ID = C.Empresa_ID
) AS Precio_Promedio_Compra,
(
    SELECT AVG(F.Factura_Importe)
    FROM COVID_20.COMPRA C1
    JOIN COVID_20.PASAJE P1 ON P1.Compra_NRO = C1.Compra_NRO
    JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P1.Pasaje_ID
    WHERE YEAR(C1.Compra_Fecha) = YEAR(C.Compra_Fecha)
        AND MONTH(C1.Compra_Fecha) = MONTH(C.Compra_Fecha) 
        AND F.Sucursal_ID = FAC.Sucursal_ID 
        AND C1.Empresa_ID = C.Empresa_ID
) AS Precio_Promedio_Venta,
(
    SELECT COUNT(DISTINCT P1.Pasaje_ID)
    FROM COVID_20.COMPRA C1
    JOIN COVID_20.PASAJE P1 ON P1.Compra_NRO = C1.Compra_NRO
    JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P1.Pasaje_ID
    WHERE YEAR(C1.Compra_Fecha) = YEAR(C.Compra_Fecha)
        AND MONTH(C1.Compra_Fecha) = MONTH(C.Compra_Fecha) 
        AND F.Sucursal_ID = FAC.Sucursal_ID 
        AND C1.Empresa_ID = C.Empresa_ID
) AS Cantidad_Comprada,
(
    SELECT COUNT(DISTINCT F.Pasaje_ID)
    FROM COVID_20.COMPRA C1
    JOIN COVID_20.PASAJE P1 ON P1.Compra_NRO = C1.Compra_NRO
    JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P1.Pasaje_ID
    WHERE YEAR(C1.Compra_Fecha) = YEAR(C.Compra_Fecha)
        AND MONTH(C1.Compra_Fecha) = MONTH(C.Compra_Fecha) 
        AND F.Sucursal_ID = FAC.Sucursal_ID  
        AND C1.Empresa_ID = C.Empresa_ID
) AS Cantidad_Vendida,
(
    SELECT SUM(F.Factura_Importe)
    FROM COVID_20.COMPRA C1
    JOIN COVID_20.PASAJE P1 ON P1.Compra_NRO = C1.Compra_NRO
    JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P1.Pasaje_ID
    WHERE YEAR(C1.Compra_Fecha) = YEAR(C.Compra_Fecha)
        AND MONTH(C1.Compra_Fecha) = MONTH(C.Compra_Fecha)
        AND F.Sucursal_ID = FAC.Sucursal_ID  
        AND C1.Empresa_ID = C.Empresa_ID
) -(
    SELECT SUM(P1.Pasaje_Costo)
    FROM COVID_20.COMPRA C1
    JOIN COVID_20.PASAJE P1 ON P1.Compra_NRO = C1.Compra_NRO
    JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P1.Pasaje_ID
    WHERE YEAR(C1.Compra_Fecha) = YEAR(C.Compra_Fecha)
        AND MONTH(C1.Compra_Fecha) = MONTH(C.Compra_Fecha) 
        AND F.Sucursal_ID = FAC.Sucursal_ID    
        AND C1.Empresa_ID = C.Empresa_ID 
)  as Ganancia
FROM COVID_20.COMPRA C
JOIN COVID_20.EMPRESA EM ON EM.Empresa_ID = C.Empresa_ID
JOIN COVID_20.PASAJE P ON P.Compra_NRO = C.Compra_NRO
JOIN COVID_20.FACTURA FAC ON FAC.Pasaje_ID = P.Pasaje_ID

GROUP BY YEAR(Compra_Fecha)  , MONTH(Compra_Fecha),C.Empresa_ID, FAC.Sucursal_ID
ORDER BY 1, 2;
