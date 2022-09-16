USE [BI_ALIANCA]
GO

/****** Object:  View [dbo].[VPBI_REPRESENTANTES]    Script Date: 20/04/2022 16:10:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[VPBI_REPRESENTANTES]  -- REPRESENTANTES

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de representantes, para uso no PowerBI
-- Autor: Robert Koch
-- Data:  03/2022
-- Historico de alteracoes:
-- 20/04/2022 - Robert - Incluida coluna A3_NREDUZ
-- 16/09/2022 - Robert - Incluidas colunas A3_ATIVO e A3_EST

AS 
SELECT A3_COD
	, A3_NOME
	, A3_VAGEREN  -- GERENTE / SUPERVISOR - VINCULADO A ESTA MESMA TABELA
	, A3_NREDUZ
	, A3_ATIVO
	, A3_EST
FROM protheus.dbo.SA3010
WHERE D_E_L_E_T_ = ''
AND A3_FILIAL = '  '
GO


