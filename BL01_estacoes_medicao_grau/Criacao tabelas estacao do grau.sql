-- Cooperativa Nova Aliança
-- Script de criacao de tabelas no SQL Express das estacoes de meducao de grau da uva para safra

USE [BL01]
GO

/****** Object:  Table [dbo].[SQL_BL01_TABLE]    Script Date: 05/02/2021 07:59:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SQL_BL01_TABLE](
	[ZZA_FILIAL] [nvarchar](2) NULL,
	[ZZA_SAFRA] [nvarchar](4) NULL,
	[ZZA_CARGA] [nvarchar](4) NULL,
	[ZZA_PRODUT] [nvarchar](15) NULL,
	[DATA_VALUE] [float] NULL,
	[DATA_NUMBER] [nvarchar](20) NULL,
	[LINE_SELECTED] [int] NULL,
	[PRODUCT_NAME] [nvarchar](40) NULL,
	[PRODUCER_NAME] [nvarchar](50) NULL,
	[RESULT] [real] NULL,
	[SAMPLES_NUMBER] [int] NULL,
	[MEASURE_SCALE] [smallint] NULL,
	[MEASURE_NAME] [nvarchar](10) NULL,
UNIQUE CLUSTERED 
(
	[ZZA_FILIAL] ASC,
	[ZZA_SAFRA] ASC,
	[ZZA_CARGA] ASC,
	[ZZA_PRODUT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [BL01]
GO

/****** Object:  Table [dbo].[SQL_BL01_SAMPLES]    Script Date: 05/02/2021 07:59:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SQL_BL01_SAMPLES](
	[ZZA_FILIAL] [nvarchar](2) NOT NULL,
	[ZZA_SAFRA] [nvarchar](4) NOT NULL,
	[ZZA_CARGA] [nvarchar](4) NOT NULL,
	[ZZA_PRODUT] [nvarchar](15) NOT NULL,
	[SAMPLE] [int] NOT NULL,
	[RESULT] [real] NULL,
UNIQUE CLUSTERED 
(
	[ZZA_FILIAL] ASC,
	[ZZA_SAFRA] ASC,
	[ZZA_CARGA] ASC,
	[ZZA_PRODUT] ASC,
	[SAMPLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [BL01]
GO

/****** Object:  Table [dbo].[MEDICOES_CONTINUAS]    Script Date: 05/02/2021 08:00:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MEDICOES_CONTINUAS](
	[FILIAL] [varchar](2) NOT NULL,
	[LINHA] [int] NOT NULL,
	[HORA] [datetime] NOT NULL,
	[LINE_STATUS] [varchar](6) NOT NULL,
	[GRAU] [float] NULL,
	ENVIADO_PARA_SERVIDOR [CHAR](1) NOT NULL DEFAULT 'N',
PRIMARY KEY CLUSTERED 
(
	[FILIAL] ASC,
	[LINHA] ASC,
	[HORA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO




CREATE TABLE [dbo].[ZZA010](
	[ZZA_FILIAL] [varchar](2)  NOT NULL DEFAULT '  ',
	[ZZA_SAFRA] [varchar](4)   NOT NULL DEFAULT '    ',
	[ZZA_CARGA] [varchar](4)   NOT NULL DEFAULT '    ',
	[ZZA_PRODUT] [varchar](15) NOT NULL DEFAULT '               ',
	[ZZA_STATUS] [varchar](1)  NOT NULL DEFAULT ' ',
	[ZZA_GRAU] [float]         NOT NULL DEFAULT 0,
	[ZZA_LINHA] [varchar](1)   NOT NULL DEFAULT ' ',
	[ZZA_NASSOC] [varchar](40) NOT NULL DEFAULT '                                        ',
	[ZZA_NPROD] [varchar](40)  NOT NULL DEFAULT '                                        ',
	[ZZA_INIST1] [varchar](17) NOT NULL DEFAULT '                 ',
	[ZZA_INIST2] [varchar](17) NOT NULL DEFAULT '                 ',
	[ZZA_INIST3] [varchar](17) NOT NULL DEFAULT '                 ',
	[ZZA_TQPULM] [varchar](1)  NOT NULL DEFAULT ' ',
	[D_E_L_E_T_] [varchar](1)  NOT NULL DEFAULT ' ',
	[ENVIADO_PARA_SERVIDOR] [datetime],
 CONSTRAINT [ZZA010_PK] PRIMARY KEY CLUSTERED (ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT ASC)
 WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[VA_TRG_ZZA010]
ON [dbo].[ZZA010]
FOR  UPDATE
AS
BEGIN

	-- Trigger para alimentar campos adicionais tabela ZZA (comunicacao
	-- Protheusx programa de leitura grau uva safra). Inicialmente grava
	-- data e hora das alteracoes no campo ZZA_STATUS.
	-- Autor: Robert Koch
	-- Data:  meados de 2017
	--
	-- Historico de alteracoes:
	-- 15/02/2023 - Robert - Gavar campo ZZA_TQPULM
	-- 18/01/2024 - Robert - Aplicado no SQL Espress local da estacao do grau na F01
	--                     - Grava apenas ZZA_INIST2 e ZZA_INIST3 (nao tenho demais situacoes no SQL da estacao)
	--

	DECLARE @AGORA AS DATETIME;
	SET @AGORA = GETDATE();
	DECLARE @DEST AS VARCHAR (17);
	SET @DEST = convert(varchar(8), @AGORA, 112) + ' ' + convert(varchar(8), @AGORA, 114);

	-- ZZA_STATUS: 0=Falta pesagem;1=Aguarda medicao grau;2=Medindo grau;3=Medicao encerrada
	UPDATE ZZA
	SET    ZZA_INIST2 = CASE ZZA.ZZA_STATUS WHEN '2' THEN @DEST ELSE ZZA.ZZA_INIST2 END,
	       ZZA_INIST3 = CASE ZZA.ZZA_STATUS WHEN '3' THEN @DEST ELSE ZZA.ZZA_INIST3 END
	FROM ZZA010 ZZA, DELETED D
	WHERE ZZA.ZZA_FILIAL = D.ZZA_FILIAL
	  AND ZZA.ZZA_SAFRA  = D.ZZA_SAFRA
	  AND ZZA.ZZA_CARGA  = D.ZZA_CARGA
	  AND ZZA.ZZA_STATUS != D.ZZA_STATUS  -- PARA NAO EXECUTAR QUANDO O CONTEUDO PERMANECER O MESMO DO ANTERIOR.
END



--; teste robert   Provider=SQLNCLI11.1;Password=Brx2011a;Persist Security Info=True;User ID=brix;Initial Catalog=BL01;Data Source=127.0.0.1
-- drop table ZZA010
-- delete ZZA010
-- exec SP_SINCRONIZA_ZZA '01', '2024'
-- insert into ZZA010 (ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT, ZZA_STATUS) VALUES ('01', '2025', '0000', 'TESTE ROBERT', '1')
 SELECT * FROM ZZA010
-- UPDATE ZZA010 SET ZZA_STATUS = '3' WHERE ZZA_FILIAL = '01' AND ZZA_SAFRA = '2024' AND ZZA_CARGA = '0000'

