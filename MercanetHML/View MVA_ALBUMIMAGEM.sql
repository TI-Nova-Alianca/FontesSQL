ALTER VIEW  MVA_ALBUMIMAGEM AS
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
	   mva_album.usuario
  from DB_ALBUM_IMAGEM a, MVA_ALBUM 
 where a.CODIGO_ALBUM = mva_album.codigo_ALBUM
