ALTER PROCEDURE MERCP_INSERE_PROD_USU (@P_USUARIO VARCHAR(27),
                                        @P_GRUPO   INT
                                       ) AS
DECLARE @V_SQL             NVARCHAR(MAX);
DECLARE @V_LISTA_TIPO_PROD VARCHAR(MAX);
DECLARE @V_LISTA_MARCA     VARCHAR(MAX);
DECLARE @V_LISTA_FAMILIA   VARCHAR(MAX);
DECLARE @V_LISTA_GRUPO     VARCHAR(MAX);
DECLARE @V_LISTA_PRECO     VARCHAR(MAX);
DECLARE @V_LISTA_PRODUTOS  VARCHAR(MAX);
DECLARE @V_SITUACAO        VARCHAR(25);
DECLARE @VERRO             VARCHAR(150);
DECLARE @TEMP_PRODNOVOS table (PRODUTO VARCHAR(27), USUARIO VARCHAR(20));
DECLARE @TEMP_PRODEXISTENTES table (PRODUTO VARCHAR(27), USUARIO VARCHAR(20));
DECLARE @TEMP_PRODREMOVER table (PRODUTO VARCHAR(27));
BEGIN
SET NOCOUNT ON;
SET FMTONLY OFF;
BEGIN TRY
	SET @V_SQL = '';
	SET @V_LISTA_TIPO_PROD = '';
	SET @V_LISTA_MARCA = '';
	SET @V_LISTA_FAMILIA = '';
	SET @V_LISTA_GRUPO = '';
	SET @V_LISTA_PRECO = '';
	SET @V_LISTA_PRODUTOS = '';
	--DELETE DB_PRODUTO_USUARIO WHERE USUARIO = @P_USUARIO;
	SELECT @V_SITUACAO = ''''  + REPLACE(ISNULL(DB_PRMS_VALOR, 'A'), ',', ''',''') + ''''
		FROM DB_PARAM_SISTEMA
		WHERE DB_PRMS_ID = 'MOB_SITUACAOPRODUTO';
	IF ISNULL(@V_SITUACAO, '') = ''
	   SET @V_SITUACAO = '''A''';
	SELECT @V_LISTA_TIPO_PROD = COALESCE(
                                     (SELECT CAST(TIPO_PRODUTO AS VARCHAR) + ',' AS [text()]
                                        FROM DB_GRUPO_USU_TPROD USU_TPPROD
                                       WHERE USU_TPPROD.GRUPO_USUARIO = @P_GRUPO
                                      for xml path(''), type).value('.[1]', 'varchar(max)'), '')
	IF @V_LISTA_TIPO_PROD <> ''
	   SET @V_LISTA_TIPO_PROD = ' AND DB_PROD_TPPROD IN (''' + REPLACE(SUBSTRING(@V_LISTA_TIPO_PROD, 1, LEN(@V_LISTA_TIPO_PROD) - 1), ',', ''',''') + ''')';
	SELECT @V_LISTA_MARCA = COALESCE(
									 (SELECT CAST(VALOR_STRING AS VARCHAR) + ',' AS [text()]
										FROM DB_FILTRO_GRUPOUSU
									   WHERE ID_FILTRO    = 'MARCAPROD'
										 AND CODIGO_GRUPO = @P_GRUPO
									  for xml path(''), type).value('.[1]', 'varchar(max)'), '')
	IF @V_LISTA_MARCA <> ''
	   SET @V_LISTA_MARCA = ' AND DB_PROD_MARCA IN (''' + REPLACE(SUBSTRING(@V_LISTA_MARCA, 1, LEN(@V_LISTA_MARCA) - 1), ',', ''',''') + ''') ';
	SELECT @V_LISTA_FAMILIA = COALESCE(
                                   (SELECT CAST(VALOR_STRING AS VARCHAR) + ',' AS [text()]
                                      FROM DB_FILTRO_GRUPOUSU
                                     WHERE ID_FILTRO    = 'FAMILIAPROD'
                                       AND CODIGO_GRUPO = @P_GRUPO
                                    for xml path(''), type).value('.[1]', 'varchar(max)'), '')
	IF @V_LISTA_FAMILIA <> ''
	   SET @V_LISTA_FAMILIA = ' AND DB_PROD_FAMILIA IN (''' + REPLACE(SUBSTRING(@V_LISTA_FAMILIA, 1, LEN(@V_LISTA_FAMILIA) - 1), ',', ''',''') + ''')';
	SELECT @V_LISTA_GRUPO = COALESCE(
                                 (SELECT CAST(VALOR_STRING AS VARCHAR) + '|||' AS [text()]
                                    FROM DB_FILTRO_GRUPOUSU
                                   WHERE ID_FILTRO    = 'GRUPOPROD'
                                     AND CODIGO_GRUPO = @P_GRUPO
                                  for xml path(''), type).value('.[1]', 'VARCHAR(MAX)'), '')
	IF @V_LISTA_GRUPO <> ''
	   SET @V_LISTA_GRUPO = ' AND ( DB_PROD_GRUPO' + ' + '','' + ' + 'DB_PROD_FAMILIA) IN (''' + REPLACE(SUBSTRING(@V_LISTA_GRUPO, 1, LEN(@V_LISTA_GRUPO) - 3), '|||', ''',''') + ''')';
	SELECT @V_LISTA_PRODUTOS = COALESCE(
									 (SELECT CAST(VALOR_STRING AS VARCHAR) + ',' AS [text()]
										FROM DB_FILTRO_GRUPOUSU
									   WHERE ID_FILTRO    = 'PRODUTOS'
										 AND CODIGO_GRUPO = @P_GRUPO
									  for xml path(''), type).value('.[1]', 'varchar(max)'), '')
									  PRINT '@V_LISTA_PRODUTOS = ' + @V_LISTA_PRODUTOS
	IF @V_LISTA_PRODUTOS <> ''
	   SET @V_LISTA_PRODUTOS = ' AND DB_PROD_CODIGO IN (''' + REPLACE(SUBSTRING(@V_LISTA_PRODUTOS, 1, LEN(@V_LISTA_PRODUTOS) - 1), ',', ''',''') + ''') ';
	SELECT @V_LISTA_PRECO = COALESCE(
                                 (SELECT CAST(VALOR_STRING AS VARCHAR) + ',' AS [text()]
                                    FROM DB_PRECO,
                                         DB_FILTRO_GRUPOUSU
                                   WHERE DB_PRECO_CODIGO    = VALOR_STRING
                                     AND ID_FILTRO          = 'LISTAPRECO'
                                     AND CODIGO_GRUPO       = @P_GRUPO
                                     AND DB_PRECO_SITUACAO  = 'A'
                                     AND DB_PRECO_DATA_FIN >= GETDATE()
                                  for xml path(''), type).value('.[1]', 'varchar(max)'), '')
	IF ISNULL(@V_LISTA_PRECO, '') = ''
		BEGIN
		   SELECT @V_LISTA_PRECO = COALESCE(
											(SELECT CAST(DB_PRECO_CODIGO AS VARCHAR) + ',' AS [text()]
											   FROM DB_PRECO
											  WHERE DB_PRECO_SITUACAO  = 'A'
												AND DB_PRECO_DATA_FIN >= GETDATE()
											 for xml path(''), type).value('.[1]', 'varchar(max)'), '')
		END
	IF @V_LISTA_PRECO <> ''
	   SET @V_LISTA_PRECO = '''' + REPLACE(SUBSTRING(@V_LISTA_PRECO, 1, LEN(@V_LISTA_PRECO) - 1), ',', ''',''') + '''';
	SET @V_SQL =  'SELECT PROD.DB_PROD_CODIGO, ''' + @P_USUARIO +
				   '''  FROM DB_PRODUTO PROD
				   WHERE UPPER(DB_PROD_SITUACAO) IN (' + @V_SITUACAO + ')';
	SET @V_SQL = @V_SQL + @V_LISTA_TIPO_PROD;
	SET @V_SQL = @V_SQL + @V_LISTA_MARCA;
	SET @V_SQL = @V_SQL + @V_LISTA_FAMILIA;
	SET @V_SQL = @V_SQL + @V_LISTA_GRUPO;
	SET @V_SQL = @V_SQL + @V_LISTA_PRODUTOS;
	SET @V_SQL = @V_SQL + ' AND EXISTS (SELECT 1 
                                FROM (SELECT REPRESENTANTE FROM DB_REPRES_USUARIO R WHERE R.USUARIO = ''' + @P_USUARIO + ''') R 
                                WHERE ((CHARINDEX ('','' + CAST(R.REPRESENTANTE AS VARCHAR) + '','', '','' + ltrim(rtrim(DB_PROD_REPRES)) + '','') > 0 AND ISNULL(DB_PROD_EXCREPRES,0) = 0) 
                                   OR (CHARINDEX ('','' + CAST(R.REPRESENTANTE AS VARCHAR) + '','', '','' + ltrim(rtrim(DB_PROD_REPRES)) + '','') = 0 AND ISNULL(DB_PROD_EXCREPRES,0) = 1) 
                                   OR ISNULL(ltrim(rtrim(DB_PROD_REPRES)), '''') = '''') 
                                        )   ';
	IF @V_LISTA_PRECO <> ''
	BEGIN
	   SET @V_SQL = @V_SQL + ' AND 1 =
							   (SELECT TOP 1 1
								  FROM DB_PRECO_PROD PPROD
								 WHERE DB_PRECOP_DTVALF   >= GETDATE()
								   AND DB_PRECOP_SITUACAO IN (' + @V_SITUACAO + ') ' +
								 ' AND DB_PRECOP_CODIGO   IN (' + @V_LISTA_PRECO + ')
								   AND PPROD.DB_PRECOP_PRODUTO = PROD.DB_PROD_CODIGO)';
	END
	--PRINT 'SQL = ' + @V_SQL
	INSERT INTO @TEMP_PRODNOVOS (PRODUTO, USUARIO) 
	EXEC SP_EXECUTESQL @V_SQL;
	INSERT INTO @TEMP_PRODEXISTENTES (PRODUTO, USUARIO)
	 SELECT PRODUTO, USUARIO FROM DB_PRODUTO_USUARIO
  	   WHERE DB_PRODUTO_USUARIO.USUARIO =  @P_USUARIO;
	-- Insere Produtos Que Apenas Existem na @TEMP_PRODNOVOS 
	INSERT INTO DB_PRODUTO_USUARIO(PRODUTO, USUARIO)
	 SELECT TAB2.PRODUTO, TAB2.USUARIO 
	 FROM (
		SELECT TAB.PRODUTO, TAB.USUARIO, SUM(TAB.OPCAO) As Soma
		FROM (
			SELECT PRODUTO, USUARIO, 1 as Opcao FROM @TEMP_PRODNOVOS
			UNION ALL
			SELECT PRODUTO, USUARIO, 2 as Opcao FROM @TEMP_PRODEXISTENTES ) TAB
		GROUP BY TAB.PRODUTO, TAB.USUARIO
		HAVING SUM(TAB.OPCAO) = 1 
	 ) TAB2;
	--Insere em Tabela Tempor�ria os Produtos que Dever�o ser Removidos da DB_Produto_Usuario
	INSERT INTO @TEMP_PRODREMOVER(PRODUTO)
	 SELECT TAB2.PRODUTO
	 FROM (
		SELECT TAB.PRODUTO, SUM(TAB.OPCAO) As Soma
		FROM (
			SELECT PRODUTO, 1 as Opcao FROM @TEMP_PRODNOVOS
			UNION ALL
			SELECT PRODUTO, 2 as Opcao FROM @TEMP_PRODEXISTENTES ) TAB
		GROUP BY TAB.PRODUTO
		HAVING SUM(TAB.OPCAO) = 2 
	 ) TAB2;
	-- Remove da DB_Produto_Usuario Itens que j� n�o pertencem mais ao usu�rio
	DELETE FROM DB_PRODUTO_USUARIO WHERE USUARIO= @P_USUARIO AND PRODUTO IN (SELECT PRODUTO FROM @TEMP_PRODREMOVER);
END TRY
BEGIN CATCH
  SET @VERRO = 'ERRO: ' + ERROR_MESSAGE() + ' , LINHA: ' + CAST(ISNULL(ERROR_LINE(), 0) AS VARCHAR) + @P_USUARIO
  INSERT INTO DBS_ERROS_TRIGGERS
    (DBS_ERROS_OBJETO, DBS_ERROS_ERRO, DBS_ERROS_DATA)
  VALUES
    ('MERCP_INSERE_PROD_USU', ISNULL(@VERRO, 'NULL'), GETDATE())
END CATCH
END;
