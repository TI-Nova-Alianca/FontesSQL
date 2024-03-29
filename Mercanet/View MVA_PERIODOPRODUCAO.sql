---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	28/01/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PERIODOPRODUCAO AS
 SELECT DB_PER_TIPO			TIPO_PERPROD,
		DB_PER_ANO			ANO_PERPROD,
		DB_PER_NRO			NUMERO_PERPROD,
		cast(DB_PER_DT_INICIO as date)	DATAINICIO_PERPROD,
		cast(DB_PER_DT_TERMINO as date)	DATAFIM_PERPROD,
		cast(DB_PER_DT_LIMITE as date)	DATALIMITE_PERPROD
   FROM DB_PERIODO
  WHERE cast(DB_PER_DT_TERMINO as date) >= cast(GETDATE() as date)
