---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/01/2014  tiago           incluido campo de ordem
-- 1.0002   30/11/2015  tiago           incluido campo especificoIdioma_AJUD e idiomas_AJUD
-- 1.0003   24/02/2016  TIAGO           INCLUIDO CAMPO DATAALTER
-- 1.0004   24/03/2106  tiago           ajustes para nao duplicar registros
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_AJUDACATALOGO AS
SELECT DB_AJU_SEQUENCIA	   SEQUENCIA_AJUD,
	   max(DB_AJU_TEMPLATE)	   TEMPLATE_AJUD,
	   DB_AJU_CODIGO	   CODIGO_AJUD,
	   max(DB_AJU_DESCRICAO)	   DESCRICAO_AJUD,
	   max(DB_AJU_ORDEM)        ORDEM_AJUD,
	   max(DB_AJU_ESPECIDIOMA)  especificoIdioma_AJUD,
       max(DB_AJU_IDIOMAS)      idiomas_AJUD,
	   C.USUARIO,
	   max(case when isnull(DB_AJU_ULT_ALTER, 0) > isnull(p.DATA_PERMC, 0) then DB_AJU_ULT_ALTER else p.DATA_PERMC end) DATAALTER
  FROM DB_AJUDA_CATALOGO, MVA_CATALOGOS C, MVA_PERMISSOESCATALOGO p
 WHERE C.AJUDA_CAT  = DB_AJU_CODIGO
   and p.CATALOGO_PERMC = c.CODIGO_CAT
   and p.USUARIO = c.USUARIO
   group by DB_AJU_CODIGO, DB_AJU_SEQUENCIA, c.usuario
