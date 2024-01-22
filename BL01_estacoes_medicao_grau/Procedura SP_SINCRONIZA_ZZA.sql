USE [BL01]
GO
/****** Object:  StoredProcedure [dbo].[SP_SINCRONIZA_ZZA]    Script Date: 18/01/2024 15:07:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- script a ser executado EM CADA ESTACAO DE MEDICAO DE GRAU
--
-- Descricao: Sincroniza tabela ZZA010 da estacao com a respectiva tabela no servidor.
--            A intencao eh deixar o programa BL01 (medicao de grau) trabalhando somente
--            com o SQL Express da estacao, para ganho de velocidade e para evitar que
--            o programa trave em caso de perda de conexao com o servidor.
-- Data.....: 18/01/2024
-- Autor....: Robert Koch
--
-- Historico de alteracoes:
--

ALTER PROCEDURE [dbo].[SP_SINCRONIZA_ZZA]
(
	@filial VARCHAR (2),
	@safra VARCHAR (4)
) AS
BEGIN

	-- Busca no servidor as novas cargas que ainda nao existem na estacao
	insert into BL01.dbo.ZZA010 (ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT, ZZA_STATUS, ZZA_NASSOC, ZZA_NPROD)
	select ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT, ZZA_STATUS, ZZA_NASSOC, ZZA_NPROD
	from LKSRV_SERVERSQL_BL01.protheus.dbo.ZZA010 servidor
	where servidor.ZZA_FILIAL = @filial COLLATE DATABASE_DEFAULT
	and servidor.ZZA_SAFRA = @safra COLLATE DATABASE_DEFAULT
	and not exists (select *
					from ZZA010 estacao
					where estacao.ZZA_FILIAL = servidor.ZZA_FILIAL COLLATE DATABASE_DEFAULT
					  and estacao.ZZA_SAFRA  = servidor.ZZA_SAFRA COLLATE DATABASE_DEFAULT
					  and estacao.ZZA_CARGA  = servidor.ZZA_CARGA COLLATE DATABASE_DEFAULT)


	-- Cria cursor para enviar cada registro da tabela ZZA local para o servidor. Isso por que
	-- quero gravar em cada registro um campo indicando data e hora em que foi enviado.
	SET NOCOUNT ON;
	declare @ZZAFILIAL varchar (2)
	declare @ZZASAFRA  varchar (4)
	declare @ZZACARGA  varchar (4)
	declare @ZZASTATUS varchar (1)
	declare @ZZAGRAU float
	declare @ZZAINIST2 varchar (17)
	declare @ZZAINIST3 varchar (17)

	declare tblcur CURSOR STATIC LOCAL FOR

		-- Busca registros ainda nao enviado (null) e os enviados recentemente (isso por que
		-- quero ter a certeza de reenviar algum registro que possa ter sido perdido em
		-- execucoes anteriores por falta de conectividade. Quando eu conseguir operar com
		-- controle de transacoes entre servidores, espero nao precisar mais disso...)
		select ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_STATUS, ZZA_GRAU, ZZA_INIST2, ZZA_INIST3
		from BL01.dbo.ZZA010 estacao
		where (ENVIADO_PARA_SERVIDOR is null
			or ENVIADO_PARA_SERVIDOR > DATEADD (HOUR, -1, getdate()))
		and exists (select *
						from LKSRV_SERVERSQL_BL01.protheus.dbo.ZZA010 servidor
						where servidor.ZZA_FILIAL = estacao.ZZA_FILIAL COLLATE DATABASE_DEFAULT
						  and servidor.ZZA_SAFRA  = estacao.ZZA_SAFRA  COLLATE DATABASE_DEFAULT
						  and servidor.ZZA_CARGA  = estacao.ZZA_CARGA  COLLATE DATABASE_DEFAULT
						  and servidor.ZZA_STATUS in ('1', '2')  -- Nao quero reenviar se jah teve alguma alteracao no servidor
						  and servidor.ZZA_GRAU   = 0  -- Nao quero reenviar se jah teve alguma alteracao no servidor
						 )
		order by ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA
	OPEN tblcur
	WHILE 1 = 1
	BEGIN
		FETCH tblcur INTO @ZZAFILIAL, @ZZASAFRA, @ZZACARGA, @ZZASTATUS, @ZZAGRAU, @ZZAINIST2, @ZZAINIST3

		IF @@fetch_status <> 0
			BREAK

		print 'Processando carga ' + @ZZACARGA;

		/* Nao vou aplicar este UPDATE antes de um bom backup. Sacumé...
		-- LEMBRAR DE VER SE A TRIGGER DOS HORARIOS VAI PERMITIR A CORRENAT SINCRONIZACAO DE HORARIOS!!!!
		update LKSRV_SERVERSQL_BL01.protheus.dbo.ZZA010 servidor
			set ZZA_STATUS = @ZZASTATUS, ZZA_GRAU = @ZZAGRAU, ZZA_INIST2 = @ZZAINIST2, ZZA_INIST3 = @ZZAINIST3
			where servidor.ZZA_FILIAL = @ZZAFILIAL --COLLATE DATABASE_DEFAULT
			  and servidor.ZZA_SAFRA  = @ZZASAFRA  --COLLATE DATABASE_DEFAULT
			  and servidor.ZZA_CARGA  = @ZZACARGA  --COLLATE DATABASE_DEFAULT
		*/

		-- Guarda a hora em que o registro foi enviado para o servidor
		update BL01.dbo.ZZA010
			set ENVIADO_PARA_SERVIDOR = getdate()
			where ZZA_FILIAL = @ZZAFILIAL
			  and ZZA_SAFRA  = @ZZASAFRA
			  and ZZA_CARGA  = @ZZACARGA

	END
	DEALLOCATE tblcur

end


