SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 14/05/2012
-- Description:	Formata campo de data do Microsiga (AAAAMMDD) para DD/MM/AAAA.
-- =============================================
ALTER FUNCTION [dbo].[VA_DTOC]
(
	@StrData AS VARCHAR (8)
)
RETURNS VARCHAR (10)
AS
BEGIN
	RETURN substring (@StrData, 7, 2) + '/' + substring (@StrData,5, 2) + '/' + substring (@StrData, 1, 4)
END
GO
