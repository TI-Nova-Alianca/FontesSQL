---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SHOPPINGPOSICOES  AS
SELECT DB_TBPSH_CODIGO    CODIGO_SHOPO,
       DB_TBPSH_DESCR     DESCRICAO_SHOPO
  FROM DB_TB_POSSHOP
