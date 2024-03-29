ALTER VIEW MVA_IMAGENS as
-------------------------------------------------------------------------------------------------------------------------------------------------
-- VERSAO  DATA        AUTOR        ALTERACAO
-- 1.0001  12/05/2014  TIAGO        DESENVOLVIMENTO 
-------------------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT 
	   ID               ID_IMG,
	   DESCRICAO        DESCRICAO_IMG,
	   TOOLTIP          TOOLTIP_IMG,
	   DATA_ALTER       DATAALTER,
	   P.USUARIO        USUARIO
  FROM DB_IMAGEM, MVA_PRODUTOSIMAGENS P
 WHERE P.PRODUTO_PRIMG = ID
