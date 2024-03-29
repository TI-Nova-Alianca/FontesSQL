
ALTER TRIGGER TrnEvento_UDP 
    ON naweb.dbo.TrnEvento  AFTER UPDATE AS	BEGIN

   INSERT INTO naweb.dbo.TrnEvento_LOG(EventoMODO,  EventoDHInteracao, EventoId, 
	   EventoFilial, EventoSetor,  EventoInicio, EventoFim, 
	   EventoTitulo, EventoDetalhes, EventoStatus, EventoNumCarga, 
	   EventoNumPedVend, EventoNumPedComp, EventoUsuInseriu, EventoUsuLOG, EventoObservacao)

   SELECT 'ALTERADO', GETDATE(), U.EventoId, 
	   U.EventoFilial, U.EventoSetor,  U.EventoInicio, U.EventoFim, 
	   U.EventoTitulo, U.EventoDetalhes, U.EventoStatus, U.EventoNumCarga, 
	   U.EventoNumPedVend, U.EventoNumPedComp,U.EventoUsuario, U.EventoUsuLOG, U.EventoObservacao
    FROM INSERTED AS U

END
