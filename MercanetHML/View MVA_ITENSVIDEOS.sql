---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   31/01/2014  tiago           incluido replace
-- 1.0002   31/03/2015  tiago           incluido campo data alteracao
-- 1.0003   19/05/2015  tiago           incluido campo link
-- 1.004    21/05/2015  tiago           incluido campo texto link
-- 1.005    21/09/2015  tiago           incluido campo tipoLink
-- 1.0006   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ITENSVIDEOS AS
SELECT DB_ITV_PRODUTO	  PRODUTO_ITVID,
	   DB_ITV_CATALOGO	  CATALOGO_ITVID,
	   DB_ITV_SEQUENCIA	  SEQUENCIA_ITVID,
	   replace(replace(replace(replace(DB_ITV_VIDEO, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')   VIDEO_ITVID,
	   DB_ITV_IDIOMA	  IDIOMA_ITVID,
	   DB_ITV_TITULO	  TITULO_ITVID,
	   DB_ITV_LEGENDA	  LEGENDA_ITVID,
	   DB_ITV_ULT_ALTER   dataUltimaAtualizacao_ITVID,
	   DB_ITV_LINK        link_ITVID,
	   DB_ITV_TEXTOLINK   textoLink_ITVID,
	   DB_ITV_TIPOLINK    tipoLink_ITVID,
	   I.USUARIO,
	   case when isnull(DB_ITV_ULT_ALTER, 0) > i.DATAALTER then DB_ITV_ULT_ALTER else i.DATAALTER end DATAALTER
  FROM DB_ITEM_VIDEO, MVA_ITENSCATALOGO I
 WHERE I.PRODUTO_ITCAT = DB_ITV_PRODUTO
