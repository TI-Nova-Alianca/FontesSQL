SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[VPBI_TRANSPORTADORAS]  -- TRANSPORTADORAS
AS 
SELECT A4_COD
	, A4_NOME
FROM protheus.dbo.SA4010
WHERE D_E_L_E_T_ = ''
AND A4_FILIAL = '  '
GO