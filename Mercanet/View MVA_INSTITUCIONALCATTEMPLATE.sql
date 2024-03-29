---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   31/01/2014  tiago           incluido replace
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_INSTITUCIONALCATTEMPLATE AS
 SELECT DB_INSTCT_SEQUENCIA	  SEQUENCIA_INSTE,
		DB_INSTCT_CHAVE	      CHAVE_INSTE,		     
		replace(replace(replace(replace(DB_INSTCT_VALOR, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M') VALOR_INSTE,
		DB_INSTCT_CODIGO	  CODIGO_INSTE,
		I.USUARIO,
		I.DATAALTER
   FROM DB_INST_CAT_TMPL, MVA_INSTITUCIONALCATALOGO I
  WHERE DB_INSTCT_CODIGO = I.CODIGO_INST
	AND DB_INSTCT_SEQUENCIA = I.SEQUENCIA_INST
