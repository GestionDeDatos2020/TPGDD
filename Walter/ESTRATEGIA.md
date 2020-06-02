
## AVION
* AVION IDENTIFICADOR. Se mantiene la definición en la tabla maestra,  [nvarchar](50), pues entendemos que como máximo puede existir un registro con hasta 50 caracteres.
  
## BUTACA
Identifica el numero de butaca en un determinado avion, distinguiendo el tipo de butaca

* Unicidad. Se crea unicidad para  (Butaca_NRO,Avion_ID,TButaca_ID) . Garantizar uniciad del numero de butaca y tipo de butaca en un avion se crea el constraint de unicidad: 
  
## CIUDAD
* Unicidad del nombre de ciudad 

## RUTA AEREA
* RUTA_AEREA_CODIGO ENO ES UNICO, NO PUEDE SER PK. EL CODIGO 6115377 TIENE  DOS RUTAS DIFERENTES
* Unicidad. Se crea unicidad para (Ruta_Codigo,Ruta_Ciudad_Origen,Ruta_Ciudad_Destino). 
  
## VUELO
* Unicidad. (Vuelo_codigo,avion_identificador,Ruta_aerea)

## PASAJE
Existen pasajes que no se vendieron Pasaje_Fecha_Compra = NULL
* Campos obligatorios Compra_Nro, Vuelo_ID, Butaca_ID, Compra_NRO, Pasaje_costo
