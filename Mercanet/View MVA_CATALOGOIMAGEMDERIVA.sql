---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	01/08/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOIMAGEMDERIVA AS
select id            id_CIDE,
       descricao     descricao_CIDE,
	   id + '.pngm'  imagem_CIDE,
	   data_alter    dataAlter
  from db_cat_imagem_deriva
