---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	22/03/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_AREASLISTACATALOGO AS
 SELECT C.GRUPO_USUARIO	 GRUPOUSUARIO_CLISA,
		AREA	         AREA_CLISA,
		DIGITA_QTDEEMB	 DIGITAQTDEEMBALAGEM_CLISA,
		EXIBE_DESCONTOS	 EXIBEDESCONTOS_CLISA,
		NRO_COLUNAS	     COLUNAS_CLISA,
		USU.USUARIO
   FROM DB_CAT_CONFIGLISTAAREAS C, DB_USUARIO USU
  WHERE C.GRUPO_USUARIO = USU.GRUPO_USUARIO
