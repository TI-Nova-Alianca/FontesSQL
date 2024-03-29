---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	18/10/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRAZOS AS
SELECT CODIGO			CODIGO_PRAZO,
	   DIAS_PRAZO		DIAS_PRAZO,
	   DESCRICAO_PRAZO	DESCRICAO_PRAZO,
	   VALOR_MINIMO		valorMinimo_PRAZO,
	   PEDIDO_MINIMO	pedidoMinimo_PRAZO
  FROM DB_PRAZOS
 WHERE CODIGO in (select CODIGOPRAZO_RPPP from MVA_REGRAS_PR_PRA_PERM)
