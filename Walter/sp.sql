USE GD1C2020;
CREATE PROCEDURE proc_tipo_butaca
AS

        INSERT INTO COVID_20.TIPO_BUTACA (TButaca_Descripcion)
        SELECT DISTINCT BUTACA_TIPO
        FROM gd_esquema.Maestra 
        WHERE BUTACA_NUMERO  IS NOT NULL ;
GO
