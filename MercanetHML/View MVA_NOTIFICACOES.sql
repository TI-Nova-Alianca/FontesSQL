---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	01/07/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_NOTIFICACOES  AS
 SELECT N.CODIGO	             CODIGO_NOT,
		USUARIO_ENVIO	         USUARIOENVIO_NOT,
		USUARIO_DESTINATARIO	 USUARIODESTINATARIO_NOT,
		GRUPO_DESTINATARIO	     GRUPODESTINATARIO_NOT,
		MENSAGEM	             MENSAGEM_NOT,
		DATA_ENVIO	             DATAENVIO_NOT,
		DATA_VISUALIZACAO	     dataVisualizada_NOT,
		(select nome from db_usuario where codigo = USUARIO_ENVIO) nomeUsuarioEnvia_NOT,	
		getdate()                dataSincronizacao_NOT,
		0                        sincronizacao_NOT,	
		N.CODIGO                 codigoWeb_NOT,	
		tipo_notificacao		 tipoNotificacao_NOT,
		ACAO					 acao_NOT,
		PARAMETRO_NUM			 parametroNum_NOT,
		ASSUNTO					 assunto_NOT,
		VALIDADENOTMOB			 validadeNotMob_NOT,
		CODIGO_FLUXO			 codigoFluxo_NOT,
		CODIGO_ETAPA			 codigoEtapa_NOT,
		CODIGO_CLIENTE			 codigoCliente_NOT,
		DATA_ENVIO    dataalter,
		usu.usuario
   FROM DB_NOTIFICACAO N, DB_USUARIO USU
  WHERE (USU.CODIGO = N.USUARIO_DESTINATARIO 
    and USUARIO_ENVIO <> usu.CODIGO
     or exists (select * from DB_GRUPONOTI_USUARIOS where DB_GRUPONOTI_USUARIOS.CODIGO_GRUPO = GRUPO_DESTINATARIO and DB_GRUPONOTI_USUARIOS.CODIGO_USUARIO = usu.CODIGO  and USUARIO_ENVIO <> usu.CODIGO))
	 and DATA_ENVIO >= (getdate() -(select cast(isnull(DB_PRMS_VALOR, 0) as int) from DB_PARAM_SISTEMA where DB_PRMS_ID = 'MOB_NUMDIASENVIANOTIFICA'))
