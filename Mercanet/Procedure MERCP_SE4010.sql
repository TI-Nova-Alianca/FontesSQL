SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_SE4010] (@VEVENTO        FLOAT,
                                      @VE4_FILIAL     VARCHAR(15),
									  @VE4_CODIGO     VARCHAR(15),
									  @VE4_TIPO       VARCHAR(15),
									  @VE4_COND       VARCHAR(40),
									  @VE4_DESCRI     VARCHAR(15),
									  @VE4_IPI        VARCHAR(15),
									  @VE4_DDD        VARCHAR(15),
									  @VE4_DESCFIN    FLOAT,
									  @VE4_DIADESC    FLOAT,
									  @VE4_FORMA      VARCHAR(15),
									  @VE4_ACRSFIN    FLOAT,
									  @VE4_SOLID      VARCHAR(15),
									  @VE4_PERCOM     FLOAT,
									  @VE4_SUPER      FLOAT,
									  @VE4_INFER      FLOAT,
									  @VE4_FATOR      FLOAT,
									  @VE4_JURCART    VARCHAR(15),
									  @VE4_PLANO      VARCHAR(15),
									  @VD_E_L_E_T_    VARCHAR(15),
									  @VR_E_C_N_O_    INT,
									  @VR_E_C_D_E_L_  INT,
									  @VE4_ACRES      VARCHAR(15),
									  @VE4_MSBLQL     VARCHAR(100),
									  @VE4_VAEXMER    VARCHAR(1)) AS

BEGIN

DECLARE @VOBJETO   VARCHAR(15) SELECT @VOBJETO = 'MERCP_SE4010 ';
DECLARE @VCOD_ERRO VARCHAR(1000);
DECLARE @VERRO     VARCHAR(255);
DECLARE @VDATA     DATETIME;
DECLARE @VTIPOCOB  NUMERIC;
DECLARE @VPERC     FLOAT;
DECLARE @VPERC1    FLOAT;
DECLARE @VPERC2    FLOAT;
DECLARE @VPERC3    FLOAT;
DECLARE @VPERC4    FLOAT;
DECLARE @VPERC5    FLOAT;
DECLARE @VPERC6    FLOAT;
DECLARE @VPERC7    FLOAT;
DECLARE @VPERC8    FLOAT;
DECLARE @VPERC9    FLOAT;
DECLARE @VPERC10   FLOAT;
DECLARE @VPERC11   FLOAT;
DECLARE @VPERC12   FLOAT;
DECLARE @VIND      NUMERIC;
DECLARE @VAUX      VARCHAR(1500);
DECLARE @VPRZMED   FLOAT SELECT @VPRZMED = 0;
DECLARE	@VINSERE   NUMERIC SELECT @VINSERE = 0;
DECLARE	@VPARCELAS FLOAT SELECT @VPARCELAS = 0;
DECLARE @VE4_COND_AUX VARCHAR(40); -- ELIAS

-------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00001  13/09/2016  ALENCAR          Gravar o campo situacao com valor A no insert
---  1.00002  11/10/2016  ALENCAR          Conversão Nova Aliança
---  1.00003  28/10/2016  ALENCAR          Gravar situacao cfme o campo E4_MSBLQL
---  1.00004  22/11/2016  ALENCAR          Definicoes do que importar:
---                                                Só importar condicoes que o codigo possua 3 digitos: 001, 003, 010, 100
---                                                Nao importar codigos com menos de 3 digitos: 01, 05...
---                                                Nao importa condições de pagamento que contenham letras
---                                                A 001 somente deve ser importado o registro que contem filial 01
---  1.00005  16/10/2018  ELIAS            Novas regras de integração de condição de pagamento do tipo 8 (Percentuais variáveis):
---           07/10/2020  ROBERT           TRATAMENTO PARA NOVO CAMPO E4_VAEXMER (DEIXAR A CONDICAO INATIVA QUANDO CONTIVER 'N' NESSE CAMPO)
---
-------------------------------------------------------------------------

BEGIN TRY

    -- Só importa condicoes que o codigo possua 3 digitos: 001, 003, 010, 100... e nao importa codigos 01, 05...
	-- Nao importa condições de pagamento que contenham letras
    IF LEN(RTRIM(LTRIM(@VE4_CODIGO))) <> 3 
	 OR ISNUMERIC(@VE4_CODIGO) = 0
	BEGIN
	   RETURN;
	END;

	--- A 001 somente deve ser importado o registro que contem filial 01
	IF @VE4_CODIGO = '001' 
	  AND @VE4_FILIAL <> '01'
	BEGIN
	    RETURN;
	END;

	IF @VEVENTO = 2 AND @VD_E_L_E_T_ <> ' '
	BEGIN

		DELETE FROM DB_TB_CPGTO WHERE DB_TBPGTO_COD = REPLACE(@VE4_CODIGO, '000', '900');

	END
	ELSE
	BEGIN
	   
	   /*INICIO ELIAS 
	   SETA A VARIAVEL AUXILIAR COM O A @VE4_COND VINDA DA CHAMADA DA ROTINA SE O TIPO FOR 8 NOVA CONDIÇÃO DE PAGAMENTO
	   E TRATA A VARIAVEL PADRÃO ! ELA VIRA COMO EX [28,120,150],[25,40,35]                 
	   */
	   IF ISNULL(@VE4_TIPO,'0') = '8' 
	   BEGIN
	   	  SET @VE4_COND_AUX = @VE4_COND;
	   	  SET @VE4_COND = REPLACE(RTRIM(LTRIM(REPLACE(dbo.MERCF_PIECE(@VE4_COND,'[',2),'],' ,''))),'[','');
	   END
	   /*FIM ELIAS*/

	   SET @VE4_COND = RTRIM(LTRIM(@VE4_COND));
	   IF ISNULL(dbo.MERCF_PIECE(@VE4_COND, ',', 1), 0) = 0
	   BEGIN
		  SET @VTIPOCOB = 2;
	   END
	   ELSE 
	   BEGIN
		  SET @VTIPOCOB = 0;
	   END

	   SET @VIND = 0;
	   BEGIN
		 WHILE @VIND <= LEN(@VE4_COND)
		 BEGIN
		   SET @VIND = @VIND + 1;
		   SET @VAUX = dbo.MERCF_PIECE(@VE4_COND,',',@VIND);

		   IF RTRIM(LTRIM(@VAUX)) > 0
		   BEGIN

			  SET @VPARCELAS = @VPARCELAS + 1;
			  SET @VPRZMED = @VPRZMED + CAST(@VAUX AS FLOAT);

		   END
		 END
	   END

	   IF ISNULL(@VPARCELAS,1) > 0
	   BEGIN
		  SET @VPRZMED = @VPRZMED / @VPARCELAS;
	   END

	   IF ISNULL(@VPARCELAS,0) <> 0
	   BEGIN
		  SET @VPERC = CONVERT(INT, 100 /  @VPARCELAS);
	   END
	   	   
	   BEGIN
	   /*INICIO ELIAS 
	   SETA @VE4_TIPO <> 8 CONTINUA O PROCESSO PADRÃO, SE FOR IGUAL TEM QUE TRATAR OS PERCENTUIAIS.
	   */
	   IF ISNULL(@VE4_TIPO,'0') <> '8' 
	      BEGIN
		   -- TESTA O ARREDONDAMENTO, PARA CASOS QUE FICA 99 (3 X 33%)
		   SET @VPERC1 = @VPERC + (100 - @VPERC * @VPARCELAS);

		   IF @VPARCELAS >= 12
		   BEGIN
			  SET @VPERC2 = @VPERC; 
			  SET @VPERC3 = @VPERC; 
			  SET @VPERC4 = @VPERC; 
			  SET @VPERC5 = @VPERC; 
			  SET @VPERC6 = @VPERC; 
			  SET @VPERC7 = @VPERC; 
			  SET @VPERC8 = @VPERC; 
			  SET @VPERC9 = @VPERC; 
			  SET @VPERC10 = @VPERC; 
			  SET @VPERC11 = @VPERC; 
			  SET @VPERC12 = @VPERC; 
		   END
		   ELSE IF @VPARCELAS = 11
		   BEGIN
			  SET @VPERC2 = @VPERC; 
			  SET @VPERC3 = @VPERC; 
			  SET @VPERC4 = @VPERC; 
			  SET @VPERC5 = @VPERC; 
			  SET @VPERC6 = @VPERC; 
			  SET @VPERC7 = @VPERC; 
			  SET @VPERC8 = @VPERC; 
			  SET @VPERC9  = @VPERC; 
			  SET @VPERC10 = @VPERC; 
			  SET @VPERC11 = @VPERC; 
		   END
		   ELSE IF @VPARCELAS = 10
		   BEGIN
			  SET @VPERC2 = @VPERC; 
			  SET @VPERC3 = @VPERC; 
			  SET @VPERC4 = @VPERC; 
			  SET @VPERC5 = @VPERC; 
			  SET @VPERC6 = @VPERC; 
			  SET @VPERC7 = @VPERC; 
			  SET @VPERC8 = @VPERC; 
			  SET @VPERC9 = @VPERC; 
			  SET @VPERC10 = @VPERC; 
		   END
		   ELSE IF @VPARCELAS = 9
		   BEGIN
			  SET @VPERC2 = @VPERC; 
			  SET @VPERC3 = @VPERC; 
			  SET @VPERC4 = @VPERC; 
			  SET @VPERC5 = @VPERC; 
			  SET @VPERC6 = @VPERC; 
			  SET @VPERC7 = @VPERC; 
			  SET @VPERC8 = @VPERC; 
			  SET @VPERC9 = @VPERC; 
		   END
		   ELSE IF @VPARCELAS = 8
		   BEGIN
			  SET @VPERC2 = @VPERC; 
			  SET @VPERC3 = @VPERC; 
			  SET @VPERC4 = @VPERC; 
			  SET @VPERC5 = @VPERC; 
			  SET @VPERC6 = @VPERC; 
			  SET @VPERC7 = @VPERC; 
			  SET @VPERC8 = @VPERC; 
		   END
		   ELSE IF @VPARCELAS = 7
		   BEGIN
			  SET @VPERC2 = @VPERC; 
			  SET @VPERC3 = @VPERC; 
			  SET @VPERC4 = @VPERC; 
			  SET @VPERC5 = @VPERC; 
			  SET @VPERC6 = @VPERC; 
			  SET @VPERC7 = @VPERC; 
		   END 
		   ELSE IF @VPARCELAS = 6
		   BEGIN
			  SET @VPERC2 = @VPERC; 
			  SET @VPERC3 = @VPERC; 
			  SET @VPERC4 = @VPERC; 
			  SET @VPERC5 = @VPERC; 
			  SET @VPERC6 = @VPERC; 
		   END
		   ELSE IF @VPARCELAS = 5
		   BEGIN
			  SET @VPERC2 = @VPERC; 
			  SET @VPERC3 = @VPERC; 
			  SET @VPERC4 = @VPERC; 
			  SET @VPERC5 = @VPERC; 
		   END
		   ELSE IF @VPARCELAS = 4
		   BEGIN
			  SET @VPERC2 = @VPERC; 
			  SET @VPERC3 = @VPERC; 
			  SET @VPERC4 = @VPERC; 
		   END
		   ELSE IF @VPARCELAS = 3
		   BEGIN
			  SET @VPERC2 = @VPERC; 
			  SET @VPERC3 = @VPERC; 
		   END
		   ELSE IF @VPARCELAS = 2
		   BEGIN
			  SET @VPERC2 = @VPERC;
		   END
         
		 END

	   ELSE-- ELIAS
	      BEGIN
	          
			  SET @VIND = 0;
			  SET @VAUX = NULL;
			  SET @VPERC1 = 0; 
			  SET @VPERC2 = 0; 
			  SET @VPERC3 = 0; 
			  SET @VPERC4 = 0; 
			  SET @VPERC5 = 0; 
			  SET @VPERC6 = 0; 
			  SET @VPERC7 = 0; 
			  SET @VPERC8 = 0; 
			  SET @VPERC9 = 0; 
			  SET @VPERC10 = 0; 
			  SET @VPERC11 = 0; 
			  SET @VPERC12 = 0; 
			  			  
			  BEGIN
				 SET @VE4_COND_AUX = REPLACE(RTRIM(LTRIM(REPLACE(dbo.MERCF_PIECE(@VE4_COND_AUX,'[',3),']' ,''))),'[','');
			  END
			  			  
			  BEGIN
			     WHILE @VIND <= @VPARCELAS
					BEGIN
					  SET @VIND = @VIND + 1;
					  SET @VAUX = CAST(ISNULL(RTRIM(LTRIM(dbo.MERCF_PIECE(@VE4_COND_AUX,',',@VIND))),0) AS FLOAT);
					
					  IF @VAUX > 0
					  BEGIN
					
			   		     IF @VIND = 1 
						 BEGIN
						    SET @VPERC1 = @VAUX;
						 END
					     
						 ELSE IF @VIND = 2 
						 BEGIN
						    SET @VPERC2 = @VAUX;
						 END

						 ELSE IF @VIND = 3 
						 BEGIN
						    SET @VPERC3 = @VAUX;
						 END

						 ELSE IF @VIND = 4 
						 BEGIN
						    SET @VPERC4 = @VAUX;
						 END

						 ELSE IF @VIND = 5 
						 BEGIN
						    SET @VPERC5 = @VAUX;
						 END

						 ELSE IF @VIND = 6 
						 BEGIN
						    SET @VPERC6 = @VAUX;
						 END

						 ELSE IF @VIND = 7 
						 BEGIN
						    SET @VPERC7 = @VAUX;
						 END

						 ELSE IF @VIND = 8 
						 BEGIN
						    SET @VPERC8 = @VAUX;
						 END

						 ELSE IF @VIND = 9 
						 BEGIN
						    SET @VPERC9 = @VAUX;
						 END

						 ELSE IF @VIND = 10 
						 BEGIN
						    SET @VPERC10 = @VAUX;
						 END

						 ELSE IF @VIND = 11 
						 BEGIN
						    SET @VPERC11 = @VAUX;
						 END

						 ELSE IF @VIND = 12 
						 BEGIN
						    SET @VPERC12 = @VAUX;
						 END
					  END
			      END
			  END			 
		  
		     SET @VPRZMED = null;
		  
		     SET @VPRZMED =  ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 1), 0)   * (@VPERC1 / 100) +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 2), 0)   * (@VPERC2 / 100) +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 3), 0)   * (@VPERC3/ 100)  +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 4), 0)   * (@VPERC4 / 100) +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 5), 0)   * (@VPERC5 / 100) +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 6), 0)   * (@VPERC6 / 100) +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 7), 0)   * (@VPERC7 / 100) +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 8), 0)   * (@VPERC8 / 100) +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 9), 0)   * (@VPERC9 / 100) +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 10), 0)  * (@VPERC10/ 100) +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 11), 0)  * (@VPERC11/ 100) +
							 ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 12), 0)  * (@VPERC12/ 100);

		  END
       END

	   SELECT @VINSERE = 1
		 FROM DB_TB_CPGTO
		WHERE DB_TBPGTO_COD = REPLACE(@VE4_CODIGO, '000', '900');
	   SET @VCOD_ERRO = @@ERROR;
	   IF @VCOD_ERRO > 0
	   BEGIN
		  SET @VINSERE = 0;
	   END

	   IF @VINSERE = 0
	   BEGIN

		  INSERT INTO DB_TB_CPGTO
			(
					DB_TBPGTO_COD,      -- 1
					DB_TBPGTO_DESCR,    -- 2 
  					DB_TBPGTO_PRZMED,   -- 3 
					DB_TBPGTO_DIAS1,    -- 4 
					DB_TBPGTO_DIAS2,    -- 5 
					DB_TBPGTO_DIAS3,    -- 6         
					DB_TBPGTO_DIAS4,    -- 7 
					DB_TBPGTO_DIAS5,    -- 8 
					DB_TBPGTO_DIAS6,    -- 9 
					DB_TBPGTO_DIAS7,    -- 10 
					DB_TBPGTO_DIAS8,    -- 11 
					DB_TBPGTO_DIAS9,    -- 12 
					DB_TBPGTO_DIAS10,   -- 13 
					DB_TBPGTO_DIAS11,   -- 14 
					DB_TBPGTO_DIAS12,   -- 15 
					DB_TBPGTO_NPARC,    -- 16 
	--                DB_TBPGTO_ACRESC,   -- 17 
					DB_TBPGTO_TIPOCOB,  -- 18 
					DB_TBPGTO_PRZESP,   -- 19 
					DB_TBPGTO_PERC1,    -- 20
					DB_TBPGTO_PERC2,    -- 21 
					DB_TBPGTO_PERC3,    -- 22 
					DB_TBPGTO_PERC4,    -- 23 
					DB_TBPGTO_PERC5,    -- 24 
					DB_TBPGTO_PERC6,    -- 25 
					DB_TBPGTO_PERC7,    -- 26 
					DB_TBPGTO_PERC8,    -- 27 
					DB_TBPGTO_PERC9,    -- 28 
					DB_TBPGTO_PERC10,   -- 29 
					DB_TBPGTO_PERC11,   -- 30 
					DB_TBPGTO_PERC12,   -- 31
					DB_TBPGTO_SITUACAO  -- 32
                
			)
		  VALUES
			(
					REPLACE(@VE4_CODIGO, '000', '900'),            -- 1
					RTRIM(@VE4_DESCRI),                            -- 2
					@VPRZMED,                                      -- 3 
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 1), 0),   -- 4 
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 2), 0),   -- 5 
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 3), 0),   -- 6
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 4), 0),   -- 7 
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 5), 0),   -- 8 
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 6), 0),   -- 9 
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 7), 0),   -- 10 
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 8), 0),   -- 11
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 9), 0),   -- 12 
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 10), 0),  -- 13
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 11), 0),  -- 14 
					ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 12), 0),  -- 15 
					@VPARCELAS,                                    -- 16 
	--                ISNULL(RTRIM(LTRIM(@VE4_ACRES)), 0),            -- 17 
					@VTIPOCOB,									--18
					'N',  --CASE WHEN @VPARCELAS = '1' THEN 'N' WHEN @VPARCELAS = '0' THEN 'N' ELSE 'S' END,                                    -- 19
					@VPERC1,                                       -- 20
					@VPERC2,                                       -- 21
					@VPERC3,                                       -- 22
					@VPERC4,                                       -- 23
					@VPERC5,                                       -- 24
					@VPERC6,                                       -- 25
					@VPERC7,                                       -- 26
					@VPERC8,                                       -- 27
					@VPERC9,                                       -- 28
					@VPERC10,                                      -- 29
					@VPERC11,                                      -- 30
					@VPERC12,                                      -- 31
					CASE @VE4_MSBLQL WHEN  '1' THEN 'I'
					                 ELSE 'A'
					     END                                       -- 32
			);
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '1 - ERRO INSERT DB_TB_CPGTO:' + @VE4_CODIGO + ' - ERRO BANCO: ' + @VCOD_ERRO;
		  END   
	   END    
	   ELSE
	   BEGIN

		  UPDATE DB_TB_CPGTO
			 SET DB_TBPGTO_DESCR   = RTRIM(@VE4_DESCRI),
      				   DB_TBPGTO_PRZMED  = @VPRZMED,
					   DB_TBPGTO_DIAS1   = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 1), 0),
					   DB_TBPGTO_DIAS2   = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 2), 0),
					   DB_TBPGTO_DIAS3   = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 3), 0),
					   DB_TBPGTO_DIAS4   = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 4), 0),
					   DB_TBPGTO_DIAS5   = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 5), 0),
					   DB_TBPGTO_DIAS6   = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 6), 0),
					   DB_TBPGTO_DIAS7   = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 7), 0),
					   DB_TBPGTO_DIAS8   = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 8), 0),
					   DB_TBPGTO_DIAS9   = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 9), 0),
					   DB_TBPGTO_DIAS10  = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 10), 0),
					   DB_TBPGTO_DIAS11  = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 11), 0),
					   DB_TBPGTO_DIAS12  = ISNULL(dbo.MERCF_PIECE(RTRIM(LTRIM(@VE4_COND)), ',', 12), 0),
					   DB_TBPGTO_NPARC   = @VPARCELAS,
	--                   DB_TBPGTO_ACRESC  = ISNULL(RTRIM(LTRIM(@VE4_ACRES)), 0),
					   DB_TBPGTO_TIPOCOB = @VTIPOCOB,
					   DB_TBPGTO_PRZESP  = 'N', --CASE WHEN @VPARCELAS = '1' THEN 'N' WHEN @VPARCELAS = '0' THEN 'N' ELSE 'S' END,
					   DB_TBPGTO_PERC1   = @VPERC1,
					   DB_TBPGTO_PERC2   = @VPERC2,
					   DB_TBPGTO_PERC3   = @VPERC3,
					   DB_TBPGTO_PERC4   = @VPERC4,
					   DB_TBPGTO_PERC5   = @VPERC5,
					   DB_TBPGTO_PERC6   = @VPERC6,
					   DB_TBPGTO_PERC7   = @VPERC7,
					   DB_TBPGTO_PERC8   = @VPERC8,
					   DB_TBPGTO_PERC9   = @VPERC9,
					   DB_TBPGTO_PERC10  = @VPERC10,
					   DB_TBPGTO_PERC11  = @VPERC11,
					   DB_TBPGTO_PERC12  = @VPERC12,
--					   DB_TBPGTO_SITUACAO = CASE @VE4_MSBLQL WHEN  '1' THEN 'I'	ELSE 'A' END
					   DB_TBPGTO_SITUACAO = CASE WHEN @VE4_MSBLQL = '1' OR @VE4_VAEXMER = 'I' THEN 'I' ELSE 'A' END
					                  
				 WHERE DB_TBPGTO_COD  = REPLACE(@VE4_CODIGO, '000', '900');           
		  SET @VCOD_ERRO = @@ERROR;
		  IF @VCOD_ERRO > 0
		  BEGIN
			 SET @VERRO = '1 - ERRO upate DB_TB_CPGTO:' + @VE4_CODIGO + ' - ERRO BANCO: ' + @VCOD_ERRO;
		  END

	   END

	END

	IF @VERRO IS NOT NULL
	BEGIN
	   SET @VDATA = GETDATE();
	   INSERT INTO DBS_ERROS_TRIGGERS
		 (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
	   VALUES
		 (@VERRO, @VDATA, @VOBJETO);
	END
END TRY

BEGIN CATCH
   SELECT @VERRO = cast(ERROR_NUMBER() as varchar) + ERROR_MESSAGE()

   INSERT INTO DBS_ERROS_TRIGGERS
  		(DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO)
		VALUES
  		( @VERRO, getdate(), @VOBJETO );			
END CATCH

END
GO
