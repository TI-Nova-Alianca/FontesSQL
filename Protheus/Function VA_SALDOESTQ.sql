SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- Descricao: Retorna saldo do produto em estoque em determinada data.
-- Autor....: Robert Koch
-- Data.....: 28/02/2012
--
-- Historico de alteracoes:
-- 10/06/2016 - Robert - Quando nao tinha nenhum SB9, assumia NULL e zerava o restante do calculo, retornando zero.
--

ALTER FUNCTION [dbo].[VA_SALDOESTQ]
(
	@FILIAL        AS VARCHAR(2),
	@PRODUTO       AS VARCHAR(15),
	@LOCAL         AS VARCHAR(2),
	@DATA_POSICAO  AS VARCHAR(8)
)
RETURNS FLOAT
AS


BEGIN
	DECLARE @RET       AS FLOAT;
	DECLARE @DATA_SB9  AS VARCHAR(8);
	DECLARE @INI_SB9   AS FLOAT;
	DECLARE @ENT_SD1   AS FLOAT;
	DECLARE @SAI_SD2   AS FLOAT;
	DECLARE @ENT_SD3   AS FLOAT;
	DECLARE @SAI_SD3   AS FLOAT;
	SET @INI_SB9 = 0;
	SET @ENT_SD1 = 0;
	SET @SAI_SD2 = 0;
	SET @ENT_SD3 = 0;
	SET @SAI_SD3 = 0;
	SET @RET = 0;
	
	-- BUSCA DATA MAIS RECENTE NO SB9 PARA USAR COMO PONTO DE PARTIDA.
--	SET @DATA_SB9 = (
--	        SELECT MAX(ISNULL(B9_DATA, ''))
--	        FROM   SB9010 SB9_DATA
--	        WHERE  SB9_DATA.D_E_L_E_T_ = ''
--	               AND SB9_DATA.B9_COD = @PRODUTO
--	               AND SB9_DATA.B9_FILIAL = @FILIAL
--	               AND SB9_DATA.B9_LOCAL = @LOCAL
--	               AND SB9_DATA.B9_DATA <= @DATA_POSICAO
--	    );
	SET @DATA_SB9 = ISNULL (
		(
	        SELECT MAX(B9_DATA)
	        FROM   SB9010 SB9_DATA
	        WHERE  SB9_DATA.D_E_L_E_T_ = ''
	               AND SB9_DATA.B9_COD = @PRODUTO
	               AND SB9_DATA.B9_FILIAL = @FILIAL
	               AND SB9_DATA.B9_LOCAL = @LOCAL
	               AND SB9_DATA.B9_DATA <= @DATA_POSICAO
	    ), '');
	
	-- INICIALIZA SALDO COM A DATA MAIS RECENTE DO SB9 (MESMO QUE SEJA VAZIA, O QUE INDICA IMPLANTACAO DE SALDO).
	SET @INI_SB9 = ISNULL(
	        (
	            SELECT B9_QINI
	            FROM   SB9010 SB9
	            WHERE  SB9.D_E_L_E_T_ = ''
	                   AND SB9.B9_COD = @PRODUTO
	                   AND SB9.B9_FILIAL = @FILIAL
	                   AND SB9.B9_LOCAL = @LOCAL
	                   AND SB9.B9_DATA = @DATA_SB9
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
	                   AND SD1.D1_LOCAL = @LOCAL
	                   AND SD1.D1_DTDIGIT > @DATA_SB9
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
	                   AND SD2.D2_LOCAL = @LOCAL
	                   AND SD2.D2_EMISSAO > @DATA_SB9
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
	                   AND SD3.D3_LOCAL = @LOCAL
	                   AND SD3.D3_EMISSAO > @DATA_SB9
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
	                   AND SD3.D3_LOCAL = @LOCAL
	                   AND SD3.D3_EMISSAO > @DATA_SB9
	                   AND SD3.D3_EMISSAO <= @DATA_POSICAO
	                   AND SD3.D3_TM >= '500'
	        ),
	        0
	    )
	
	SET @RET = @INI_SB9 + @ENT_SD1 + @ENT_SD3 - @SAI_SD2 - @SAI_SD3;
	RETURN @RET
END
GO
