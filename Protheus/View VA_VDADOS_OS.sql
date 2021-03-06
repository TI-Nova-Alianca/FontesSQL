USE [protheus]
GO

/****** Object:  View [dbo].[VA_VDADOS_OS]    Script Date: 22/02/2022 17:20:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[VA_VDADOS_OS] AS 
	-- Cooperativa Agroindustrial Nova Alianca Ltda
	-- View para buscar dados de ordens de servico da manutencao de ativos.
	-- Autor: Robert Koch
	-- Data:  01/12/2021
	-- Historico de alteracoes:
	-- 06/12/2021 - Robert - Criadas colunas MANUTENTOR1, MANUTENTOR2, 3 e 4.
	-- 22/02/2022 - Robert - Adicionados alguns comentarios sobre as colunas
	-- 08/04/2022 - Robert - Melhorada a leitura de manutentores por OS:
	--                         - Usa LEFT JOIN entre SLT e ST1
	--                         - Desconsidera TL_REPFIM = 'S' (para trazer tambem os menutentores previstos para a OS)
	--                     - Adicionados mais manutentores (ate 7)
	--

-- MONTA UMA CTE CONTENDO OS NOMES DOS PRINCIPAIS MANUTENTORES DE CADA O.S. EM COLUNAS,
-- PARA PODER, DEPOIS, FAZER UM JOIN COM A TABELA PRINCIPAL DE O.S.
WITH MANUTENTORES_POR_OS AS (
	SELECT TL_FILIAL
		, TL_ORDEM
		, max (CASE WHEN SEQ = 1 THEN T1_NOME ELSE '' END) AS MANUTENTOR1
		, max (CASE WHEN SEQ = 2 THEN T1_NOME ELSE '' END) AS MANUTENTOR2
		, max (CASE WHEN SEQ = 3 THEN T1_NOME ELSE '' END) AS MANUTENTOR3
		, max (CASE WHEN SEQ = 4 THEN T1_NOME ELSE '' END) AS MANUTENTOR4
		, max (CASE WHEN SEQ = 5 THEN T1_NOME ELSE '' END) AS MANUTENTOR5
		, max (CASE WHEN SEQ = 6 THEN T1_NOME ELSE '' END) AS MANUTENTOR6
		, max (CASE WHEN SEQ = 7 THEN T1_NOME ELSE '' END) AS MANUTENTOR7
	FROM (SELECT TL_FILIAL
				, TL_ORDEM
				, ROW_NUMBER () OVER(PARTITION BY TL_FILIAL, TL_ORDEM ORDER BY SUM (TL_QUANTID) DESC) AS SEQ
				, TL_CODIGO
				, ST1.T1_NOME
				, SUM (TL_QUANTID) AS HORAS
			FROM STL010 STL
				LEFT JOIN ST1010 ST1
					ON (ST1.D_E_L_E_T_ = ''
					AND ST1.T1_FILIAL = '  '
					AND ST1.T1_CODFUNC = STL.TL_CODIGO)
				WHERE STL.D_E_L_E_T_ = ''
				AND STL.TL_TIPOREG = 'M' -- MAO DE OBRA
				--AND STL.TL_REPFIM = 'S'  -- REALIZADO
				--AND TL_ORDEM in ('023203', '022422', '022162')
				AND ST1.D_E_L_E_T_ = ''
				AND ST1.T1_FILIAL = '  '
				AND ST1.T1_CODFUNC = STL.TL_CODIGO
			GROUP BY TL_FILIAL, TL_ORDEM, TL_CODIGO, ST1.T1_NOME
		) AS T1
	GROUP BY T1.TL_FILIAL, T1.TL_ORDEM
)

-- MONTA UMA CTE COM OS DADOS PRINCIPAIS DE CADA O.S. E SEUS HORARIOS,
-- PARA PODER, DEPOIS, CALCULAR AS DIFERENCAS ENTRE OS HORARIOS DE INICIO E FIM.
, C AS (
SELECT TJ_FILIAL AS FILIAL, TJ_ORDEM AS ORDEM
	, TJ_SITUACA + '-' + CASE TJ_SITUACA WHEN 'C' THEN 'Cancelado' WHEN 'L' THEN 'Liberado' WHEN 'P' THEN 'Pendente' ELSE '' END AS SITUACAO  -- INDICA SE FOI LIBERADA PARA O MANUTENTOR FAZER O TRABALHO (CANCELADO = LIBEROU E DEPOIS CALCELOU A LIBERACAO)
	, TJ_TERMINO + '-' + CASE TJ_TERMINO WHEN 'N' THEN 'Nao' WHEN 'S' THEN 'Sim' ELSE '' END AS TERMINO
	, TJ_PLANO AS PLANO, RTRIM (STI.TI_DESCRIC) AS DESCR_PLANO
	, TJ_TIPO AS TIPO_MANUT, STJ.TJ_CODAREA AS AREA_MANUT
	--, STJ.TJ_LUBRIFI + '-' + CASE TJ_LUBRIFI WHEN 'S' THEN 'Sim' WHEN 'N' THEN 'Nao' ELSE '' END AS PLANO_LUBRIFICACAO
	--, TJ_HORACO1, TJ_HORACO2
	, TJ_CODBEM AS BEM, RTRIM (T9_NOME) AS DESCR_BEM
	, ST9.T9_CODFAMI AS FAMILIA, RTRIM (ST6.T6_NOME) AS DESCR_FAMILIA
	, CASE TJ_PLANO WHEN '000000'
		THEN CAST (TJ_DTMRINI + ' ' + TJ_HOMRINI AS DATETIME)  -- QUANDO MANUTENCAO CORRETIVA (PELO QUE PUDE VERIFICAR)
		ELSE CAST (TJ_DTMPINI + ' ' + TJ_HOMPINI AS DATETIME) -- QUANDO MANUTENCAO PREVENTIVA (PELO QUE PUDE VERIFICAR)
		END AS INICIO_PREVISTO
	, CASE TJ_PLANO WHEN '000000'
		THEN CAST (TJ_DTMRFIM + ' ' + TJ_HOMRFIM AS DATETIME)  -- QUANDO MANUTENCAO CORRETIVA (PELO QUE PUDE VERIFICAR)
		ELSE CAST (TJ_DTMPFIM + ' ' + TJ_HOMPFIM AS DATETIME)  -- QUANDO MANUTENCAO PREVENTIVA (PELO QUE PUDE VERIFICAR)
		END AS FIM_PREVISTO
	, CAST (TJ_DTPRINI + ' ' + TJ_HOPRINI AS DATETIME) AS INICIO_REAL
	, CAST (TJ_DTPRFIM + ' ' + TJ_HOPRFIM AS DATETIME) AS FIM_REAL
	, STJ.TJ_CCUSTO AS CCUSTO, RTRIM (CTT.CTT_DESC01) AS DESCR_CCUSTO
	, TJ_SERVICO AS TIPO_SERV, T4_NOME AS DESCR_SERVICO
	, STJ.TJ_SOLICI AS SOLICITACAO, TQB.TQB_USUARI AS SOLICITANTE
	, REPLACE(ISNULL(REPLACE (REPLACE ( REPLACE ( CAST(RTRIM (CAST (TJ_OBSERVA AS VARBINARY (8000))) AS VARCHAR (8000)) , char(13), ''), char(10), ''), char(14), ''),''),char(34),' ') AS OBSERVACOES
	--, STJ.TJ_CUSTMDO AS CUSTO_MAO_OBRA
	--, STJ.TJ_CUSTMAT AS CUSTO_MATERIAIS_TROCA
	--, STJ.TJ_CUSTMAA AS CUSTO_MATERIAIS_APOIO
	--, STJ.TJ_CUSTMAS AS CUSTO_MATERIAIS_SUBSTITUICAO
	--, STJ.*
	FROM STJ010 STJ  -- O.S.
		LEFT JOIN ST9010 ST9
			LEFT JOIN ST6010 ST6 ON (ST6.D_E_L_E_T_ = '' AND ST6.T6_FILIAL = '  ' AND ST6.T6_CODFAMI = ST9.T9_CODFAMI)
		ON ST9.D_E_L_E_T_ = '' AND ST9.T9_FILIAL  = STJ.TJ_FILIAL AND ST9.T9_CODBEM = STJ.TJ_CODBEM -- BENS
		LEFT JOIN STI010 STI ON STI.D_E_L_E_T_ = '' AND STI.TI_FILIAL  = STJ.TJ_FILIAL AND STI.TI_PLANO = STJ.TJ_PLANO  -- PLANOS DE MANUTENCAO
		LEFT JOIN ST4010 ST4 ON ST4.D_E_L_E_T_ = '' AND ST4.T4_FILIAL  = '  ' AND  ST4.T4_SERVICO = STJ.TJ_SERVICO  -- SERVICOS DE MANUTENCAO
		LEFT JOIN CTT010 CTT ON CTT.D_E_L_E_T_ = '' AND CTT.CTT_FILIAL = '  ' AND  CTT.CTT_CUSTO = STJ.TJ_CCUSTO  -- CENTROS DE CUSTO
		LEFT JOIN TQB010 TQB ON TQB.D_E_L_E_T_ = '' AND TQB.TQB_FILIAL = STJ.TJ_FILIAL AND TQB.TQB_SOLICI = STJ.TJ_SOLICI  -- SOLICITACOES DE MANUTENCAO
	WHERE STJ.D_E_L_E_T_ = ''
)

-- PREPARA TABELA DE RESULTADOS JUNTANDO AS CTEs ANTERIORES E CALCULANDO INTERVALOS DE TEMPO.
SELECT
	FILIAL, ORDEM, SITUACAO, TERMINO, PLANO, DESCR_PLANO, TIPO_MANUT, AREA_MANUT, BEM, DESCR_BEM, FAMILIA, DESCR_FAMILIA
	, INICIO_PREVISTO, FIM_PREVISTO
	, DATEDIFF (MINUTE, INICIO_PREVISTO, FIM_PREVISTO) AS DURACAO_PREVISTA_MINUTOS
	, INICIO_REAL, FIM_REAL
	, DATEDIFF (MINUTE, INICIO_REAL, FIM_REAL) AS DURACAO_REAL_MINUTOS
	, CCUSTO, DESCR_CCUSTO, TIPO_SERV, DESCR_SERVICO, SOLICITACAO, SOLICITANTE, OBSERVACOES
	, ISNULL (RTRIM (M.MANUTENTOR1), '') AS MANUTENTOR1
	, ISNULL (RTRIM (M.MANUTENTOR2), '') AS MANUTENTOR2
	, ISNULL (RTRIM (M.MANUTENTOR3), '') AS MANUTENTOR3
	, ISNULL (RTRIM (M.MANUTENTOR4), '') AS MANUTENTOR4
	, ISNULL (RTRIM (M.MANUTENTOR5), '') AS MANUTENTOR5
	, ISNULL (RTRIM (M.MANUTENTOR6), '') AS MANUTENTOR6
	, ISNULL (RTRIM (M.MANUTENTOR7), '') AS MANUTENTOR7
FROM C
	LEFT JOIN MANUTENTORES_POR_OS M ON (M.TL_FILIAL = C.FILIAL AND M.TL_ORDEM = C.ORDEM)

GO


