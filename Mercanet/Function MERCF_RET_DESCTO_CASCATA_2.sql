ALTER FUNCTION MERCF_RET_DESCTO_CASCATA_2 (
                                            @PDESCONTO_CAPA1 FLOAT = 0,
                                            @PDESCONTO_CAPA2 FLOAT  = 0,
                                            @PDESCONTO_CAPA3 FLOAT  = 0,
                                            @PDESCONTO_CAPA4 FLOAT  = 0,
                                            @PDESCONTO_CAPA5 FLOAT  = 0,
                                            @PDESCONTO_CAPA6 FLOAT  = 0,
											@PDESCONTO_CAPA7 FLOAT  = 0,
                                            @PDESCONTO_ITEM1 FLOAT  = 0,
                                            @PDESCONTO_ITEM2 FLOAT  = 0,
                                            @PDESCONTO_ITEM3 FLOAT  = 0,
                                            @PDESCONTO_ITEM4 FLOAT  = 0,
                                            @PDESCONTO_ITEM5 FLOAT  = 0,
                                            @PDESCONTO_ITEM6 FLOAT  = 0,
											@PDESCONTO_ITEM7 FLOAT  = 0,
											@PDESCONTO_ITEM8 FLOAT  = 0,
											@PDESCONTO_ITEM9 FLOAT  = 0,
											@PDESCONTO_ITEM10 FLOAT  = 0,
											@PDESCONTO_ITEM11 FLOAT  = 0,
											@VACRESCIMO_CAPA  FLOAT = 0,
                                            @VACRESCIMO_ITEM  FLOAT = 0
                                            ) RETURNS FLOAT AS
BEGIN
DECLARE
	@VDATA    DATE,
	@VOBJETO  VARCHAR(200) = 'MERCF_RET_DESCTO_CASCATA_2',
	@VERRO    VARCHAR(1000),
	@V_DESCTO FLOAT = 0,
	@V_APLICA_DESCTO   INT;
------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR    ALTERACAO
---  1.00000  24/01/2018  ALENCAR  DESENVOLVIMENTO - ROTINA QUE RETORNA O DESCONTO ACUMULADO EM CASCATA
---                                Criada com base na MERCF_RET_DESCTO_CASCATA adicionando os param de @PDESCONTO_ITEM7 a @PDESCONTO_ITEM11
------------------------------------------------------------------------------------------------------------
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
			SET @V_DESCTO = @V_DESCTO - ISNULL(@VACRESCIMO_CAPA, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM1, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM2, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM3, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM4, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM5, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM6, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM7, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM8, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM9, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM10, 0); 
			SET @V_DESCTO = @V_DESCTO + ISNULL(@PDESCONTO_ITEM11, 0); 
			SET @V_DESCTO = @V_DESCTO - ISNULL(@VACRESCIMO_ITEM, 0);
		END
		ELSE	
		BEGIN
			SET @V_DESCTO = 100 - ISNULL(@PDESCONTO_CAPA1, 0);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_CAPA2, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_CAPA3, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_CAPA4, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_CAPA5, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_CAPA6, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_CAPA7, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO + (( @V_DESCTO * ISNULL(@VACRESCIMO_CAPA, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM1, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM2, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM3, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM4, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM5, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM6, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM7, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM8, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM9, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM10, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO - (( @V_DESCTO * ISNULL(@PDESCONTO_ITEM11, 0)) / 100);
			SET @V_DESCTO = @V_DESCTO + (( @V_DESCTO * ISNULL(@VACRESCIMO_ITEM, 0)) / 100);
			SET @V_DESCTO = 100 - @V_DESCTO;			
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
