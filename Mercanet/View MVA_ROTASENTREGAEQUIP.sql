---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.000   27/04/2015   TIAGO           DESENVOLVIMENTO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ROTASENTREGAEQUIP as
 SELECT CODIGO_ROTA	    CODIGOROTA_RENTE,
		TRANSPORTADOR	TRANSPORTADOR_RENTE,
		EQUIPAMENTO	    EQUIPAMENTO_RENTE,
		PERCMINCARGA	PERCMINCARGA_RENTE
   FROM DB_ROTAENTEQUIP
