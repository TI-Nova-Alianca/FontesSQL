USE [BL01]
GO
/****** Object:  StoredProcedure [dbo].[SP_SINCRONIZA_ZZA]    Script Date: 20/02/2024 08:56:12 ******/
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
-- Data.....: 24/01/2024
-- Autor....: Robert Koch
--
-- Historico de alteracoes:
-- 29/01/2024 - Robert - Resincronizava apenas cargas com ZZA_STATUS 1/C. Agora passa a ser 1/C/M
-- 31/01/2024 - Robert - Nao baixava ZZA_INIST1, ZZA_INIST2, ZZA_INIST3 do servidor ao ler novas cargas.
-- 20/02/2024 - Robert - Campo ZZA_PRODUT nao fazia parte das chaves de leitura/gravacao.
--

ALTER PROCEDURE [dbo].[SP_SINCRONIZA_ZZA]
(
	@filial VARCHAR (2),
	@safra VARCHAR (4)
) AS
BEGIN

	-- Busca no servidor as novas cargas que ainda nao existem na estacao
	insert into BL01.dbo.ZZA010 (ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT, ZZA_STATUS, ZZA_NASSOC, ZZA_NPROD, ZZA_INIST1, ZZA_INIST2, ZZA_INIST3)
	select ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT, ZZA_STATUS, ZZA_NASSOC, ZZA_NPROD, ZZA_INIST1, ZZA_INIST2, ZZA_INIST3
	from LKSRV_SERVERSQL_BL01.protheus.dbo.ZZA010 servidor
	where servidor.ZZA_FILIAL = @filial COLLATE DATABASE_DEFAULT
	and servidor.ZZA_SAFRA = @safra COLLATE DATABASE_DEFAULT
	and servidor.ZZA_STATUS != '0'
	and not exists (select *
					from ZZA010 estacao
					where estacao.ZZA_FILIAL = servidor.ZZA_FILIAL COLLATE DATABASE_DEFAULT
					  and estacao.ZZA_SAFRA  = servidor.ZZA_SAFRA  COLLATE DATABASE_DEFAULT
					  and estacao.ZZA_CARGA  = servidor.ZZA_CARGA  COLLATE DATABASE_DEFAULT
					  and estacao.ZZA_PRODUT = servidor.ZZA_PRODUT COLLATE DATABASE_DEFAULT)

	-- Se a carga teve alguma alteracao no servidor (foi cancelada ou reenviada), preciso replicar para a estacao.
	update estacao set ZZA_STATUS = servidor.ZZA_STATUS
	from BL01.dbo.ZZA010 estacao, LKSRV_SERVERSQL_BL01.protheus.dbo.ZZA010 servidor
	where estacao.ZZA_FILIAL = @filial
	  and estacao.ZZA_SAFRA = @safra
	  and estacao.ZZA_STATUS in ('1', 'C', 'M')
	  and servidor.ZZA_STATUS != estacao.ZZA_STATUS COLLATE DATABASE_DEFAULT
	  and servidor.ZZA_FILIAL = estacao.ZZA_FILIAL  COLLATE DATABASE_DEFAULT
	  and servidor.ZZA_SAFRA  = estacao.ZZA_SAFRA   COLLATE DATABASE_DEFAULT
	  and servidor.ZZA_CARGA  = estacao.ZZA_CARGA   COLLATE DATABASE_DEFAULT
	  and servidor.ZZA_PRODUT = estacao.ZZA_PRODUT  COLLATE DATABASE_DEFAULT
	  and servidor.ZZA_STATUS in ('1', '3', 'C', 'M')


	-- Cria cursor para enviar cada registro da tabela ZZA local para o servidor. Isso por que
	-- quero gravar em cada registro um campo indicando data e hora em que foi enviado.
	SET NOCOUNT ON;
	declare @ZZAFILIAL varchar (2)
	declare @ZZASAFRA  varchar (4)
	declare @ZZACARGA  varchar (4)
	declare @ZZAPRODUT varchar (15)
	declare @ZZASTATUS varchar (1)
	declare @ZZAGRAU float
	declare @ZZAINIST1 varchar (17)
	declare @ZZAINIST2 varchar (17)
	declare @ZZAINIST3 varchar (17)

	declare tblcur CURSOR STATIC LOCAL FOR

		-- Busca registros ainda nao enviado (null) e os enviados recentemente (isso por que
		-- quero ter a certeza de reenviar algum registro que possa ter sido perdido em
		-- execucoes anteriores por falta de conectividade. Quando eu conseguir operar com
		-- controle de transacoes entre servidores, espero nao precisar mais disso...)
		select ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT, ZZA_STATUS, ZZA_GRAU, ZZA_INIST1, ZZA_INIST2, ZZA_INIST3
		from BL01.dbo.ZZA010 estacao
	--	where (ENVIADO_PARA_SERVIDOR is null
	--		or ENVIADO_PARA_SERVIDOR > DATEADD (HOUR, -1, getdate()))
		where exists (select *
						from LKSRV_SERVERSQL_BL01.protheus.dbo.ZZA010 servidor
						where servidor.ZZA_FILIAL = estacao.ZZA_FILIAL COLLATE DATABASE_DEFAULT
						  and servidor.ZZA_SAFRA  = estacao.ZZA_SAFRA  COLLATE DATABASE_DEFAULT
						  and servidor.ZZA_CARGA  = estacao.ZZA_CARGA  COLLATE DATABASE_DEFAULT
						  and servidor.ZZA_PRODUT = estacao.ZZA_PRODUT COLLATE DATABASE_DEFAULT
						  and servidor.ZZA_STATUS in ('1', '2')  -- Nao quero reenviar se jah teve alguma alteracao no servidor
						  and servidor.ZZA_GRAU   = 0  -- Nao quero reenviar se jah teve alguma alteracao no servidor
						 )
		order by ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA
	OPEN tblcur
	WHILE 1 = 1
	BEGIN
		FETCH tblcur INTO @ZZAFILIAL, @ZZASAFRA, @ZZACARGA, @ZZAPRODUT, @ZZASTATUS, @ZZAGRAU, @ZZAINIST1, @ZZAINIST2, @ZZAINIST3

		IF @@fetch_status <> 0
			BREAK

		print 'Processando carga ' + @ZZACARGA;

		-- Faz duas atualizacoes em separado no servidor por que a tabela
		-- ZZA tem triggers que gravam o horario em que mudou o ZZA_STATUS.
		-- Soh que preciso que seja levado o horario que tenho na tabela
		-- da estacao, em vez do SQL do servidor assumir o 'horario atual'.
		update LKSRV_SERVERSQL_BL01.protheus.dbo.ZZA010
			set ZZA_STATUS = @ZZASTATUS, ZZA_GRAU = @ZZAGRAU
			where ZZA_FILIAL = @ZZAFILIAL
			  and ZZA_SAFRA  = @ZZASAFRA
			  and ZZA_CARGA  = @ZZACARGA
			  and ZZA_PRODUT = @ZZAPRODUT

		update LKSRV_SERVERSQL_BL01.protheus.dbo.ZZA010
			set ZZA_INIST1 = @ZZAINIST1, ZZA_INIST2 = @ZZAINIST2, ZZA_INIST3 = @ZZAINIST3
			where ZZA_FILIAL = @ZZAFILIAL
			  and ZZA_SAFRA  = @ZZASAFRA
			  and ZZA_CARGA  = @ZZACARGA
			  and ZZA_PRODUT = @ZZAPRODUT

		-- Guarda a hora em que o registro foi enviado para o servidor
	--	update BL01.dbo.ZZA010
	--		set ENVIADO_PARA_SERVIDOR = getdate()
	--		where ZZA_FILIAL = @ZZAFILIAL
	--		  and ZZA_SAFRA  = @ZZASAFRA
	--		  and ZZA_CARGA  = @ZZACARGA

	END
	DEALLOCATE tblcur

end


