SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Descricao: Busca informacoes para rastrear movimentacao de etiqueta da producao / integracao Protheus X FullWMS.
-- Autor....: Robert Koch
-- Data.....: 11/12/2020
--
-- Historico de alteracoes:
--

ALTER PROCEDURE [dbo].[SP_RASTREIO_ETIQUETA]
(
	@IN_ETIQ VARCHAR (10)
) AS
BEGIN

	DECLARE @CONTINUA INT = 1;
	DECLARE @PRODUTO VARCHAR (15);

	SELECT 'RASTREANDO ETIQUETA ' + @IN_ETIQ

	IF NOT EXISTS (SELECT *
					FROM LKSRV_PROTHEUS.protheus.dbo.ZA1010
					WHERE D_E_L_E_T_ = ''
					AND ZA1_CODIGO = @IN_ETIQ)
	BEGIN
		SELECT '1.TABELA ZA1', 'ETIQUETA NAO CADASTRADA!'
		SET @CONTINUA = 0;
	END
	ELSE
	BEGIN
		SELECT '1.TABELA ZA1', *
		FROM LKSRV_PROTHEUS.protheus.dbo.ZA1010
		WHERE D_E_L_E_T_ = ''
		AND ZA1_CODIGO = @IN_ETIQ
		
--		SELECT 'ORIGEM_ETIQUETA: ' + CASE WHEN ZA1_OP != '' THEN 'SD3 (APONTAMENTO DE OP)'
--			ELSE CASE WHEN ZA1_DOCE != '' THEN 'SD1 (NF DE ENTRADA)'
--				ELSE CASE WHEN ZA1_IDZAG != '' THEN 'ZAG (SOLIC.TRANSF.ENTRE ALMOX)'
--					ELSE '' END END END
--		FROM LKSRV_PROTHEUS.protheus.dbo.ZA1010
--		WHERE D_E_L_E_T_ = ''
--		AND ZA1_CODIGO = @IN_ETIQ

		SET @PRODUTO = (SELECT ZA1_PROD
						FROM LKSRV_PROTHEUS.protheus.dbo.ZA1010
						WHERE D_E_L_E_T_ = ''
						AND ZA1_CODIGO = @IN_ETIQ)
	END

	IF (@CONTINUA = 1)
	BEGIN
		IF NOT EXISTS (SELECT *
						FROM LKSRV_PROTHEUS.protheus.dbo.v_wms_item
						WHERE coditem = @PRODUTO)
		BEGIN
			SELECT '2.VIEW v_wms_item', 'PRODUTO DEVERIA APARECER NA VIEW'
		END
		ELSE
		BEGIN
			SELECT '2.VIEW v_wms_item', *
			FROM LKSRV_PROTHEUS.protheus.dbo.v_wms_item
			WHERE coditem = @PRODUTO
		END
	END

	IF (@CONTINUA = 1)
	BEGIN
		IF NOT EXISTS (SELECT *
						FROM LKSRV_PROTHEUS.protheus.dbo.tb_wms_etiquetas
						WHERE id = @IN_ETIQ)
		BEGIN
			SELECT '3.TABELA tb_wms_etiquetas', 'ETIQUETA DEVERIA APARECER NA VIEW'
		END
		ELSE
		BEGIN
			SELECT '3.TABELA tb_wms_etiquetas', *
			FROM LKSRV_PROTHEUS.protheus.dbo.tb_wms_etiquetas
			WHERE id = @IN_ETIQ
		END
	END

	IF (@CONTINUA = 1)
	BEGIN
		IF EXISTS (SELECT *
					FROM LKSRV_PROTHEUS.protheus.dbo.v_wms_entrada
					WHERE SUBSTRING (entrada_id, 6, 10) = @IN_ETIQ)
		BEGIN
			SELECT 'ETIQUETA AINDA APARECE NA VIEW v_wms_entrada (PARECE QUE AINDA NAO FOI LIDA PELO FULLWMS)'
		END
	END

	IF (@CONTINUA = 1)
	BEGIN
		IF EXISTS (SELECT *
					FROM LKSRV_PROTHEUS.protheus.dbo.tb_wms_entrada
					WHERE empresa = 1
					AND codfor = @IN_ETIQ)
		BEGIN
			SELECT 'JA FOI VISTA PELO FULLWMS (ENCONTRA-SE NA TABELA tb_wms_entrada)'
		END
	END

END

GO
