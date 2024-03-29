--
-- Descricao: Retorna RECNO do ultimo movimento de estorno do SE5 cujo RECNO foi
--            passado como parametro. Util para filtrar movimentos estornados.
-- Autor....: Robert Koch
-- Data.....: 05/03/2012
--
-- Historico de alteracoes:
-- 02/09/2012 - Robert - Passa a verificar estorno de compensacoes de outros fornecedores.
-- 26/09/2023 - Robert - Desconsidera E5_MOEDA='M1' (ver comentario no local)
--

ALTER FUNCTION [dbo].[VA_SE5_ESTORNO2]
(
	@RECNO FLOAT
)
RETURNS FLOAT
AS

BEGIN
	DECLARE @RET FLOAT;

	-- SE FOR UM MOV.BANCARIO DIGITADO MANUALMENTE, NAO EXISTE MOVIMENTO 'PAR'
	-- DE ESTORNO. APENAS EH PREENCHIDO O CAMPO E5_SITUACA. E, COMO ESSES
	-- MOVIMENTOS NAO POSSUEM PREFIXO, NUMERO, ETC... EU ACABARIA CONSIDERANDO
	-- COMO SE UM FOSSE O ESTORNO DO OUTRO. ENTAO ESTA FUNCAO VAI SEMPRE
	-- RETORNAR ZERO COMO SE NAO ENCONTRASSE O REGISTRO DE ESTORNO DELES.
	IF (SELECT E5_MOEDA
		FROM SE5010
		WHERE R_E_C_N_O_ = @RECNO) = 'M1'
	BEGIN
		SET @RET = 0
	END
	ELSE
	BEGIN
		SET @RET = ISNULL(
	        (
	            SELECT MAX(ESTORNO.R_E_C_N_O_)
	            FROM   SE5010 ESTORNO,
	                   SE5010 SE5
	            WHERE  SE5.R_E_C_N_O_ = @RECNO
	                   AND ESTORNO.D_E_L_E_T_ = ''
	                   AND ESTORNO.E5_FILIAL = SE5.E5_FILIAL
	                   AND ESTORNO.E5_PREFIXO = SE5.E5_PREFIXO
	                   AND ESTORNO.E5_NUMERO = SE5.E5_NUMERO
	                   AND ESTORNO.E5_PARCELA = SE5.E5_PARCELA
	                   AND ESTORNO.E5_TIPO = SE5.E5_TIPO
	                   AND ESTORNO.E5_CLIFOR = SE5.E5_CLIFOR
	                   AND ESTORNO.E5_LOJA = SE5.E5_LOJA
	                   AND ESTORNO.E5_SEQ = SE5.E5_SEQ
	                   AND ESTORNO.E5_TIPODOC = 'ES'
	        ),
	        0
	    )
	END
	RETURN @RET;
END

