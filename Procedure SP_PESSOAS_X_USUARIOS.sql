USE TI
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Cooperativa Agroindustrial Nova Alianca Ltda
-- Procedure para listar de forma amigavel os relacionamentos entre pessoas (Metadados) e usuarios/acessos a diferentes sistemas.
-- Autor: Robert Koch
-- Data:  31/03/2021
-- Historico de alteracoes:
-- 04/05/2021 - Daiana - Passa a gerar saida em HTML para melhor visualizacao no NaWeb
--
-- Exemplo de uso:
-- declare @resultado varchar (max);
-- exec SP_PESSOAS_X_USUARIOS 'julian', '', @RET = @resultado output
-- print @resultado
--

ALTER procedure [dbo].[SP_PESSOAS_X_USUARIOS]
(
    @IN_PARTE_NOME1 VARCHAR (80),
    @IN_PARTE_NOME2 VARCHAR (80),
	@RET VARCHAR(max) output --DAY 04/05/21
 ) AS
BEGIN
    SET NOCOUNT ON


--	DECLARE @IN_NOME VARCHAR (80) = 'RAMBO'
--	DECLARE @RET VARCHAR(max)


    DECLARE @PESSOAS_ENCONTRADAS       INT
    DECLARE @META_PESSOA               INT
    DECLARE @META_DESCRI_SITUACAO      VARCHAR (15)
    DECLARE @META_OP05                 VARCHAR (40)
    DECLARE @META_SETOR                VARCHAR (20)
    DECLARE @META_FUNCAO               VARCHAR (8)
    DECLARE @META_DESCRI_FUNCAO        VARCHAR (20)
    DECLARE @EmployeeID_para_AD        VARCHAR (15)
    DECLARE @Cargo_para_Protheus       VARCHAR (40)
    DECLARE @AD_ACCOUNTNAME            VARCHAR (20)
    DECLARE @AD_ENABLED                VARCHAR (1)
    DECLARE @NOME_COMPLETO             VARCHAR (80)
    DECLARE @PROTHEUS_ID               VARCHAR (6)
    DECLARE @PROTHEUS_USER             VARCHAR (20)
    DECLARE @PROTHEUS_NOME             VARCHAR (40)
    DECLARE @PROTHEUS_SITUACAO         VARCHAR (10)
    DECLARE @PROTHEUS_AUTENTIC_DOMINIO VARCHAR (50)
    --DECLARE @PROTHEUS_PERFIS           VARCHAR (MAX)
	--DECLARE @PROTHEUS_ID_GRUPO         VARCHAR (6)
    --DECLARE @PROTHEUS_FILIAIS          VARCHAR (MAX)
    DECLARE @NAWEB_ID                  VARCHAR (6)
    DECLARE @NAWEB_USER                VARCHAR (20)
    DECLARE @NAWEB_PERFIS              VARCHAR (MAX)
    
    SET @RET = ''--DAY 04/05/21
	--SET @RET = '<body style="font-family: ''' + 'Courier New' + '''">'

	SET @IN_PARTE_NOME1 = ISNULL (@IN_PARTE_NOME1, '')
	SET @IN_PARTE_NOME2 = ISNULL (@IN_PARTE_NOME2, '')

    --CRIA TABELA TEMPORARIA DE PESSOAS A SEREM LISTADAS
	SELECT ROW_NUMBER() OVER (ORDER BY NOME_FOLHA, AD_ACCOUNTNAME, PROTHEUS_NOME) AS REGISTRO  -- CHAVE UNICA
		, *
	INTO #PESSOAS 
	FROM VISAO_GERAL_ACESSOS
	WHERE (
	   UPPER (NOME_FOLHA)     LIKE '%' + @IN_PARTE_NOME1 + '%'
	OR UPPER (AD_ACCOUNTNAME) LIKE '%' + @IN_PARTE_NOME1 + '%'
	OR UPPER (PROTHEUS_USER)  LIKE '%' + @IN_PARTE_NOME1 + '%'
	OR UPPER (PROTHEUS_NOME)  LIKE '%' + @IN_PARTE_NOME1 + '%'
	OR UPPER (NAWEB_USER)     LIKE '%' + @IN_PARTE_NOME1 + '%')
	AND (
	   UPPER (NOME_FOLHA)     LIKE '%' + @IN_PARTE_NOME2 + '%'
	OR UPPER (AD_ACCOUNTNAME) LIKE '%' + @IN_PARTE_NOME2 + '%'
	OR UPPER (PROTHEUS_USER)  LIKE '%' + @IN_PARTE_NOME2 + '%'
	OR UPPER (PROTHEUS_NOME)  LIKE '%' + @IN_PARTE_NOME2 + '%'
	OR UPPER (NAWEB_USER)     LIKE '%' + @IN_PARTE_NOME2 + '%')
	
	ORDER BY NOME_FOLHA

	SET @PESSOAS_ENCONTRADAS = (SELECT COUNT (*) FROM #PESSOAS)
	IF (@PESSOAS_ENCONTRADAS = 0)
	BEGIN
		SET @RET += '<p><strong>NAO FOI ENCONTRADA NENHUMA PESSOA DENTRO DOS CRITERIOS ESPECIFICADOS.</strong></p>'
	END

	-- SE ENCONTROU MUITAS PESSOAS, RETORNA AVISO DE ERRO.
	ELSE IF (@PESSOAS_ENCONTRADAS > 6)
	BEGIN
		SET @RET += '<p><strong>FORAM ENCONTRADAS MUITAS (' + CAST (@PESSOAS_ENCONTRADAS AS NVARCHAR) + ') PESSOAS! ESPECIFIQUE UM FILTRO MELHOR.</strong></p>'
	
		-- SE ENCONTROU "NEM TANTAS PESSOAS", RETORNA UMA LISTA DE NOMES.
		IF (@PESSOAS_ENCONTRADAS < 30)
		BEGIN
			SET @RET += '<pre>'
			WHILE EXISTS (SELECT TOP 1 NULL    FROM #PESSOAS)
			BEGIN
				SELECT TOP 1  @AD_ACCOUNTNAME            = ISNULL (RTRIM (AD_ACCOUNTNAME), '')
							, @NOME_COMPLETO             = ISNULL (RTRIM (NOME_FOLHA), '')
							, @META_SETOR                = ISNULL (RTRIM (SETOR_FOLHA), '')
							, @META_DESCRI_SITUACAO      = ISNULL (RTRIM (DESCRI_SITUACAO_FOLHA), '')
							, @PROTHEUS_USER             = ISNULL (RTRIM (PROTHEUS_USER), '')
							, @PROTHEUS_NOME             = ISNULL (RTRIM (PROTHEUS_NOME), '')
							, @NAWEB_USER                = ISNULL (NAWEB_USER, '')
				FROM #PESSOAS
				ORDER BY REGISTRO
			--	SET @RET += '<[METADADOS: ' + RTRIM (@NOME_COMPLETO) + ' (' + RTRIM (@META_SETOR) + ')] [AD: ' + RTRIM (@AD_ACCOUNTNAME) + '] [PROTHEUS: ' + RTRIM (@PROTHEUS_USER) + '/' + RTRIM (@PROTHEUS_NOME) + '] [NAWEB: ' + RTRIM (@NAWEB_USER) + ']</br>'
				SET @RET += '<[METADADOS: ' + RTRIM (@NOME_COMPLETO) + ' (' + RTRIM (@META_SETOR) + ')(' + RTRIM (@META_DESCRI_SITUACAO) + ')] [AD: ' + RTRIM (@AD_ACCOUNTNAME) + '] [PROTHEUS: ' + RTRIM (@PROTHEUS_USER) + '/' + RTRIM (@PROTHEUS_NOME) + '] [NAWEB: ' + RTRIM (@NAWEB_USER) + ']</br>'
				DELETE #PESSOAS WHERE REGISTRO = (SELECT MIN (REGISTRO) FROM #PESSOAS)
			END
			SET @RET += '</pre>'
		END
	END
	ELSE
	BEGIN
		-- PERCORRE A TABELA TEMPORARIA DE PESSOAS. A CADA UMA PROCESSADA, APAGA-A DA TABELA.
		WHILE EXISTS (SELECT TOP 1 NULL    FROM #PESSOAS)
		BEGIN
			SELECT TOP 1  @META_PESSOA               = ISNULL (PESSOA_FOLHA, '')
						, @META_DESCRI_SITUACAO      = ISNULL (RTRIM (DESCRI_SITUACAO_FOLHA), '')
						, @META_OP05                 = ISNULL (RTRIM (OP05_FOLHA) + '-' + RTRIM (DESC_OP05_FOLHA), 'Nao informado (assume situacao folha)')
						, @META_SETOR                = ISNULL (RTRIM (SETOR_FOLHA), '')
						, @META_FUNCAO               = ISNULL (RTRIM (FUNCAO), '')
						, @META_DESCRI_FUNCAO        = ISNULL (RTRIM (DESC_FUNCAO), '')
						, @AD_ACCOUNTNAME            = ISNULL (RTRIM (AD_ACCOUNTNAME), '')
						, @AD_ENABLED                = ISNULL (AD_ENABLED, '')
						, @NOME_COMPLETO             = ISNULL (RTRIM (NOME_FOLHA), '')
						, @PROTHEUS_ID               = ISNULL (PROTHEUS_ID, '')
						, @PROTHEUS_USER             = ISNULL (RTRIM (PROTHEUS_USER), '')
						, @PROTHEUS_NOME             = ISNULL (RTRIM (PROTHEUS_NOME), '')
						, @PROTHEUS_AUTENTIC_DOMINIO = ISNULL (RTRIM (PROTHEUS_AUTENTIC_DOMINIO), '')
						, @PROTHEUS_SITUACAO         = ISNULL (PROTHEUS_SITUACAO, '')  --						, @PROTHEUS_PERFIS           = ISNULL (PROTHEUS_PERFIS, '')     --, @PROTHEUS_FILIAIS          = ISNULL (PROTHEUS_FILIAIS, '')
						, @EmployeeID_para_AD        = ISNULL (EmployeeID_para_AD, '')
						, @Cargo_para_Protheus       = ISNULL (Cargo_para_Protheus, '')
						, @NAWEB_ID                  = ISNULL (RTRIM (CAST (NAWEB_ID AS VARCHAR (MAX))), '')
						, @NAWEB_USER                = ISNULL (NAWEB_USER, '')
						, @NAWEB_PERFIS              = ISNULL (NAWEB_PERFIS, '')
			FROM #PESSOAS
			ORDER BY REGISTRO

			-- Abre um paragrafo no HTML de retorno para mostrar dados do RH
			SET @RET += '<p><strong>Registros no RH</strong></p>'
			SET @RET += '<pre style="padding-left: 40px;">'

			IF (@META_PESSOA = '')
			BEGIN
				SET @RET += 'Nada consta.</br>'
			END
			ELSE
			BEGIN
				SET @RET += 'Pessoa..: ' + FORMAT (@META_PESSOA, 'G') + ' </br>'
				SET @RET += 'Nome....: ' + @NOME_COMPLETO + ' </br>'
				SET @RET += 'Setor...: ' + @META_SETOR + ' </br>'
				SET @RET += 'Funcao..: ' + @META_FUNCAO + ' (' + @META_DESCRI_FUNCAO + ') </br>'
				SET @RET += 'Situacao: ' + ISNULL (@META_DESCRI_SITUACAO, '') + '</br>'
				SET @RET += 'Bloqueio: ' + @META_OP05 + '</br>'
			END
			SET @RET += '</pre>'

			
			SET @RET += '<p><br><strong>ACTIVE DIRECTORY</strong></p>'--DAY 04/05/21 - RETORNANDO UMA VARIAVEL COM O CONTEUDO DO TEXTO
			SET @RET += '<pre style="padding-left: 40px;">'
			IF (@AD_ACCOUNTNAME = '')
			BEGIN
				SET @RET += 'Nada consta (ao criar novo usuario, informar "' + @EmployeeID_para_AD + '" no atributo EmployeeID)' + '</br>'
			END
			ELSE
			BEGIN
				SET @RET += 'Username: ' + @AD_ACCOUNTNAME + ' </br>'
				SET @RET += 'Situacao: ' + CASE WHEN @AD_ENABLED != 'S' THEN 'Bloqueado' ELSE 'Ativo' END + '</br>'
			END
			SET @RET += '</pre>'


			-- Abre um paragrafo no HTML de retorno para mostrar dados do Protheus
			SET @RET += '<p><br><strong>PROTHEUS</strong></p>'
			SET @RET += '<pre style="padding-left: 40px;">'
			IF (@PROTHEUS_USER = '')
			BEGIN
				SET @RET += 'Nada consta. Ao criar novo usuario, informar "' + @Cargo_para_Protheus + '" no campo CARGO do configurador.' + '</br>'
			END
			ELSE
			BEGIN
				SET @RET += 'ID......: ' + @PROTHEUS_ID + ' (' + ISNULL (@PROTHEUS_SITUACAO, '') + ')' + '</br>'
				SET @RET += 'Username: ' + @PROTHEUS_USER + CASE WHEN @PROTHEUS_AUTENTIC_DOMINIO = '/' THEN '' ELSE ' [' + @PROTHEUS_AUTENTIC_DOMINIO + ']' END + '</br>'
				SET @RET += 'Nome....: ' + ISNULL (@PROTHEUS_NOME, '') + '</br>'
			--	SET @RET += 'Grupos x privilegios:</br>'

				-- CRIA TABELA TEMPORARIA DE GRUPOS DESTE USUARIO NO PROTHEUS.
				SELECT ROW_NUMBER() OVER (ORDER BY GU.USR_PRIORIZA, GU.R_E_C_N_O_) AS REGISTRO  -- SEGUNDO DOCUMENTACAO, O PRIMEIRO GRUPO 'MANDA MAIS' QUANDO NAO TEM PRIORIZACAO: https://tdn.totvs.com/display/public/PROT/Configurar+dias+de+troca+da+Data+Base+do+Sistema
					, GU.USR_ID, GP.GR__ID, GP.GR__NOME, GU.USR_PRIORIZA
				INTO #PROTHEUS_GRUPOS_DO_USUARIO
				FROM LKSRV_PROTHEUS.protheus.dbo.SYS_GRP_GROUP GP,
					LKSRV_PROTHEUS.protheus.dbo.SYS_USR_GROUPS GU
				WHERE GP.D_E_L_E_T_ = ''
				AND GU.D_E_L_E_T_ = ''
				--AND GP.GR__CODIGO NOT LIKE 'Fili%'  -- Nao quero listar aqui os grupos que representam acesso a filiais.
				AND GU.USR_ID = @PROTHEUS_ID
				AND GP.GR__ID = GU.USR_GRUPO

				-- PERCORRE A TABELA TEMPORARIA DE GRUPOS E ACRESCENTA TODOS `A STRING DE RETORNO.
				WHILE EXISTS (SELECT TOP 1 NULL FROM #PROTHEUS_GRUPOS_DO_USUARIO)
				BEGIN
				
					SET @RET += '    Grp.'
					SET @RET += (SELECT TOP 1 GR__ID + ' - ' + RTRIM (GR__NOME) + CASE WHEN USR_PRIORIZA = '1' THEN ' (priorizar)' ELSE '' END
								FROM #PROTHEUS_GRUPOS_DO_USUARIO
								ORDER BY REGISTRO)
					SET @RET += '<br>'

/*
					-- CRIA TABELA TEMPORARIA DE PRIVILEGIOS ASSOCIADOS A ESTE GRUPO.
					SELECT ROW_NUMBER () OVER (ORDER BY PRIVGRP.R_E_C_N_O_) AS REGISTRO
						,PRIV.RL__ID, PRIV.RL__DESCRI
					INTO #PROTHEUS_PRIVILEGIOS_DO_GRUPO
					FROM LKSRV_PROTHEUS.protheus.dbo.SYS_RULES PRIV
						INNER JOIN LKSRV_PROTHEUS.protheus.dbo.SYS_RULES_GRP_RULES PRIVGRP
						ON (PRIVGRP.D_E_L_E_T_ = '' AND PRIVGRP.GR__RL_ID = PRIV.RL__ID)
					WHERE PRIV.D_E_L_E_T_ = ''
					AND PRIVGRP.GROUP_ID = (SELECT TOP 1 GR__ID
											FROM #PROTHEUS_GRUPOS_DO_USUARIO
											ORDER BY REGISTRO)
					ORDER BY PRIVGRP.GR__RL_ID

					-- PERCORRE A TABELA TEMPORARIA DE PRIVILEGIOS DO GRUPO E ACRESCENTA TODOS `A STRING DE RETORNO.
					WHILE EXISTS (SELECT TOP 1 NULL FROM #PROTHEUS_PRIVILEGIOS_DO_GRUPO)
					BEGIN
				
						SET @RET += '        Priv.'
						SET @RET += (SELECT TOP 1 RL__ID + ' - ' + RTRIM (RL__DESCRI)
									FROM #PROTHEUS_PRIVILEGIOS_DO_GRUPO
									ORDER BY REGISTRO)
						SET @RET += '</br>'

						-- REMOVE O REGISTRO DA TABELA DE PRIVILEGIOS DO GRUPO
						DELETE #PROTHEUS_PRIVILEGIOS_DO_GRUPO WHERE REGISTRO = (SELECT MIN (REGISTRO) FROM #PROTHEUS_PRIVILEGIOS_DO_GRUPO)
					END
					DROP TABLE #PROTHEUS_PRIVILEGIOS_DO_GRUPO
*/

					-- CRIA TABELA TEMPORARIA DE PRIVILEGIOS ASSOCIADOS A ESTE GRUPO.
					SET @RET += (SELECT STRING_AGG ('        Priv.' + PRIV.RL__ID + ' - ' + RTRIM (PRIV.RL__DESCRI), '<br>') + '<br>'
					FROM LKSRV_PROTHEUS.protheus.dbo.SYS_RULES PRIV
						INNER JOIN LKSRV_PROTHEUS.protheus.dbo.SYS_RULES_GRP_RULES PRIVGRP
						ON (PRIVGRP.D_E_L_E_T_ = '' AND PRIVGRP.GR__RL_ID = PRIV.RL__ID)
					WHERE PRIV.D_E_L_E_T_ = ''
					AND PRIVGRP.GROUP_ID = (SELECT TOP 1 GR__ID
											FROM #PROTHEUS_GRUPOS_DO_USUARIO
											ORDER BY REGISTRO)
					--ORDER BY PRIVGRP.GR__RL_ID
					)







					-- REMOVE O REGISTRO DA TABELA DE GRUPOS
					DELETE #PROTHEUS_GRUPOS_DO_USUARIO WHERE REGISTRO = (SELECT MIN (REGISTRO) FROM #PROTHEUS_GRUPOS_DO_USUARIO)
				END
				DROP TABLE #PROTHEUS_GRUPOS_DO_USUARIO
			END
			SET @RET += '</pre>'


			SET @RET += '<p><br><strong>NaWeb:</strong></p>'
			SET @RET += '<pre style="padding-left: 40px;">'
			IF (@NAWEB_USER = '')
			BEGIN
				SET @RET += 'Nada consta</br>'
			END
			ELSE
			BEGIN
				SET @RET += 'ID......: ' + @NAWEB_ID + '</br>'
				SET @RET += 'Username: ' + @NAWEB_USER + ' </br>'
				SET @RET += 'Situacao: ' + CASE WHEN @AD_ENABLED != 'S' THEN ' bloqueado ' ELSE ' ativo ' END + ' (cfe. Active Directory)</br>'
				SET @RET += 'Perfis..: ' + @NAWEB_PERFIS + ' </br>'
			END
			SET @RET += '</pre>'

			-- LINHA PARA SEPARAR OS NOMES ENCONTRADOS
			SET @RET += '<p><br><br><strong>========================================================================</strong></p>'


			-- REMOVE O REGISTRO IMPRESSO DA TABELA.
			DELETE #PESSOAS WHERE REGISTRO = (SELECT MIN (REGISTRO) FROM #PESSOAS)
		END
		DROP TABLE #PESSOAS
	END
	SET @RET += '</body>'
--	print @RET

/* TESTES:
sp_help VISAO_GERAL_ACESSOS

declare @resultado varchar (max);
exec SP_PESSOAS_X_USUARIOS 'KATIA', 'NUNES', @RET = @resultado output
print @resultado

SELECT * FROM RHOPELOGIN
--SELECT * FROM RHPESSOALOGINAD
SELECT * FROM RHOPEDADOS

SELECT TOP 10 * FROM LKSRV_SIRH.SIRH.dbo.VA_VFUNCIONARIOS ORDER BY NOME

*/
END


GO
