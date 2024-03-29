---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/08/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_FAIXASITENS AS
SELECT CODIGO_FAIXA     codigoFaixa_FAII,
       SEQUENCIA        sequencia_FAII,
	   VALOR_INICIAL    valorInicial_FAII,
	   VALOR_FINAL      valorFinal_FAII,
	   CONCEITO         conceito_FAII,
	   COR              cor_FAII
  FROM DB_FAIXA_ITENS, mva_faixas
 where mva_faixas.CODIGO_FAI = CODIGO_FAIXA
