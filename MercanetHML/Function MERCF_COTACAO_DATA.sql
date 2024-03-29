ALTER FUNCTION MERCF_COTACAO_DATA(@Pcotacao INT, @Pdata DATETIME) RETURNS FLOAT
BEGIN
DECLARE @v_valor_retorno FLOAT;
(SELECT @v_valor_retorno = max(DB_MOEC_VALOR)
FROM DB_MOEDA_COTACAO
WHERE  DB_MOEC_CODIGO = @Pcotacao
and DB_MOEC_DATA = @Pdata)
IF @v_valor_retorno = 0
RETURN 1;
RETURN isnull(@v_valor_retorno, 1);
END
