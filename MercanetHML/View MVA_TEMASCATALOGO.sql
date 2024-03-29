---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	29/05/2014	TIAGO PRADELLA	CRIACAO
-- 1.0001   14/07/2014  tiago           incluido distinct
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TEMASCATALOGO AS
SELECT distinct TEMA.DB_TEMA	     TEMA_CAT,
	   TEMA.DB_CHAVE	 CHAVE_CAT,
	   TEMA.DB_VALOR	 VALOR_CAT,
	   DB_TIPO	         TIPO_CAT,
	   USUARIO
  FROM DB_SIS_CAT_TEMA_CAMPOS,
       DB_CAT_TEMA_CAMPOS    TEMA,
	   MVA_CATALOGOS
 WHERE TEMA.DB_CHAVE = DB_SIS_CAT_TEMA_CAMPOS.DB_CHAVE
   AND DB_TEMA = TEMA_CAT
