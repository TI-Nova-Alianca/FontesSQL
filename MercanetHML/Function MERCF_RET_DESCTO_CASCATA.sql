ALTER FUNCTION MERCF_RET_DESCTO_CASCATA (
                                            @PDESCONTO_CAPA1 float = 0,
                                            @PDESCONTO_CAPA2 float  = 0,
                                            @PDESCONTO_CAPA3 float  = 0,
                                            @PDESCONTO_CAPA4 float  = 0,
                                            @PDESCONTO_CAPA5 float  = 0,
                                            @PDESCONTO_CAPA6 float  = 0,
											@PDESCONTO_CAPA7 float  = 0,
                                            @PDESCONTO_ITEM1 float  = 0,
                                            @PDESCONTO_ITEM2 float  = 0,
                                            @PDESCONTO_ITEM3 float  = 0,
                                            @PDESCONTO_ITEM4 float  = 0,
                                            @PDESCONTO_ITEM5 float  = 0,
                                            @PDESCONTO_ITEM6 float  = 0
                                            ) RETURNs float as
begin
declare
	@VDATA    DATE,
	@VOBJETO  VARCHAR(200) = 'MERCF_RET_DESCTO_CASCATA',
	@VERRO    VARCHAR(1000),
	@V_DESCTO float = 0,
	@V_APLICA_DESCTO   INT;
------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR    ALTERACAO
---  1.00000  03/09/2013  ALENCAR  DESENVOLVIMENTO - ROTINA QUE RETORNA O DESCONTO ACUMULADO EM CASCATA(oracle)
---  1.00001  10/09/2013  tiago    conventida para sql server
------------------------------------------------------------------------------------------------------------
	--BEGIN try
		SELECT @V_APLICA_DESCTO = ISNULL(DB_PRM_APLICADCTO, 0)          
		 FROM DB_PARAMETRO1
		WHERE DB_PRM1_CHAVE = 'PARAM'
		--SOMATORIO
		IF @V_APLICA_DESCTO = 1
		BEGIN
			SET @V_DESCTO = ISNULL(@PDESCONTO_CAPA1, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_CAPA2, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_CAPA3, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_CAPA4, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_CAPA5, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_CAPA6, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_CAPA7, 0); 			
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM1, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM2, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM3, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM4, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM5, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM6, 0); 			
		END
		ELSE	
		BEGIN
			set @V_DESCTO = 100 - isnull(@PDESCONTO_CAPA1, 0);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_CAPA2, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_CAPA3, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_CAPA4, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_CAPA5, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_CAPA6, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_CAPA7, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_ITEM1, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_ITEM2, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_ITEM3, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_ITEM4, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_ITEM5, 0)) / 100);
			set @V_DESCTO = @V_DESCTO - (( @V_DESCTO * isnull(@PDESCONTO_ITEM6, 0)) / 100);
			set @V_DESCTO = 100 - @V_DESCTO;
		END
		RETURN @V_DESCTO;
	--end try
	--begin catch
 --      set @VDATA = getdate();
 --      set @VERRO = @VERRO + error_message()
 --      INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (VERRO, VDATA, VOBJETO);
 --      RETURN 0;
 --  end catch
END;
