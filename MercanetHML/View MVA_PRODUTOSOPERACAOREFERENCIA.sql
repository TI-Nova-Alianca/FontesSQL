---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRODUTOSOPERACAOREFERENCIA  AS
SELECT DB_TBOPSR_OPER_REF   CODIGOOPERACAO_PROPR,
	   DB_TBOPSR_SEQ        SEQUENCIA_PROPR,
	   DB_TBOPSR_PRODUTO    PRODUTO_PROPR,
	   USU.USUARIO
  FROM DB_TB_OPERS_REFER,
       DB_USUARIO     USU
