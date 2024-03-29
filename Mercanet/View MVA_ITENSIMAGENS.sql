---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/01/2014  tiago           incluido replace
-- 1.0002   31/03/2015  tiago           incluido campo data ultima alteracao
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ITENSIMAGENS AS
SELECT DB_ITIMG_PRODUTO	       PRODUTO_ITIMG,
	   DB_ITIMG_CATALOGO	   CATALOGO_ITIMG,
	   DB_ITIMG_SEQUENCIA	   SEQUENCIA_ITIMG,
	   replace(replace(replace(replace(DB_ITIMG_IMAGEM, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M') IMAGEM_ITIMG,
	   DB_ITIMG_IDIOMA	       IDIOMA_ITIMG,
	   DB_ITIMG_COMPARTILHADA  COMPARTILHADA_ITIMG,
	   DB_ITIMG_ULT_ALTER      dataUltimaAtualizacao_ITIMG,
	   I.USUARIO,
	   case when isnull(DB_ITIMG_ULT_ALTER, 0) > i.DATAALTER then  DB_ITIMG_ULT_ALTER else i.DATAALTER end  DATAALTER
  FROM DB_ITEM_IMAGEM, MVA_ITENSCATALOGO I
 WHERE I.PRODUTO_ITCAT = DB_ITIMG_PRODUTO
   AND I.CATALOGO_ITCAT = DB_ITIMG_CATALOGO
