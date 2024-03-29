ALTER VIEW  MVA_ALBUMPRODUTO_V4 AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	03/04/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
select CODIGO_ALBUM		  album_ALPRO,
	   CODIGO_PRODUTO	  produto_ALPRO,
	   DATA_ATUALIZACAO	  dataalter,
	   EXCLUIDO		      excluido_ALPRO,
	   prod.USUARIO	   
 from DB_ALBUM_PRODUTO, DB_PRODUTO_USUARIO prod
where CODIGO_PRODUTO = prod.PRODUTO
