ALTER VIEW MVA_ABASCLIENTE  AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/07/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
SELECT ABA.GRUPO_USUARIO	  GRUPOUSUARIO_ABACLI,
	   ABA.ABA		          ABA_ABACLI,
	   ABA.LABEL			  LABEL_ABACLI,
	   ORDEM                   ORDEM_ABACLI,
	   USU.USUARIO
  FROM DB_MOB_ABAS_CLIENTE ABA, DB_USUARIO USU, DB_GRUPO_USUARIOS GRUPO 
 WHERE USU.GRUPO_USUARIO = GRUPO.CODIGO
   AND ABA.GRUPO_USUARIO = USU.GRUPO_USUARIO
