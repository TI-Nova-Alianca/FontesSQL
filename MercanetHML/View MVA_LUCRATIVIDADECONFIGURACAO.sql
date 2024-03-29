---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	22/01/2015	TIAGO PRADELLA	CRIACAO
-- 1.0002   25/05/2015  tiago           traz registros onde tipo e diferente de 2
-- 1.0003   09/08/2016  tiago           incluido campo TOTALIZADOR
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LUCRATIVIDADECONFIGURACAO AS
 SELECT CONFIG.ID           ID_LUCONF,
		TIPO                TIPO_LUCONF,
		VARIAVEL            VARIAVEL_LUCONF,
		COLUNA              COLUNA_LUCONF,
		ORDEM               ORDEM_LUCONF,
		LABEL               LABEL_LUCONF,
		NEGRITO             NEGRITO_LUCONF,
		ITALICO             ITALICO_LUCONF,
		COR                 COR_LUCONF,
		RECUO               RECUO_LUCONF,
		PERCENTUALSOBRE     PERCENTUALSOBRE_LUCONF,	
		APRESENTAPERCENTUAL	APRESENTAPERCENTUAL_LUCONF,
		TOTALIZADOR         totalizador_LUCONF,
		GRAVARPEDIDO		gravarPedido_LUCONF,
		CAMPOPEDIDO			campoPedido_LUCONF,
		DB_LUC_VISUALIZACAO.id   idVisualizacao_LUCONF,
		DB_LUC_VISUALIZACAO.TIPOPED		tipoPed_LUCONF,
		CONFIG.APRESENTA_POPUP	 apresentaPopUp_LUCONF,
		usu.USUARIO
   FROM DB_LUC_CALC_CONFIGURACAO CONFIG,
        DB_LUC_VISUALIZACAO,
		DB_LUC_VIS_GRUPOS,
		DB_USUARIO USU
  WHERE CONFIG.MODELO = DB_LUC_VISUALIZACAO.MODELO 
    AND DB_LUC_VISUALIZACAO.ID = DB_LUC_VIS_GRUPOS.ID
	AND DB_LUC_VIS_GRUPOS.GRUPO_USUARIO = USU.GRUPO_USUARIO
	and tipo <> 2
	and DB_LUC_VISUALIZACAO.modelo = (select top 1 modelo from DB_LUC_CALC_MODELOS where tipo = 1)
	and (isnull(DB_LUC_VISUALIZACAO.TIPOPED, '') = '' or (DB_LUC_VISUALIZACAO.TIPOPED in (select CODIGO_TPPED from MVA_TIPOSPEDIDO where usuario = usu.USUARIO)))
