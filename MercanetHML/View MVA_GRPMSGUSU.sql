ALTER VIEW MVA_GRPMSGUSU AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR	ALTERACAO
-- 1.0001	26/04/2013	BRUNO	CRIACAO
---------------------------------------------------------------------------------------------------
SELECT DISTINCT MSGM2.CODIGO_GRUPO_MENSAGEM codigo_GMSGU,
                USERM.USUARIO usuario_GMSGU,
                usere.usuario
  FROM DB_GRUPOMSG_MEMBROS MSGM2, DB_USUARIO USERM, db_usuario usere
 WHERE     MSGM2.TIPO = 0
       AND USERM.CODIGO = MSGM2.CODIGO_USUARIO
       AND MSGM2.CODIGO_GRUPO_MENSAGEM IN
              (SELECT MSGM1.CODIGO_GRUPO_MSG_PERM
                 FROM DB_GRUPOMSG_MEMBROS MSGM1
                WHERE     MSGM1.TIPO = 1
                      AND MSGM1.CODIGO_GRUPO_MENSAGEM IN
                             (SELECT MSGM.CODIGO_GRUPO_MENSAGEM
                                FROM DB_USUARIO USU, DB_GRUPOMSG_MEMBROS MSGM
                               WHERE     USU.USUARIO = usere.usuario
                                     AND MSGM.TIPO = 0
                                     AND MSGM.CODIGO_USUARIO = USU.CODIGO))
UNION ALL
SELECT DISTINCT MSGM2.CODIGO_GRUPO_MENSAGEM,
                USERM.USUARIO,
                usere.usuario
  FROM DB_GRUPOMSG_MEMBROS MSGM2, DB_USUARIO USERM, db_usuario usere
 WHERE     MSGM2.TIPO = 0
       AND USERM.CODIGO = MSGM2.CODIGO_USUARIO
       AND MSGM2.CODIGO_GRUPO_MENSAGEM IN
              (SELECT MSGM.CODIGO_GRUPO_MENSAGEM
                 FROM DB_USUARIO USU, DB_GRUPOMSG_MEMBROS MSGM
                WHERE     USU.USUARIO = usere.usuario
                      AND MSGM.TIPO = 0
                      AND MSGM.CODIGO_USUARIO = USU.CODIGO)
