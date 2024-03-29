

ALTER TRIGGER [dbo].[TRIGGER_TRNAGEAGENDA_AFTERUPDATE]
ON [dbo].[TrnAgeAgenda]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Inserir na tabela de logs (TrnAgeAgenda_logs)
    INSERT INTO TrnAgeAgenda_LOGs(
		--[Log_chave],
		[Log_DtHoraLog],

		[LogDe_TrnAgeAgendaUsuCod],
		[LogDe_TrnAgeAgendaOri],
	    [LogDe_TrnAgeAgendaDatHor],
		[LogDe_TrnAgeTombadorCod],
		[LogDe_TrnAgeAgendaGruDes],
		[LogDe_TrnAgeAgendaAssNom],
		[LogDe_TrnAgeAgendaProDes],
		[LogDe_TrnAgeAgendaSit],
		[LogDe_TrnAgeAgendaQtdOri],
        [LogDe_TrnAgeAgendaSafra],

		[LogPara_TrnAgeAgendaUsuCod],
		[LogPara_TrnAgeAgendaOri],
	    [LogPara_TrnAgeAgendaDatHor],
		[LogPara_TrnAgeTombadorCod],
		[LogPara_TrnAgeAgendaGruDes],
		[LogPara_TrnAgeAgendaAssNom],
		[LogPara_TrnAgeAgendaProDes],
		[LogPara_TrnAgeAgendaSit],
		[LogPara_TrnAgeAgendaQtdOri],
        [LogPara_TrnAgeAgendaSafra]
  )
    SELECT
	GETDATE()
	,d.TrnAgeAgendaUsuCod
	,d.TrnAgeAgendaOri
	,d.TrnAgeAgendaDatHor
	,d.TrnAgeTombadorCod
	,d.TrnAgeAgendaGruDes
	,d.TrnAgeAgendaAssNom
	,d.TrnAgeAgendaProDes
	,d.TrnAgeAgendaSit
	,d.TrnAgeAgendaQtdOri
	,d.TrnAgeAgendaSafra
  
	,i.TrnAgeAgendaUsuCod
	,i.TrnAgeAgendaOri
	,i.TrnAgeAgendaDatHor
	,i.TrnAgeTombadorCod
	,i.TrnAgeAgendaGruDes
	,i.TrnAgeAgendaAssNom
	,i.TrnAgeAgendaProDes
	,i.TrnAgeAgendaSit
	,i.TrnAgeAgendaQtdOri
	,i.TrnAgeAgendaSafra

    FROM inserted i
    INNER JOIN deleted d ON i.TrnAgeAgendaCod = d.TrnAgeAgendaCod;

END;

