---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW  MVA_GRUPOSMARGEMOBJETIVOS AS
SELECT DB_TBGOM_CODIGO	CODIGO_GRMOBJ,
       DB_TBGOM_DESCR	DESCRICAO_GRMOBJ
  FROM DB_TB_GRPOBJMRG
