---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	22/01/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LUCRAVISCONFIGURACAO AS
 SELECT ID_VARIAVEL		VARIAVEL_LUVCONF,
		ORDEM			ORDEM_LUVCONF,
		COLUNA			COLUNA_LUVCONF,	
		ID_MODELO		modeloVis_LUVCONF,
		USU.USUARIO
   FROM DB_LUC_VIS_CONFIGURACAO,
        DB_LUC_VIS_GRUPOS,
		DB_USUARIO USU
  WHERE DB_LUC_VIS_CONFIGURACAO.ID_MODELO = DB_LUC_VIS_GRUPOS.ID
    AND DB_LUC_VIS_GRUPOS.GRUPO_USUARIO = USU.GRUPO_USUARIO
	and DB_LUC_VIS_CONFIGURACAO.ID_MODELO in (select idVisualizacao_LUCONF from MVA_LUCRATIVIDADECONFIGURACAO
	                                where MVA_LUCRATIVIDADECONFIGURACAO.usuario = USU.usuario)
