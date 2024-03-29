ALTER VIEW MVA_PERMGRPMSG AS 
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR	ALTERACAO
-- 1.0001	26/04/2013	BRUNO	CRIACAO
-- 1.0002   08/07/2015  tiago   retirado codigo de grupo que estava fixo
---------------------------------------------------------------------------------------------------
SELECT DISTINCT
       NULL usuarioDestino_PGMSG,
       MSGM2.CODIGO_GRUPO_MENSAGEM grupoDestino_PGMSG,
       usur.usuario
  FROM DB_GRUPOMSG_MEMBROS MSGM2, db_usuario usur
 WHERE     MSGM2.TIPO = 0
       AND MSGM2.CODIGO_GRUPO_MENSAGEM IN
										  (SELECT MSGM1.CODIGO_GRUPO_MSG_PERM
											 FROM DB_GRUPOMSG_MEMBROS MSGM1
											WHERE     MSGM1.TIPO = 1
												  AND MSGM1.CODIGO_GRUPO_MENSAGEM IN
														 (SELECT MSGM.CODIGO_GRUPO_MENSAGEM
															FROM DB_USUARIO USU, DB_GRUPOMSG_MEMBROS MSGM
														   WHERE     USU.USUARIO = usur.usuario
																 AND MSGM.TIPO = 0
																 AND MSGM.CODIGO_USUARIO = USU.CODIGO))
UNION
SELECT DISTINCT userr.USUARIO, 
       NULL, 
	   usua.usuario
  FROM db_usuario userr, db_usuario usua
 WHERE userr.CODIGO IN
          (SELECT codigo_usuario
             FROM DB_GRUPOMSG_MEMBROS MSGM1
            WHERE MSGM1.TIPO = 1
              AND codigo_usuario != 0
              AND MSGM1.CODIGO_GRUPO_MENSAGEM IN
												 (SELECT MSGM.CODIGO_GRUPO_MENSAGEM
													FROM DB_USUARIO USU, DB_GRUPOMSG_MEMBROS MSGM
												   WHERE     USU.USUARIO = usua.usuario
														 AND MSGM.TIPO = 0
														 AND MSGM.CODIGO_USUARIO = USU.CODIGO))
union
select NULL usuarioDestino_PGMSG,
	   MSGM.CODIGO_GRUPO_MENSAGEM grupoDestino_PGMSG,
	   usu.usuario
  FROM DB_USUARIO USU, DB_GRUPOMSG_MEMBROS MSGM
 WHERE MSGM.TIPO = 0
   AND MSGM.CODIGO_USUARIO = USU.CODIGO
union
SELECT DISTINCT userr.USUARIO, 
				NULL, 
	   			usua.usuario
  FROM db_usuario userr, db_usuario usua
 WHERE userr.CODIGO_ACESSO IN
          (SELECT distinct R.DB_EREG_REPRES
			FROM 
		 		 DB_USUARIO USU,
		 		 DB_ESTRUT_REGRA R,
		 		 DB_ESTRUT_VENDA V,
		 		 DB_USUARIO USU_in,
		 		 DB_FILTRO_USUARIO usu_filtro
  		  WHERE usua.USUARIO = usu.USUARIO
		and usu.CODIGO <> USU_in.CODIGO
		AND V.DB_EVDA_ESTRUTURA = usu.ESTRUTURA_NIVEL_REPRESENTANTE
		AND R.DB_EREG_ESTRUTURA = V.DB_EVDA_ESTRUTURA
		AND R.DB_EREG_ID = DB_EVDA_ID
		AND usu_filtro.ID_FILTRO = 'MENSAGEMESTRUTMOB' AND usu_filtro.VALOR_NUM = 1 AND usu_filtro.CODIGO_USUARIO = usu.CODIGO		
		and USU_in.CODIGO_ACESSO = DB_EREG_REPRES
		AND V.DB_EVDA_CODIGO LIKE SUBSTRING((SELECT venda.DB_EVDA_CODIGO from DB_ESTRUT_VENDA venda WHERE venda.DB_EVDA_ID = usu.NIVEL_REPRESENTANTE and venda.db_evda_estrutura  = usu.estrutura_nivel_representante),
		1,
		LEN((SELECT venda.DB_EVDA_CODIGO from DB_ESTRUT_VENDA venda WHERE venda.DB_EVDA_ID = usu.NIVEL_REPRESENTANTE and venda.db_evda_estrutura  = usu.estrutura_nivel_representante)) - 3) + '%')
