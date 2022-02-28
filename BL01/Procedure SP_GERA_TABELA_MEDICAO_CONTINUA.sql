USE [BL01]
GO
/****** Object:  StoredProcedure [dbo].[SP_GERA_TABELA_MEDICAO_CONTINUA]    Script Date: 28/02/2022 14:58:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- script a ser agendado EM CADA ESTACAO DE MEDICAO DE GRAU
--
-- Descricao: Conversao das tabelas de medicao continua de grau para uma tabela unica.
-- Data:      02/03/2019
-- Autor:     Robert Koch
-- Observ.:   Na safra 2019 solicitamos que a Maseli gerasse uma tabela em SQL Express com dados
--            continuos de medicao de grau. Eles insistiram em gerar uma tabela para cada dia
--            por isso montei este script para fazer a migracao para dentro de uma tabela unica.
--
-- Historico de alteracoes:
-- 19/02/2020 - Robert - Recebe a filial como parametro
--

ALTER PROCEDURE [dbo].[SP_GERA_TABELA_MEDICAO_CONTINUA]
(
	@filial VARCHAR (2)
) AS
BEGIN

-- Cria a tabela para gravar as medicoes continuas
IF OBJECT_ID('MEDICOES_CONTINUAS') IS NULL
create table MEDICOES_CONTINUAS
(
	FILIAL VARCHAR (2) NOT NULL,
	LINHA INT NOT NULL,
	HORA DATETIME,
	LINE_STATUS VARCHAR (6) NOT NULL,
	GRAU FLOAT
	PRIMARY KEY CLUSTERED (FILIAL, LINHA, HORA) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

SET NOCOUNT ON;
declare @tabela varchar (16);
declare @linha varchar (1);
declare @select varchar (max);

-- Cria cursor para processar as tabelas de medicao existentes
declare tblcur CURSOR STATIC LOCAL FOR
		select name, substring (name, 16, 1)
		  from sysobjects
		 where xtype = 'U' and name like 'Mis_%'
		   and substring (name, 11, 4) + substring (name, 8, 2) + substring (name, 5, 2) >= '20190211'  -- antes disso tinha outra estrutura
		   and substring (name, 11, 4) >= '2022'  -- Atualizar a cada safra para nao ler dados antigos desnecessariamente
		 order by substring (name, 11, 4) + substring (name, 8, 2) + substring (name, 5, 2) + substring (name, 16, 1)+ substring (name, 16, 1)
OPEN tblcur
WHILE 1 = 1
BEGIN
	FETCH tblcur INTO @tabela, @linha
	IF @@fetch_status <> 0
		BREAK
	print 'Processando tabela ' + @tabela;

	set @select = '';
	set @select = @select + 'select ''' + @filial + ''' AS FILIAL'
	set @select = @select + ', ' + @linha + ' AS LINHA'
	set @select = @select + ', t.Date as HORA'
	set @select = @select + ', t.Line_status as LINE_STATUS'
	set @select = @select + ', t.Value as GRAU'
	set @select = @select + ' from ' + @tabela + ' t'
	
	-- Peguei casos onde o relogio do PC foi retroagido (final de horario de verao, vai saber...) entao quero somente a ultima medicao
	set @select = @select + ' where not exists (select * '
	set @select = @select +                     ' from ' + @tabela + ' as posterior'
	set @select = @select +                    ' where posterior.Date = t.Date'
	set @select = @select +                      ' and posterior.progressive > t.progressive)'

	-- Se jah existe na tabela continua, nao regrava.
	set @select = @select + ' and not exists (SELECT *'
	set @select = @select +                   ' FROM MEDICOES_CONTINUAS M'
	set @select = @select +                  ' WHERE M.FILIAL = ''' + @filial + ''''
	set @select = @select +                    ' AND M.LINHA  = ''' + @linha + ''''
	set @select = @select +                    ' AND M.HORA   = t.Date)'

	print @select;
	INSERT INTO MEDICOES_CONTINUAS exec (@select)

END
DEALLOCATE tblcur

END
