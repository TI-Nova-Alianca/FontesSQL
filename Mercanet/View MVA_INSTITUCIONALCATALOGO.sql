---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/01/2014  tiago           incluido campo de ordem
-- 1.0002   30/11/2015  tiago           incluido campos especificoIdioma_INST e idiomas_INST
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
-- 1.0004   24/03/2106  tiago           ajustes para nao duplicar registros
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_INSTITUCIONALCATALOGO AS
    SELECT DB_INST_SEQUENCIA	SEQUENCIA_INST,
		max(DB_INST_TEMPLATE)	TEMPLATE_INST,
		DB_INST_CODIGO	    CODIGO_INST,
		max(DB_INST_DESCRICAO)	DESCRICAO_INST,
		max(DB_INST_ORDEM)       ORDEM_INST,
		max(DB_INST_ESPECIDIOMA) especificoIdioma_INST,
		max(DB_INST_IDIOMAS)     idiomas_INST,
		C.USUARIO,
		max(case when  isnull(DB_INST_ULT_ALTER, 0)  > isnull(p.DATA_PERMC, 0) then  DB_INST_ULT_ALTER else p.DATA_PERMC end)  DATAALTER
   FROM DB_INST_CATALOGO, MVA_CATALOGOS C, MVA_PERMISSOESCATALOGO p
  WHERE C.INSTITUCIONAL_CAT = DB_INST_CODIGO
    and p.USUARIO = c.USUARIO
	and p.CATALOGO_PERMC = c.CODIGO_CAT
  group by DB_INST_CODIGO, DB_INST_SEQUENCIA, C.USUARIO
