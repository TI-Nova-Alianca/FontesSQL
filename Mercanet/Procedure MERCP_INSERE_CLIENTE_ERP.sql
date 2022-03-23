SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[MERCP_INSERE_CLIENTE_ERP] (
                                                 @PDB_CLI_CODIGO NUMERIC,
                                                 @PRETORNO       VARCHAR(255) OUTPUT
                                                ) AS

BEGIN

BEGIN TRY

DECLARE @VDATA               DATETIME;
DECLARE @VCOD_ERRO           VARCHAR(1000);
DECLARE @VERRO               VARCHAR(1000);
DECLARE @VOBJETO             VARCHAR(50) SELECT @VOBJETO = 'MERCP_INSERE_CLIENTE_ERP';
DECLARE @VINSERE             NUMERIC SELECT @VINSERE = 0;
DECLARE @VCGC                VARCHAR(20);
DECLARE @VREPRES             INT;
DECLARE @VCOND_PGTO          VARCHAR(10);
DECLARE @VCGCTE              VARCHAR(18);
DECLARE @VDB_CLI_NOME        VARCHAR(40);
DECLARE @VDB_CLI_COGNOME     VARCHAR(20);
DECLARE @VDB_CLI_ENDERECO    VARCHAR(40);
DECLARE @VDB_CLI_BAIRRO      VARCHAR(19);
DECLARE @VDB_CLI_CEP         INT;
DECLARE @VDB_CLI_CIDADE      VARCHAR(30);
DECLARE @VDB_CLI_ESTADO      VARCHAR(8);
DECLARE @VDB_CLI_CX_POSTAL   VARCHAR(10);
DECLARE @VDB_CLI_TELEFONE    VARCHAR(15);
DECLARE @VDB_CLI_FAX         VARCHAR(15);
DECLARE @VDB_CLI_CONTATO     VARCHAR(20);
DECLARE @VDB_CLI_CGCMF       VARCHAR(19);
DECLARE @VDB_CLI_CGCTE       VARCHAR(19);
DECLARE @VDB_CLI_DATA_CADAS  DATETIME;
DECLARE @VDB_CLI_PORTADOR    INT;
DECLARE @VDB_CLI_COND_PGTO   SMALLINT;
DECLARE @VDB_CLI_COB_ENDER   VARCHAR(40);
DECLARE @VDB_CLI_COB_CEP     INT;
DECLARE @VDB_CLI_COB_CIDADE  VARCHAR(30);
DECLARE @VDB_CLI_COB_ESTADO  VARCHAR(8);
DECLARE @VDB_CLI_COB_BAIRRO  VARCHAR(25);
DECLARE @VDB_CLI_COB_CGCTE   VARCHAR(19);
DECLARE @VDB_CLI_TRANSP      FLOAT;
DECLARE @VDB_CLI_TIPO_PESSOA VARCHAR(1);
DECLARE @VDB_CLI_OBSERV      VARCHAR(255);
DECLARE @VDB_CLI_SUFRAMA     VARCHAR(12);
DECLARE @VDB_CLI_LIM_CREDAP  FLOAT;
DECLARE @VDB_CLI_LPRECO      VARCHAR(8);
DECLARE @VDB_CLIC_EMAIL      VARCHAR(100);
DECLARE @VDB_CLIC_SITE       VARCHAR(100);
DECLARE @VDB_CLIC_RESTRICAO  INT;
DECLARE @VCC2_CODMUN         VARCHAR(5);
DECLARE @VZA1_FILA           VARCHAR(10);
DECLARE @VR_E_C_N_O_         NUMERIC;
DECLARE @VDB_CLIC_OPTSIMPLES VARCHAR(20)
     ,  @VDB_CLI_RAMATIV     VARCHAR(5)
     ,  @VDB_CLIC_RAMATIVII  VARCHAR(5);


---------------------------------------------------------------------
---  VERSAO   DATA        AUTOR            ALTERACAO
---  1.00000  22/07/2010  SERGIO LUCCHINI  DESENVOLVIMENTO
---  1.00001  17/03/2016  ALENCAR          Clone para a Fini. 
---  1.00002  09/05/2016  ALENCAR          Exporta o cliente para a tabela de interface ZA1010
---  1.00003  17/05/2016  ALENCAR          Grava o campo R_E_C_N_O_
---  1.00004  24/06/2016  ALENCAR          Envia o ramo de atividade: ZA1_SATIV1 = DB_CLI_RAMATIV
---  1.00005  29/09/2016  ALENCAR          Quando a cidade nao existe no Protheus, envia o campo @VCC2_CODMUN com valor ' '
---  1.00006  10/11/2016  ALENCAR          Conversao Nova Alianca
---  1.00007  17/07/2017  ALENCAR          Gravar novo campo da Interface ZA1_SIMPNAC (77754)
---                                        Gravar novo campo da Interface ZA1_VACANAL e ZVA1_SATIV1 (77717)
---           02/05/2018  ROBERT           Alterado nome do linked server de acesso ao ERP Protheus.
---           23/03/2022  Robert           Versao inicial utilizando sinonimos
---------------------------------------------------------------------

DECLARE C CURSOR
FOR SELECT DB_CLI_TIPO_PESSOA, DB_CLI_CGCMF,      DB_CLI_CGCTE,      DB_CLI_COB_CGCTE,  DB_CLI_SUFRAMA,
           DB_CLI_NOME,        DB_CLI_ENDERECO,   DB_CLI_BAIRRO,     DB_CLI_CIDADE,     DB_CLI_ESTADO,
           DB_CLI_CEP,         DB_CLI_CONTATO,    DB_CLI_TELEFONE,   DB_CLI_DATA_CADAS, DB_CLI_COGNOME,
           DB_CLI_COB_ENDER,   DB_CLI_COB_BAIRRO, DB_CLI_COB_CIDADE, DB_CLI_COB_ESTADO, DB_CLI_COB_CEP,
           DB_CLI_FAX,         DB_CLIC_RESTRICAO, DB_CLI_PORTADOR,   DB_CLI_TRANSP,     DB_CLI_LIM_CREDAP,
           DB_CLI_LPRECO,      DB_CLI_OBSERV,     DB_CLIC_EMAIL,     DB_CLIC_SITE,      DB_CLI_CX_POSTAL,
           DB_CLI_COND_PGTO,   DB_CLI_RAMATIV,    DB_CLIC_OPTSIMPLES,DB_CLIC_RAMATIVII
      FROM DB_CLIENTE
         , DB_CLIENTE_COMPL 
     WHERE DB_CLI_CODIGO = @PDB_CLI_CODIGO AND DB_CLI_CODIGO = DB_CLIC_COD;
    OPEN C
    FETCH NEXT FROM C
    INTO @VDB_CLI_TIPO_PESSOA, @VDB_CLI_CGCMF,      @VDB_CLI_CGCTE,      @VDB_CLI_COB_CGCTE,  @VDB_CLI_SUFRAMA,
         @VDB_CLI_NOME,        @VDB_CLI_ENDERECO,   @VDB_CLI_BAIRRO,     @VDB_CLI_CIDADE,     @VDB_CLI_ESTADO,
         @VDB_CLI_CEP,         @VDB_CLI_CONTATO,    @VDB_CLI_TELEFONE,   @VDB_CLI_DATA_CADAS, @VDB_CLI_COGNOME,
         @VDB_CLI_COB_ENDER,   @VDB_CLI_COB_BAIRRO, @VDB_CLI_COB_CIDADE, @VDB_CLI_COB_ESTADO, @VDB_CLI_COB_CEP,
         @VDB_CLI_FAX,         @VDB_CLIC_RESTRICAO, @VDB_CLI_PORTADOR,   @VDB_CLI_TRANSP,     @VDB_CLI_LIM_CREDAP,
         @VDB_CLI_LPRECO,      @VDB_CLI_OBSERV,     @VDB_CLIC_EMAIL,     @VDB_CLIC_SITE,      @VDB_CLI_CX_POSTAL,
         @VDB_CLI_COND_PGTO,   @VDB_CLI_RAMATIV,    @VDB_CLIC_OPTSIMPLES,@VDB_CLIC_RAMATIVII
    WHILE @@FETCH_STATUS = 0
    BEGIN

--PRINT('ENTROU NO CURSOR');

      SELECT TOP 1 @VREPRES = DB_TBREP_CODORIG
                    , @VCOND_PGTO = DB_CLIR_COND_PGTO
        FROM DB_CLIENTE_REPRES
                , DB_TB_REPRES
       WHERE DB_CLIR_CLIENTE = @PDB_CLI_CODIGO
         AND DB_TBREP_CODIGO = DB_CLIR_REPRES;
      SET @VCOD_ERRO = @@ERROR;
      IF @VCOD_ERRO > 0
      BEGIN
         SET @VREPRES = 0;
         SET @VCOND_PGTO = 0;
      END

      IF @VDB_CLI_TIPO_PESSOA = 0
      BEGIN
         SET @VCGC = RIGHT('00000000000000' + CONVERT(VARCHAR(14), @VDB_CLI_CGCMF), 14);
      END
      ELSE IF @VDB_CLI_TIPO_PESSOA = 1
      BEGIN
         SET @VCGC = RIGHT('00000000000' + CONVERT(VARCHAR(11), @VDB_CLI_CGCMF), 11);
      END
      ELSE
      BEGIN
         SET @VCGC = @VDB_CLI_CGCMF;
      END

      -- TRATA INSCRICAO ESTADUAL QDO FOR DIGITADA NO CAMPO SUFRAMA
      IF ISNULL(@VDB_CLI_CGCTE,' ') <> ' '
      BEGIN
         SET @VCGCTE = UPPER(LEFT (CONVERT(VARCHAR(18), @VDB_CLI_CGCTE) + '                  ' , 18));
      END
      ELSE
      BEGIN
         IF ISNULL(@VDB_CLI_COB_CGCTE,' ') <> ' '
         BEGIN
            SET @VCGCTE = UPPER(LEFT (CONVERT(VARCHAR(18), @VDB_CLI_COB_CGCTE) + '                  ' , 18));
         END
         ELSE
         BEGIN
            SET @VCGCTE = UPPER(LEFT (CONVERT(VARCHAR(18), @VDB_CLI_SUFRAMA) + '                  ' , 18));
         END
      END

      SELECT @VCC2_CODMUN = CC2_CODMUN
        FROM INTEGRACAO_PROTHEUS_CC2
       WHERE UPPER(LTRIM(RTRIM(CC2_MUN))) = UPPER(LTRIM(RTRIM(@VDB_CLI_CIDADE)))
         AND UPPER(LTRIM(RTRIM(CC2_EST))) = UPPER(LTRIM(RTRIM(@VDB_CLI_ESTADO)));

      
         ---- Primeiro tentar elimina o registro na interface
         delete ZA1010
          where ZA1_CODMER = cast(@PDB_CLI_CODIGO as varchar);


         SELECT @VZA1_FILA   = ISNULL(MAX(ZA1_FILA), 0) + 1 
		      , @VR_E_C_N_O_ = ISNULL(MAX(R_E_C_N_O_), 0) + 1 
		   FROM ZA1010;


         IF @VINSERE = 0
      BEGIN
	    print 'vai inserir'

         INSERT INTO ZA1010
           (
            ZA1_FILIAL,     -- 01 2
            ZA1_CODMER,     -- 02 20
            ZA1_STATUS,     -- 03 3
            ZA1_FILA,       -- 04 10
            ZA1_ERRO,       -- 05 10
            ZA1_DTINC,      -- 06 8
            ZA1_HRINC,         -- 07 8
            ZA1_DTINI,      -- 08 8
            ZA1_HRINI,      -- 09 8
            ZA1_DTFIM,      -- 10 8
            ZA1_HRFIM,      -- 11 8
            ZA1_PROCRT,     -- 12 1
            ZA1_COD,        -- 13 6
            ZA1_LOJA,       -- 14 2
            ZA1_NOME,       -- 15 60
            ZA1_PESSOA,     -- 16 1
            ZA1_NREDUZ,     -- 17 20
            ZA1_END,        -- 18 40
            ZA1_EST,        -- 19 2
            ZA1_MUN,        -- 20 30
            ZA1_COD_MU,     -- 21 5
            ZA1_BAIRRO,     -- 22 30
            ZA1_ESTADO,     -- 23 20
            ZA1_CEP,        -- 24 8
            ZA1_TEL,        -- 25 15
            ZA1_FAX,        -- 26 15
            ZA1_ENDCOB,     -- 27 40
            ZA1_CONTAT,     -- 28 15
            ZA1_CGC,        -- 29 14
            ZA1_INSCR,      -- 30 18
            ZA1_VEND,       -- 31 6
            ZA1_BCO1,       -- 32 3
            ZA1_COND,       -- 33 3
            ZA1_LC,         -- 34 FLOAT
            ZA1_ULTVIS,     -- 35 8
            ZA1_CXPOST,     -- 36 20
            ZA1_OBSERV,     -- 37 40
            ZA1_BAIRRC,     -- 38 30
            ZA1_CEPC,       -- 39 8
            ZA1_MUNC,       -- 40 15
            ZA1_ESTC,       -- 41 2
            ZA1_EMAIL,      -- 42 50
            ZA1_HPAGE,      -- 43 30
			R_E_C_N_O_,     -- 44
			ZA1_SIMPNAC,    -- 45	
			ZA1_VACANAL,    -- 46
            ZA1_SATIV1      -- 47
           )
         VALUES  -- DB_CLIENTE
           (
            '  ',                                                                                                    -- 01
            @PDB_CLI_CODIGO,                                                                                         -- 02
            'INS',                                                                                                     -- 03
            RIGHT('0000000000' + CAST(@VZA1_FILA AS VARCHAR(10)), 10),                                               -- 04
            ' ',                                                                                                     -- 05
            CONVERT(CHAR,GETDATE(),112),                                                                             -- 06
            CONVERT(CHAR,GETDATE(),108),                                                                             -- 07
            ' ',                                                                                                     -- 08
            ' ',                                                                                                     -- 09
            ' ',                                                                                                     -- 10
            ' ',                                                                                                     -- 11
            ' ',                                                                                                     -- 12
            ' ',                                                                                                     -- 13
            ' ',                                                                                                     -- 14
            UPPER(LEFT (CONVERT(VARCHAR(40), @VDB_CLI_NOME)+ '                                        ' , 40)),      -- 15
            CASE @VDB_CLI_TIPO_PESSOA WHEN '1' THEN 'F' ELSE 'J' END,                                                -- 16
            UPPER(LEFT (CONVERT(VARCHAR(15), ISNULL(@VDB_CLI_COGNOME, ' ' ))+ '               ' , 15)),              -- 17
            UPPER(LEFT (CONVERT(VARCHAR(40), @VDB_CLI_ENDERECO)+ '                                        ' , 40)),  -- 18
            UPPER(LEFT (CONVERT(VARCHAR(2), @VDB_CLI_ESTADO)+ '  ' , 2)),                                            -- 19
            UPPER(LEFT (CONVERT(VARCHAR(20), @VDB_CLI_CIDADE)+ '                    ' , 20)),                        -- 20
            isnull(@VCC2_CODMUN, ''),                                                                                            -- 21
            UPPER(LEFT (CONVERT(VARCHAR(20), @VDB_CLI_BAIRRO)+ '                    ' , 20)),                        -- 22
            LEFT (CONVERT(VARCHAR(20), ISNULL(@VDB_CLI_ESTADO,' ')) + '                    ' , 20),                  -- 23
            RIGHT('00000000' + CONVERT(VARCHAR(8), @VDB_CLI_CEP), 8),                                                -- 24
            LEFT (CONVERT(VARCHAR(15), ISNULL(@VDB_CLI_TELEFONE,' ')) + '               ' , 15),                     -- 25
            LEFT (CONVERT(VARCHAR(15), ISNULL(@VDB_CLI_FAX, ' ')) + '               ' , 15),                         -- 26
            UPPER(LEFT (CONVERT(VARCHAR(40), ISNULL(@VDB_CLI_COB_ENDER,' '))+ '                                        ', 40)),  -- 27
            UPPER(LEFT (CONVERT(VARCHAR(15), ISNULL(@VDB_CLI_CONTATO, ' '))+ '               ' , 15)),               -- 28
            UPPER(LEFT (CONVERT(VARCHAR(14), @VCGC)+ '              ' , 14)),                                        -- 29
            SUBSTRING(@VCGCTE,1,18),                                                                                 -- 30
            RIGHT('000000' + CONVERT(VARCHAR(6), ISNULL(@VREPRES, '0')), 6),                                         -- 31
            CASE @VDB_CLI_PORTADOR WHEN 0 THEN '   ' ELSE RIGHT('000' + CONVERT(VARCHAR(3), ISNULL(@VDB_CLI_PORTADOR,'0')), 3) END,  -- 32
            LEFT (REPLACE( CONVERT(VARCHAR(3), SUBSTRING(ISNULL(@VCOND_PGTO,' '),1,3)),'900','0') + '   ' , 3) ,     -- 33
            @VDB_CLI_LIM_CREDAP,                                                                                     -- 34
            SUBSTRING(CONVERT(CHAR,@VDB_CLI_DATA_CADAS,103),4,2) + SUBSTRING(CONVERT(CHAR,@VDB_CLI_DATA_CADAS,103),1,2) + SUBSTRING(CONVERT(CHAR,@VDB_CLI_DATA_CADAS,103),7,4),  -- 35
            LEFT (CONVERT(VARCHAR(20), ISNULL(@VDB_CLI_CX_POSTAL,' ')) + '                    ' , 20),               -- 36
            LEFT (CONVERT(VARCHAR(40),SUBSTRING(UPPER(ISNULL(@VDB_CLI_OBSERV, ' ')),1,40)) + '                                        ',40),  -- 37
            UPPER(LEFT (CONVERT(VARCHAR(20), ISNULL(@VDB_CLI_COB_BAIRRO,' '))+ '                    ' , 20)),        -- 38
            RIGHT('00000000' + CONVERT(VARCHAR(8), ISNULL(@VDB_CLI_COB_CEP, ' ')), 8),                               -- 39
            UPPER(LEFT (CONVERT(VARCHAR(15), ISNULL(@VDB_CLI_COB_CIDADE, ' '))+ '                    ' , 15)),       -- 40
            UPPER(LEFT (CONVERT(VARCHAR(2), ISNULL(@VDB_CLI_COB_ESTADO,' ')) + '  ' , 2)),                           -- 41
            LEFT (CONVERT(VARCHAR(30), ISNULL(@VDB_CLIC_EMAIL,' ')) + '                              ' , 30),        -- 42
            LEFT (CONVERT(VARCHAR(30), ISNULL(@VDB_CLIC_SITE,' ')) + '                              ' , 30),         -- 43
			@VR_E_C_N_O_,                                                                                            -- 44
			CASE @VDB_CLIC_OPTSIMPLES WHEN '1' THEN 1      
			                                   ELSE 2
										END,                                                                         -- 45
            @VDB_CLI_RAMATIV,                                                                                        -- 46
            @VDB_CLIC_RAMATIVII                                                                                      -- 47

           );
         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO INSERT ZA1010:' + CAST(@PDB_CLI_CODIGO AS VARCHAR) + ' - ERRO BANCO: ' + CAST(@VCOD_ERRO AS VARCHAR);
         END

      END
      ELSE
      BEGIN

         print 'nao precisa mais dar update, deve eliminar o registro da interface antes'

         SET @VCOD_ERRO = @@ERROR;
         IF @VCOD_ERRO > 0
         BEGIN
            SET @VERRO = '1 - ERRO INSERT ZA1010:' + @PDB_CLI_CODIGO + ' - ERRO BANCO: ' + @VCOD_ERRO;
         END 
--PRINT('FIM UPDATE: ZA1010');
      END

    FETCH NEXT FROM C
    INTO @VDB_CLI_TIPO_PESSOA, @VDB_CLI_CGCMF,      @VDB_CLI_CGCTE,      @VDB_CLI_COB_CGCTE,  @VDB_CLI_SUFRAMA,
         @VDB_CLI_NOME,        @VDB_CLI_ENDERECO,   @VDB_CLI_BAIRRO,     @VDB_CLI_CIDADE,     @VDB_CLI_ESTADO,
         @VDB_CLI_CEP,         @VDB_CLI_CONTATO,    @VDB_CLI_TELEFONE,   @VDB_CLI_DATA_CADAS, @VDB_CLI_COGNOME,
         @VDB_CLI_COB_ENDER,   @VDB_CLI_COB_BAIRRO, @VDB_CLI_COB_CIDADE, @VDB_CLI_COB_ESTADO, @VDB_CLI_COB_CEP,
         @VDB_CLI_FAX,         @VDB_CLIC_RESTRICAO, @VDB_CLI_PORTADOR,   @VDB_CLI_TRANSP,     @VDB_CLI_LIM_CREDAP,
         @VDB_CLI_LPRECO,      @VDB_CLI_OBSERV,     @VDB_CLIC_EMAIL,     @VDB_CLIC_SITE,      @VDB_CLI_CX_POSTAL,
         @VDB_CLI_COND_PGTO,   @VDB_CLI_RAMATIV,    @VDB_CLIC_OPTSIMPLES,@VDB_CLIC_RAMATIVII
    END
CLOSE C
DEALLOCATE C

    SET @PRETORNO = 'OK';
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
