---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	01/07/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_USUARIOSNOTIFICA AS
 SELECT 0	             SEQUENCIA_USNOT,
		USUARIO_ENVIA	         USUARIOENVIA_USNOT,
		(select NOME from db_usuario where codigo = USUARIO_ENVIA)	             NOMEUSUARIO_USNOT,
		GRUPO_NOTIFICA	         GRUPONOTIFICACAO_USNOT,
		(select DB_GRUPO_NOTIFICA.NOME from DB_GRUPO_NOTIFICA where DB_GRUPO_NOTIFICA.CODIGO = DB_USUARIO_NOTIFICA.GRUPO_NOTIFICA)	 NOMEGRUPONOTIFICACAO_USNOT,
		USU.USUARIO
   FROM DB_USUARIO_NOTIFICA,       
		DB_USUARIO USU
  WHERE DB_USUARIO_NOTIFICA.CODIGO_USUARIO = USU.CODIGO
  union 
SELECT distinct 0 		  	SEQUENCIA_USNOT,
 				USU_in.CODIGO 		USUARIOENVIA_USNOT,
 				(select NOME from db_usuario where codigo = USU_in.CODIGO) 		NOMEUSUARIO_USNOT,
 				0 		GRUPONOTIFICACAO_USNOT,
 				null 	NOMEGRUPONOTIFICACAO_USNOT,
				USU.USUARIO
	FROM DB_USUARIO_NOTIFICA,
		 DB_USUARIO USU,
		 DB_ESTRUT_REGRA R,
		 DB_ESTRUT_VENDA V,
		 DB_USUARIO USU_in,
		 DB_FILTRO_USUARIO usu_filtro
  WHERE DB_USUARIO_NOTIFICA.CODIGO_USUARIO = usu.CODIGO
		and usu.CODIGO <> USU_in.CODIGO
		and V.DB_EVDA_ESTRUTURA = usu.ESTRUTURA_NIVEL_REPRESENTANTE
		AND R.DB_EREG_ESTRUTURA = V.DB_EVDA_ESTRUTURA
		AND R.DB_EREG_ID = DB_EVDA_ID
		AND usu_filtro.ID_FILTRO = 'NOTIFICACAOESTRUTMOB' AND usu_filtro.VALOR_NUM = 1 AND usu_filtro.CODIGO_USUARIO = usu.CODIGO
		and DB_USUARIO_NOTIFICA.CODIGO_USUARIO > 0
		and USU_in.CODIGO_ACESSO = DB_EREG_REPRES
		AND V.DB_EVDA_CODIGO LIKE SUBSTRING((SELECT venda.DB_EVDA_CODIGO from DB_ESTRUT_VENDA venda WHERE venda.DB_EVDA_ID = usu.NIVEL_REPRESENTANTE and venda.db_evda_estrutura  = usu.estrutura_nivel_representante),
		1,
		LEN((SELECT venda.DB_EVDA_CODIGO from DB_ESTRUT_VENDA venda WHERE venda.DB_EVDA_ID = usu.NIVEL_REPRESENTANTE and venda.db_evda_estrutura  = usu.estrutura_nivel_representante)) - 3) + '%'
