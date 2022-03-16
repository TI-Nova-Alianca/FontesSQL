SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_CONCORRENTE_EXPORT_CLIENTE] AS

---------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR          ALTERACAO
---  1.0000   09/05/2016  ALENCAR        DESENVOLVIMENTO - Rotina que exporta clientes automaticamente. 
---                                                        Será executada através de um scheduler no banco
---                                      ETAPAS EXECUTADAS:
---                                              1 - exporta Clientes para a interface
---                                              2 - atualiza o retorno dos clientes com informacao da interface(incluindo nro do cliente gerado e msgs de erros)
---                                      Estrutura dos programas de exportação:
---                        MERCP_CONCORRENTE_EXPORT_CLIENTE --> MERCP_INSERE_CLIENTE_ERP
---  1.0001   16/05/2016   ALENCAR       Ao exportar o cliente colocar uma restrição para não permitir digitar pedidos.
---                                      Essa restrição é retirada no momento do retorno do cliente na rotina MERCP_ATUALIZA_RETORNO_CLIENTE
---------------------------------------------------------------------------------------------------

BEGIN

    DECLARE	@VERRO            VARCHAR(255);
	DECLARE @VRETORNO         VARCHAR(255);
	DECLARE @VOBJETO          VARCHAR(200) SELECT @VOBJETO = 'MERCP_CONCORRENTE_EXPORT_CLIENTE';

	DECLARE @VDB_CLI_CODIGO  FLOAT;

	-------------------------
	--- PRIMEIRA ETAPA - EXPORTAR CLIENTES PARA INTERFACES
	-------------------------
	BEGIN TRY
			DECLARE C_CLI_ENVIAR CURSOR
			FOR SELECT DB_CLI_CODIGO 
				  FROM DB_CLIENTE
				 WHERE DB_CLI_DATA_ENVIO IS NULL
				   AND DB_CLI_SITUACAO = 0

				   AND DB_CLI_DATA_CADAS is not null

				  OPEN C_CLI_ENVIAR
				 FETCH NEXT FROM C_CLI_ENVIAR
				  INTO @VDB_CLI_CODIGO
				 WHILE @@FETCH_STATUS = 0
				 BEGIN

			   print 'exportando cliente ' + cast(@VDB_CLI_CODIGO as varchar)

    					UPDATE DB_CLIENTE
						   SET DB_CLI_DATA_ENVIO = GETDATE()
						WHERE DB_CLI_CODIGO  = @VDB_CLI_CODIGO; 
  
						EXEC dbo.MERCP_INSERE_CLIENTE_ERP @VDB_CLI_CODIGO, @VRETORNO OUTPUT

						PRINT 'RETORNOU COM ' + @VRETORNO
						-----------------------------------------------------------------------
						--- SE RETORNOU COM ERRO DEVE RETIRAR A DATA DE ENVIO, GRAVAR MENSAGEM DE ERRO NO ABTRIBUTO
						--- E COLOCAR NA ALCADA 10 PARA NOVA LIBERACAO
						-----------------------------------------------------------------------
						IF @VRETORNO <> 'OK' 
						BEGIN
    						UPDATE DB_CLIENTE
								SET DB_CLI_DATA_ENVIO = NULL
							WHERE DB_CLI_CODIGO  = @VDB_CLI_CODIGO; 

						END

				 FETCH NEXT FROM C_CLI_ENVIAR
				  INTO @VDB_CLI_CODIGO
				 END;
			CLOSE C_CLI_ENVIAR
			DEALLOCATE C_CLI_ENVIAR

	END TRY

	BEGIN CATCH
	   SELECT @VERRO = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()

	   INSERT INTO DBS_ERROS_TRIGGERS
  			(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
			VALUES
  			( @VERRO, GETDATE(), @VOBJETO );			
	END CATCH		



	-------------------------
	--- SEGUNDA ETAPA - ATUALIZAR O RETORNO DOS PEDIDOS NO MERCANET, CFME INFORMAÇOES DA INTERFACE
	-------------------------
	BEGIN
	   EXEC dbo.MERCP_ATUALIZA_RETORNO_CLIENTE
	END


END
GO
