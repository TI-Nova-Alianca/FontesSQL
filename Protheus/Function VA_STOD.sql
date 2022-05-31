SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 14/11/2008
-- Description:	Converte campo de data do Microsiga (formato VarChar) para DateTime do SQL.
-- =============================================
ALTER FUNCTION [dbo].[VA_STOD]
(
	@StrData AS VARCHAR (8)
)
RETURNS datetime
AS
BEGIN
	if @StrData = ''
	begin
		set @StrData = '19000101'
	end
	RETURN convert (datetime, substring (@StrData, 5, 2) + '/' + substring (@StrData,7, 2) + '/' + substring (@StrData, 1, 4), 101)
END
GO
