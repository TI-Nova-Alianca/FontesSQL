---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	11/12/2014	TIAGO PRADELLA	CRIACAO
-- 1.0002   15/07/2015  tiago           retorna dados quando data em branco
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_OPERACOESVENDAIMPOSTOS AS
 SELECT DB_TBOPSP_COD       CODIGO_IMPOP,
		DB_TBOPSP_SEQ       SEQUENCIA_IMPOP,
		DB_TBOPSP_IMPOSTO   IMPOSTO_IMPOP,
		DB_TBOPSP_DT_INI    DATAINICIAL_IMPOP,
		DB_TBOPSP_DT_FIN    DATAFINAL_IMPOP,
		DB_TBOPSP_PERC      PERCENTUAL_IMPOP,
		OP.USUARIO
   FROM DB_TB_OPERS_PERC, MVA_OPERACOESVENDA OP
  WHERE OP.CODIGO_OPERV = DB_TBOPSP_COD
    AND (DB_TBOPSP_DT_FIN >= GETDATE() or (isnull(DB_TBOPSP_DT_INI, '') = '' or isnull(DB_TBOPSP_DT_FIN, '') = ''))
	AND (SELECT ISNULL(DB_PRM_LCPED_ANAL, 0) FROM DB_PARAMETRO) <> 0
