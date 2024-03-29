ALTER VIEW  MVA_CONVERSAMSG AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR		ALTERACAO
-- 1.0000	03/04/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001       15/05/2013      bruno           alteracoes
-- 1.0002   08/07/2015  tiago           novo filtro na tabela db_grupomsg_restricoes
---------------------------------------------------------------------------------------------------
SELECT tab.CODIGO             CODIGO_COMSG,
       tab.CODIGO_CONVERSA    CODIGOCONVERSA_COMSG,
       tab.MENSAGEM           MENSAGEM_COMSG,
       tab.REMETENTE          REMETENTE_COMSG,
       tab.DATA_ENVIO         DATAENVIOMENSAGEM_COMSG,
       (SELECT max (data_exclusao)
          FROM DB_CONV_MSG_EXCLU
         WHERE CODIGO_MENSAGEM = tab.codigo AND PARTICIPANTE = usu.usuario)    DATAEXCLUSAO_COMSG,
       tab.DATA_ENVIO         DATAALTER,
       getdate()                dataEnvio_COMSG,
       1                      sincronizacao_COMSG,
       usu.usuario
  FROM DB_CONV_MENSAGEM tab, db_usuario usu
 WHERE tab.CODIGO_CONVERSA IN (SELECT CODIGO_CONVE
                                    FROM MVA_CONVERSA CON
                                   WHERE con.usuario = usu.usuario)
      and (tab.DATA_ENVIO <= (SELECT CON.DATASAIDA_CONVE
                                    FROM MVA_CONVERSA CON
                                   WHERE con.usuario = usu.usuario
                   and CON.CODIGO_CONVE = tab.CODIGO_CONVERSA
                                   and CON.PARTICIPANTE_CONVE =  usu.usuario)
                                   or not exists(SELECT CON.DATASAIDA_CONVE
                                    FROM MVA_CONVERSA CON
                                   WHERE con.usuario = usu.usuario
                   and CON.CODIGO_CONVE = tab.CODIGO_CONVERSA
                                   and isnull(CON.DATASAIDA_CONVE,'') != ''
                                   and CON.PARTICIPANTE_CONVE =  usu.usuario))
   and (exists (select 1
                 from db_grupomsg_restricoes, db_usuario des
                 where db_grupomsg_restricoes.usuario = usu.codigo
                   and des.usuario = tab.REMETENTE     
                   and des.codigo  = db_grupomsg_restricoes.usuario_permconversa   
                   or   tab.REMETENTE = usu.usuario)
       or (select 1 
             from db_grupomsg_restricoes 
            where db_grupomsg_restricoes.usuario = usu.codigo) is null)
