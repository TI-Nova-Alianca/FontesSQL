---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001   22/07/2013  TIAGO           INCLUIDO FILTRO DE USUARIO, TRAZ CIDADES FILTRADA POR ESTADO
-- 1.0002   09/08/2013	TIAGO           INCLUIDO TRIM NO NOME DA CIDADE
-- 1.0003   02/09/2014  TIAGO           INCLUIDO CAMPO ESTADO
-- 1.0004   25/1/2014   tiago           incluido campo codigo
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CIDADES AS
SELECT LTRIM(RTRIM(DB_TBCID_NOME))    NOME_CIDAD,
	   DB_TBCID_ESTADO                ESTADO_CIDAD,
	   DB_TBCID_COD                   CODIGO_CIDAD,
       EST.USUARIO      USUARIO
  FROM DB_TB_CIDADE, MVA_ESTADOS EST
 WHERE DB_TBCID_ESTADO = EST.SIGLA_ESTAD
