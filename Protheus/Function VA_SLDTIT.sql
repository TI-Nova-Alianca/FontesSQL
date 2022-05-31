SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[VA_SLDTIT]
(	@WPREFIXO   Char( 3),
	@WNUMERO    Char( 9),
	@WPARCELA   Char( 1),
	@WTIPO      Char( 3),
	@WCART      Char( 1),
	@WCLIFOR    Char( 6), 
	@WLOJA      Char( 2),
	@WDATABASE  Char( 8), 
	@WFILIALTIT Char( 2), 
	@WVALORTIT  Float 
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @SALDOTIT		Float
	DECLARE @nSaldoMovto	Float
	DECLARE @nDesconto		Float
	DECLARE @nMulta			Float
	DECLARE @nJuros			Float

	SET @nSaldoMovto   = 0 
	SET @nDesconto	   = 0 
	SET @nMulta		   = 0 
	SET @nJuros		   = 0 
		
	BEGIN
		SELECT @nSaldoMovto  = ISNULL ( SUM(A.E5_VALOR ), 0 ), @nDesconto  = ISNULL ( SUM(A.E5_VLDESCO ), 0 )
		     , @nMulta  = ISNULL ( SUM(A.E5_VLMULTA ), 0 ), @nJuros  = ISNULL ( SUM(A.E5_VLJUROS ), 0 )
		  FROM SE5010 A
		  /*
		 WHERE A.E5_FILIAL  = @WFILIALTIT  and A.E5_PREFIXO  = @WPREFIXO  and A.E5_NUMERO  = @WNUMERO  and A.E5_PARCELA  = @WPARCELA 
			and A.E5_TIPO  = @WTIPO  and A.E5_CLIFOR  = @WCLIFOR  and A.E5_LOJA  = @WLOJA  and A.E5_DATA  <= @WDATABASE
			and A.E5_SITUACA  <> 'C'  and A.E5_TIPODOC in ('VL' , 'BA' , 'V2' , 'CP' , 'LJ' )  and  not  (A.E5_TIPODOC  = 'VL' 
			and A.E5_ORIGEM  = 'LOJXREC '  and @WCART  = 'R' )  and  ( (A.E5_RECPAG  = @WCART )  or  (A.E5_RECPAG  = @WCART  and E5_DOCUMEN  != ' ' 
			) )  and A.D_E_L_E_T_  = ' '  and 0  = (   SELECT COUNT ( * )
														FROM SE5010 B
													WHERE B.E5_FILIAL  = A.E5_FILIAL  and B.E5_PREFIXO  = A.E5_PREFIXO  and B.E5_NUMERO  = A.E5_NUMERO  and B.E5_PARCELA  = A.E5_PARCELA 
														and B.E5_TIPO  = A.E5_TIPO  and B.E5_CLIFOR  = A.E5_CLIFOR  and B.E5_LOJA  = A.E5_LOJA  and B.E5_SEQ  = A.E5_SEQ  and B.E5_TIPODOC  = 'ES' 
														and  (B.E5_DATA  <= @WDATABASE) and B.D_E_L_E_T_  = ' ' )
*/
		WHERE A.E5_PREFIXO  = @WPREFIXO  and A.E5_NUMERO  = @WNUMERO  and A.E5_PARCELA  = @WPARCELA 
			and A.E5_TIPO  = @WTIPO  and A.E5_CLIFOR  = @WCLIFOR  and A.E5_LOJA  = @WLOJA  and A.E5_DATA  <= @WDATABASE
			and A.E5_SITUACA  <> 'C'  
			--and A.E5_TIPODOC in ('VL' , 'BA' , 'V2' , 'CP' , 'LJ' )  
			and (A.E5_TIPODOC in ('VL' , 'BA' , 'V2' , 'CP' , 'LJ') or (A.E5_TIPODOC = 'DC' AND E5_VLDESCO=0) )
			and  not  (A.E5_TIPODOC  = 'VL' and A.E5_ORIGEM  = 'LOJXREC '  and @WCART  = 'R' )  
			and  ( (A.E5_RECPAG  = @WCART )  or  (A.E5_RECPAG  = @WCART  and E5_DOCUMEN  != ' ' ) )  
			and A.D_E_L_E_T_  = ' '  and 0  = (   SELECT COUNT ( * )
														FROM SE5010 B
													WHERE B.E5_FILIAL  = A.E5_FILIAL  and B.E5_PREFIXO  = A.E5_PREFIXO  and B.E5_NUMERO  = A.E5_NUMERO  and B.E5_PARCELA  = A.E5_PARCELA 
														and B.E5_TIPO  = A.E5_TIPO  and B.E5_CLIFOR  = A.E5_CLIFOR  and B.E5_LOJA  = A.E5_LOJA  and B.E5_SEQ  = A.E5_SEQ  and B.E5_TIPODOC  = 'ES' 
														and  (B.E5_DATA  <= @WDATABASE) and B.D_E_L_E_T_  = ' ' )
		 SET @SALDOTIT  = ISNULL(ROUND(@WVALORTIT  - (@nSaldoMovto  - @nJuros  - @nMulta  + @nDesconto ) ,2),0)
	END
	--- no caso de o valor do movimento ser igual ao valor do titulo, mas ter juros lctos e ai o saldo fica o valor do juros 
    IF @WVALORTIT = @nSaldoMovto
    BEGIN
	   SET @SALDOTIT  = 0 	
    END

	RETURN @SALDOTIT
END
GO
