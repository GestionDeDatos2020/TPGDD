/*
Aerolíneas más elegidas
Fact Table Aerolíneas
Dimensiones
Anio
Mes
Aerolínea
Tipo Pasaje
Atributos
Cantidad de aviones
*/
USE GD1C2020;

SELECT YEAR(Compra_Fecha) as Anio, MONTH(Compra_Fecha)AS Mes,1 as fk_producto , C.Empresa_ID, 
AVG(Pasaje_Costo) Precio_Promedio_Compra,  
(
    SELECT AVG(Factura_Importe)
    FROM COVID_20.COMPRA C1
    JOIN COVID_20.PASAJE P1 ON P1.Compra_NRO = C1.Compra_NRO
    JOIN COVID_20.FACTURA F1 ON F1.Pasaje_ID = P1.Pasaje_ID
    WHERE YEAR(C1.Compra_Fecha) = YEAR(C.Compra_Fecha)
        AND MONTH(C1.Compra_Fecha) = MONTH(C.Compra_Fecha) 
        AND C1.Empresa_ID = C.Empresa_ID
) as Precio_Promedio_venta,
COUNT(DISTINCT P.Pasaje_ID) Cantidad_Comprada,
(
    SELECT COUNT(DISTINCT F1.Pasaje_ID)
    FROM COVID_20.COMPRA C1
    JOIN COVID_20.PASAJE P1 ON P1.Compra_NRO = C1.Compra_NRO
    JOIN COVID_20.FACTURA F1 ON F1.Pasaje_ID = P1.Pasaje_ID
    WHERE YEAR(C1.Compra_Fecha) = YEAR(C.Compra_Fecha)
        AND MONTH(C1.Compra_Fecha) = MONTH(C.Compra_Fecha) 
        AND C1.Empresa_ID = C.Empresa_ID
) as Cantidad_Vendida,
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
GROUP BY YEAR(Compra_Fecha)  , MONTH(Compra_Fecha),C.Empresa_ID
ORDER BY 1, 2;
