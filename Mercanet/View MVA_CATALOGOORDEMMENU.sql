ALTER VIEW MVA_CATALOGOORDEMMENU AS
select catalogo   catalogo_CORM,
       ordem      ordem_CORM,
	   MVA_CATALOGOS.USUARIO
  from db_cat_menuordem,
       MVA_CATALOGOS
 where db_cat_menuordem.catalogo = MVA_CATALOGOS.CODIGO_CAT
