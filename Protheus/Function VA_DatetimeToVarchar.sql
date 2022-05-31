SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 29/01/2009
-- Description:	Converte campo DateTime (SQL) para Varchar de 8 (Microsiga)
-- =============================================
ALTER FUNCTION [dbo].[VA_DatetimeToVarchar]
(
	@Data AS DATETIME
)
RETURNS VARCHAR(8)
AS
BEGIN
	RETURN REPLICATE('0', 4 - LEN(CAST(YEAR(@Data) AS VARCHAR))) + CAST(YEAR(@Data) AS VARCHAR)
	+ REPLICATE('0', 2 - LEN(CAST(MONTH(@Data) AS VARCHAR))) + CAST(MONTH(@Data) AS VARCHAR)
	+ REPLICATE('0', 2 - LEN(CAST(DAY(@Data) AS VARCHAR))) + CAST(DAY(@Data) AS VARCHAR)
END
GO
