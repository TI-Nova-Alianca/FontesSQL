
-- =============================================
-- Author     : Robert Koch
-- Create date: 27/10/2017
-- Description:	Busca o percentual padrao de rapel do cliente / produto
--              Criado com base no VA_RAPEL.PRW de Catia Cardoso.
-- =============================================
-- Historico de alteracoes:
-- 29/09/2020 - Claudia - Alterada a linha de B1_CLINF para B1_CODLIN. GLPI: 8552
-- 16/11/2021 - Robert  - Removidas referencias fixas a 'protheus.dbo' por que dava problemas qualdo levada para a base teste.
--

ALTER FUNCTION [dbo].[VA_FRAPELPADRAO]
(
	@CLIENTE AS VARCHAR (6),
	@LOJA    AS VARCHAR (2),
	@PRODUTO AS VARCHAR (15)
)
RETURNS FLOAT
AS

BEGIN
	DECLARE @RET AS FLOAT;
	SET @RET = NULL;

	-- VERIFICA SE O CLIENTE TEM RAPEL
	IF (SELECT A1_VABARAP
	      FROM SA1010 SA1
		 WHERE SA1.D_E_L_E_T_ = ''
		   AND SA1.A1_FILIAL  = '  '
		   AND SA1.A1_COD     = @CLIENTE
		   AND SA1.A1_LOJA    = @LOJA) = '0'
		SET @RET = 0;
	ELSE
		BEGIN
		-- TENTA POR CLIENTE + PRODUTO.
		SET @RET = (SELECT ZAX_PRAPEL
					  FROM ZAX010 ZAX, SA1010 SA1, SB1010 SB1
					 WHERE ZAX.D_E_L_E_T_ = ''
					   AND ZAX.ZAX_FILIAL = '  '
					   AND ZAX.ZAX_CLIENT = @CLIENTE
					   AND ZAX.ZAX_LOJA   = @LOJA
					   AND ZAX.ZAX_LINHA  = ''
					   AND ZAX.ZAX_ITEM   = @PRODUTO
					   AND SA1.D_E_L_E_T_ = ''
					   AND SA1.A1_FILIAL  = '  '
					   AND SA1.A1_COD     = ZAX.ZAX_CLIENT
					   AND SA1.A1_LOJA    = ZAX.ZAX_LOJA
					   AND SB1.D_E_L_E_T_ = ''
					   AND SB1.B1_FILIAL  = '  '
					   AND SB1.B1_COD     = ZAX.ZAX_ITEM)

		-- TENTA POR CLIENTE + LINHA
		IF @RET IS NULL
		BEGIN
			DECLARE @LINHA AS VARCHAR (4);
			SET @LINHA = (SELECT B1_CODLIN --B1_CLINF
							FROM SB1010
						   WHERE D_E_L_E_T_ = ''
							 AND B1_FILIAL = '  '
							 AND B1_COD = @PRODUTO);
			IF @LINHA IS NOT NULL
			BEGIN
				-- TENTA POR CLIENTE + LINHA 
				SET @RET = (SELECT ZAX_PRAPEL
							  FROM ZAX010 ZAX, ZAZ010 ZAZ
							 WHERE ZAX.D_E_L_E_T_ = ''
							   AND ZAX.ZAX_FILIAL = '  '
							   AND ZAX.ZAX_CLIENT = @CLIENTE
							   AND ZAX.ZAX_LOJA   = @LOJA
							   AND ZAX.ZAX_LINHA  = @LINHA
							   AND ZAX.ZAX_ITEM   = ''
							   AND ZAZ.D_E_L_E_T_ = ''
							   AND ZAZ.ZAZ_FILIAL = '  '
							   AND ZAZ.ZAZ_CLINF  = ZAX.ZAX_LINHA)
			END
		END

		-- TENTA APENAS POR CLIENTE
		IF @RET IS NULL
		BEGIN
			-- TENTA POR CLIENTE
			SET @RET = (SELECT ZAX_PRAPEL
						  FROM ZAX010 ZAX, SA1010 SA1
						 WHERE ZAX.D_E_L_E_T_ = ''
						   AND ZAX.ZAX_FILIAL = '  '
						   AND ZAX.ZAX_CLIENT = @CLIENTE
						   AND ZAX.ZAX_LOJA   = @LOJA
						   AND ZAX.ZAX_LINHA  = ''
						   AND ZAX.ZAX_ITEM   = ''
						   AND SA1.D_E_L_E_T_ = ''
						   AND SA1.A1_FILIAL  = '  '
						   AND SA1.A1_COD     = ZAX.ZAX_CLIENT
						   AND SA1.A1_LOJA    = ZAX.ZAX_LOJA)
		END
	END

	RETURN ISNULL (@RET, 0)
END

