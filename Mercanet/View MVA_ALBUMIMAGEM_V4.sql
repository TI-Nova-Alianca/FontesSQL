ALTER VIEW  MVA_ALBUMIMAGEM_V4 AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	03/04/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
select a.CODIGO_ALBUM		  album_ALIMG,
	   a.ORDEM			      ordem_ALIMG,
	   a.LEGENDA			  legenda_ALIMG,
	   a.DATA_ATUALIZACAO	  dataalter,
	   a.EXCLUIDO		      excluido_ALIMG,
	   a.DATA_ATUALIZACAO     dataImagem_ALIMG,
	   MVA_ALBUM_V4.usuario
  from DB_ALBUM_IMAGEM a, MVA_ALBUM_V4
 where a.CODIGO_ALBUM = MVA_ALBUM_V4.codigo_ALBUM
