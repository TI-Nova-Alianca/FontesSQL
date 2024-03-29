---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	19/11/2015	TIAGO PRADELLA	CRIACAO
-- 1.0001   19/04/2016  tiago           incluido campo baseCalculo_HISTC
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_HISTORICOSCONTACORRENTE AS
SELECT DB_TBHC_CODIGO	    CODIGO_HISTC,
	   DB_TBHC_DESCRICAO	DESCRICAO_HISTC,
	   DB_TBHC_TPCONTRAT	TIPO_HISTC,
	   DB_TBHC_BASECALC     baseCalculo_HISTC 
  FROM DB_TB_HISTCC
