---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   02/09/2014	TIAGO PRADELLA	   CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRESTACAOCONTASESTOQUE  AS
SELECT 	DB_PCE_NRO			PRESTACAOCONTA_PCITEM,
		DB_PCE_PRODUTO		PRODUTO_PCITEM,
		DB_PCE_QTD_TOTAL	QUANTIDADETOTAL_PCITEM,
		DB_PCE_QTD_COMPLEM	QUANTIDADECOMPLEMENTAR_PCITEM,
		P.USUARIO
   FROM DB_PREST_ESTOQUE, MVA_PRESTACAOCONTAS P
  WHERE P.NUMERO_PCONTA = DB_PCE_NRO
