SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
-- Descricao: Retorna saldo de determinado produto x lote x endereco (estoque) em determinada data.
-- Autor....: Robert Koch
-- Data.....: 06/10/2017
--
-- Historico de alteracoes:
--

ALTER FUNCTION [dbo].[VA_FSALDOENDERECO]
(
	@FILIAL        AS VARCHAR(2),
	@PRODUTO       AS VARCHAR(15),
	@LOTE          AS VARCHAR(10),
	@ENDERECO      AS VARCHAR(15),
	@DATA_POSICAO  AS VARCHAR(8)
)
RETURNS FLOAT
AS

BEGIN
	DECLARE @RET      AS FLOAT;
	DECLARE @DATA_SBK AS VARCHAR(8);
	DECLARE @INI_SBK  AS FLOAT;
	DECLARE @MOVTO_SDB AS FLOAT;
	SET @INI_SBK = 0;
	SET @MOVTO_SDB = 0;
	SET @RET = 0;
	
	-- BUSCA DATA MAIS RECENTE DE FECHAMENTO PARA USAR COMO PONTO DE PARTIDA.
	SET @DATA_SBK = ISNULL (
		(
	        SELECT MAX(BK_DATA)
	        FROM   SBK010 SBK_DATA
	        WHERE  SBK_DATA.D_E_L_E_T_ = ''
	               AND SBK_DATA.BK_COD = @PRODUTO
	               AND SBK_DATA.BK_FILIAL = @FILIAL
	               AND SBK_DATA.BK_LOTECTL = @LOTE
	               AND SBK_DATA.BK_LOCALIZ = @ENDERECO
	               AND SBK_DATA.BK_DATA <= @DATA_POSICAO
	    ), '');

	-- INICIALIZA SALDO COM A DATA MAIS RECENTE DO SBK (MESMO QUE SEJA VAZIA, O QUE INDICA IMPLANTACAO DE SALDO).
	SET @INI_SBK = ISNULL(
	        (
	            SELECT SUM (BK_QINI)
	            FROM   SBK010 SBK
	            WHERE  SBK.D_E_L_E_T_ = ''
	                   AND SBK.BK_COD = @PRODUTO
	                   AND SBK.BK_FILIAL = @FILIAL
	                   AND SBK.BK_LOTECTL = @LOTE
					   AND SBK.BK_LOCALIZ = @ENDERECO
	                   AND SBK.BK_DATA = @DATA_SBK
	        ),
	        0
	    );

	-- BUSCA MOVIMENTACOES POSTERIORES NO ARQUIVO DE ENDERECAMENTOS
	SET @MOVTO_SDB = ISNULL(
	        (
	              SELECT SUM (DB_QUANT * CASE WHEN DB_TM <= '499' THEN 1 ELSE -1 END)
				    FROM SDB010 SDB
				   WHERE SDB.D_E_L_E_T_ = ''
				     AND SDB.DB_FILIAL = @FILIAL
					 AND SDB.DB_PRODUTO = @PRODUTO
					 AND SDB.DB_LOTECTL = @LOTE
					 AND SDB.DB_LOCALIZ = @ENDERECO
					 AND SDB.DB_ESTORNO != 'S'
					 AND SDB.DB_DATA > @DATA_SBK
					 AND SDB.DB_DATA <= @DATA_POSICAO
	        ),
	        0
	    )
	
	SET @RET = @INI_SBK + @MOVTO_SDB;
	RETURN @RET
END
GO
