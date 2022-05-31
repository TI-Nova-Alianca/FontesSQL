SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- Descricao: Retorna saldo de determinado lancamento da conta corrente
--            de associados na data de referencia.
-- Autor....: Robert Koch
-- Data.....: 01/09/2012
--
-- Historico de alteracoes:
-- 18/03/2013 - Robert - Passa a desconsiderar movimentos com E5_TIPO vazio, pois alguns movtos da
--                       conta corrente geram SE2 e tambem SE5, mas apenas o saldo do SE2 deve ser
--                       considerado, senao o saldo consideraria 2 baixas e ficaria negativo.
-- 08/01/2016 - Robert - Nao considera mais o campo E5_VLDESCO
-- 12/01/2016 - Robert - Desconsidera data do lcto, para manter consistencia com SE2 (antes desconsiderava lctos com data futura).
-- 11/08/2016 - Robert - Deixa de usar o campo E5_VACHVEX e passa a usar as amarracoes padrao do sistema.
-- 14/09/2016 - Robert - Soh recalcula movimentos que geram financeiro.
--

ALTER FUNCTION [dbo].[VA_CTACORRSALDOEM]
(
	@RECNO         AS INT,
	@DATA_POSICAO  AS VARCHAR(8)
)
RETURNS FLOAT
AS

BEGIN
	DECLARE @RET AS FLOAT;
	DECLARE @TM  AS VARCHAR (2);
	SET @RET = 0;
	
	SET @TM  = ISNULL ((SELECT ZI_TM    FROM SZI010 WHERE R_E_C_N_O_ = @RECNO), '')

	-- O SALDO INICIAL EH O PROPRIO VALOR DO LANCAMENTO.
	SET @RET = ISNULL(
	        (
			SELECT ZI_VALOR
	               FROM SZI010 SZI
	               WHERE SZI.R_E_C_N_O_ = @RECNO
	        ),
	        0
		)
	
	IF (SELECT COUNT (*)
			FROM ZX5010
			WHERE D_E_L_E_T_ = ''
			AND ZX5_FILIAL = '  '
			AND ZX5_TABELA = '10'
			AND ZX5_10COD = @TM
			AND ZX5_10GERI IN ('1', '2', '3', '4', '5')
			) > 0  -- 0=Nada;1=NDF no SE2;2=PA no SE2;3=DP no SE2;4=DP no SE2 + Mov.bancario receber;5=SE2 jah gerado por outra rot.
	BEGIN
	    SET @RET = @RET -(
	            SELECT ISNULL(SUM(E5_VALOR - E5_VLJUROS - E5_VLMULTA), 0)
	            FROM   SE5010 SE5,
	                   SZI010 SZI,
					   SE2010 SE2
	            WHERE  SZI.R_E_C_N_O_ = @RECNO
				       AND SE2.D_E_L_E_T_ != '*'
					   AND SE2.E2_FILIAL = SZI.ZI_FILIAL
					   AND SE2.E2_FORNECE = SZI.ZI_ASSOC
					   AND SE2.E2_LOJA = SZI.ZI_LOJASSO
					   AND SE2.E2_PREFIXO = SZI.ZI_SERIE
					   AND SE2.E2_NUM = SZI.ZI_DOC
					   AND SE2.E2_PARCELA = SZI.ZI_PARCELA
	                   AND SE5.D_E_L_E_T_ != '*'
	                   AND SE5.E5_FILIAL = SZI.ZI_FILIAL
	                   AND SE5.E5_SITUACA != 'C'
	                   AND SE5.E5_TIPODOC != 'PA' -- Quando PA, quero suas baixas e nao a sua geracao.
	                   AND SE5.E5_TIPODOC != 'JR'
	                   AND SE5.E5_DTDISPO <= @DATA_POSICAO
					   AND SE5.E5_CLIFOR = SE2.E2_FORNECE
					   AND SE5.E5_LOJA = SE2.E2_LOJA
					   AND SE5.E5_NUMERO = SE2.E2_NUM
					   AND SE5.E5_PREFIXO = SE2.E2_PREFIXO
					   AND SE5.E5_PARCELA = SE2.E2_PARCELA
					   AND dbo.VA_SE5_ESTORNO (SE5.R_E_C_N_O_) = 0 -- Ignora movimentos estornados.
	                   AND SE5.E5_TIPO != ''
	        )
	END
	
	RETURN @RET
END;
GO
