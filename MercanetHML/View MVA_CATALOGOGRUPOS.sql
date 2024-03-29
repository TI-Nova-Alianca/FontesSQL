---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	30/03/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOGRUPOS AS
 select distinct CODIGO	    codigo_CATGR,
		DESCRICAO	descricao_CATGR,
		replace(replace(replace(IMAGEM, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/')    imagem_CATGR,
		ORDEM	    ordem_CATGR,
		usuario
   from DB_CAT_GRUPOS, MVA_CATALOGOS
  where CODIGO = grupo_CAT
