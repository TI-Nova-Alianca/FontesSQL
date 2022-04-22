SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[VPBI_CLIENTES]  -- CLIENTES
AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de clientes, para uso no PowerBI
-- Autor: Robert Koch
-- Data:  03/2022
-- Historico de alteracoes:
-- 20/04/2022 - Robert - Incluidas colunas A1_VACBASE e A1_VALBASE
--

SELECT A1_COD
	, A1_LOJA
	, A1_NOME
	, A1_EST      -- ESTADO (UF)
	, A1_REGIAO   -- REGIAO
	, A1_MESO     -- MESOREGIAO
	, A1_COD_MUN  -- CODIGO MUNICIPIO IBGE
	, A1_VACBASE  AS COD_REDE -- CODIGO BASE (REDE)
	, A1_VALBASE  AS LOJA_REDE -- LOJA BASE (REDE)
FROM protheus.dbo.SA1010
WHERE D_E_L_E_T_ = ''
AND A1_FILIAL = '  '
GO
