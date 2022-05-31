SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 08/05/2009
-- Description:	Retorna o menor de dois valores.
-- =============================================
ALTER FUNCTION [dbo].[MENOR]
(
	@VAL1 FLOAT,
	@VAL2 FLOAT
)
RETURNS float
AS
BEGIN
	DECLARE @RET AS FLOAT;
	IF (@VAL1 < @VAL2)
		SET @RET = @VAL1;
	ELSE
		SET @RET = @VAL2;
	RETURN @RET;
END
GO
