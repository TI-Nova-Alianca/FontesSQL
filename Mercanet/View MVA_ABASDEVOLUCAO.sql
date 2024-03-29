---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/01/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ABASDEVOLUCAO AS			
 SELECT DEV.GRUPO_USUARIO   GRUPOUSUARIO_ABADEV,
		ABA                 ABA_ABADEV,
		LABEL               LABEL_ABADEV,
		ORDEM               ORDEM_ABADEV,
		USU.USUARIO
   FROM DB_MOB_ABAS_DEVOLUCAO DEV,
        DB_USUARIO USU
  WHERE USU.GRUPO_USUARIO = DEV.GRUPO_USUARIO
