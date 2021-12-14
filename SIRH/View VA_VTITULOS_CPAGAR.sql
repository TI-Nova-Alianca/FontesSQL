SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View para buscar dados de titulos a serem importados do Metadados pera o Protheus (titulos a pagar).
-- Autor: Robert Koch (com base em query do programa MetaFin.prw)
-- Data:  16/12/2020
--
-- Historico de alteracoes:
-- 09/08/2021 - Robert Koch - Passa a buscar qualquer filial, inclusive NULL, para compatibilidade com query original do programa MetaFin.prw (GLPI 10667)
--                          - Renomeadas algumas colunas e formatadas datas para yyyyMMdd (GLPI 10667)
--

create VIEW [dbo].[VA_VTITULOS_CPAGAR]
AS

WITH CTE
AS
(SELECT
		CASE C.TIPOITEMCONTAPAGAR
			WHEN '05' THEN SUBSTRING(DARF.UNIDADE, 3, 2)  -- Tipo 05 = DARF PIS: busca detalhamento em tabela especifica.
			WHEN '22' THEN SUBSTRING(DEP.ESTABELECIMENTO, 3, 2)  -- Tipo 22 = remessa p/ banco: busca detalhamento em tabela especifica.
			ELSE SUBSTRING(C.ESTABELECIMENTO, 3, 2)
		END AS FILIAL
	   ,C.NROSEQUENCIAL
	   ,ISNULL (C.NROREMESSA, '') AS NROREMESSA
	   --,C.DATAINCLUSAO AS EMISSAO_orig
	   ,FORMAT (C.DATAINCLUSAO, 'yyyyMMdd') AS EMISSAO
	   --,C.DATAVENCIMENTO AS VENCTO_orig
	   ,FORMAT (C.DATAVENCIMENTO, 'yyyyMMdd') AS VENCTO
	   ,CASE C.TIPOITEMCONTAPAGAR
			WHEN '05' THEN DARF.VALOR
			WHEN '22' THEN DEP.VALOR
			ELSE C.VALOR
		END AS VALOR
	   ,SUBSTRING(C.DESCRICAO20, 1, 6) AS FORNECE
	   ,RTRIM(C.DESCRICAO250) +
		CASE
			WHEN C.TIPOITEMCONTAPAGAR = '22' THEN ' (Rem.' + CAST(C.NROREMESSA AS VARCHAR) + ')'
			ELSE ''
		END AS HIST
	   ,CASE C.TIPOITEMCONTAPAGAR
			WHEN '22' THEN RTRIM(DEP.NUMERODOCUMENTO)  -- Tipo 22 = remessa p/ banco: busca detalhamento em tabela especifica.
			ELSE RTRIM(C.NUMERODOCUMENTO)
		END AS NATUREZA
		
--		,C.NUMERODOCUMENTO AS DOC1
--		,C.NRODOC, DEP.NUMERODOCUMENTO AS DOC2
	   

	   ,C.TIPOITEMCONTAPAGAR AS TPITEMCP
	   ,CASE C.TIPOITEMCONTAPAGAR
			WHEN '01' THEN 'GPS EMPRESA MENSAL'
			WHEN '04' THEN 'DARF IRF S/ SALARIOS'
			WHEN '05' THEN 'DARF PIS'
			WHEN '09' THEN 'CONTRATO'
			WHEN '10' THEN 'DARF IRF S/ AUTONOMOS'
			WHEN '13' THEN 'GPS DIFERENCA DISSIDIO'
			WHEN '16' THEN 'GFIP (FGTS 115)'
			WHEN '19' THEN 'GFIP (FGTS 650)'
			WHEN '22' THEN 'REMESSA P/BANCO'
			WHEN '26' THEN 'PENSIONISTAS'
			WHEN '40' THEN 'FOLHA AVULSA/RPA'
			WHEN '41' THEN 'FERIAS'
			WHEN '44' THEN 'RESCISAO PRINCIPAL'
			WHEN '45' THEN 'RESCISAO COMPLEMENTAR'
			WHEN '99' THEN 'OUTROS'
			ELSE ''
		END AS DESCR_TPITCP
	   ,C.STATUSREGISTRO AS STATUSREG
	   ,CASE C.STATUSREGISTRO
			WHEN '01' THEN 'INCLUIDO (AINDA NAO LIBERADO) NO METADADOS'
			WHEN '02' THEN 'LIBERADO (METADADOS) PARA O PROTHEUS IMPORTAR'
			WHEN '03' THEN 'ACEITO PELO PROTHEUS'
			WHEN '05' THEN 'EXCLUIDO NO PROTHEUS'
			WHEN '06' THEN 'EXCLUSAO NEGADA PELO PROTHEUS'
			WHEN '07' THEN 'EXCLUIDO NO METADADOS (AGUARDA EXCLUSAO PELO PROTHEUS)'
			WHEN '08' THEN 'REJEITADO PELO PROTHEUS'
			WHEN '10' THEN 'PROVISIONADO'
		END AS DESCR_STATUS
	FROM RHCONTASPAGARHIST C

	-- Busca detalhamento de remessa para bancos.
	LEFT JOIN (SELECT
			EMPRESA
		   ,BANCO
		   ,NROREMESSA
		   ,ESTABELECIMENTO
		   ,NUMERODOCUMENTO
		   ,SUM(VALOR) AS VALOR
		FROM RHDEPOSITOSANALITICO
		WHERE EMPRESA = '00' + '01'
		GROUP BY EMPRESA
				,BANCO
				,NROREMESSA
				,ESTABELECIMENTO
				,NUMERODOCUMENTO) AS DEP
		ON (DEP.EMPRESA = C.EMPRESA
		AND DEP.BANCO = C.BANCO
		AND DEP.NROREMESSA = C.NROREMESSA
		AND C.TIPOITEMCONTAPAGAR = '22')

	-- Busca detalhamento de DARF para pagamento de PIS.
	-- Quando o RH gera os titulos de PIS antes do final do mes, a query abaixo nao os encontra (dataemissao > datainclusao). A solucao
	-- atual eh incluir manualmente no financeiro. Outra possibilidade seria desvincular os titulos de PIS desta rotina automatica
	-- e fazer a geracao atraves de um programa com parametrizacao manual do usuario, assim poderia gerar em qualquer data.
	LEFT JOIN (SELECT
			EMPRESA
		   ,UNIDADE
		   ,DATAEMISSAO
		   ,SUM(LIQUIDOCOMPETENCIA) AS VALOR
		FROM RHDARFANALITICO
		WHERE ESTABELECIMENTO = '00' + '01'
		AND TIPODARF = '3'  -- 3=PIS
		AND DATAEMISSAO = (SELECT
				MAX(DATAEMISSAO)
			FROM RHDARFANALITICO
			WHERE ESTABELECIMENTO = '0001'
			AND TIPODARF = '3')
		GROUP BY EMPRESA
				,UNIDADE
				,DATAEMISSAO) AS DARF
		ON (DARF.EMPRESA = C.EMPRESA
		AND DARF.DATAEMISSAO < C.DATAINCLUSAO
		AND C.TIPOITEMCONTAPAGAR = '05')

	WHERE C.EMPRESA = '00' + '01'
)
SELECT
	CTE.*
FROM CTE

GO
