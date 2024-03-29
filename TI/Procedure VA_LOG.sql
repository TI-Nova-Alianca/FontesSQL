
-- Descricao: Grava logs para depuracao / auditoria.
-- Autor....: Robert Koch
-- Data.....: 30/11/2020
--
-- Historico de alteracoes:
-- 07/11/2022 - Robert - Renomeada e migrada para o database TI visando ter sempre num unico lugar.
--

ALTER PROCEDURE [dbo].[VA_LOG]
(
	@ORIGEM VARCHAR (50)
	,@TEXTO VARCHAR (MAX)
) AS
BEGIN
	-- CRIA A TABELA, SE NAO EXISTIR.
	IF OBJECT_ID('VA_LOGS', 'U') IS NULL
	BEGIN
		CREATE TABLE VA_LOGS (
			DATAHORA [datetime] DEFAULT GETDATE (),
			ORIGEM varchar (50) NULL,
			TEXTO varchar(max) NULL
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	END

	INSERT INTO VA_LOGS (ORIGEM, TEXTO) VALUES (@ORIGEM, @TEXTO)

END

