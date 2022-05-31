SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- Descricao: Retorna RECNO do ultimo movimento de estorno do SE5 cujo RECNO foi
--            passado como parametro. Util para filtrar movimentos estornados.
-- Autor....: Robert Koch
-- Data.....: 05/03/2012
--
-- Historico de alteracoes:
-- 02/09/2012 - Robert - Passa a verificar estorno de compensacoes de outros fornecedores.
--

ALTER FUNCTION [dbo].[VA_SE5_ESTORNO]
(
	@RECNO FLOAT
)
RETURNS FLOAT
AS

BEGIN
	DECLARE @RET FLOAT;
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
	/*
	-- SE FOR COMPENSACAO, VERIFICA POSSIBILIDADE DE ESTORNO DO MOVIMENTO VIA CAMPO E5_DOCUMEN.
	-- ISSO PARA CASOS DE ESTORNOS DE COMPENSACOES FEITAS CONTRA OUTROS FORNECEDORES.
	-- EX.: FILIAL 07, FORN. 002499 EM 05/2012.
	IF @RET = 0
	BEGIN
	    SET @RET = ISNULL(
	            (
	                SELECT MAX(ESTORNO.R_E_C_N_O_)
	                FROM   SE5010 ESTORNO,
	                       SE5010 SE5, SE5010 COMP
	                WHERE  SE5.R_E_C_N_O_ = @RECNO
	                       AND SE5.E5_MOTBX = 'CMP'
	                       AND SE5.E5_DOCUMEN != ''
	                       AND COMP.D_E_L_E_T_ = ''
	                       AND COMP.E5_FILIAL = SE5.E5_FILIAL
	                       AND COMP.E5_DOCUMEN = SE5.E5_PREFIXO + SE5.E5_NUMERO + SE5.E5_PARCELA + SE5.E5_TIPO + SE5.E5_CLIFOR + SE5.E5_LOJA
	                       AND COMP.E5_SEQ = SE5.E5_SEQ
	                       AND COMP.E5_TIPODOC = 'BA'
	                       AND ESTORNO.D_E_L_E_T_ = ''
	                       AND ESTORNO.E5_FILIAL = COMP.E5_FILIAL
	                       AND ESTORNO.E5_DOCUMEN = COMP.E5_DOCUMEN
	                       AND ESTORNO.E5_SEQ = COMP.E5_SEQ
	                       AND ESTORNO.E5_TIPODOC = 'ES'
	            ),
	            0
	        )
	END
	*/
	RETURN @RET;
END
GO
