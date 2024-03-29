--------------------------------------------------------------------------------------------------------------------------
---  1.00003  09/07/2015  TIAGO PRADELLA  DEFINIDO TAMANHO DE CAMPOS VARCHAR NS PARAMETROS DE ENTRADA
---  1.00004  16/07/2015  tiago           incluido try catch, ajustes no replace da mensagem pelas tags
---  1.00005  28/07/2015  tiago           ajustado tag numero do pedido, pois cortava o ultimo digito, e mensagem duplicada
---  1.00006  03/08/2015  tiago           incluida novas tags
---  1.00007  06/06/2017  tiago           novas tags para a solicitacao de investimento
--------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE    MERCP_WORKFLOW_MENS     (@PWL_CLIENTE      FLOAT,
                                             @PWL_PEDIDO       INT,
                                             @PWL_EMPRESA      VARCHAR(25),
                                             @PWL_NOTA         INTEGER,
                                             @PWL_SERIE        VARCHAR(25),
                                             @PWL_USUARIO      VARCHAR(50),
                                             @PVWF3_TITULO     VARCHAR(512),
                                             @PVWF3_TEXTO      VARCHAR(3000),
                                             @POUT_WL_TITULO   VARCHAR(1024) OUTPUT,
                                             @POUT_WL_MENSAGEM VARCHAR(4000) OUTPUT,
											 @PMENSAGEM_COMPLEMENTAR VARCHAR(4000),
											 @P_TIPO_CHAMA      INT
                                            ) AS
BEGIN
DECLARE @VWL_TITULO    VARCHAR(2000) SELECT @VWL_TITULO = @PVWF3_TITULO;
DECLARE @VWL_MENSAGEM  VARCHAR(4000) SELECT @VWL_MENSAGEM = @PVWF3_TEXTO;
DECLARE @VV_CLI_NOME   VARCHAR(40);
DECLARE @VV_ORD_COMPRA VARCHAR(30);
DECLARE @VV_DT_EMISSAO DATETIME;
DECLARE @VV_DT_PREVENT DATETIME;
DECLARE @VV_DT_VCTO    DATETIME;
DECLARE @VV_VLR_PEDIDO FLOAT;
DECLARE @VVDATA		   DATE;
DECLARE @VERRO		   VARCHAR(1000);
DECLARE @VNOTA_SERIE   VARCHAR(50);
DECLARE @v_cod_empresa              varchar(25);
DECLARE @v_nome_empresa             varchar(100);
DECLARE @v_nome_repres              varchar(100);
DECLARE @v_situacao_cliente         int;
declare @v_data_assistencia         DATETIME;
declare @v_dt_emissao_cobranca      DATETIME;
declare @v_dt_vencimento_cobranca   DATETIME;
declare @v_dt_solic_contrato        DATETIME;
declare @v_dt_devolucao             DATETIME;
declare @v_CR01_DTEMIS              datetime;
declare @v_situacao_cliente_des     varchar(20);
declare @V_NUMERO_PEDIDO_SOLIC       INT;
declare @V_VALOR_INVEST_LIBERADO     FLOAT;
declare @V_DATA_LIBERACAO_SOLIC      DATETIME;
DECLARE @V_NOTAS                 VARCHAR(500);
DECLARE @V_COD_TRANSP            FLOAT;
DECLARE @V_DB_TBTRA_NOME         VARCHAR(40);
DECLARE @VDB_PEDI_ATD_DCTO       VARCHAR(512);
---VARIAVEIS PARA A MENSAGEM SEPARADAS POR TAGS
declare @V_TAG				VARCHAR(50);
declare @V_VALOR			VARCHAR(100);
declare @V_MENSAGEM_PIECE   VARCHAR(500);
declare @V_MENSAGEM_TEMP	VARCHAR(4000);
declare @V_COUNT			INT;
DECLARE @V_NUMERO_SOLICITACAO   INT;
DECLARE @V_DESC_MOTIVO_REJEICAO   VARCHAR(1024);
DECLARE @V_NOME_USUARIO     VARCHAR(50)
SET @VWL_TITULO    = SUBSTRING(@PVWF3_TITULO, 1, LEN(@PVWF3_TITULO))
SET @VWL_MENSAGEM  = SUBSTRING(@PVWF3_TEXTO, 1, LEN(@PVWF3_TEXTO))
SET @VV_CLI_NOME   = '';
SET @VV_ORD_COMPRA = '';
SET @VV_DT_EMISSAO = NULL;
SET @VV_DT_PREVENT = NULL;
SET @VV_DT_VCTO    = NULL;
SET @VV_VLR_PEDIDO = 0;
BEGIN TRY
IF @PWL_CLIENTE > 0
BEGIN
   SELECT @VV_CLI_NOME = DB_CLI_NOME 
     FROM DB_CLIENTE 
    WHERE DB_CLI_CODIGO = @PWL_CLIENTE;
END
set @v_situacao_cliente = 0;
SET @V_NUMERO_SOLICITACAO = @PWL_PEDIDO
IF @P_TIPO_CHAMA = 1
BEGIN
	SELECT @PWL_PEDIDO = PEDIDO
	  FROM DB_SOLIC_INVESTIMENTO
	 WHERE NUMERO = @PWL_PEDIDO -- NESSE MOMENTO ESSA VARIAVEL CONTEM O CODIGO DA SOLICITAÇÃO DE INVESTIMENTO
END
IF @PWL_PEDIDO > 0 
BEGIN
    SELECT @VV_ORD_COMPRA       = DB_PED_ORD_COMPRA, 
          @VV_DT_EMISSAO       = DB_PED_DT_EMISSAO,
          @VV_DT_PREVENT       = DB_PED_DT_PREVENT, 
		  @VV_CLI_NOME         = DB_CLI_NOME,
          @VV_VLR_PEDIDO       = ROUND(SUM(DB_PEDI_QTDE_SOLIC*DB_PEDI_PRECO_LIQ),2),
		  @v_nome_repres       = DB_TBREP_NOME,
		  @v_cod_empresa       = DB_TBEMP_CODIGO,
		  @v_nome_empresa      = DB_TBEMP_NOME,
		  @v_situacao_cliente  = DB_CLI_SITUACAO,
		  @V_COD_TRANSP        = DB_PED_COD_TRANSP         
     FROM DB_PEDIDO, DB_PEDIDO_PROD, DB_CLIENTE, DB_TB_REPRES, DB_TB_EMPRESA
    WHERE DB_PED_NRO      = DB_PEDI_PEDIDO
      AND DB_PED_CLIENTE  = DB_CLI_CODIGO
      AND DB_PED_NRO      = @PWL_PEDIDO
	  and db_tbrep_codigo = DB_PED_REPRES
	  and DB_TBEMP_CODIGO = DB_Ped_Empresa
    GROUP BY DB_PED_ORD_COMPRA, DB_PED_DT_EMISSAO, DB_PED_DT_PREVENT, DB_PED_COD_TRANSP, DB_CLI_NOME, DB_CLI_SITUACAO,
               DB_TBEMP_CODIGO, DB_TBEMP_NOME, DB_TBREP_NOME
	SET @V_NOTAS = ''
    BEGIN
	DECLARE C	CURSOR
	FOR SELECT DISTINCT DB_PEDI_ATD_DCTO 
          FROM DB_PEDIDO_PROD
         WHERE DB_PEDI_PEDIDO = @PWL_PEDIDO
	OPEN C
	FETCH NEXT FROM C
	INTO @VDB_PEDI_ATD_DCTO
			SET @V_NOTAS = ', ' + @V_NOTAS + @VDB_PEDI_ATD_DCTO;				
	FETCH NEXT FROM C
	INTO @VDB_PEDI_ATD_DCTO
	CLOSE C
	DEALLOCATE C
	END
	SET @V_NOTAS = SUBSTRING(@V_NOTAS,3,500)
	 SET @V_DB_TBTRA_NOME = ' ';
	 SELECT @V_DB_TBTRA_NOME = DB_TBTRA_NOME       
       FROM DB_TB_TRANSP
      WHERE DB_TBTRA_COD  = @V_COD_TRANSP;
END
IF @PWL_NOTA > 0
BEGIN
   SELECT @VV_ORD_COMPRA      = DB_NOTA_PEDIDO, @VV_DT_EMISSAO = DB_NOTA_DT_EMISSAO,
          @VV_CLI_NOME        = DB_CLI_NOME, @VV_VLR_PEDIDO = ROUND(SUM(DB_NOTAP_VALOR),2),
		  @v_nome_repres      = DB_TBREP_NOME,
		  @v_cod_empresa      = DB_nota_Empresa,
		  @v_nome_empresa     = DB_TBEMP_NOME,
		  @v_situacao_cliente = DB_CLI_SITUACAO
     FROM DB_NOTA_FISCAL, DB_NOTA_PROD, DB_CLIENTE, db_tb_repres, DB_TB_EMPRESA
    WHERE DB_NOTA_EMPRESA = DB_NOTAP_EMPRESA
      AND DB_NOTA_NRO     = DB_NOTAP_NRO
      AND DB_NOTA_SERIE   = DB_NOTAP_SERIE
      AND DB_NOTA_CLIENTE = DB_CLI_CODIGO
      AND DB_NOTA_EMPRESA = @PWL_EMPRESA
      AND DB_NOTA_NRO     = @PWL_NOTA
      AND DB_NOTA_SERIE   = @PWL_SERIE
	  and DB_TBEMP_CODIGO = DB_NOTA_EMPRESA
	  and DB_TBREP_CODIGO = DB_NOTA_REPRES
    GROUP BY DB_NOTA_PEDIDO, DB_NOTA_DT_EMISSAO, DB_CLI_NOME, DB_nota_Empresa, DB_TBEMP_NOME, DB_CLI_SITUACAO, DB_TBREP_NOME
END
SELECT @VV_DT_VCTO    = MIN(CR01_DTVCTO),
       @v_CR01_DTEMIS = min(CR01_DTEMIS)
  FROM MCR01
 WHERE CR01_EMPRESA = @PWL_EMPRESA
   AND CR01_NFNRO   = @PWL_NOTA
   AND CR01_NFSER   = @PWL_SERIE;
SET @VNOTA_SERIE = CAST(ISNULL(@PWL_NOTA, '') AS VARCHAR) 
SET @VNOTA_SERIE = @VNOTA_SERIE + ' ' + @PWL_SERIE
IF ISNULL(@VNOTA_SERIE, '') = ''
	SET @VNOTA_SERIE = '';
if @v_situacao_cliente = 0
	set @v_situacao_cliente_des = 'Ativo'
else if @v_situacao_cliente = 1
	set @v_situacao_cliente_des = 'Bloqueado'
else if @v_situacao_cliente = 2
	set @v_situacao_cliente_des = 'Suspenso'
else if @v_situacao_cliente = 3
	set @v_situacao_cliente_des = 'Desativado'
else if @v_situacao_cliente = 09
	set @v_situacao_cliente_des = 'Novo'
set @VV_VLR_PEDIDO = cast(@VV_VLR_PEDIDO as money)
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<NRO.PEDIDO>', substring( RIGHT('00000000' + CONVERT(VARCHAR(8), (@PWL_PEDIDO)), 8), 1,4) + '/' +   substring( RIGHT('00000000' + CONVERT(VARCHAR(8), (@PWL_PEDIDO)), 8), 5,4)   ) ;
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<NRO.NF>', isnull(@VNOTA_SERIE, ''));
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<COD.CLIENTE>', @PWL_CLIENTE );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<NOME CLIENTE>', @VV_CLI_NOME );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<ORD.COMPRA>', @VV_ORD_COMPRA );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<EMISSAOPED>', CONVERT(VARCHAR, @VV_DT_EMISSAO, 103 ));
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<PREV.ENTREGA>', CONVERT(VARCHAR, ISNULL(@VV_DT_PREVENT, ''), 103 ));
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<1.VENCIMENTO>', CONVERT(VARCHAR, ISNULL(@VV_DT_VCTO, '')));
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<VALORPED>', ' ' + cast( ROUND(@VV_VLR_PEDIDO ,2) as money));
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<VALORNF>', ' ' +  cast(ROUND(@VV_VLR_PEDIDO ,2) as money));
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<NOME USUARIO>', @PWL_USUARIO );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Usu Lib>',  isnull(@PWL_USUARIO, ''));
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Cod Empresa>',isnull(@v_cod_empresa, '') );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Nome Empresa>', isnull(@v_nome_empresa, '') );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Nome Representante>',isnull( @v_nome_repres, '') );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Situação Cliente>',  cast(isnull(@v_situacao_cliente, '') as varchar));
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Emissão do Título>', CONVERT(VARCHAR, isnull(@v_CR01_DTEMIS, ''), 103) );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Vencimento Título>', CONVERT(VARCHAR, isnull(@VV_DT_VCTO, ''), 103) );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<EmissaoPed>', CONVERT(VARCHAR, isnull(@VV_DT_EMISSAO, ''), 103) );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Prev.Entrega>',  CONVERT(VARCHAR,isnull(@VV_DT_PREVENT, ''), 103) );
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Usuário Lib.Pedido>',  isnull(@PWL_USUARIO, ''));
SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Nome Transportador>',  CAST(@V_COD_TRANSP AS VARCHAR) + '-' + @V_DB_TBTRA_NOME);
if isnull(@V_NOTAS, '') <> ''
	SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Nota fiscal>',  @V_NOTAS);
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<NRO.PEDIDO>', substring( RIGHT('00000000' + CONVERT(VARCHAR(8), (@PWL_PEDIDO)), 8), 1,4) + '/' +   substring( RIGHT('00000000' + CONVERT(VARCHAR(8), (@PWL_PEDIDO)), 8), 5,4)) ;
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<NRO.NF>', isnull(@VNOTA_SERIE, ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<COD.CLIENTE>', isnull(@PWL_CLIENTE, '') );
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<NOME CLIENTE>', isnull(@VV_CLI_NOME, '') );
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<ORD.COMPRA>', isnull(@VV_ORD_COMPRA, ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<EMISSAOPED>', isnull(CONVERT(varchar, @VV_DT_EMISSAO, 103), ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<PREV.ENTREGA>',  isnull(CONVERT(varchar, @VV_DT_PREVENT, 103), ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<VALORPED>', ' ' + isnull(cast(ROUND(@VV_VLR_PEDIDO ,2) as money), ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<VALORNF>', ' ' + isnull(cast( ROUND(@VV_VLR_PEDIDO ,2) as money), ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<1.VENCIMENTO>', isnull(CONVERT(varchar, @VV_DT_VCTO, 103), ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<NOME USUARIO>', isnull(@PWL_USUARIO, ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Usu Lib>',  isnull(@PWL_USUARIO, ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Cod Empresa>',isnull(@v_cod_empresa, '')  );
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Nome Empresa>', isnull(@v_nome_empresa, '') );
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Nome Representante>', isnull(@v_nome_repres, '') );
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Situação Cliente>', isnull(@v_situacao_cliente_des, ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Emissão do Título>', isnull(CONVERT(varchar, isnull(@v_CR01_DTEMIS, ''), 103), '') );
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Vencimento Título>', isnull(CONVERT(varchar, isnull(@VV_DT_VCTO, ''), 103), '') );
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<EmissaoPed>', isnull(CONVERT(varchar, isnull(@VV_DT_EMISSAO, ''), 103), '')  );
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Prev.Entrega>',  isnull(CONVERT(varchar, isnull(@VV_DT_PREVENT, ''), 103), ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Usuário Lib.Pedido>',  isnull(@PWL_USUARIO, ''));
SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Nome Transportador>',  CAST(@V_COD_TRANSP AS VARCHAR) + '-' + @V_DB_TBTRA_NOME);
if isnull(@V_NOTAS, '') <> ''
	SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Nota fiscal>',  @V_NOTAS);
if @VWL_TITULO like '%<Nro.PedidoSolic>%'
begin
	SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<Nro.PedidoSolic>',  isnull(@PWL_PEDIDO, ''));
end
if @VWL_MENSAGEM like '%<Nro.PedidoSolic>%'
begin
	SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<Nro.PedidoSolic>',  isnull(@PWL_PEDIDO, ''));
end
if @VWL_TITULO like '%<ValorInvestimentoLiber>%'
BEGIN
	SELECT @V_VALOR_INVEST_LIBERADO = VALOR
	  FROM DB_SOLIC_INVESTIMENTO
	 WHERE NUMERO = @V_NUMERO_SOLICITACAO	 
	SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<ValorInvestimentoLiber>',  isnull(cast( ROUND(@V_VALOR_INVEST_LIBERADO ,2) as money), ''));
END
if @VWL_MENSAGEM like '%<ValorInvestimentoLiber>%'
BEGIN
	SELECT @V_VALOR_INVEST_LIBERADO = VALOR
	  FROM DB_SOLIC_INVESTIMENTO
	 WHERE NUMERO = @V_NUMERO_SOLICITACAO
	SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<ValorInvestimentoLiber>',  isnull(cast( ROUND(@V_VALOR_INVEST_LIBERADO ,2) as money), ''));
END
if @VWL_TITULO like '%<DataLiberacao>%'
begin
	 SELECT TOP 1 @V_DATA_LIBERACAO_SOLIC = DB_SOLINV_DATALIB 
	   FROM DB_SOLIC_INVESTIMENTO_ALCADA 
	  WHERE DB_SOLINV_NUMERO = @V_NUMERO_SOLICITACAO 
	  ORDER BY DB_SOLINV_SEQ DESC
	  if isnull(@V_DATA_LIBERACAO_SOLIC, '') = ''
		set @V_DATA_LIBERACAO_SOLIC = getdate()
	SET @VWL_TITULO = REPLACE(@VWL_TITULO, '<DataLiberacao>',  isnull(CONVERT(varchar, isnull(@V_DATA_LIBERACAO_SOLIC, ''), 103), ''));
end
if @VWL_MENSAGEM like '%<DataLiberacao>%'
begin
	 SELECT TOP 1 @V_DATA_LIBERACAO_SOLIC = DB_SOLINV_DATALIB 
	   FROM DB_SOLIC_INVESTIMENTO_ALCADA 
	  WHERE DB_SOLINV_NUMERO = @V_NUMERO_SOLICITACAO 
	  ORDER BY DB_SOLINV_SEQ DESC
	  if isnull(@V_DATA_LIBERACAO_SOLIC, '') = ''
		set @V_DATA_LIBERACAO_SOLIC = getdate()
	SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<DataLiberacao>',  isnull(CONVERT(varchar, isnull(@V_DATA_LIBERACAO_SOLIC, ''), 103), ''));
end
if @VWL_MENSAGEM like '%<MotivoRejeicaoLiber>%'   
BEGIN
   SET @V_DESC_MOTIVO_REJEICAO = '';
   SELECT @V_DESC_MOTIVO_REJEICAO = DESCRICAO 
     FROM DB_MOTIVO_REJEICAO
    WHERE CODIGO = (SELECT DB_MSG_MOTIVO_REJEICAO 
                      FROM DB_MENSAGEM
                     WHERE DB_MSG_PEDIDO = @PWL_PEDIDO
                       AND DB_MSG_SEQUENCIA  = (select MAX(DB_MSG_SEQUENCIA)
                                                  from DB_MENSAGEM
                                                 WHERE DB_MSG_PEDIDO = @PWL_PEDIDO
                                                   AND ISNULL(DB_MSG_MOTIVO_REJEICAO, '') <> '' ));     
   SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<MotivoRejeicaoLiber>',  ISNULL(@V_DESC_MOTIVO_REJEICAO, ''));     
END
if @VWL_MENSAGEM like '%<UsuarioRejeicaoLiber>%'   
BEGIN
 SET @V_NOME_USUARIO = '';
   SELECT @V_NOME_USUARIO = NOME 
     FROM DB_USUARIO
    WHERE USUARIO = (SELECT DB_MSG_USU_ENVIO 
                      FROM DB_MENSAGEM
                     WHERE DB_MSG_PEDIDO = @PWL_PEDIDO
                       AND DB_MSG_SEQUENCIA  = (select MAX(DB_MSG_SEQUENCIA)
                                                  from DB_MENSAGEM
                                                 WHERE DB_MSG_PEDIDO = @PWL_PEDIDO))
	SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, '<UsuarioRejeicaoLiber>',  ISNULL(@V_NOME_USUARIO, ''));
END
IF ISNULL(@PMENSAGEM_COMPLEMENTAR, '') <> ''
BEGIN
	SET @V_COUNT = 1;
	WHILE 1= 1
	BEGIN
			SET @V_MENSAGEM_PIECE = DBO.MERCF_PIECE(@PMENSAGEM_COMPLEMENTAR , ';', @V_COUNT)
			IF ISNULL(@V_MENSAGEM_PIECE, '') = ''
				BREAK;
			SET @V_COUNT = @V_COUNT + 1
			SET @V_TAG = SUBSTRING(@V_MENSAGEM_PIECE, CHARINDEX('<', @V_MENSAGEM_PIECE), CHARINDEX('>', @V_MENSAGEM_PIECE))
			SET @V_VALOR = REPLACE(@V_MENSAGEM_PIECE, @V_TAG, '')
			IF @VWL_TITULO LIKE '%' + @V_TAG + '%'
				SET @VWL_TITULO = REPLACE(@VWL_TITULO, @V_TAG,  ISNULL(@V_VALOR, ''));
			IF @VWL_MENSAGEM LIKE '%' + @V_TAG + '%'
				SET @VWL_MENSAGEM = REPLACE(@VWL_MENSAGEM, @V_TAG,  ISNULL(@V_VALOR, ''));
	END
END
IF NOT @VWL_MENSAGEM  = ''
BEGIN
   SET @VWL_MENSAGEM = @VWL_MENSAGEM + '<BR>' + '<BR>' ;
END
SET @VWL_MENSAGEM = '<HTML><BODY><FONT FACE = ''COURIER NEW'' SIZE = ''2''>'
                    + @VWL_MENSAGEM + '</HTML></BODY></FONT>';
SET @POUT_WL_TITULO   = @VWL_TITULO;
SET @POUT_WL_MENSAGEM = @VWL_MENSAGEM;
END TRY
	BEGIN CATCH
		SET @VERRO = 'ERRO: '  + ERROR_MESSAGE();
		INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, GETDATE(), 'WORKFLOW_MENS');
    --COMMIT;
	END CATCH
END;
