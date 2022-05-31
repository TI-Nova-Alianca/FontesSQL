SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 11/07/2011
-- Description:	Retorna o peso da classificacao das uvas finas convertido para numerico.
-- =============================================
ALTER FUNCTION [dbo].[VA_PESO_CLAS_UVA]
(
	@VAL1 VARCHAR (2)
)
RETURNS INT
AS
BEGIN
	DECLARE @RET AS INT;
	SET @RET = -1;
	IF (@VAL1 = 'AA')
		SET @RET = 6;
	IF (@VAL1 = 'A')
		SET @RET = 5;
	IF (@VAL1 = 'B')
		SET @RET = 4;
	IF (@VAL1 = 'C')
		SET @RET = 3;
	IF (@VAL1 = 'D')
		SET @RET = 2;
	IF (@VAL1 = 'DS')
		SET @RET = 1;
	RETURN @RET;
END
GO
