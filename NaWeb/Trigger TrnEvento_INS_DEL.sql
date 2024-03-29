create TRIGGER TrnEvento_INS_DEL
    ON naweb.dbo.TrnEvento
    AFTER INSERT, DELETE  AS BEGIN SET NOCOUNT ON;

    INSERT INTO naweb.dbo.TrnEvento_LOG(EventoMODO,  EventoDHInteracao, EventoId, 
	   EventoFilial, EventoSetor,  EventoInicio, EventoFim, 
	   EventoTitulo, EventoDetalhes, EventoStatus, EventoNumCarga, 
	   EventoNumPedVend, EventoNumPedComp, EventoUsuInseriu, EventoUsuLOG, EventoObservacao)

    SELECT 'INSERIDO',  GETDATE(), i.EventoId, 
	   i.EventoFilial, i.EventoSetor,  i.EventoInicio, i.EventoFim, 
	   i.EventoTitulo, i.EventoDetalhes, i.EventoStatus, i.EventoNumCarga, 
	   i.EventoNumPedVend, i.EventoNumPedComp,i.EventoUsuario,  i.EventoUsuLOG, i.EventoObservacao
    FROM INSERTED i

	  UNION ALL

	SELECT 'DELETADO', GETDATE(), D.EventoId, 
	   D.EventoFilial, D.EventoSetor,  D.EventoInicio, D.EventoFim, 
	   D.EventoTitulo, D.EventoDetalhes, D.EventoStatus, D.EventoNumCarga, 
	   D.EventoNumPedVend, D.EventoNumPedComp, D.EventoUsuario, D.EventoUsuLOG, D.EventoObservacao
    FROM DELETED AS D

END
