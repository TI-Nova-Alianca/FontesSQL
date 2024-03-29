---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   08/11/2012  TIAGO PRADELLA  INCLUIDO DATA DE ALTERACAO
-- 1.0003   06/12/2013  tiago           incluido campo do codigo do repres
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTECONFIGTIPOSPRODUTOS  AS
SELECT DB_CLIR_CLIENTE    CLIENTE_CCTPR    ,
       DB_CLIR_EMPRESA    EMPRESA_CCTPR,
       DB_CLIR_TPPROD     TIPOPRODUTO_CCTPR,
	   DB_CLIR_REPRES     REPRESENTANTE_CCTPR,
	   DB_CLIR_DATA_ALTER DATAALTER,
	   USU.USUARIO
  FROM DB_CLIENTE_REPRES, 
       DB_USUARIO    USU
 WHERE isnull(DB_CLIR_TPPROD, '') <> ''
   AND DB_CLIR_REPRES IN (SELECT CODIGO_REPRES FROM MVA_REPRESENTANTES WHERE MVA_REPRESENTANTES.USUARIO = USU.USUARIO)
