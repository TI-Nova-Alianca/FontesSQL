---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONCORRENTES AS
SELECT DB_TBCON_CODIGO   CODIGO_CONC,
       DB_TBCON_DESCR    DESCRICAO_CONC
  FROM DB_TB_CONCORRENTE
