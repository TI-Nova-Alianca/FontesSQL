---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/01/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_AREASABASDEVOLUCAO AS	
 SELECT DEV.GRUPO_USUARIO   GRUPOUSUARIO_AREADEV,
		ABA                 ABA_AREADEV,
		AREA                AREA_AREADEV,
		COLUNAS             COLUNAS_AREADEV,
		ORDEM               ORDEM_AREADEV,
		USU.USUARIO         USUARIO
   FROM DB_MOB_AREAS_ABAS_DEVOLUCAO DEV,
        DB_USUARIO USU
  WHERE DEV.GRUPO_USUARIO = USU.GRUPO_USUARIO
    AND ABA IN (SELECT ABA_ABADEV
	              FROM MVA_ABASDEVOLUCAO
				 WHERE USU.USUARIO = MVA_ABASDEVOLUCAO.USUARIO)
