ALTER VIEW MVA_PRODUTOSIMAGENS AS
----------------------------------------------------------------------------------------------------------------  
--  VERSAO  DATA        AUTOR       ALTERACAO
--  1.0001  12/05/2014  TIAGO       DESENVOLVIMENTO
----------------------------------------------------------------------------------------------------------------
SELECT CODIGO_PRODUTO   PRODUTO_PRIMG,
       ID_IMAGEM        IMAGEM_PRIMG,       
       DATA_ALTER       DATAALTER,
       P.USUARIO        USUARIO
  FROM DB_PRODUTO_IMAGEM, DB_PRODUTO_USUARIO P
 WHERE CODIGO_PRODUTO = P.PRODUTO
   AND SITUACAO = 'A'
