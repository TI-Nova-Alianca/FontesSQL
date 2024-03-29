
	Create TRIGGER TrnEvento_INS_DEL_UDP
    ON naweb.dbo.TrnEvento
    AFTER INSERT, DELETE, UPDATE  AS BEGIN SET NOCOUNT ON;

    INSERT INTO naweb.dbo.TrnEvento_LOG(EventoMODO, EventoUsuarInteracao, EventoDHInteracao, EventoId, 
	   EventoFilial, EventoSetor,  EventoInicio, EventoFim, 
	   EventoTitulo, EventoDetalhes, EventoStatus, EventoNumCarga, 
	   EventoNumPedVend, EventoNumPedComp, EventoUsuario, EventoObservacao)

    SELECT 'INSERIDO', SUSER_NAME(), GETDATE(), i.EventoId, 
	   i.EventoFilial, i.EventoSetor,  i.EventoInicio, i.EventoFim, 
	   i.EventoTitulo, i.EventoDetalhes, i.EventoStatus, i.EventoNumCarga, 
	   i.EventoNumPedVend, i.EventoNumPedComp, i.EventoUsuario, i.EventoObservacao
    FROM inserted i

	  UNION ALL

	SELECT 'DELETADO', SUSER_NAME(), GETDATE(), D.EventoId, 
	   D.EventoFilial, D.EventoSetor,  D.EventoInicio, D.EventoFim, 
	   D.EventoTitulo, D.EventoDetalhes, D.EventoStatus, D.EventoNumCarga, 
	   D.EventoNumPedVend, D.EventoNumPedComp, D.EventoUsuario, D.EventoObservacao
    FROM DELETED AS D

	 UNION ALL

	SELECT 'ALTERADO', SUSER_NAME(), GETDATE(), D.EventoId, 
	   D.EventoFilial, D.EventoSetor,  D.EventoInicio, D.EventoFim, 
	   D.EventoTitulo, D.EventoDetalhes, D.EventoStatus, D.EventoNumCarga, 
	   D.EventoNumPedVend, D.EventoNumPedComp, D.EventoUsuario, D.EventoObservacao
    FROM DELETED AS D
END


