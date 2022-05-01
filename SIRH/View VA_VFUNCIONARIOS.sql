USE [SIRH]
GO

/****** Object:  View [dbo].[VA_VFUNCIONARIOS]    Script Date: 25/04/2022 13:58:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View para buscar dados de funcionarios, para permitir a integracao com ERP Protheus a sem que sejam abertos todos os dados dos funcionarios.
-- Autor: Robert Koch (com base em query de Catia Cardoso - 27/11/2015)
-- Data:  02/09/2017
-- Historico de alteracoes:
-- 30/08/2018 - Robert - Incluidos mais campos (endereco, telefone, descritivo da situacao, etc.)
-- 18/11/2019 - Robert - Incluidas colunas de numero de cracha e em_ferias.
-- 09/01/2020 - Robert - Retornava EM_FERIAS=N quando consultado no ultimo dia de gozo de ferias.
-- 11/02/2020 - Robert - Acrescentado campo OP05 para indicar se o usuario deve ser bloqueado na rede e sistemas como Protheus, etc.
-- 25/02/2020 - Robert - Campo OP05 passa a vir separado em CODIGOCOMPLEMENTAR e DESCRICAOCODIGOCOMPLEMENTAR.
-- 03/03/2020 - Robert - Passa a buscar o contrato mais recente de cada pessoa, e nao mais uma UNION de ativos + inativos.
--                     - Somente com vinculo empregaticio 01 (CLT), 06 (trab.rural) e 08 (presidente/vice).
--                     - Acrescentada informacao de setor e funcao.
-- 10/03/2020 - Robert - Nao validava campo UNIDADE ao ferificar a tabela RHFERIASCEDIDAS.
-- 17/09/2020 - Robert - Passa a retornar tambem o codigo da pessoa e escala do contrato.
-- 26/10/2020 - Robert - Ignora RHPESSOAS.EMPRESA = '9999'
-- 07/12/2020 - Robert - Acrescentadas colunas com sugestao de chave para A.D., Protheus e NaWeb
-- 31/03/2021 - Robert - Acrescentados vinculos empregaticios 13 e 14 (estagiario e menor aprendiz)
-- 18/06/2021 - Robert - Acrescentado vinculo empregaticio 99 (sem vinculo - Ex.: Rita e Sara)
--

ALTER VIEW [dbo].[VA_VFUNCIONARIOS] AS

WITH CONTRATOATUAL
AS
(SELECT
		C.PESSOA
	   ,C.CONTRATO
	   ,C.CRACHA
	   ,C.UNIDADE
	   ,C.SITUACAO
	   ,C.SETOR
	   ,S.DESCRICAO20 AS DESC_SETOR
		--, C.VINCULOEMPREGATICIO, V.DESCRICAO20 AS DESC_VINCULO
	   ,C.CARGO, RHCARGOS.DESCRICAO20 AS DESC_CARGO--, RHCARGOS.CBO CBO_CARGO
	   ,C.FUNCAO, F.DESCRICAO20 AS DESC_FUNCAO--, F.CBO AS CBO_FUNCAO
	   ,CASE
			WHEN EXISTS (SELECT
						*
					FROM RHFERIASCEDIDAS F
					WHERE F.UNIDADE = C.UNIDADE
					AND F.CONTRATO = C.CONTRATO
					AND INICIOGOZOFERIAS <= GETDATE()
					AND DATEADD(DAY, 1, F.TERMINOGOZOFERIAS) >= GETDATE()) THEN 'S'
			ELSE 'N'
		END AS EM_FERIAS
	   ,OP05.CODIGOCOMPLEMENTAR AS OP05
	   ,OP05.DESCRICAO20 AS DESC_OP05
	   ,C.ESCALA AS ESCALA_CONTRATO
	FROM RHCONTRATOS C
	LEFT JOIN (SELECT
			UNIDADE
		   ,CONTRATO
		   ,CODIGOCOMPLEMENTAR
		   ,DESCRICAO20
		FROM RHCOMPLCONTRATO
		LEFT JOIN RHOPCOESCOMPL
			ON (RHOPCOESCOMPL.VARIAVEL = 'OP05'
			AND RHOPCOESCOMPL.OPCAOCOMPLEMENTAR = RHCOMPLCONTRATO.CODIGOCOMPLEMENTAR)
		WHERE RHCOMPLCONTRATO.VARIAVEL = 'OP05') AS OP05
		ON (OP05.UNIDADE = C.UNIDADE
		AND OP05.CONTRATO = C.CONTRATO)
	left join RHFUNCOES F ON (F.FUNCAO = C.FUNCAO)
	left join RHCARGOS ON (RHCARGOS.CARGO = C.CARGO)
	--left join RHVINCEMPREGATICIOS V ON (V.VINCULOEMPREGATICIO = C.VINCULOEMPREGATICIO)
	LEFT JOIN RHSETORES S
		ON (S.SETOR = C.SETOR)
	--WHERE C.VINCULOEMPREGATICIO IN ('01', '06', '08')
	--WHERE C.VINCULOEMPREGATICIO IN ('01', '06', '08','13','14')
	WHERE C.VINCULOEMPREGATICIO IN ('01', '06', '08','13','14','99')
	AND NOT EXISTS (SELECT
			*
		FROM RHCONTRATOS MAISRECENTE
		WHERE MAISRECENTE.PESSOA = C.PESSOA
		AND MAISRECENTE.DATAADMISSAO > C.DATAADMISSAO)
	AND (C.SITUACAO != '4'
	OR (C.SITUACAO = '4'
	AND C.DATARESCISAO > '20160101 00:00'))  -- DESCONSIDERAR RESCISOES ANTES DESTA DATA POR MOTIVO DE PERFORMANCE
)
SELECT P.PESSOA
   ,CA.UNIDADE AS UNIDADE
   ,P.NOMECOMPLETO AS NOME
   ,P.CPF AS CPF
   ,CA.SITUACAO AS SITUACAO
   ,CASE CA.SITUACAO
		WHEN '1' THEN 'ATIVO'
		WHEN '2' THEN 'AFASTADO'
		WHEN '3' THEN 'DEMITIDO NO MES'
		WHEN '4' THEN 'DEMITIDO'
	END AS DESCRI_SITUACAO
   ,CA.SETOR ,CA.DESC_SETOR
   ,CA.CARGO ,CA.DESC_CARGO--, CA.CBO_CARGO
   ,CA.FUNCAO ,CA.DESC_FUNCAO--, CA.CBO_FUNCAO
	--,CA.VINCULOEMPREGATICIO, CA.DESC_VINCULO
   ,P.RUA + ', ' + P.NRORUA + ISNULL(' - ' + P.COMPLEMENTO, '') AS ENDERECO
   ,P.BAIRRO
   ,P.UF
   ,REPLACE(REPLACE(P.CEP, '.', ''), '-', '') AS CEP
   ,P.CIDADE
   ,ISNULL(P.DDD, '') + P.TELEFONE AS TELEFONE
   ,P.EMAIL
   ,CA.CONTRATO
   ,CA.CRACHA
   ,CA.EM_FERIAS
   ,CA.OP05
   ,CA.DESC_OP05
   ,CA.ESCALA_CONTRATO
   ,'Pessoa ' + cast (P.PESSOA as nvarchar) as EmployeeID_para_AD
   ,'Pessoa ' + cast (P.PESSOA as nvarchar) + ' ' + rtrim (DESC_FUNCAO) COLLATE SQL_Latin1_General_CP1251_CS_AS as Cargo_para_Protheus
   ,'Funcao_' + CA.FUNCAO as Grupo_prioritario_para_Protheus
FROM SIRH.dbo.RHPESSOAS AS P
	 JOIN CONTRATOATUAL CA ON (CA.PESSOA = P.PESSOA)
WHERE P.EMPRESA != '9999'

GO


