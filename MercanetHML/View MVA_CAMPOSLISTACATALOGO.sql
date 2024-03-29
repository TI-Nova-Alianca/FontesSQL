---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	22/03/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CAMPOSLISTACATALOGO AS
 SELECT C.GRUPO_USUARIO	   GRUPOUSUARIO_CLICA,
		AREA	           AREA_CLICA,
		CAMPO	           CAMPO_CLICA,
		LABEL	           LABEL_CLICA,
		ORDEM 	           ORDEM_CLICA,
		TIPO_COMPONENTE	   TIPOCOMPONENTE_CLICA,
		COLUNA	           COLUNA_CLICA,
		OBRIGATORIO	       OBRIGATORIO_CLICA,
		EDITAVEL	       EDITAVEL_CLICA,
		USU.USUARIO
   FROM DB_CAT_CONFIGLISTACAMPOS C, DB_USUARIO USU
  WHERE C.GRUPO_USUARIO = USU.GRUPO_USUARIO
