USE [BI_ALIANCA]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- View para o PowerBI ler dados dos demais sistemas
-- Data: 07/12/2021
-- Autor: Robert Koch
--
-- Historico de alteracoes:
--

ALTER VIEW [dbo].[VPBI_DADOS_OS]
AS 
SELECT *
FROM protheus.dbo.VA_VDADOS_OS

GO
