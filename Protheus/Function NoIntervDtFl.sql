SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author     : Robert Koch
-- Create date: 24/09/2009
-- Description:	Verifica se uma data encontra-se dentro do intervalo
--              informado e retorna tipo float se estiver.
-- =============================================
ALTER FUNCTION [dbo].[NoIntervDtFl]
(
	@Dado AS VARCHAR (8),
	@Inicio AS VARCHAR (8),
	@Fim as VARCHAR (8),
	@SeSim AS FLOAT,
	@SeNao AS FLOAT
)
RETURNS FLOAT
AS
BEGIN
	if (@Dado >= @Inicio and @Dado <= @Fim)
		RETURN @SeSim;
	RETURN @SeNao;
END
GO
