ALTER VIEW MVA_GRUPOS_MENSAGEM AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR	ALTERACAO
-- 1.0001	26/04/2013	BRUNO	CRIACAO
---------------------------------------------------------------------------------------------------
SELECT DISTINCT
       GRP.CODIGO codigo_GMSG, GRP.NOME nome_GMSG, usuf.USUARIO usuario
  FROM DB_GRUPO_MENSAGEM GRP, DB_USUARIO usuf
 WHERE GRP.CODIGO IN
          (SELECT MSGM1.CODIGO_GRUPO_MSG_PERM
             FROM DB_GRUPOMSG_MEMBROS MSGM1
            WHERE     MSGM1.TIPO = 1
                  AND MSGM1.CODIGO_GRUPO_MENSAGEM IN
                         (SELECT MSGM.CODIGO_GRUPO_MENSAGEM
                            FROM DB_USUARIO USU, DB_GRUPOMSG_MEMBROS MSGM
                           WHERE     USU.USUARIO = usuf.usuario
                                 AND MSGM.TIPO = 0
                                 AND MSGM.CODIGO_USUARIO = USU.CODIGO))
UNION ALL
SELECT DISTINCT GRP.CODIGO codigo_GMSG, GRP.NOME nome_GMSG, usuf.usuario
  FROM DB_GRUPO_MENSAGEM GRP, DB_USUARIO usuf
 WHERE GRP.CODIGO IN
          (SELECT MSGM.CODIGO_GRUPO_MENSAGEM
             FROM DB_USUARIO USU, DB_GRUPOMSG_MEMBROS MSGM
            WHERE     USU.USUARIO = usuf.usuario
                  AND MSGM.TIPO = 0
                  AND MSGM.CODIGO_USUARIO = USU.CODIGO)
