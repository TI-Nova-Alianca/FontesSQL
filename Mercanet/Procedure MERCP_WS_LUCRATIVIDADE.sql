ALTER PROCEDURE MERCP_WS_LUCRATIVIDADE (@P_TIPO_CALCULO INT,
										 @P_PEDIDO       VARCHAR(max),
                                         @P_VARIAVEIS    VARCHAR(max),
                                         @P_CODIGO_CHAMA VARCHAR(10)) as
---------------------------------------------------------------------------------------------------
-- VERSAO	  DATA		     AUTOR			      ALTERACAO
-- 1.0000	  11/08/2015	 TIAGO PRADELLA	      desenvolvimento
-- 1.0001     10/02/2017     tiago                incluido parametro tipo de calculo
---------------------------------------------------------------------------------------------------
declare
	@VERRO         varchar(1024),
	@v_json        varchar(max),
	@v_url         varchar(150),
	@vPointer INT, 
    @vResponseText VARCHAR(8000),
    @vStatus INT,
    @vStatusText VARCHAR(200),
    @unwrappedXml nvarchar(4000)
begin
begin try
	set @v_url = ''
	select @v_url = 'http:' + substring(db_prms_valor,  CHARINDEX('//', db_prms_valor), len(db_prms_valor)) + '/Services/WSLucratividade.svc/Calcular'
      from db_param_sistema 
     where db_prms_id = 'SIS_ENDERECOMERCANETWEB';
    set @v_json = '"{ PEDIDOS :  ';
    set @v_json = @v_json + '\"' + @P_PEDIDO + '\"';
    set @v_json = @v_json + ' , ';
    set @v_json = @v_json + ' VARIAVEIS :  ';
    set @v_json = @v_json + '\"' + @P_VARIAVEIS + '\"';
    set @v_json = @v_json + ' , ';
	set @v_json = @v_json + ' TIPO :  ';
    set @v_json = @v_json + '\"' + cast(@P_TIPO_CALCULO as varchar) + '\"';
    set @v_json = @v_json + ' , ';
    set @v_json = @v_json + ' ORIGEM : ' + @P_CODIGO_CHAMA;
    set @v_json = @v_json + ' } " ';	
    EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @vPointer OUTPUT
	EXEC sp_OAMethod @vPointer, 'open', NULL, 'POST', @v_url
	Exec sp_OAMethod @vPointer, 'setRequestHeader', null, 'Content-Type', 'application/json'	
	EXEC sp_OAMethod @vPointer, 'send', null, @v_json
	EXEC sp_OAMethod @vPointer, 'responseText' --, @vResponseText OUTPUT
	EXEC sp_OAMethod @vPointer, 'Status', @vStatus OUTPUT
	EXEC sp_OAMethod @vPointer, 'StatusText', @vStatusText OUTPUT
	EXEC sp_OADestroy @vPointer
	--Select @vStatus, @vStatusText, @vResponseText
	--select @unwrappedXml
	if @vStatus <> 200
	begin 
		set @VERRO = 'Erro chamada WS: ' + cast(@vStatus as varchar) + ' - ' + isnull( @vStatusText, 'null')
		INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, GETDATE(), 'WS_LUCRATIVIDADE');	
	end
END TRY
BEGIN CATCH
	SET @VERRO = 'ERRO: ' +  ERROR_MESSAGE();
	INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, GETDATE(), 'WS_LUCRATIVIDADE');
--COMMIT;
END CATCH
end
