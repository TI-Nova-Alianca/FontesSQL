---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR   ALTERACAO
-- 1.0001	02/01/2017	TIAGO 	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SOLICINVESTMOTIVO AS
select SOLIC_INVESTIMENTO     solicitacao_SOLINMOT
	  ,MOTIVO                 motivo_SOLINMOT
	  ,MVA_SOLICITACOESINVESTIMENTO.usuario
  from DB_SOLIC_INVESTIMENTO_MOTIVO,
       MVA_SOLICITACOESINVESTIMENTO
 where SOLIC_INVESTIMENTO = numero_SOLINV
