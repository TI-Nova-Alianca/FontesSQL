
-- Descricao: Retorna tabela com acumulados mensais do CT3 (saldos orcados e realizados) para todas as contas,
--            inclusive acumulando nas sinteticas, para uso em consultas de previsto X realizado.
-- Autor....: Robert Koch
-- Data.....: 10/03/2016
--
-- Historico de alteracoes:
--

ALTER FUNCTION [dbo].[VA_FCTB_ORCXREA_CTA]
-- PARAMETROS DE CHAMADA
(
	@DATAINI AS VARCHAR(8),
	@DATAFIM AS VARCHAR(8),
	@FILINI  AS VARCHAR(2),
	@FILFIM  AS VARCHAR(2),
	@CTAINI  AS VARCHAR(20),
	@CTAFIM  AS VARCHAR(20),
	@CCINI   AS VARCHAR(9),
	@CCFIM   AS VARCHAR(9)
)

-- RETORNA TABELA TEMPORARIA
RETURNS @RET TABLE (FILIAL VARCHAR (2),
                    ANO VARCHAR (4),
                    CONTA VARCHAR (20),
                    DESCRICAO VARCHAR (40),
					CLASSE VARCHAR (1),
					ORC01 FLOAT, REA01 FLOAT,
                    ORC02 FLOAT, REA02 FLOAT,
                    ORC03 FLOAT, REA03 FLOAT,
                    ORC04 FLOAT, REA04 FLOAT,
                    ORC05 FLOAT, REA05 FLOAT,
                    ORC06 FLOAT, REA06 FLOAT,
                    ORC07 FLOAT, REA07 FLOAT,
                    ORC08 FLOAT, REA08 FLOAT,
                    ORC09 FLOAT, REA09 FLOAT,
                    ORC10 FLOAT, REA10 FLOAT,
                    ORC11 FLOAT, REA11 FLOAT,
                    ORC12 FLOAT, REA12 FLOAT)
AS
BEGIN

	-- TABELA TEMPORARIA PARA ACUMULAR VALORES POR ANO/MES.
	DECLARE @T TABLE (FILIAL VARCHAR (2),
					  CONTA VARCHAR (20),
					  ANO VARCHAR (4),
					  MES VARCHAR (2),
					  ORCADO FLOAT,
					  REALIZADO FLOAT)
					  --unique NONCLUSTERED (FILIAL, CONTA, ANO, MES))
	INSERT INTO @T
	SELECT CT3_FILIAL AS FILIAL,
	       CT3_CONTA AS CONTA,
	       SUBSTRING (CT3_DATA, 1, 4) AS ANO,
	       SUBSTRING (CT3_DATA, 5, 2) AS MES,
	       ISNULL (SUM (CASE CT3_TPSALD WHEN '0' THEN CT3_DEBITO - CT3_CREDIT ELSE 0 END), 0) AS ORCADO,
	       ISNULL (SUM (CASE CT3_TPSALD WHEN '1' THEN CT3_DEBITO - CT3_CREDIT ELSE 0 END), 0) AS REALIZADO
	  FROM CT3010
	 WHERE D_E_L_E_T_ = ''
	   AND CT3_FILIAL BETWEEN @FILINI AND @FILFIM
	   AND CT3_CONTA  BETWEEN @CTAINI AND @CTAFIM
	   AND CT3_CUSTO  BETWEEN @CCINI  AND @CCFIM
	   AND CT3_DATA   BETWEEN @DATAINI AND @DATAFIM
	 GROUP BY CT3_FILIAL, CT3_CONTA, SUBSTRING (CT3_DATA, 1, 4), SUBSTRING (CT3_DATA, 5, 2)

	-- POPULA TABELA PARA RETORNO A PARTIR DE UM JOIN ENTRE O PLANO DE CONTAS E UMA SUBQUERY FEITA EM @T PARA BUSCAR OS ANOS E FILIAIS ENVOLVIDOS.
	INSERT INTO @RET
	SELECT ANO_FILIAL.FILIAL,
		   ANO_FILIAL.ANO,
	       CT1_CONTA,
	       CT1_DESC01,
		   CT1_CLASSE,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '01' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC01,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '01' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA01,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '02' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC02,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '02' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA02,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '03' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC03,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '03' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA03,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '04' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC04,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '04' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA04,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '05' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC05,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '05' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA05,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '06' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC06,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '06' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA06,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '07' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC07,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '07' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA07,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '08' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC08,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '08' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA08,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '09' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC09,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '09' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA09,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '10' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC10,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '10' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA10,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '11' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC11,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '11' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA11,
		   ISNULL ((SELECT SUM (T.ORCADO)    FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '12' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS ORC12,
		   ISNULL ((SELECT SUM (T.REALIZADO) FROM @T T WHERE T.FILIAL = ANO_FILIAL.FILIAL AND T.MES = '12' AND T.CONTA LIKE RTRIM(CT1.CT1_CONTA) + '%'), 0) AS REA12
	  FROM CT1010 AS CT1,
	       (SELECT DISTINCT FILIAL, ANO FROM @T) AS ANO_FILIAL
	 WHERE CT1.D_E_L_E_T_ = ''
	   AND CT1.CT1_CONTA BETWEEN @CTAINI AND @CTAFIM
	   AND CT1.CT1_FILIAL = '  '
	 GROUP BY ANO_FILIAL.FILIAL, ANO_FILIAL.ANO, CT1.CT1_CONTA, CT1.CT1_DESC01, CT1_CLASSE

	RETURN
END

--SELECT * FROM VA_FCTB_ORCXREA_CTA ('20151101', '20160210', '', 'Z', '4', '49', '', 'Z')

