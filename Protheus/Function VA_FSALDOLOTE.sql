SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- Descricao: Retorna saldo do lote (estoque) em determinada data.
-- Autor....: Robert Koch
-- Data.....: 06/10/2017
--
-- Historico de alteracoes:
-- 28/11/2020 - Robert - Nao considerava origem SD5 (implan.saldo inicial)
--

ALTER FUNCTION [dbo].[VA_FSALDOLOTE]
(
	@FILIAL        AS VARCHAR(2),
	@PRODUTO       AS VARCHAR(15),
	@LOTE          AS VARCHAR(10),
	@DATA_POSICAO  AS VARCHAR(8)
)
RETURNS FLOAT
AS

BEGIN
	DECLARE @RET      AS FLOAT;
	DECLARE @DATA_SBJ AS VARCHAR(8);
	DECLARE @INI_SBJ  AS FLOAT;
	DECLARE @INI_SD5  AS FLOAT;
	DECLARE @ENT_SD1  AS FLOAT;
	DECLARE @SAI_SD2  AS FLOAT;
	DECLARE @ENT_SD3  AS FLOAT;
	DECLARE @SAI_SD3  AS FLOAT;
	SET @INI_SBJ = 0;
	SET @ENT_SD1 = 0;
	SET @SAI_SD2 = 0;
	SET @ENT_SD3 = 0;
	SET @SAI_SD3 = 0;
	SET @RET = 0;
	
	-- BUSCA DATA MAIS RECENTE DE FECHAMENTO PARA USAR COMO PONTO DE PARTIDA.
	SET @DATA_SBJ = ISNULL (
		(
	        SELECT MAX(BJ_DATA)
	        FROM   SBJ010 SBJ_DATA
	        WHERE  SBJ_DATA.D_E_L_E_T_ = ''
	               AND SBJ_DATA.BJ_COD = @PRODUTO
	               AND SBJ_DATA.BJ_FILIAL = @FILIAL
	               AND SBJ_DATA.BJ_LOTECTL = @LOTE
	               AND SBJ_DATA.BJ_DATA <= @DATA_POSICAO
	    ), '');

	-- INICIALIZA SALDO COM A DATA MAIS RECENTE DO SBJ (MESMO QUE SEJA VAZIA, O QUE INDICA IMPLANTACAO DE SALDO).
	SET @INI_SBJ = ISNULL(
	        (
	            SELECT SUM (BJ_QINI)
	            FROM   SBJ010 SBJ
	            WHERE  SBJ.D_E_L_E_T_ = ''
	                   AND SBJ.BJ_COD = @PRODUTO
	                   AND SBJ.BJ_FILIAL = @FILIAL
	                   AND SBJ.BJ_LOTECTL = @LOTE
	                   AND SBJ.BJ_DATA = @DATA_SBJ
	        ),
	        0
	    );

	-- BUSCA IMPLANTACAO DE SALDO (QUANDO O ITEM EXISTIA EM ESTOQUE, MAS NAO CONTROLAVA ENDERECAMENTO)
	SET @INI_SD5 = ISNULL(
	        (
				SELECT SUM (DA_QTDORI)
				FROM   SDA010 SDA, SD5010 SD5
				WHERE  SDA.D_E_L_E_T_ = ''
				       AND DA_FILIAL = @FILIAL
					   AND DA_PRODUTO = @PRODUTO
					   AND DA_LOTECTL = @LOTE
					   AND DA_ORIGEM = 'SD5'
					   AND SD5.D_E_L_E_T_ = ''
					   AND SD5.D5_FILIAL = SDA.DA_FILIAL
					   AND SD5.D5_PRODUTO = SDA.DA_PRODUTO
					   AND SD5.D5_LOTECTL = SDA.DA_LOTECTL
					   AND SD5.D5_NUMSEQ = SDA.DA_NUMSEQ
					   AND SD5.D5_ORIGLAN = 'MAN'
			),
			0
		);

	-- BUSCA NOTAS DE ENTRADA
	SET @ENT_SD1 = ISNULL(
	        (
	            SELECT SUM(D1_QUANT)
	            FROM   SD1010 SD1,
	                   SF4010 SF4
	            WHERE  SD1.D_E_L_E_T_ = ''
	                   AND SD1.D1_FILIAL = @FILIAL
	                   AND SD1.D1_COD = @PRODUTO
	                   AND SD1.D1_LOTECTL = @LOTE
	                   AND SD1.D1_DTDIGIT > @DATA_SBJ
	                   AND SD1.D1_DTDIGIT <= @DATA_POSICAO
	                   AND SF4.D_E_L_E_T_ = ''
	                   AND SF4.F4_FILIAL = '  '
	                   AND SF4.F4_CODIGO = SD1.D1_TES
	                   AND SF4.F4_ESTOQUE = 'S'
	        ),
	        0
	    )
	
	-- BUSCA SAIDAS POR NF
	SET @SAI_SD2 = ISNULL(
	        (
	            SELECT SUM(D2_QUANT)
	            FROM   SD2010 SD2,
	                   SF4010 SF4
	            WHERE  SD2.D_E_L_E_T_ = ''
	                   AND SD2.D2_FILIAL = @FILIAL
	                   AND SD2.D2_COD = @PRODUTO
	                   AND SD2.D2_LOTECTL = @LOTE
	                   AND SD2.D2_EMISSAO > @DATA_SBJ
	                   AND SD2.D2_EMISSAO <= @DATA_POSICAO
	                   AND SF4.D_E_L_E_T_ = ''
	                   AND SF4.F4_FILIAL = '  '
	                   AND SF4.F4_CODIGO = SD2.D2_TES
	                   AND SF4.F4_ESTOQUE = 'S'
	        ),
	        0
	    )
	
	-- BUSCA MOVIMENTOS INTERNOS (ENTRADAS)
	SET @ENT_SD3 = ISNULL(
	        (
	            SELECT SUM(D3_QUANT)
	            FROM   SD3010 AS SD3
	            WHERE  SD3.D_E_L_E_T_ = ''
	                   AND SD3.D3_FILIAL = @FILIAL
	                   AND SD3.D3_COD = @PRODUTO
	                   AND SD3.D3_LOTECTL = @LOTE
	                   AND SD3.D3_EMISSAO > @DATA_SBJ
	                   AND SD3.D3_EMISSAO <= @DATA_POSICAO
	                   AND SD3.D3_TM < '500'
	        ),
	        0
	    )
	
	-- BUSCA MOVIMENTOS INTERNOS (SAIDAS)
	SET @SAI_SD3 = ISNULL(
	        (
	            SELECT SUM(D3_QUANT)
	            FROM   SD3010 AS SD3
	            WHERE  SD3.D_E_L_E_T_ = ''
	                   AND SD3.D3_FILIAL = @FILIAL
	                   AND SD3.D3_COD = @PRODUTO
	                   AND SD3.D3_LOTECTL = @LOTE
	                   AND SD3.D3_EMISSAO > @DATA_SBJ
	                   AND SD3.D3_EMISSAO <= @DATA_POSICAO
	                   AND SD3.D3_TM >= '500'
	        ),
	        0
	    )

--	SET @RET = @INI_SBJ + @ENT_SD1 + @ENT_SD3 - @SAI_SD2 - @SAI_SD3;
	SET @RET = @INI_SBJ + @INI_SD5 + @ENT_SD1 + @ENT_SD3 - @SAI_SD2 - @SAI_SD3;
	RETURN @RET
END


GO
