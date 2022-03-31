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

ALTER VIEW [dbo].[VPBI_LINHAS_DE_ENVASE]
AS 
SELECT H1_CODIGO, H1_DESCRI
FROM protheus.dbo.SH1010
WHERE D_E_L_E_T_ = ''
AND H1_FILIAL = '  '
GO
