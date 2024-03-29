---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   31/01/2014  tiago           incluido replace
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_AJUDACATTEMPLATE AS
 SELECT	DB_AJUCT_SEQUENCIA	  SEQUENCIA_AJUTE,
		DB_AJUCT_CHAVE	      CHAVE_AJUTE,
		replace(replace(replace(replace(DB_AJUCT_VALOR, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M')     VALOR_AJUTE,
		DB_AJUCT_CODIGO	      CODIGO_AJUTE,
		A.USUARIO,
		a.dataalter
   FROM DB_AJUDA_CAT_TMPL, MVA_AJUDACATALOGO A
  WHERE A.CODIGO_AJUD = DB_AJUCT_CODIGO
    AND A.SEQUENCIA_AJUD = DB_AJUCT_SEQUENCIA
