---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   31/01/2014  tiago           incluido replace
-- 1.0003   20/03/2014  tiago           renomeado o campo codigo
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_AJUDACATTRADUCAO AS
 SELECT 
		DB_AJUT_CODIGO	     CODIGO_AJUTRA,
		DB_AJUT_SEQUENCIA	 SEQUENCIA_AJUTRA,
		DB_AJUT_CHAVE	     CHAVE_AJUTRA,
		DB_AJUT_IDIOMA	     IDIOMA_AJUTRA,
		replace(replace(replace(replace(DB_AJUT_TRADUCAO, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M') TRADUCAO_AJUTRA,
		A.USUARIO,
		a.dataalter
   FROM DB_AJUDA_TRADUCAO, MVA_AJUDACATALOGO A
  WHERE A.CODIGO_AJUD =  DB_AJUT_CODIGO
    AND A.SEQUENCIA_AJUD = DB_AJUT_SEQUENCIA
