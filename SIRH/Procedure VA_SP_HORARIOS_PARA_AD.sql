SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Descricao: Retorna dados de horarios de uma pessoa para preencher no A.D.
-- Autor....: Robert Koch
-- Data.....: 19/10/2020 (inicio)
--
-- Historico de alteracoes:
-- 21/09/2021 - Robert - Iniciada alteracao para verificar uma semana cheia, para posterior uso no A.D.
-- 09/11/2021 - Robert - Iniciada leitura de programacoes de horarios e escalas.
-- 05/11/2022 - Robert - Funcao renomeada de VA_FVERIFICAHORARIO2 para VA_FHORARIOS_PARA_AD
--

ALTER procedure [dbo].[VA_SP_HORARIOS_PARA_AD]
-- PARAMETROS DE CHAMADA
(
	@in_Pessoa INT
	,@in_DiaSolicitado DATE
)
as
begin
	declare @Continua       bit = 1;
	declare @OP05           varchar (1) = ''
	declare @EmFerias       varchar (1) = ''
	declare @Contrato       int = 0
	declare @SituacaoFolha  varchar (1) = ''
	declare @EscalaContrato varchar (4) = ''

	if (@in_DiaSolicitado is null)
	begin
		set @in_DiaSolicitado = format (getdate (), 'yyyyMMdd')
	end

	-- Tabela temporaria para retornar dados
	declare @Ret table (
	 DiaSemana INT not null
	,Dia date not null
	,EscalaContrato varchar (4)
	,EscalaProgramada varchar (4)
	,EscalaAConsiderar varchar (4)
	,HorarioEscala varchar (4)
	,HorarioProgramado varchar (4)
	,HorarioAConsiderar varchar (4)
	,PrimeiraMarcacaoEsperada varchar (5)
	,UltimaMarcacaoEsperada varchar (5)
	,H00 varchar (2) default '' not null
	,H01 varchar (2) default '' not null
	,H02 varchar (2) default '' not null
	,H03 varchar (2) default '' not null
	,H04 varchar (2) default '' not null
	,H05 varchar (2) default '' not null
	,H06 varchar (2) default '' not null
	,H07 varchar (2) default '' not null
	,H08 varchar (2) default '' not null
	,H09 varchar (2) default '' not null
	,H10 varchar (2) default '' not null
	,H11 varchar (2) default '' not null
	,H12 varchar (2) default '' not null
	,H13 varchar (2) default '' not null
	,H14 varchar (2) default '' not null
	,H15 varchar (2) default '' not null
	,H16 varchar (2) default '' not null
	,H17 varchar (2) default '' not null
	,H18 varchar (2) default '' not null
	,H19 varchar (2) default '' not null
	,H20 varchar (2) default '' not null
	,H21 varchar (2) default '' not null
	,H22 varchar (2) default '' not null
	,H23 varchar (2) default '' not null
	)

	-- O Metadados considera segunda=1, terca=2, ...domingo=7
	-- Mas, sendo um dinossauro, aqui trabalharei pelo velho padrao: domingo=1
	-- INICIALIZA TABELA A SER RETORNADA COM OS 7 DIAS DA SEMANA ATUAL.
	-- Royalties para https://stackoverflow.com/questions/23051197/how-to-get-data-of-current-week-only-in-sql-server/32226598
	declare @Domingo      DATE = dateadd (day, 1-datepart(dw, @in_DiaSolicitado), CONVERT(date, @in_DiaSolicitado))
	declare @SegundaFeira DATE = dateadd (DAY, 1, @Domingo)
	declare @TercaFeira   DATE = dateadd (DAY, 2, @Domingo)
	declare @QuartaFeira  DATE = dateadd (DAY, 3, @Domingo)
	declare @QuintaFeira  DATE = dateadd (DAY, 4, @Domingo)
	declare @SextaFeira   DATE = dateadd (DAY, 5, @Domingo)
	declare @Sabado       DATE = dateadd (DAY, 6, @Domingo)
	insert into @Ret (DiaSemana, Dia) values (1, @Domingo);
	insert into @Ret (DiaSemana, Dia) values (2, @SegundaFeira);
	insert into @Ret (DiaSemana, Dia) values (3, @TercaFeira);
	insert into @Ret (DiaSemana, Dia) values (4, @QuartaFeira);
	insert into @Ret (DiaSemana, Dia) values (5, @QuintaFeira);
	insert into @Ret (DiaSemana, Dia) values (6, @SextaFeira);
	insert into @Ret (DiaSemana, Dia) values (7, @Sabado);


	-- BUSCA DADOS PRINCIPAIS DA PESSOA
	select TOP 1 @OP05           = isnull (OP05, 1)  -- TRATA null COMO SE FOSSE 1.
				,@EmFerias      = isnull (EM_FERIAS, '')
				,@Contrato       = isnull (CONTRATO, '')
				,@EscalaContrato = isnull (ESCALA_CONTRATO, '')
				,@SituacaoFolha  = isnull (SITUACAO, '')
	from VA_VFUNCIONARIOS
	where PESSOA = @in_Pessoa
	print 'Contrato: ' + cast (@Contrato as varchar (max)) + ' Situacao: ' + @SituacaoFolha + ' Em ferias: ' + @EmFerias + ' Escala contrato: ' + @EscalaContrato

	-- VERIFICA A SITUACAO DO CAMPO 'OPC05', QUE EH ONDE O PESSOAL DO RH PODE INFORMAR COMO O FUNCIONARIO DEVE SER TRATADO
	if (@OP05 = 3)  --Pessoa marcada como SEMPRE LIBERAR
	begin
		print 'Pessoa marcada como SEMPRE LIBERAR.'
		update @Ret set H00 = 'SL',H01 = 'SL',H02 = 'SL',H03 = 'SL',H04 = 'SL',H05 = 'SL',H06 = 'SL',H07 = 'SL',H08 = 'SL',H09 = 'SL',H10 = 'SL',H11 = 'SL',H12 = 'SL',H13 = 'SL',H14 = 'SL',H15 = 'SL',H16 = 'SL',H17 = 'SL',H18 = 'SL',H19 = 'SL',H20 = 'SL',H21 = 'SL',H22 = 'SL',H23 = 'SL'
		set @Continua = 0;
	end
	
	if (@Continua = 1)
	begin
		if (@EmFerias = 'S' OR @SituacaoFolha IN ('2', '3','4'))  -- PESSOA AFASTADA OU DEMITIDA
		begin
			print 'Pessoa em ferias, afastada ou demitida.'
			-- NAO PRECISO FAZER NADA, POIS A TABELA DE RETORNO EH INICIALIZADA VAZIA.
			set @Continua = 0;
		end
	end

	-- confirmar, ainda, onde eh que preciso verificar se tem ocorrencias como atestado.

	-- VERIFICA SE TEM PROGRAMACAO DE HORA EXTRA
	if (@Continua = 1)
	begin
		-- Gera uma CTE com todas as autorizacoes de horas extras do
		-- funcionario dentro do periodo pesquisado.
		SELECT CAST(FORMAT(HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING(HE.HORADE, 1, 2) + ':00' AS DATETIME) as DTHRINI
			,  CAST(FORMAT(HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + SUBSTRING(HE.HORAATE, 1, 2) + ':00' AS DATETIME) as DTHRFIM
		into #AutHE
		from RHAUTHORASEXTRAS HE
		where CONTRATO = @Contrato
		and DATAINICIO >= dateadd (day, -1, @Domingo)  -- Um dia a menos para pegar turno da noite
		and DATATERMINO <= dateadd (day, 1, @Sabado)  -- Um dia a mais para pegar turno da noite

		update @Ret set H00 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 00:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 00:00' AS datetime))
		update @Ret set H01 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 01:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 01:00' AS datetime))
		update @Ret set H02 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 02:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 02:00' AS datetime))
		update @Ret set H03 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 03:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 03:00' AS datetime))
		update @Ret set H04 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 04:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 04:00' AS datetime))
		update @Ret set H05 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 05:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 05:00' AS datetime))
		update @Ret set H06 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 06:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 06:00' AS datetime))
		update @Ret set H07 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 07:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 07:00' AS datetime))
		update @Ret set H08 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 08:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 08:00' AS datetime))
		update @Ret set H09 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 09:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 09:00' AS datetime))
		update @Ret set H10 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 10:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 10:00' AS datetime))
		update @Ret set H11 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 11:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 11:00' AS datetime))
		update @Ret set H12 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 12:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 12:00' AS datetime))
		update @Ret set H13 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 13:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 13:00' AS datetime))
		update @Ret set H14 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 14:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 14:00' AS datetime))
		update @Ret set H15 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 15:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 15:00' AS datetime))
		update @Ret set H16 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 16:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 16:00' AS datetime))
		update @Ret set H17 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 17:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 17:00' AS datetime))
		update @Ret set H18 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 18:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 18:00' AS datetime))
		update @Ret set H19 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 19:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 19:00' AS datetime))
		update @Ret set H20 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 20:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 20:00' AS datetime))
		update @Ret set H21 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 21:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 21:00' AS datetime))
		update @Ret set H22 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 22:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 22:00' AS datetime))
		update @Ret set H23 = 'HE' where exists (select * from #AutHE where DTHRINI <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 23:00' AS datetime) and DTHRFIM >= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 23:00' AS datetime))
	end
	
	if (@Continua = 1)
	begin

		update @Ret set EscalaContrato = @EscalaContrato

		-- Verifica se tem programacao de escala para cada dia da semana.
		update r set EscalaProgramada = e.ESCALA
			from @Ret r
				, RHPROGRAMACAOESCALAS e
			where e.CONTRATO = @Contrato
			and e.DATAINICIO <= r.Dia
			and e.DATATERMINO >= r.Dia

		-- Se tiver escala programada, considera. Senao, vale a do contrato.
		update @Ret set EscalaAConsiderar = isnull (EscalaProgramada, EscalaContrato)

		-- Cada escala faz referencia a um horario na tabela RHESCALASSEMANAIS
		-- Obs.: O Metadados considera segunda=1, terca=2, ...domingo=7
		update r set HorarioEscala = e.HORARIO
			from @Ret r
				, RHESCALASSEMANAIS e
			where e.ESCALA = r.EscalaAConsiderar
			and e.DiaSemana = case when r.DiaSemana = 1 then 7 else r.DiaSemana - 1 end

		-- Verifica se tem programacao de horario para cada dia da semana
		update @Ret set HorarioProgramado = (select HORARIO
			from RHPROGRAMACAOHORARIO
			where CONTRATO = @Contrato
			and DATAHORARIO = Dia)

		-- Se tem programacao de horario, considera. Senao, usa o horario da escala.
		update @Ret set HorarioAConsiderar = isnull (HorarioProgramado, HorarioEscala)

		-- Busca horarios da primeira e ultima marcacoes esperadas para o
		-- horario a ser considerado.
		update @Ret set PrimeiraMarcacaoEsperada = (select HORAMARCACAO
			from RHHORARIOSMARCACOES
			where HORARIO = HorarioAConsiderar
			and CLASSEMARCACAO = '01')

		update @Ret set UltimaMarcacaoEsperada = (select HORAMARCACAO
			from RHHORARIOSMARCACOES
			where HORARIO = HorarioAConsiderar
			and CLASSEMARCACAO = '99')

		-- Tendo a primeira e ultima marcacoes esperadas, posso decidir quais
		-- campos de 'hora cheia' evem ser gravados.
		update @Ret set H00 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H00 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '00'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '00'

		update @Ret set H01 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H01 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '01'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '01'

		update @Ret set H02 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H02 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '02'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '02'

		update @Ret set H03 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H03 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '03'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '03'

		update @Ret set H04 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H04 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '04'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '04'

		update @Ret set H05 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H05 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '05'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '05'

		update @Ret set H06 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H06 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '06'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '06'

		update @Ret set H07 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H07 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '07'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '07'

		update @Ret set H08 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H08 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '08'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '08'

		update @Ret set H09 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H09 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '09'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '09'

		update @Ret set H10 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H10 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '10'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '10'

		update @Ret set H11 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H11 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '11'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '11'

		update @Ret set H12 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H12 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '12'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '12'

		update @Ret set H13 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H13 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '13'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '13'

		update @Ret set H14 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H14 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '14'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '14'

		update @Ret set H15 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H15 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '15'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '15'

		update @Ret set H16 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H16 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '16'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '16'

		update @Ret set H17 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H17 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '17'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '17'

		update @Ret set H18 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H18 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '18'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '18'

		update @Ret set H19 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H19 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '19'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '19'

		update @Ret set H20 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H20 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '20'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '20'

		update @Ret set H21 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H21 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '21'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '21'

		update @Ret set H22 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H22 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '22'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '22'

		update @Ret set H23 = case when HorarioProgramado is not null then 'HP' else case when EscalaProgramada is not null then 'EP' else 'EC' end end
			where H23 = ''  -- Se jah tem algum dado, nao vou alterar.
			and substring (PrimeiraMarcacaoEsperada, 1, 2) <= '23'
			and substring (UltimaMarcacaoEsperada, 1, 2) >= '23'

	end

	-- Retorna os dados para a rotina chamadora.
	select * from @Ret
	return

	/*
	-- TESTES COM HORAS EXTRAS
	set nocount on
	--exec VA_SP_HORARIOS_PARA_AD @in_Pessoa=1002193, @in_DiaSolicitado='20201103' -- CLAUDIA DIA 03/11/2020 17:18 AS 20:00
	--exec VA_SP_HORARIOS_PARA_AD @in_Pessoa=1001868, @in_DiaSolicitado='20210213' -- 20:30 (sabado) AS 06:00 (domingo)
	--exec VA_SP_HORARIOS_PARA_AD @in_Pessoa=1001868, @in_DiaSolicitado='20210214' -- 20:30 (sabado) AS 06:00 (domingo)
	--exec VA_SP_HORARIOS_PARA_AD @in_Pessoa=1002020, @in_DiaSolicitado='20211014' -- 05:30 AS 07:30 DO DIA SEGUINTE!

	-- Usando a escala do contrato
	set nocount on
	exec VA_SP_HORARIOS_PARA_AD @in_Pessoa=1001632, @in_DiaSolicitado='20210405' -- ROBSON SILVA 4A.FEIRA
	select * from RHESCALASSEMANAIS where ESCALA = '0049' --and DiaSemana = 3

	-- Sobrepondo horario da escala com horario programado
	set nocount on
	exec VA_SP_HORARIOS_PARA_AD @in_Pessoa=1001632, @in_DiaSolicitado='20201230' -- ROBSON SILVA progr.horario
	select * from RHPROGRAMACAOHORARIO where CONTRATO = 1632 and DATAHORARIO = '20201230'
	select HORAMARCACAO, * from RHHORARIOSMARCACOES where HORARIO in ('0010', '0164') and CLASSEMARCACAO in ('01', '99')

	-- Hora extra e programacao de escala
	set nocount on
	exec VA_SP_HORARIOS_PARA_AD @in_Pessoa=1001632, @in_DiaSolicitado='20220104' -- ROBSON SILVA progr.escala
	select * from RHAUTHORASEXTRAS HE where CONTRATO = '1632' and DATAINICIO >= '20220102' and DATATERMINO <= '20220108'
	select * from RHPROGRAMACAOESCALAS where CONTRATO = '1632' and DATAINICIO = '20220104'
	select HORAMARCACAO, * from RHHORARIOSMARCACOES where HORARIO in ('0049', '0177') and CLASSEMARCACAO in ('01', '99')
*/
end
GO
