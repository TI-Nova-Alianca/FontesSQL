ALTER VIEW MVA_AGENDA_LOGS AS 
 select CODIGO_AGENDAMENTO	codigoAgendamento_AGLOG,
		DATA				data_AGLOG,
		CAMPO				campo_AGLOG,
		DESCRICAO			descricao_AGLOG,
		DB_AG_LOGS.USUARIO	usuario_AGLOG,
		SEQUENCIA			sequencia_AGLOG,
		CODIGO_ATIVIDADE	codigoAtiv_AGLOG,
		getdate()			dataEnvio_AGLOG,
		MVA_AGENDA.usuario
   from DB_AG_LOGS, MVA_AGENDA
  where MVA_AGENDA.codigo_AGE = CODIGO_AGENDAMENTO
