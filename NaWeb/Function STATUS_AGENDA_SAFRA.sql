-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER FUNCTION [dbo].[STATUS_AGENDA_SAFRA]
(	
	@ZE_SAFRA AS VARCHAR(4),
	@ZE_FILIAL AS VARCHAR(2),
	@ZE_CARGA AS VARCHAR(6)
)
RETURNS VARCHAR(3)
AS
BEGIN
	DECLARE @RET VARCHAR(3);

	SET @RET = (select distinct A.TrnAgeAgendaSit
				from LKSRV_NAWEB.naweb.dbo.TrnAgeAgenda A
					,LKSRV_NAWEB.naweb.dbo.TrnAgeTombador T
					,LKSRV_NAWEB.naweb.dbo.SFInspCarga I
				WHERE T.TrnAgeTombadorCod = A.TrnAgeTombadorCod
					AND I.InspCargaAgendaId = A.TrnAgeAgendaOri
					AND A.TrnAgeAgendaSafra = @ZE_SAFRA
					AND T.TrnAgeTombadorFil = @ZE_FILIAL
					AND I.InspCargaCod      = @ZE_CARGA
					)
	RETURN @RET
END




