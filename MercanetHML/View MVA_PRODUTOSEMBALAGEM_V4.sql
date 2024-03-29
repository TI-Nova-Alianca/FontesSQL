---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	31/01/2014	TIAGO PRADELLA	CRIACAO
-- 1.0001   02/07/2014  tiago           incluido campo cubagem
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRODUTOSEMBALAGEM_V4 AS
SELECT DB_PRDEMB_PRODUTO	PRODUTO_PREMB ,
	   DB_PRDEMB_CODEMB	    EMBALAGEM_PREMB, 
	   DB_PRDEMB_QTDEEMB	QUANTIDADE_PREMB, 
	   DB_PRDEMB_CODBARRA	EAN_PREMB ,
	   DB_PRDEMB_PADRAO	    PADRAO_PREMB, 
	   DB_PRDEMB_DIMENSOES	DIMENSOES_PREMB, 
	   DB_PRDEMB_PESO	    PESO_PREMB,
	   DB_PRDEMB_CUBAGEM    CUBAGEM_PREMB,
	   P.USUARIO
  FROM DB_PRODUTO_EMBAL, DB_PRODUTO_USUARIO P
 WHERE P.PRODUTO = DB_PRDEMB_PRODUTO
