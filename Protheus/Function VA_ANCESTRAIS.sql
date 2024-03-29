--
-- Descricao: Retorna tabela com produtos ancestrais do codigo informado.
-- Autor....: Robert koch
-- Data.....: 19/01/2008
--
-- Historico de alteracoes:
--
ALTER FUNCTION [dbo].[VA_ANCESTRAIS]
(
	@FILIAL      VARCHAR(2),
	@COMPONENTE  VARCHAR(15),
	@DATABASE    VARCHAR(8)
)
RETURNS @TMP TABLE 
        (COMP VARCHAR(15), ANCESTRAL VARCHAR (15), QUANT FLOAT, NIVEL INT)
AS


BEGIN
	WITH CTE AS (
	    SELECT G1_COMP,
	           G1_COD,
	           G1_QUANT,
	           0 AS NIVEL
	    FROM   SG1010
	    WHERE  G1_COMP = @COMPONENTE
	           AND D_E_L_E_T_ = ''
	           AND G1_FILIAL = @FILIAL
	           AND G1_INI <= @DATABASE
	           AND G1_FIM >= @DATABASE
	    
	    UNION ALL
	    SELECT SG1.G1_COMP,
	           SG1.G1_COD,
	           SG1.G1_QUANT,
	           C.NIVEL + 1
	    FROM   CTE AS C
	           JOIN SG1010 SG1
	                ON  C.G1_COD = SG1.G1_COMP
	                AND D_E_L_E_T_ = ''
	                AND G1_FILIAL = @FILIAL
	                AND G1_INI <= @DATABASE
	                AND G1_FIM >= @DATABASE
	)
	INSERT INTO @TMP
	  (
	    COMP,
	    ANCESTRAL,
	    QUANT,
	    NIVEL
	  )
	SELECT *
	FROM   CTE
	
	;
	RETURN
END

