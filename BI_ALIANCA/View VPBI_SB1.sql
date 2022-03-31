USE [BI_ALIANCA]
GO

/****** Object:  View [dbo].[VPBI_SB1]    Script Date: 31/03/2022 17:16:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- View para o PowerBI ler dados dos demais sistemas
-- Data: 13/10/2021
-- Autor: Robert Koch
--
-- Historico de alteracoes:
--

ALTER VIEW [dbo].[VPBI_SB1]
AS 
SELECT B1_COD, B1_DESC, B1_TIPO
FROM protheus.dbo.SB1010
WHERE D_E_L_E_T_ = ''
--AND D3_FILIAL = '01'
--AND D3_EMISSAO >= FORMAT (DATEADD (MONTH, -1, GETDATE ()), 'yyyyMMdd')
GO


