---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	14/05/2015	TIAGO PRADELLA	CRIACAO
-- 1.0002   29/10/2015  tiago           reduzido numero do rownum no select temporario, e colocado na funcao with
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTECONFIGROTAS AS
 SELECT DB_CLIR_CLIENTE     CLIENTE_CCROTA,
		DB_CLIR_EMPRESA     EMPRESA_CCROTA,
		DB_CLIR_REPRES      REPRESENTANTE_CCROTA,
		DB_CLIR_ROTA        ROTA_CCROTA,
		DB_CLIR_DATA_ALTER  DATAALTER,
		R.USUARIO
   FROM DB_CLIENTE_REPRES, MVA_REPRESENTANTES R
  WHERE DB_CLIR_REPRES  = R.CODIGO_REPRES   
    and isnull(DB_CLIR_ROTA, '') <> ''
