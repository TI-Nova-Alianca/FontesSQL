---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   11/11/2013  tiago           incluido campo numero minimo
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MIXVENDAITENS AS
SELECT DB_TBMVP_CODIGO    MIXVENDA_MIXIT,
	   DB_TBMVP_SEQ       SEQUENCIA_MIXIT,
	   DB_TBMVP_TIPO      TIPO_MIXIT,
	   DB_TBMVP_PRODUTO   CHAVE_MIXIT,
	   DB_TBMVP_SUBPROD   SUBCHAVE_MIXIT,
	   DB_TBMVP_QTDEMIN   QUANTIDADEMINIMA_MIXIT,
	   DB_TBMVP_QTDEMAX   QUANTIDADEMAXIMA_MIXIT,
	   DB_TBMVP_NROITENS  NUMEROMINIMO_MIXIT,
	   DB_TBMVP_OBRIGATORIO obrigatorio_MIXIT,
	   DB_TBMVP_PARTMIN   participacaoMinima_MIXIT,
       DB_TBMVP_PARTMAX   participacaoMaxima_MIXIT,
	   DB_TBMVP_VLRMIN    valorMinimo_MIXIT,
       DB_TBMVP_VLRMAX    valorMaximo_MIXIT,
	   DB_TBMVP_CAMPANHA  mixCampanha_MIXIT
  FROM DB_TB_MIX_VENDAP
 WHERE DB_TBMVP_CODIGO IN (SELECT CODIGO_MIX FROM MVA_MIXESVENDA)
