SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Cooperativa Vinicola Nova Alianca Ltda
-- Funcao para classificar ordens de producao conforme os produtos movimentados.
-- Autor: Robert Koch
-- Data:  25/04/2012
-- Historico de alteracoes:
-- 08/10/2014 - Robert - Criado tratamento para consumo de nectares.
--

ALTER FUNCTION [dbo].[VA_TIPO_OP]
(
	@FILIAL  VARCHAR(2),
	@OP      VARCHAR(13)
)
RETURNS VARCHAR(1)
AS

BEGIN
	DECLARE @RET                AS VARCHAR(1);
	DECLARE @AUX                AS VARCHAR(50);
	DECLARE @PRODUTO_FINAL      AS VARCHAR(15);
	DECLARE @PRODUZ_GRANEL      AS INT;
	DECLARE @PRODUZ_PA          AS INT;
	DECLARE @PRODUZ_PI          AS INT;
	DECLARE @PRODUZ_BORRA       AS INT;
	DECLARE @PRODUZ_NECTAR      AS INT;
	DECLARE @CONSOME_UVA        AS INT;
	DECLARE @CONSOME_NECTAR     AS INT;
	DECLARE @CONSOME_GRANEL     AS INT;
	DECLARE @CONSOME_GARRAFA    AS INT;
	DECLARE @CONSOME_PI         AS INT;
	DECLARE @CONSOME_PA         AS INT;
	DECLARE @CONSOME_SEMI_ACAB  AS INT;
	
	SET @RET = ''; -- VALOR DEFAULT
	
	-- BUSCA PRODUTO FINAL DA OP E SEUS DADOS. CONCATENA DADOS PARA PODER BUSCAR TUDO
	-- NA MESMA QUERY. ESPERO DESCOBRIR UMA FORMA MAIS ELEGANTE DE FAZER ISSO...
	SET @AUX = (
	        SELECT C2_PRODUTO + B1_TIPO + B1_GRPEMB + B1_GRUPO
	        FROM   SC2010 SC2,
	               SB1010 SB1
	        WHERE  SC2.D_E_L_E_T_ = ''
	               AND SC2.C2_FILIAL = @FILIAL
	               AND SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN + SC2.C2_ITEMGRD = @OP
	               AND SB1.D_E_L_E_T_ = ''
	               AND SB1.B1_FILIAL = '  '
	               AND SB1.B1_COD = SC2.C2_PRODUTO
	    );
	SET @PRODUTO_FINAL = SUBSTRING(@AUX, 1, 15);
	
	IF RTRIM(@PRODUTO_FINAL) IN ('0107', '0269', '1197')
	    SET @PRODUZ_BORRA = 1
	ELSE
	    SET @PRODUZ_BORRA = 0;
	
	IF SUBSTRING(@AUX, 18, 2) = '18'
	    SET @PRODUZ_GRANEL = 1
	ELSE
	    SET @PRODUZ_GRANEL = 0;
	
	IF SUBSTRING(@AUX, 16, 2) = 'PA'
	    SET @PRODUZ_PA = 1
	ELSE
	    SET @PRODUZ_PA = 0;
	
	IF SUBSTRING(@AUX, 16, 2) = 'PI'
	    SET @PRODUZ_PI = 1
	ELSE
	    SET @PRODUZ_PI = 0;
	
	IF SUBSTRING(@AUX, 20, 4) IN ('0707')
	    SET @PRODUZ_NECTAR = 1
	ELSE
	    SET @PRODUZ_NECTAR = 0;

	-- VERIFICA ITENS CONSUMIDOS
	SET @CONSOME_UVA = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_GRUPO = '0400'
	               AND SD3.D3_QUANT != 0
	               AND SD3.D3_ESTORNO != 'S'
	    );
	
	SET @CONSOME_NECTAR = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_GRUPO = '0707'
	               AND SD3.D3_QUANT != 0
	               AND SD3.D3_ESTORNO != 'S'
	    );

	SET @CONSOME_GRANEL = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3,
	               SB1010 SB1
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_GRUPO != '0400'
	               AND SD3.D3_QUANT != 0
	               AND SD3.D3_ESTORNO != 'S'
	               AND SB1.D_E_L_E_T_ = ''
	               AND SB1.B1_FILIAL = '  '
	               AND SB1.B1_COD = SD3.D3_COD
	               AND SB1.B1_GRPEMB = '18'
	    );
	
	SET @CONSOME_PI = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3,
	               SB1010 SB1
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_TIPO = 'PI'
	               AND SD3.D3_QUANT != 0
	               AND SD3.D3_ESTORNO != 'S'
	    );
	
	SET @CONSOME_PA = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3,
	               SB1010 SB1
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_TIPO = 'PA'
	               AND SD3.D3_QUANT != 0
	               AND SD3.D3_ESTORNO != 'S'
	    );
	
	SET @CONSOME_SEMI_ACAB = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3,
	               SB1010 SB1
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_COD = RTRIM(@PRODUTO_FINAL) + 'A'
	               AND SD3.D3_QUANT != 0
	               AND SD3.D3_ESTORNO != 'S'
	    );
	
	SET @CONSOME_GARRAFA = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3,
	               SB1010 SB1
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_QUANT != 0
	               AND SD3.D3_ESTORNO != 'S'
	               AND SB1.B1_FILIAL = '  '
	               AND SB1.B1_COD = SD3.D3_COD
	               AND SB1.B1_GRPEMB != '18'
	               AND SB1.B1_CODPAI = @PRODUTO_FINAL
	    );
	
	IF (@PRODUZ_GRANEL > 0 AND @CONSOME_UVA > 0)
	    SET @RET = 'V'; -- VINIFICACAO
	ELSE
	IF (
	       @PRODUZ_GRANEL = 0
	       AND @PRODUZ_PI + @PRODUZ_PA > 0
	       --AND @CONSOME_GRANEL > 0 
	       AND @CONSOME_GRANEL + @CONSOME_NECTAR > 0 
	       AND @CONSOME_UVA = 0
	   )
	    SET @RET = 'E'; -- ENVASE
	ELSE
	IF (
	       @PRODUZ_PI + @PRODUZ_PA > 0
	       AND @PRODUZ_GRANEL = 0
	       AND @CONSOME_GRANEL = 0
	       AND @CONSOME_PI + @CONSOME_PA > 0
	   )
	    SET @RET = 'A'; -- ACABAMENTO
	ELSE
	IF (@PRODUZ_GRANEL = 0 AND @CONSOME_GRANEL = 0 AND @CONSOME_GARRAFA > 0)
	    SET @RET = 'R'; -- REMONTAGEM
	ELSE
	IF (@PRODUZ_BORRA > 0 AND @CONSOME_GRANEL > 0 AND @CONSOME_GARRAFA = 0)
	    SET @RET = 'B'; -- BORRA / TARTARO
	ELSE
	IF (
	       @PRODUZ_GRANEL > 0
	       AND @CONSOME_GRANEL > 0
	       AND @CONSOME_UVA = 0
	       AND @CONSOME_SEMI_ACAB > 0
	   )
	    SET @RET = 'C'; -- CLARIFICAO / CANTINA
	ELSE
	IF (
	       @CONSOME_UVA = 0
	       AND (
	               (@PRODUZ_PI > 0 AND @CONSOME_PI > 0)
	               OR (@PRODUZ_PA > 0 AND @CONSOME_PA > 0)
	               OR (@PRODUZ_GRANEL > 0 AND @CONSOME_GRANEL > 0)
	           )
	   )
	    SET @RET = 'T'; -- TRANSFORMACAO
	ELSE
	IF (
	       @PRODUZ_GRANEL > 0
	       AND @PRODUZ_NECTAR > 0
	       AND @CONSOME_UVA = 0
	   )
	    SET @RET = 'N'; -- NECTAR
	ELSE
		SET @RET = ''; -- NAO DEFINIDA

	RETURN @RET
END


/* VERSAO ATEH 08/10/2014
ALTER FUNCTION [dbo].[VA_TIPO_OP]
(
	@FILIAL  VARCHAR(2),
	@OP      VARCHAR(13)
)
RETURNS VARCHAR(1)
AS
BEGIN
	DECLARE @RET                AS VARCHAR(1);
	DECLARE @AUX                AS VARCHAR(50);
	DECLARE @PRODUTO_FINAL      AS VARCHAR(15);
	DECLARE @PRODUZ_GRANEL      AS INT;
	DECLARE @PRODUZ_PA          AS INT;
	DECLARE @PRODUZ_PI          AS INT;
	DECLARE @PRODUZ_BORRA       AS INT;
	DECLARE @CONSOME_UVA        AS INT;
	DECLARE @CONSOME_GRANEL     AS INT;
	DECLARE @CONSOME_GARRAFA    AS INT;
	DECLARE @CONSOME_PI         AS INT;
	DECLARE @CONSOME_PA         AS INT;
	DECLARE @CONSOME_SEMI_ACAB  AS INT;
	
	SET @RET = ''; -- VALOR DEFAULT
	
	-- BUSCA PRODUTO FINAL DA OP E SEUS DADOS. CONCATENA DADOS PARA PODER BUSCAR TUDO
	-- NA MESMA QUERY. ESPERO DESCOBRIR UMA FORMA MAIS ELEGANTE DE FAZER ISSO...
	SET @AUX = (
	        SELECT C2_PRODUTO + B1_TIPO + B1_GRPEMB + B1_GRUPO
	        FROM   SC2010 SC2,
	               SB1010 SB1
	        WHERE  SC2.D_E_L_E_T_ = ''
	               AND SC2.C2_FILIAL = @FILIAL
	               AND SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN + SC2.C2_ITEMGRD = @OP
	               AND SB1.D_E_L_E_T_ = ''
	               AND SB1.B1_FILIAL = '  '
	               AND SB1.B1_COD = SC2.C2_PRODUTO
	    );
	SET @PRODUTO_FINAL = SUBSTRING(@AUX, 1, 15);
	
	IF RTRIM(@PRODUTO_FINAL) IN ('0107', '0269', '1197')
	    SET @PRODUZ_BORRA = 1
	ELSE
	    SET @PRODUZ_BORRA = 0;
	
	IF SUBSTRING(@AUX, 18, 2) = '18'
	    SET @PRODUZ_GRANEL = 1
	ELSE
	    SET @PRODUZ_GRANEL = 0;
	
	IF SUBSTRING(@AUX, 16, 2) = 'PA'
	    SET @PRODUZ_PA = 1
	ELSE
	    SET @PRODUZ_PA = 0;
	
	IF SUBSTRING(@AUX, 16, 2) = 'PI'
	    SET @PRODUZ_PI = 1
	ELSE
	    SET @PRODUZ_PI = 0;
	
	-- VERIFICA ITENS CONSUMIDOS
	SET @CONSOME_UVA = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_GRUPO = '0400'
	               AND SD3.D3_QUANT != 0
	    );
	
	SET @CONSOME_GRANEL = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3,
	               SB1010 SB1
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_GRUPO != '0400'
	               AND SD3.D3_QUANT != 0
	               AND SB1.D_E_L_E_T_ = ''
	               AND SB1.B1_FILIAL = '  '
	               AND SB1.B1_COD = SD3.D3_COD
	               AND SB1.B1_GRPEMB = '18'
	    );
	
	SET @CONSOME_PI = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3,
	               SB1010 SB1
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_TIPO = 'PI'
	               AND SD3.D3_QUANT != 0
	    );
	
	SET @CONSOME_PA = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3,
	               SB1010 SB1
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_TIPO = 'PA'
	               AND SD3.D3_QUANT != 0
	    );
	
	SET @CONSOME_SEMI_ACAB = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3,
	               SB1010 SB1
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_COD = RTRIM(@PRODUTO_FINAL) + 'A'
	               AND SD3.D3_QUANT != 0
	    );
	
	SET @CONSOME_GARRAFA = (
	        SELECT COUNT(*)
	        FROM   SD3010 SD3,
	               SB1010 SB1
	        WHERE  SD3.D_E_L_E_T_ = ''
	               AND SD3.D3_FILIAL = @FILIAL
	               AND SD3.D3_OP = @OP
	               AND SD3.D3_CF LIKE 'RE%'
	               AND SD3.D3_QUANT != 0
	               AND SB1.B1_FILIAL = '  '
	               AND SB1.B1_COD = SD3.D3_COD
	               AND SB1.B1_GRPEMB != '18'
	               AND SB1.B1_CODPAI = @PRODUTO_FINAL
	    );
	
	IF (@PRODUZ_GRANEL > 0 AND @CONSOME_UVA > 0)
	    SET @RET = 'V'; -- VINIFICACAO
	ELSE
	IF (
	       @PRODUZ_GRANEL = 0
	       AND @PRODUZ_PI + @PRODUZ_PA > 0
	       AND @CONSOME_GRANEL > 0
	       AND @CONSOME_UVA = 0
	   )
	    SET @RET = 'E'; -- ENVASE
	ELSE
	IF (
	       @PRODUZ_PI + @PRODUZ_PA > 0
	       AND @PRODUZ_GRANEL = 0
	       AND @CONSOME_GRANEL = 0
	       AND @CONSOME_PI + @CONSOME_PA > 0
	   )
	    SET @RET = 'A'; -- ACABAMENTO
	ELSE
	IF (@PRODUZ_GRANEL = 0 AND @CONSOME_GRANEL = 0 AND @CONSOME_GARRAFA > 0)
	    SET @RET = 'R'; -- REMONTAGEM
	ELSE
	IF (@PRODUZ_BORRA > 0 AND @CONSOME_GRANEL > 0 AND @CONSOME_GARRAFA = 0)
	    SET @RET = 'B'; -- BORRA / TARTARO
	ELSE
	IF (
	       @PRODUZ_GRANEL > 0
	       AND @CONSOME_GRANEL > 0
	       AND @CONSOME_UVA = 0
	       AND @CONSOME_SEMI_ACAB > 0
	   )
	    SET @RET = 'C'; -- CLARIFICAO / CANTINA
	ELSE
	IF (
	       @CONSOME_UVA = 0
	       AND (
	               (@PRODUZ_PI > 0 AND @CONSOME_PI > 0)
	               OR (@PRODUZ_PA > 0 AND @CONSOME_PA > 0)
	               OR (@PRODUZ_GRANEL > 0 AND @CONSOME_GRANEL > 0)
	           )
	   )
	    SET @RET = 'T'; -- TRANSFORMACAO
	ELSE
	SET @RET = ''; -- NAO DEFINIDA
	
	RETURN @RET
END
*/
GO
