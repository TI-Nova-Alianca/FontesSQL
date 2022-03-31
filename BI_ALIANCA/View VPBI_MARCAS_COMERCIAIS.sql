SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- View para o PowerBI ler dados dos demais sistemas
-- Data: 31/03/2022
-- Autor: Robert Koch
--
-- Historico de alteracoes:
--

ALTER VIEW [dbo].[VPBI_MARCAS_COMERCIAIS]
AS
SELECT ZX5_40COD, ZX5_40DESC
FROM protheus.dbo.ZX5010
WHERE D_E_L_E_T_ = ''
AND ZX5_FILIAL = '  '
AND ZX5_TABELA = '40'
GO
