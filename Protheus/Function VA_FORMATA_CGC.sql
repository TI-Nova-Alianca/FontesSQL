SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 23/06/2010
-- Description:	Formata CPF/CNPJ para impressao
-- =============================================
ALTER FUNCTION [dbo].[VA_FORMATA_CGC]
(
	@CGC AS VARCHAR(14)
)
RETURNS VARCHAR (18)
AS
	BEGIN
	DECLARE @RET VARCHAR (18);
		--SET @RET = ''
		IF LEN(@CGC) = 14
		BEGIN
		    SET @RET = SUBSTRING(@CGC, 1, 2) + '.' + SUBSTRING(@CGC, 3, 3) + '.' + SUBSTRING(@CGC, 6, 3) + '/' + SUBSTRING(@CGC, 9, 4) + '-' + SUBSTRING(@CGC, 13, 2)
		END
		ELSE
		BEGIN
		    IF LEN(@CGC) = 11
		    BEGIN
		        SET @RET = SUBSTRING(@CGC, 1, 3) + '.' + SUBSTRING(@CGC, 4, 3) + '.' + SUBSTRING(@CGC, 7, 3) + '-' + SUBSTRING(@CGC, 10, 2)
		    END
		END
		
		RETURN @RET
	END
GO
