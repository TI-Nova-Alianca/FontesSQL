set ANSI_nullS ON
GO
set QUOTED_IDENTIFIER ON
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

alter function [dbo].[VA_FHORARIOS_PARA_AD]
-- PARAMETROS DE CHAMADA
(
	@in_Pessoa AS INT
	,@in_DiaSolicitado AS DATE
)

-- RETORNA TABELA TEMPORARIA
returns @Ret table (
	 DIASEMANA INT
	,DIA datetime
	,H00 varchar (1) default '' not null
	,H01 varchar (1) default '' not null
	,H02 varchar (1) default '' not null
	,H03 varchar (1) default '' not null
	,H04 varchar (1) default '' not null
	,H05 varchar (1) default '' not null
	,H06 varchar (1) default '' not null
	,H07 varchar (1) default '' not null
	,H08 varchar (1) default '' not null
	,H09 varchar (1) default '' not null
	,H10 varchar (1) default '' not null
	,H11 varchar (1) default '' not null
	,H12 varchar (1) default '' not null
	,H13 varchar (1) default '' not null
	,H14 varchar (1) default '' not null
	,H15 varchar (1) default '' not null
	,H16 varchar (1) default '' not null
	,H17 varchar (1) default '' not null
	,H18 varchar (1) default '' not null
	,H19 varchar (1) default '' not null
	,H20 varchar (1) default '' not null
	,H21 varchar (1) default '' not null
	,H22 varchar (1) default '' not null
	,H23 varchar (1) default '' not null
	)

as
begin
	declare @Continua BIT = 1;
	declare @OP05 varchar (1) = ''
	declare @EmFerias varchar (1) = ''
	declare @Contrato INT = 0
	declare @SituacaoFolha varchar (1) = ''
	declare @EscalaContrato     varchar (4) = ''

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
	insert into @Ret (DIASEMANA, DIA) values (1, @Domingo);
	insert into @Ret (DIASEMANA, DIA) values (2, @SegundaFeira);
	insert into @Ret (DIASEMANA, DIA) values (3, @TercaFeira);
	insert into @Ret (DIASEMANA, DIA) values (4, @QuartaFeira);
	insert into @Ret (DIASEMANA, DIA) values (5, @QuintaFeira);
	insert into @Ret (DIASEMANA, DIA) values (6, @SextaFeira);
	insert into @Ret (DIASEMANA, DIA) values (7, @Sabado);


	-- BUSCA DADOS PRINCIPAIS DA PESSOA
	select TOP 1 @OP05           = isnull (OP05, 1)  -- TRATA null COMO SE FOSSE 1.
				,@EmFerias      = isnull (EM_FERIAS, '')
				,@Contrato       = isnull (CONTRATO, '')
				,@EscalaContrato = isnull (ESCALA_CONTRATO, '')
				,@SituacaoFolha  = isnull (SITUACAO, '')
	from VA_VFUNCIONARIOS
	where PESSOA = @in_Pessoa


	-- VERIFICA A SITUACAO DO CAMPO 'OPC05', QUE EH ONDE O PESSOAL DO RH PODE INFORMAR COMO O FUNCIONARIO DEVE SER TRATADO
	if (@OP05 = 3)  --Pessoa marcada como SEMPRE LIBERAR
	begin
		update @Ret set H00 = 'L',H01 = 'L',H02 = 'L',H03 = 'L',H04 = 'L',H05 = 'L',H06 = 'L',H07 = 'L',H08 = 'L',H09 = 'L',H10 = 'L',H11 = 'L',H12 = 'L',H13 = 'L',H14 = 'L',H15 = 'L',H16 = 'L',H17 = 'L',H18 = 'L',H19 = 'L',H20 = 'L',H21 = 'L',H22 = 'L',H23 = 'L'
		set @Continua = 0;
	end
	
	if (@Continua = 1)
	begin
		if (@EmFerias = 'S' OR @SituacaoFolha IN ('2', '3','4'))  -- PESSOA AFASTADA OU DEMITIDA
		begin
			-- NAO PRECISO FAZER NADA, POIS A TABELA DE RETORNO EH INICIALIZADA VAZIA.
			set @Continua = 0;
		end
	end

	-- confirmar, ainda, onde eh que preciso verificar se tem ocorrencias como atestado.

	-- VERIFICA SE TEM PROGRAMACAO DE HORA EXTRA
	if (@Continua = 1)
	begin
		-- PRECISO VERIFICAR EM TODOS OS DIAS DA SEMANA A SER RETORNADA.
		update @Ret set H00 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 00:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 00:00' AS datetime))
		update @Ret set H01 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 01:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 01:00' AS datetime))
		update @Ret set H02 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 02:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 02:00' AS datetime))
		update @Ret set H03 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 03:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 03:00' AS datetime))
		update @Ret set H04 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 04:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 04:00' AS datetime))
		update @Ret set H05 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 05:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 05:00' AS datetime))
		update @Ret set H06 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 06:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 06:00' AS datetime))
		update @Ret set H07 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 07:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 07:00' AS datetime))
		update @Ret set H08 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 08:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 08:00' AS datetime))
		update @Ret set H09 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 09:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 09:00' AS datetime))
		update @Ret set H10 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 10:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 10:00' AS datetime))
		update @Ret set H11 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 11:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 11:00' AS datetime))
		update @Ret set H12 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 12:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 12:00' AS datetime))
		update @Ret set H13 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 13:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 13:00' AS datetime))
		update @Ret set H14 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 14:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 14:00' AS datetime))
		update @Ret set H15 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 15:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 15:00' AS datetime))
		update @Ret set H16 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 16:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 16:00' AS datetime))
		update @Ret set H17 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 17:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 17:00' AS datetime))
		update @Ret set H18 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 18:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 18:00' AS datetime))
		update @Ret set H19 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 19:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 19:00' AS datetime))
		update @Ret set H20 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 20:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 20:00' AS datetime))
		update @Ret set H21 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 21:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 21:00' AS datetime))
		update @Ret set H22 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 22:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 22:00' AS datetime))
		update @Ret set H23 = 'E' where exists (select * from RHAUTHORASEXTRAS HE where CONTRATO = @Contrato and CAST (FORMAT (HE.DATAINICIO, 'yyyy-MM-dd') + ' ' + SUBSTRING (HE.HORADE, 1, 2) + ':00' AS datetime) <= CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 23:00' AS datetime) and CAST (FORMAT (HE.DATATERMINO, 'yyyy-MM-dd') + ' ' + HE.HORAATE AS datetime) > CAST (FORMAT (DIA, 'yyyy-MM-dd') + ' 23:00' AS datetime))
	end
	
	-- VERIFICA SE TEM PROGRAMACAO DE HORARIO. SE NAO TIVER, VERIFICA SE TEM PROGRAMACAO DE ESCALA.
	if (@Continua = 1)
	begin
		declare @CodHorarioProgramado1 varchar (4) = isnull ((select HORARIO from RHPROGRAMACAOHORARIO where CONTRATO = @Contrato and FORMAT (DATAHORARIO, 'yyyy-MM-dd') = FORMAT (@Domingo, 'yyyy-MM-dd')), '')
		declare @CodHorarioProgramado2 varchar (4) = isnull ((select HORARIO from RHPROGRAMACAOHORARIO where CONTRATO = @Contrato and FORMAT (DATAHORARIO, 'yyyy-MM-dd') = FORMAT (dateadd (DAY, 1, @Domingo), 'yyyy-MM-dd')), '')
		declare @CodHorarioProgramado3 varchar (4) = isnull ((select HORARIO from RHPROGRAMACAOHORARIO where CONTRATO = @Contrato and FORMAT (DATAHORARIO, 'yyyy-MM-dd') = FORMAT (dateadd (DAY, 2, @Domingo), 'yyyy-MM-dd')), '')
		declare @CodHorarioProgramado4 varchar (4) = isnull ((select HORARIO from RHPROGRAMACAOHORARIO where CONTRATO = @Contrato and FORMAT (DATAHORARIO, 'yyyy-MM-dd') = FORMAT (dateadd (DAY, 3, @Domingo), 'yyyy-MM-dd')), '')
		declare @CodHorarioProgramado5 varchar (4) = isnull ((select HORARIO from RHPROGRAMACAOHORARIO where CONTRATO = @Contrato and FORMAT (DATAHORARIO, 'yyyy-MM-dd') = FORMAT (dateadd (DAY, 4, @Domingo), 'yyyy-MM-dd')), '')
		declare @CodHorarioProgramado6 varchar (4) = isnull ((select HORARIO from RHPROGRAMACAOHORARIO where CONTRATO = @Contrato and FORMAT (DATAHORARIO, 'yyyy-MM-dd') = FORMAT (dateadd (DAY, 5, @Domingo), 'yyyy-MM-dd')), '')
		declare @CodHorarioProgramado7 varchar (4) = isnull ((select HORARIO from RHPROGRAMACAOHORARIO where CONTRATO = @Contrato and FORMAT (DATAHORARIO, 'yyyy-MM-dd') = FORMAT (dateadd (DAY, 6, @Domingo), 'yyyy-MM-dd')), '')

		-- Verifica se tem programacao de escala para cada dia da semana.
		declare @EscalaProgramada1 varchar (4) = (select ESCALA from RHPROGRAMACAOESCALAS where CONTRATO = @Contrato and FORMAT (DATAINICIO, 'yyyy-MM-dd') <= FORMAT (@Domingo,      'yyyy-MM-dd') and FORMAT (DATATERMINO, 'yyyy-MM-dd') >= FORMAT (@Domingo,      'yyyy-MM-dd'))
		declare @EscalaProgramada2 varchar (4) = (select ESCALA from RHPROGRAMACAOESCALAS where CONTRATO = @Contrato and FORMAT (DATAINICIO, 'yyyy-MM-dd') <= FORMAT (@SegundaFeira, 'yyyy-MM-dd') and FORMAT (DATATERMINO, 'yyyy-MM-dd') >= FORMAT (@SegundaFeira, 'yyyy-MM-dd'))
		declare @EscalaProgramada3 varchar (4) = (select ESCALA from RHPROGRAMACAOESCALAS where CONTRATO = @Contrato and FORMAT (DATAINICIO, 'yyyy-MM-dd') <= FORMAT (@TercaFeira,   'yyyy-MM-dd') and FORMAT (DATATERMINO, 'yyyy-MM-dd') >= FORMAT (@TercaFeira,   'yyyy-MM-dd'))
		declare @EscalaProgramada4 varchar (4) = (select ESCALA from RHPROGRAMACAOESCALAS where CONTRATO = @Contrato and FORMAT (DATAINICIO, 'yyyy-MM-dd') <= FORMAT (@QuartaFeira,  'yyyy-MM-dd') and FORMAT (DATATERMINO, 'yyyy-MM-dd') >= FORMAT (@QuartaFeira,  'yyyy-MM-dd'))
		declare @EscalaProgramada5 varchar (4) = (select ESCALA from RHPROGRAMACAOESCALAS where CONTRATO = @Contrato and FORMAT (DATAINICIO, 'yyyy-MM-dd') <= FORMAT (@QuintaFeira,  'yyyy-MM-dd') and FORMAT (DATATERMINO, 'yyyy-MM-dd') >= FORMAT (@QuintaFeira,  'yyyy-MM-dd'))
		declare @EscalaProgramada6 varchar (4) = (select ESCALA from RHPROGRAMACAOESCALAS where CONTRATO = @Contrato and FORMAT (DATAINICIO, 'yyyy-MM-dd') <= FORMAT (@SextaFeira,   'yyyy-MM-dd') and FORMAT (DATATERMINO, 'yyyy-MM-dd') >= FORMAT (@SextaFeira,   'yyyy-MM-dd'))
		declare @EscalaProgramada7 varchar (4) = (select ESCALA from RHPROGRAMACAOESCALAS where CONTRATO = @Contrato and FORMAT (DATAINICIO, 'yyyy-MM-dd') <= FORMAT (@Sabado,       'yyyy-MM-dd') and FORMAT (DATATERMINO, 'yyyy-MM-dd') >= FORMAT (@Sabado,       'yyyy-MM-dd'))
		
		-- Se nao tem programacao de escala, vale a escala do contrato.
		declare @EscalaAConsiderar1 varchar (4) = isnull (@EscalaProgramada1, @EscalaContrato)
		declare @EscalaAConsiderar2 varchar (4) = isnull (@EscalaProgramada2, @EscalaContrato)
		declare @EscalaAConsiderar3 varchar (4) = isnull (@EscalaProgramada3, @EscalaContrato)
		declare @EscalaAConsiderar4 varchar (4) = isnull (@EscalaProgramada4, @EscalaContrato)
		declare @EscalaAConsiderar5 varchar (4) = isnull (@EscalaProgramada5, @EscalaContrato)
		declare @EscalaAConsiderar6 varchar (4) = isnull (@EscalaProgramada6, @EscalaContrato)
		declare @EscalaAConsiderar7 varchar (4) = isnull (@EscalaProgramada7, @EscalaContrato)

		-- Cada escala faz referencia a um horario na tabela RHESCALASSEMANAIS
		-- O Metadados considera segunda=1, terca=2, ...domingo=7
		declare @CodHorarioPelaEscala1 varchar (4) = (select HORARIO from RHESCALASSEMANAIS where ESCALA = @EscalaAConsiderar1 and DIASEMANA = 7)
		declare @CodHorarioPelaEscala2 varchar (4) = (select HORARIO from RHESCALASSEMANAIS where ESCALA = @EscalaAConsiderar1 and DIASEMANA = 1)
		declare @CodHorarioPelaEscala3 varchar (4) = (select HORARIO from RHESCALASSEMANAIS where ESCALA = @EscalaAConsiderar1 and DIASEMANA = 2)
		declare @CodHorarioPelaEscala4 varchar (4) = (select HORARIO from RHESCALASSEMANAIS where ESCALA = @EscalaAConsiderar1 and DIASEMANA = 3)
		declare @CodHorarioPelaEscala5 varchar (4) = (select HORARIO from RHESCALASSEMANAIS where ESCALA = @EscalaAConsiderar1 and DIASEMANA = 4)
		declare @CodHorarioPelaEscala6 varchar (4) = (select HORARIO from RHESCALASSEMANAIS where ESCALA = @EscalaAConsiderar1 and DIASEMANA = 5)
		declare @CodHorarioPelaEscala7 varchar (4) = (select HORARIO from RHESCALASSEMANAIS where ESCALA = @EscalaAConsiderar1 and DIASEMANA = 6)

		-- Definicao de qual horario deve ser considerado:
		declare @CodHorarioAConsiderar1 varchar (4)
		declare @CodHorarioAConsiderar2 varchar (4)
		declare @CodHorarioAConsiderar3 varchar (4)
		declare @CodHorarioAConsiderar4 varchar (4)
		declare @CodHorarioAConsiderar5 varchar (4)
		declare @CodHorarioAConsiderar6 varchar (4)
		declare @CodHorarioAConsiderar7 varchar (4)
		
		-- Se tem programacao de horario, considera. Senao, busca na escala.
		set @CodHorarioAConsiderar1 = case when @CodHorarioProgramado1 = '' then @EscalaAConsiderar1 else @CodHorarioPelaEscala1 end
		set @CodHorarioAConsiderar2 = case when @CodHorarioProgramado2 = '' then @EscalaAConsiderar2 else @CodHorarioPelaEscala2 end
		set @CodHorarioAConsiderar3 = case when @CodHorarioProgramado3 = '' then @EscalaAConsiderar3 else @CodHorarioPelaEscala3 end
		set @CodHorarioAConsiderar4 = case when @CodHorarioProgramado4 = '' then @EscalaAConsiderar4 else @CodHorarioPelaEscala4 end
		set @CodHorarioAConsiderar5 = case when @CodHorarioProgramado5 = '' then @EscalaAConsiderar5 else @CodHorarioPelaEscala5 end
		set @CodHorarioAConsiderar6 = case when @CodHorarioProgramado6 = '' then @EscalaAConsiderar6 else @CodHorarioPelaEscala6 end
		set @CodHorarioAConsiderar7 = case when @CodHorarioProgramado7 = '' then @EscalaAConsiderar7 else @CodHorarioPelaEscala7 end

		-- BUSCA HORARIOS DA PRIMEIRA E ULTIMA MARCACOES DE PONTO ESPERADAS PARA O HORARIO DE CADA DIA.
		declare @PrimeiraMarcacaoEsperada1 varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar1 and CLASSEMARCACAO = '01'), '00:00')
		declare @PrimeiraMarcacaoEsperada2 varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar2 and CLASSEMARCACAO = '01'), '00:00')
		declare @PrimeiraMarcacaoEsperada3 varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar3 and CLASSEMARCACAO = '01'), '00:00')
		declare @PrimeiraMarcacaoEsperada4 varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar4 and CLASSEMARCACAO = '01'), '00:00')
		declare @PrimeiraMarcacaoEsperada5 varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar5 and CLASSEMARCACAO = '01'), '00:00')
		declare @PrimeiraMarcacaoEsperada6 varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar6 and CLASSEMARCACAO = '01'), '00:00')
		declare @PrimeiraMarcacaoEsperada7 varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar7 and CLASSEMARCACAO = '01'), '00:00')
		declare @UltimaMarcacaoEsperada1   varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar1 and CLASSEMARCACAO = '99'), '00:00')
		declare @UltimaMarcacaoEsperada2   varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar2 and CLASSEMARCACAO = '99'), '00:00')
		declare @UltimaMarcacaoEsperada3   varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar3 and CLASSEMARCACAO = '99'), '00:00')
		declare @UltimaMarcacaoEsperada4   varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar4 and CLASSEMARCACAO = '99'), '00:00')
		declare @UltimaMarcacaoEsperada5   varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar5 and CLASSEMARCACAO = '99'), '00:00')
		declare @UltimaMarcacaoEsperada6   varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar6 and CLASSEMARCACAO = '99'), '00:00')
		declare @UltimaMarcacaoEsperada7   varchar (5) = isnull ((select HORAMARCACAO from RHHORARIOSMARCACOES where HORARIO = @CodHorarioAConsiderar7 and CLASSEMARCACAO = '99'), '00:00')

		
		exec LKSRV_TI.TI.dbo.VA_LOG 'VA_FHORARIOS_PARA_AD', 'PrimeiraMarcacaoEsperada1:'

		-- Tendo os horarios esperados de marcacoes, posso popular a tabela de retorno.
		update @Ret set H00 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '00%'
		update @Ret set H01 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '01%'
		update @Ret set H02 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '02%'
		update @Ret set H03 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '03%'
		update @Ret set H04 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '04%'
		update @Ret set H05 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '05%'
		update @Ret set H06 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '06%'
		update @Ret set H07 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '07%'
		update @Ret set H08 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '08%'
		update @Ret set H09 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '09%'
		update @Ret set H10 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '10%'
		update @Ret set H11 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '11%'
		update @Ret set H12 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '12%'
		update @Ret set H13 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '13%'
		update @Ret set H14 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '14%'
		update @Ret set H15 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '15%'
		update @Ret set H16 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '16%'
		update @Ret set H17 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '17%'
		update @Ret set H18 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '18%'
		update @Ret set H19 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '19%'
		update @Ret set H20 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '20%'
		update @Ret set H21 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '21%'
		update @Ret set H22 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '22%'
		update @Ret set H23 = 'N' where DIASEMANA = 1 and @PrimeiraMarcacaoEsperada1 LIKE '23%'

		update @Ret set H00 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '00%'
		update @Ret set H01 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '01%'
		update @Ret set H02 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '02%'
		update @Ret set H03 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '03%'
		update @Ret set H04 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '04%'
		update @Ret set H05 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '05%'
		update @Ret set H06 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '06%'
		update @Ret set H07 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '07%'
		update @Ret set H08 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '08%'
		update @Ret set H09 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '09%'
		update @Ret set H10 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '10%'
		update @Ret set H11 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '11%'
		update @Ret set H12 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '12%'
		update @Ret set H13 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '13%'
		update @Ret set H14 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '14%'
		update @Ret set H15 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '15%'
		update @Ret set H16 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '16%'
		update @Ret set H17 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '17%'
		update @Ret set H18 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '18%'
		update @Ret set H19 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '19%'
		update @Ret set H20 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '20%'
		update @Ret set H21 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '21%'
		update @Ret set H22 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '22%'
		update @Ret set H23 = 'N' where DIASEMANA = 2 and @PrimeiraMarcacaoEsperada2 LIKE '23%'

		update @Ret set H00 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '00%'
		update @Ret set H01 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '01%'
		update @Ret set H02 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '02%'
		update @Ret set H03 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '03%'
		update @Ret set H04 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '04%'
		update @Ret set H05 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '05%'
		update @Ret set H06 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '06%'
		update @Ret set H07 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '07%'
		update @Ret set H08 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '08%'
		update @Ret set H09 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '09%'
		update @Ret set H10 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '10%'
		update @Ret set H11 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '11%'
		update @Ret set H12 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '12%'
		update @Ret set H13 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '13%'
		update @Ret set H14 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '14%'
		update @Ret set H15 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '15%'
		update @Ret set H16 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '16%'
		update @Ret set H17 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '17%'
		update @Ret set H18 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '18%'
		update @Ret set H19 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '19%'
		update @Ret set H20 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '20%'
		update @Ret set H21 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '21%'
		update @Ret set H22 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '22%'
		update @Ret set H23 = 'N' where DIASEMANA = 3 and @PrimeiraMarcacaoEsperada3 LIKE '23%'

		update @Ret set H00 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '00%'
		update @Ret set H01 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '01%'
		update @Ret set H02 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '02%'
		update @Ret set H03 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '03%'
		update @Ret set H04 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '04%'
		update @Ret set H05 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '05%'
		update @Ret set H06 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '06%'
		update @Ret set H07 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '07%'
		update @Ret set H08 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '08%'
		update @Ret set H09 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '09%'
		update @Ret set H10 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '10%'
		update @Ret set H11 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '11%'
		update @Ret set H12 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '12%'
		update @Ret set H13 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '13%'
		update @Ret set H14 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '14%'
		update @Ret set H15 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '15%'
		update @Ret set H16 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '16%'
		update @Ret set H17 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '17%'
		update @Ret set H18 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '18%'
		update @Ret set H19 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '19%'
		update @Ret set H20 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '20%'
		update @Ret set H21 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '21%'
		update @Ret set H22 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '22%'
		update @Ret set H23 = 'N' where DIASEMANA = 4 and @PrimeiraMarcacaoEsperada4 LIKE '23%'

		update @Ret set H00 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '00%'
		update @Ret set H01 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '01%'
		update @Ret set H02 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '02%'
		update @Ret set H03 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '03%'
		update @Ret set H04 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '04%'
		update @Ret set H05 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '05%'
		update @Ret set H06 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '06%'
		update @Ret set H07 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '07%'
		update @Ret set H08 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '08%'
		update @Ret set H09 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '09%'
		update @Ret set H10 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '10%'
		update @Ret set H11 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '11%'
		update @Ret set H12 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '12%'
		update @Ret set H13 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '13%'
		update @Ret set H14 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '14%'
		update @Ret set H15 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '15%'
		update @Ret set H16 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '16%'
		update @Ret set H17 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '17%'
		update @Ret set H18 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '18%'
		update @Ret set H19 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '19%'
		update @Ret set H20 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '20%'
		update @Ret set H21 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '21%'
		update @Ret set H22 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '22%'
		update @Ret set H23 = 'N' where DIASEMANA = 5 and @PrimeiraMarcacaoEsperada5 LIKE '23%'

		update @Ret set H00 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '00%'
		update @Ret set H01 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '01%'
		update @Ret set H02 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '02%'
		update @Ret set H03 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '03%'
		update @Ret set H04 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '04%'
		update @Ret set H05 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '05%'
		update @Ret set H06 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '06%'
		update @Ret set H07 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '07%'
		update @Ret set H08 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '08%'
		update @Ret set H09 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '09%'
		update @Ret set H10 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '10%'
		update @Ret set H11 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '11%'
		update @Ret set H12 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '12%'
		update @Ret set H13 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '13%'
		update @Ret set H14 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '14%'
		update @Ret set H15 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '15%'
		update @Ret set H16 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '16%'
		update @Ret set H17 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '17%'
		update @Ret set H18 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '18%'
		update @Ret set H19 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '19%'
		update @Ret set H20 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '20%'
		update @Ret set H21 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '21%'
		update @Ret set H22 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '22%'
		update @Ret set H23 = 'N' where DIASEMANA = 6 and @PrimeiraMarcacaoEsperada6 LIKE '23%'

		update @Ret set H00 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '00%'
		update @Ret set H01 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '01%'
		update @Ret set H02 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '02%'
		update @Ret set H03 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '03%'
		update @Ret set H04 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '04%'
		update @Ret set H05 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '05%'
		update @Ret set H06 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '06%'
		update @Ret set H07 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '07%'
		update @Ret set H08 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '08%'
		update @Ret set H09 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '09%'
		update @Ret set H10 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '10%'
		update @Ret set H11 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '11%'
		update @Ret set H12 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '12%'
		update @Ret set H13 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '13%'
		update @Ret set H14 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '14%'
		update @Ret set H15 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '15%'
		update @Ret set H16 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '16%'
		update @Ret set H17 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '17%'
		update @Ret set H18 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '18%'
		update @Ret set H19 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '19%'
		update @Ret set H20 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '20%'
		update @Ret set H21 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '21%'
		update @Ret set H22 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '22%'
		update @Ret set H23 = 'N' where DIASEMANA = 7 and @PrimeiraMarcacaoEsperada7 LIKE '23%'

		update @Ret
			set H00 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '00' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '00' then 'N' else '' end
			,   H01 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '01' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '01' then 'N' else '' end
			,   H02 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '02' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '02' then 'N' else '' end
			,   H03 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '03' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '03' then 'N' else '' end
			,   H04 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '04' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '04' then 'N' else '' end
			,   H05 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '05' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '05' then 'N' else '' end
			,   H06 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '06' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '06' then 'N' else '' end
			,   H07 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '07' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '07' then 'N' else '' end
			,   H08 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '08' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '08' then 'N' else '' end
			,   H09 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '09' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '09' then 'N' else '' end
			,   H10 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '10' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '10' then 'N' else '' end
			,   H11 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '11' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '11' then 'N' else '' end
			,   H12 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '12' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '12' then 'N' else '' end
			,   H13 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '13' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '13' then 'N' else '' end
			,   H14 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '14' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '14' then 'N' else '' end
			,   H15 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '15' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '15' then 'N' else '' end
			,   H16 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '16' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '16' then 'N' else '' end
			,   H17 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '17' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '17' then 'N' else '' end
			,   H18 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '18' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '18' then 'N' else '' end
			,   H19 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '19' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '19' then 'N' else '' end
			,   H20 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '20' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '20' then 'N' else '' end
			,   H21 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '21' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '21' then 'N' else '' end
			,   H22 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '22' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '22' then 'N' else '' end
			,   H23 = case when substring (@PrimeiraMarcacaoEsperada7, 1, 2) >= '23' and substring (@UltimaMarcacaoEsperada7, 1, 2) <= '23' then 'N' else '' end
			where DIASEMANA = 7
	end

	/*
	-- TESTES COM HORAS EXTRAS
	declare @in_Pessoa INT = 1002193; declare @CTR INT = 2193; declare @DT1 DATE = cast ('20201103' AS DATE); declare @DT2 DATE = @DT1  -- CLAUDIA DIA 03/11/2020 17:18 AS 20:00
	declare @in_Pessoa INT = 1001868; declare @CTR INT = 1868; declare @DT1 DATE = cast ('20210123' AS DATE); declare @DT2 DATE = dateadd (DAY, 1, @DT1) -- 16:00 AS 02:12
	declare @in_Pessoa INT = 1001868; declare @CTR INT = 1868; declare @DT1 DATE = cast ('20210213' AS DATE); declare @DT2 DATE = dateadd (DAY, 1, @DT1) -- 20:30 AS 06:00
	declare @in_Pessoa INT = 1002020; declare @CTR INT = 2383; declare @DT1 DATE = cast ('20211014' AS DATE); declare @DT2 DATE = dateadd (DAY, 1, @DT1) -- 05:30 AS 07:30 DO DIA SEGUINTE!
	select * from VA_FVERIFICAHORARIO2 (@in_Pessoa, @DT1)
	select * from VA_FVERIFICAHORARIO2 (@in_Pessoa, @DT2)
	select TOP 10 CONTRATO, DATAINICIO, HORADE, DATATERMINO, HORAATE, * from RHAUTHORASEXTRAS where CONTRATO = @CTR and DATAINICIO BETWEEN @DT1 and @DT2

	-- TESTES COM PROGRAMACAO DE HORARIOS
	declare @in_Pessoa INT = 1001632; declare @CTR INT = 1632; declare @DT1 DATE = cast ('20210405' AS DATE); declare @DT2 DATE = dateadd (DAY, 1, @DT1) -- ROBSON SILVA 4A.FEIRA

	select TOP 100 CONTRATO, DATAINICIO, HORADE, DATATERMINO, HORAATE, * from RHAUTHORASEXTRAS where DATAINICIO != DATATERMINO and DATAINICIO >= '20210101'
	select TOP 100 * from RHAUTHORASEXTRAS where HORADE > HORAATE and DATAINICIO >= '20210101' and SUBSTRING (HORAATE, 4, 2) != '00'
	select * from VA_VFUNCIONARIOS where CONTRATO = 1632

	select * from RHPROGRAMACAOHORARIO where DATAHORA >= '20210101' and CONTRATO = 1632 and DATAHORARIO = '20201230'
	select * from RHESCALASSEMANAIS where ESCALA = '0164' and DIASEMANA = 3
	select HORAMARCACAO, * from RHHORARIOSMARCACOES where HORARIO = '0165' --and CLASSEMARCACAO = '01'
	*/
	RETURN
end
GO
