CREATE   VIEW MVA_OC_ALCADAS
AS
(
		--------------------------------------------------------------------------- 
		---  VIEW PADRÃO DE ALÇADAS PARA OCORRÊNCIAS SQL SERVER 
		--------------------------------------------------------------------------- 
		---  Esta view tem como objetivo realizar a validação das permissões do usuário de acordo com a hierarquia comercial e alçadas.
		---  Normalmente é utilizada com a view padrão MVA_ODS_OCORRENCIAS. Ao utilizar, obrigatório filtrar por TIPO_ALCADA e aplicar a REGRA_ALCADA nas validações.
		--------------------------------------------------------------------------- 
		---  EXEMPLO DE JOIN
		---------------------------------------------------------------------------
		---	INNER JOIN MVA_OC_ALCADAS AR WITH (NOLOCK) ON AR.USUARIO = MVA_ODS_OCORRENCIAS.usuario
		---		AND (
		---			NULLIF(AR.empresa, '') IS NULL
		---			OR CHARINDEX(CONCAT (
		---					','
		---					,MVA_ODS_OCORRENCIAS.empresa
		---					,','
		---					), CONCAT (
		---					','
		---					,AR.emp
		---					,','
		---					)) > 0 /*VALIDAÇÕES DE EMPRESA*/
		---			)
		---		AND (
		---			NULLIF(AR.ramo, '') IS NULL
		---			OR CHARINDEX(CONCAT (
		---					','
		---					,MVA_ODS_OCORRENCIAS.ramo
		---					,','
		---					), CONCAT (
		---					','
		---					,AR.ramo
		---					,','
		---					)) > 0 /*VALIDAÇÕES DE RAMO*/
		---			)
		---		AND CASE /*VALIDAÇÕES DE ACESSO*/
		---			WHEN AR.regra_alcada = 0
		---				THEN '1' /* REGRA 0 - Todos os representantes   */
		---			WHEN AR.regra_alcada = 1 /* REGRA 1 - Apenas os representantes informados   */
		---				AND AR.alc_rep = MVA_ODS_OCORRENCIAS.representante
		---				THEN '1'
		---			WHEN AR.regra_alcada = 2 /* REGRA 2 - Exceto os representantes informados */
		---				AND AR.alc_rep NOT IN (MVA_ODS_OCORRENCIAS.representante)
		---				THEN '1'
		---			WHEN AR.regra_alcada = 3 /* REGRA 3 - Estrutura de Venda informada   */
		---				AND AR.alc_rep = MVA_ODS_OCORRENCIAS.representante
		---				THEN '1'
		---			WHEN AR.regra_alcada = 5 /* REGRA 5 - Apenas o representante vinculado a ocorrência  */
		---				AND (
		---					AR.usuario = MVA_ODS_OCORRENCIAS.usuario_criacao
		---					OR AR.alc_rep = MVA_ODS_OCORRENCIAS.representante
		---					)
		---				THEN '1'
		---			WHEN AR.regra_alcada = 7
		---				THEN '1' /* REGRA 7 - Usuários que podem visualizar todas as etapas */
		---			END = '1'
		---------------------------------------------------------------------------  
		--- 1.0001 06/03/2020  CARLOS   Implementação Inicial   
		--------------------------------------------------------------------------- 
		---   Lista todos os representantes vinculados à alçadas no Mercanet  
		---  db_alcp_opcrep (REGRA) 0 - Todos os representantes    
		---  REGRA 1 - Apenas os representantes informados     
		---  REGRA 2 - Exceto os representantes informados   
		SELECT DISTINCT Split.a.value('.', 'VARCHAR(100)') AS alc_rep
			,U.usuario AS usuario
			,A.db_alcp_codigo AS alc_cod
			,A.db_alcp_opcrep AS regra_alcada
			,A.db_alcp_vlrmaxlib AS valormax
			,A.db_alcp_vlrmaxlib + (A.db_alcp_vlrmaxlib * A.db_alcp_dctmaxexc) / 100 AS valormax_toler
			,A.db_alcp_vlrminlib AS valormin
			,A.db_alcp_vlrminlib - (A.db_alcp_vlrminlib * A.db_alcp_dctmaxexc) / 100 AS valormin_toler
			,A.db_alcp_dctmaxexc AS toler
			,A.db_alcp_grpalcada AS grupo
			,A.db_alcp_lstemp AS emp
			,A.db_alcp_lstramo AS ramo
			,A.db_alcp_nivellib AS nivel
			,A.db_alcp_tipo AS tipo_alcada
			,G.codigo AS grupo_ocorrencia
		FROM (
			SELECT db_alcp_codigo
				,db_alcp_opcrep
				,db_alcp_vlrmaxlib
				,db_alcp_vlrminlib
				,db_alcp_dctmaxexc
				,db_alcp_grpalcada
				,db_alcp_lstemp
				,db_alcp_lstramo
				,db_alcp_nivellib
				,Cast('<M>' + Replace(db_alcp_lstrep, ',', '</M><M>') + '</M>' AS XML) AS String
				,db_alcp_tipo
			FROM DB_ALCADA_PED WITH (NOLOCK)
			) AS A
		CROSS APPLY String.nodes('/M') AS SPLIT(a)
			,DB_USUARIO U WITH (NOLOCK)
			,DB_ALCADA_USUARIO UALC WITH (NOLOCK)
			,DB_ALCADA_PED WITH (NOLOCK)
			,DB_OC_GRUPOS_USUARIOS GU WITH (NOLOCK)
			,DB_OC_GRUPOS G WITH (NOLOCK)
		WHERE UALC.db_alcu_usuario = U.codigo
			AND UALC.db_alcu_alcada = A.db_alcp_codigo
			AND NOT EXISTS (
				SELECT 1
				FROM DB_ALCADA_ESTRUT AL WITH (NOLOCK)
				WHERE AL.db_alce_alcada = A.db_alcp_codigo
				)
			AND A.db_alcp_tipo = 8	
			AND U.codigo = GU.usuario
			AND G.codigo = GU.codigo_grupo
		
		UNION ALL
		
		---  Lista todos os representantes vinculados à alçadas com estrutura no Mercanet
		---  REGRA 3 - Estrutura de Venda informada  
		SELECT DISTINCT Z.db_ereg_repres AS alc_rep
			,U.usuario AS usuario
			,A.db_alcp_codigo AS alc_cod
			,'3' AS regra_alcada
			,A.db_alcp_vlrmaxlib AS valormax
			,A.db_alcp_vlrmaxlib + (A.db_alcp_vlrmaxlib * A.db_alcp_dctmaxexc) / 100 AS valormax_toler
			,A.db_alcp_vlrminlib AS valormin
			,A.db_alcp_vlrminlib - (A.db_alcp_vlrminlib * A.db_alcp_dctmaxexc) / 100 AS valormin_toler
			,A.db_alcp_dctmaxexc AS toler
			,A.db_alcp_grpalcada AS grupo
			,A.db_alcp_lstemp AS emp
			,A.db_alcp_lstramo AS ramo
			,A.db_alcp_nivellib AS nivel
			,A.db_alcp_tipo AS tipo_alcada
			,G.codigo AS grupo_ocorrencia
		FROM DB_ESTRUT_VENDA X WITH (NOLOCK)
			,DB_ESTRUT_VENDA Y WITH (NOLOCK)
			,DB_ESTRUT_REGRA Z WITH (NOLOCK)
			,DB_ESTRUT_REGRA Z1 WITH (NOLOCK)
			,DB_ALCADA_ESTRUT AL WITH (NOLOCK)
		INNER JOIN DB_ALCADA_PED A WITH (NOLOCK) ON A.db_alcp_tipo IN (0, 3)
			AND AL.db_alce_alcada = A.db_alcp_codigo
		INNER JOIN DB_ALCADA_USUARIO UALC WITH (NOLOCK) ON UALC.db_alcu_alcada = A.db_alcp_codigo
		INNER JOIN DB_USUARIO U WITH (NOLOCK) ON UALC.db_alcu_usuario = U.codigo
		INNER JOIN DB_OC_GRUPOS_USUARIOS GU WITH (NOLOCK) ON U.codigo = GU.usuario
		INNER JOIN DB_OC_GRUPOS G WITH (NOLOCK) ON G.codigo = GU.codigo_grupo
		WHERE X.db_evda_estrutura = Y.db_evda_estrutura
			AND Y.db_evda_codigo LIKE (X.db_evda_codigo + '%')
			AND X.db_evda_estrutura = Z.db_ereg_estrutura
			AND Y.db_evda_id = Z.db_ereg_id
			AND X.db_evda_estrutura = Z1.db_ereg_estrutura
			AND X.db_evda_id = Z1.db_ereg_id
			AND AL.db_alce_estrutura = Z1.db_ereg_estrutura
			AND AL.db_alce_id = Z1.db_ereg_id
			AND GU.codigo_grupo IN (7, 8)
			AND A.db_alcp_tipo = 8
		
		UNION ALL
		
		--  Lista apenas os representantes vinculados à clientes para que possam visualizar apenas as suas ocorrências
		--  REGRA 5 - Apenas o representante vinculado a ocorrência
		SELECT DISTINCT U.codigo_acesso AS alc_rep
			,U.usuario AS usuario
			,NULL AS alc_cod
			,'5' AS regra_alcada
			,0 AS valormax
			,0 AS valormax_toler
			,0 AS valormin
			,0 AS valormin_toler
			,0 AS toler
			,G.descricao AS grupo
			,NULL AS emp
			,NULL AS ramo
			,0 AS nivel
			,8 AS tipo_alcada
			,G.codigo AS grupo_ocorrencia
		FROM DB_USUARIO U WITH (NOLOCK)
		INNER JOIN DB_OC_GRUPOS_USUARIOS GU WITH (NOLOCK) ON U.codigo = GU.usuario
		INNER JOIN DB_OC_GRUPOS G WITH (NOLOCK) ON G.codigo = GU.codigo_grupo
		WHERE NOT EXISTS (
				SELECT 1
				FROM DB_ALCADA_USUARIO UALC WITH (NOLOCK)
				WHERE U.codigo = UALC.db_alcu_usuario
				)
			AND EXISTS (
				SELECT 1
				FROM DB_CLIENTE_REPRES DCR WITH (NOLOCK)
				WHERE U.codigo_acesso = DCR.db_clir_repres
				)
		
		UNION ALL
		
		--  Lista todos os usuários em grupos de ocorrência que não são representantes vinculados à clientes e não tem alçada cadastrada  
		--  REGRA 7 - Usuários que podem visualizar todas as etapas 
		SELECT DISTINCT U.codigo_acesso AS alc_rep
			,U.usuario AS usuario
			,NULL AS alc_cod
			,'7' AS regra_alcada
			,0 AS valormax
			,0 AS valormax_toler
			,0 AS valormin
			,0 AS valormin_toler
			,0 AS toler
			,G.descricao AS grupo
			,NULL AS emp
			,NULL AS ramo
			,0 AS nivel
			,8 AS tipo_alcada
			,G.codigo AS grupo_ocorrencia
		FROM DB_USUARIO U WITH (NOLOCK)
		INNER JOIN DB_OC_GRUPOS_USUARIOS GU WITH (NOLOCK) ON U.codigo = GU.usuario
		INNER JOIN DB_OC_GRUPOS G WITH (NOLOCK) ON G.codigo = GU.codigo_grupo
		WHERE NOT EXISTS (
				SELECT 1
				FROM DB_ALCADA_USUARIO UALC WITH (NOLOCK)
				WHERE U.codigo = UALC.db_alcu_usuario
				)
			AND NOT EXISTS (
				SELECT 1
				FROM DB_CLIENTE_REPRES DCR WITH (NOLOCK)
				WHERE U.codigo_acesso = DCR.db_clir_repres
				)
		)

