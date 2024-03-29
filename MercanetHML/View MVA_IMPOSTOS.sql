---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   14/10/2013  tiago           incluido campo data de alteracao
-- 1.0003   12/03/2014  tiago           incluido campo dataalter
-- 1.0004   23/09/2014  tigo            incluido novo campo cfop_IMPOS 
-- 1.0005   20/03/2015  tiago           incluido campo ICMSDescontado_IMPOS
-- 1.0006   16/03/2017  tiago           incluido campo desconto fiscal
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_IMPOSTOS AS
SELECT MPF01.PF01_CONTROLE CONTROLE_IMPOS,
       PF01_SEQ            SEQUENCIA_IMPOS,
       PF01_REGRA	       CODIGOREGRA_IMPOS,
	   -- PF01_ DESCRICAO_IMPOS, 
	   CASE PF01_TIPO WHEN 'RI' THEN 'ICMS'
	                  WHEN 'ST' THEN 'SUBSTITUI��O TRIBUT�RIA'
					  WHEN 'IT' THEN 'ICMS-ST'
					  WHEN 'IP' THEN 'IPI' ELSE ' ' END AS  DESCRICAO_IMPOS,
	   PF01_TIPO		 TIPO_IMPOS,
	   PF01_PERCENTUAL   PERCENTUAL_IMPOS,
	   PF01_BASERED      BASEREDUZIDA_IMPOS,
	   PF01_TPCALC       TIPOCALCULO_IMPOS,
	   PF01_PRCMAX       PERCENTUALMAXIMO_IMPOS,
	   PF01_DCTOPMC      DESCONTOPMC_IMPOS,
	   PF01_APLIC        FORMAAPLICACAOST_IMPOS,
	   PF01_CALC         CALCULAST_IMPOS,
	   PF01_DESCTO       DESCONTO_IMPOS,
	   PF01_UTILBASERED  INCIDENCIABASEREDUZIDA_IMPOS,
       PV04_PESO_IMP     PESO_IMPOS,
	   PF01_DATAINI      DATAINICIAL_IMPOS,
       PF01_DATAFIN      DATAFINAL_IMPOS,
	   PF01_DATA_ALTER   DATAALTER,
	   PF01_CFOP         CFOP_IMPOS,
	   PF01_ICMSDSCTO    ICMSDescontado_IMPOS,
	   PF01_DESCONTOFISCAL descontoFiscal_IMPOS,
	   PF01_DCTOPMC       percentualPMC_IMPOS
  FROM MPF01,
	   MPV04
 WHERE PF01_CONTROLE = MPV04.PV04_CONTROLE
   AND PF01_DATAFIN >= convert(date, GETDATE())
