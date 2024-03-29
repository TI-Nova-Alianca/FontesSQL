---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	03/07/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_NOTIFICACOESANEXOS AS
SELECT CODIGO    CODIGO_NOTA,
       SEQUENCIA SEQUENCIA_NOTA,
	   NOME_ARQUIVO   NOMEARQUIVO_NOTA,
	   NOTIF.dataalter,
	   NOTIF.USUARIO
  FROM DB_NOTIFICACAO_ANEXOS
     , MVA_NOTIFICACOES NOTIF
 WHERE NOTIF.CODIGO_NOT = DB_NOTIFICACAO_ANEXOS.CODIGO
