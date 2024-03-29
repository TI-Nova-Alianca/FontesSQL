---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	22/01/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LUCRATIVIDADEVARIAVEIS AS
 SELECT VARIAVEL			VARIAVEL_LUCVAR,
	    NOME				NOME_LUCVAR,
	    FORMULA				FORMULA_LUCVAR,
		TIPO_PROCESSAMENTO  TIPOPROCESSAMENTO_LUCVAR,
		CONSULTA_DINAMICA	CONSULTADINAMICA_LUCVAR,
		COLUNA_CONSULTA     colunaConsulta_LUCVAR,
		isnull(VALOR_CAPA, 0)   VALORCAPA_LUCVAR
   FROM DB_LUC_CALC_VARIAVEIS
