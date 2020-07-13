/*Anio-venta
Mes-venta
Edad (puede ser rango)
Tipo de pasaje
Ciudad destino (si da más de un registro)
Aerolinea (ver resultados)
Atributos
Monto_Compra

*/
USE GD1C2020;
SELECT YEAR(Compra_Fecha) Anio  , MONTH(Compra_Fecha) Mes,E.Empresa_ID, B.TButaca_ID ,  DATEDIFF ( YEAR ,Cliente_Fecha_Nac, GETDATE()  )  Edad, RA.Ruta_Ciudad_Destino AS Ciudad_Destino_ID , SUM(F.Factura_Importe) Monto_Compra
FROM COVID_20.COMPRA C
JOIN COVID_20.EMPRESA E ON E.Empresa_ID = C.Empresa_ID
JOIN COVID_20.PASAJE P ON P.Compra_NRO = C.Compra_NRO
JOIN COVID_20.FACTURA F ON F.Pasaje_ID = P.Pasaje_ID
JOIN COVID_20.CLIENTE CL ON CL.Cliente_ID = F.Cliente_ID
JOIN COVID_20.VUELO v ON v.Vuelo_ID = p.Vuelo_ID
JOIN COVID_20.AVION A ON A.Avion_ID = V.Avion_ID
JOIN COVID_20.BUTACA B ON B.Butaca_ID = P.Butaca_ID AND B.Avion_ID = A.Avion_ID
JOIN COVID_20.RUTA_AEREA RA ON RA.Ruta_ID = V.Ruta_ID
GROUP BY YEAR(Compra_Fecha)  , MONTH(Compra_Fecha),E.Empresa_ID, B.TButaca_ID , RA.Ruta_Ciudad_Destino , DATEDIFF ( YEAR ,Cliente_Fecha_Nac, GETDATE()  ) 
ORDER BY 1, 2

/*
select GETDATE(), Cliente_Fecha_Nac, DATEDIFF ( YEAR ,Cliente_Fecha_Nac, GETDATE()  )
from COVID_20.CLIENTE
*/