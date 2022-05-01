USE [SIRH]
GO

/****** Object:  View [dbo].[VA_VFORNECEDORES]    Script Date: 27/04/2022 12:53:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View para buscar dados de fornecedores, para permitir a integracao com ERP Protheus.
-- Autor: Robert Koch
-- Data:  07/06/2018
-- Historico de alteracoes:
--

ALTER VIEW [dbo].[VA_VFORNECEDORES] AS

SELECT FORNECEDOR, NOME, TIPOINSCRICAO, INSCRICAO
FROM RHFORNECEDORES

GO


