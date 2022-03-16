SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_CONCORRENTE_EXPORT_PEDIDOS] AS

---------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR          ALTERACAO
---  1.0000   15/03/2016  ALENCAR        DESENVOLVIMENTO - Rotina que exporta pedidos automaticamente. 
---                                                        Será executada através de um scheduler no banco
---                                      ETAPAS EXECUTADAS:
---                                              1 - exporta Pedidos para a interface
---                                              2 - atualiza o retorno dos pedidos com informacao da interface(incluindo nro do pedido gerado e msgs de erros)
---                                              3 - atualiza o estoque de todos os produtos
---                                      Estrutura dos programas de exportação:
---                                           MERCP_CONCORRENTE_EXPORT --> MERCP_INSERE_PEDIDO_ERP
---  1.0001   04/11/2016  ALENCAR        Conversão Nova Aliança
---------------------------------------------------------------------------------------------------

BEGIN
DECLARE	@VERRO            VARCHAR(255);
DECLARE @VDB_PED_NRO      NUMERIC;
DECLARE @VRETORNO         VARCHAR(255);
DECLARE @VOBJETO          VARCHAR(200) SELECT @VOBJETO = 'MERCP_CONCORRENTE_EXPORT_PEDIDOS';
DECLARE @VSEMAFORO        VARCHAR(254);

DECLARE @PDEDIDO_PAI      NUMERIC


BEGIN TRY


    -------------------------
    --- PRIMEIRA ETAPA - SPLITAR OS PEDIDOS E EXPORTAR PARA INTERFACES
    -------------------------

    --- SO EXECUTA A ETAPA DE ENVIAR PEDIDOS PARA A INTERFACE QUANDO O SEMAFORO ESTA LIGADO
	SET @VSEMAFORO = 'ON'

	IF RTRIM(@VSEMAFORO) = 'ON'
	BEGIN

		DECLARE C_PED_ENVIAR CURSOR
		FOR SELECT DB_PED_NRO
			  FROM DB_PEDIDO_COMPL
				 , DB_PEDIDO
			 WHERE DB_PED_DATA_ENVIO IS NULL
			   AND DB_PED_SITUACAO    = 0
			   AND ISNULL(DB_PEDC_EMNEGOCIACAO, 0) = 0
			   AND DB_PED_NRO         = DB_PEDC_NRO
			   and ISNULL(DB_PEDC_RASCUNHO, 0) = 0
			   AND DB_PED_EMPRESA IS NOT NULL 
			   AND LEN(DB_PED_CLIENTE) < 10   -- NAO EXPORTAR PEDIDOS DE CLIENTES COM CGC NO CODIGO
			  OPEN C_PED_ENVIAR
			 FETCH NEXT FROM C_PED_ENVIAR
			  INTO @VDB_PED_NRO
			 WHILE @@FETCH_STATUS = 0
			 BEGIN

		       print 'exportando pedido ' + cast(@VDB_PED_NRO as varchar)

    				UPDATE DB_PEDIDO
					   SET DB_PED_DATA_ENVIO = GETDATE()
					WHERE DB_PED_NRO = @VDB_PED_NRO; 

		            EXECUTE [dbo].[MERCP_INSERE_PEDIDO_ERP]  @VDB_PED_NRO
				           							       , @VRETORNO OUTPUT
													       , @PDEDIDO_PAI

			 FETCH NEXT FROM C_PED_ENVIAR
			  INTO @VDB_PED_NRO
			 END;
		CLOSE C_PED_ENVIAR
		DEALLOCATE C_PED_ENVIAR

	END --- IF @VSEMAFORO


	-------------------------
	--- SEGUNDA ETAPA - ATUALIZAR O RETORNO DOS PEDIDOS NO MERCANET, CFME INFORMAÇOES DA INTERFACE
	-------------------------
	BEGIN
	   EXEC dbo.MERCP_ATUALIZA_RETORNO_PEDIDO
	END



END TRY

BEGIN CATCH
	SELECT @VERRO = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()

	INSERT INTO DBS_ERROS_TRIGGERS
  		(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
		VALUES
  		( @VERRO, GETDATE(), @VOBJETO );			
END CATCH	

END
GO
