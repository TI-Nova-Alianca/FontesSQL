ALTER PROCEDURE       [dbo].[MERCP_WORKFLOW_DEST]  (@PWL_FLAGGERAL     INTEGER,
                                             @PWL_ACAO          INTEGER,
                                             @PWL_SITUACAO      INTEGER,
                                             @PWL_CLIENTE       FLOAT,
                                             @PWL_PEDIDO        INTEGER,
                                             @PWL_EMPRESA       VARCHAR(25),
                                             @PWL_NOTA          INTEGER,
                                             @PWL_SERIE         VARCHAR(512),
                                             @PWL_USUARIO       VARCHAR(50),
                                             @POUT_WL_DEST_NOME VARCHAR(1024) OUTPUT,
                                             @POUT_WL_DEST_ENDE VARCHAR(1024) OUTPUT
                                            ) AS
BEGIN
-----------------------------------------------------------------------
---  VERSAO   DATA        AUTOR           ALTERACAO
---  1.00001              ALENCAR BOITO   DESENVOLVIMENTO
---  1.00002  22/07/2011  FERNANDO LESSA  CONVERSAO PARA SQLSERVER
---  1.00003  09/07/2015  TIAGO PRADELLA  DEFINIDO TAMANHO DE CAMPOS VARCHAR NS PARAMETROS DE ENTRADA
---  1.00004  16/07/2015  tiago           incluido try catch
---  1.00005  17/02/2017  Alencar         Adicionado acao 24 - EMAIL PARA PROXIMO LIBERADOR, que existia apenas para Sql Server
---  1.00006  02/05/2018  TIAGO           INCLUIDA ACAO 51
-----------------------------------------------------------------------
DECLARE @VVNOME        VARCHAR(100);
DECLARE @VVEMAIL       VARCHAR(100);
DECLARE @VWL_DEST_NOME VARCHAR(2000);
DECLARE @VWL_DEST_ENDE VARCHAR(2000);
DECLARE @VVDATA        DATETIME;
DECLARE @VERRO         VARCHAR(512);
SET @VWL_DEST_NOME = '';
SET @VWL_DEST_ENDE = '';
BEGIN TRY
IF @PWL_ACAO = 11
BEGIN
  SELECT @VVNOME = DB_CLI_NOME, @VVEMAIL = DB_CLIC_EMAIL
    FROM DB_CLIENTE, DB_CLIENTE_COMPL
   WHERE DB_CLI_CODIGO = @PWL_CLIENTE
     AND DB_CLIC_COD = DB_CLI_CODIGO;
  IF  @VVEMAIL IS NOT NULL
  BEGIN
      SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
      SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
  END;
END
IF @PWL_ACAO = 12
BEGIN
   DECLARE CUR CURSOR
   FOR SELECT DB_CLIP_NOME, DB_CLIP_EMAIL
         FROM DB_CLIENTE_PESS
        WHERE DB_CLIP_COD        = @PWL_CLIENTE
          AND NOT DB_CLIP_EMAIL IS NULL
         OPEN CUR
        FETCH NEXT FROM CUR
         INTO @VVNOME, @VVEMAIL
        WHILE @@FETCH_STATUS = 0
        BEGIN
          IF @VVEMAIL IS NOT NULL
          BEGIN
             SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
             SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
          END;
        FETCH NEXT FROM CUR
         INTO @VVNOME, @VVEMAIL
      END;
   CLOSE CUR
   DEALLOCATE CUR
END
IF @PWL_ACAO = 13
BEGIN
   DECLARE CUR CURSOR
   FOR SELECT DB_CLIP_NOME, DB_CLIP_EMAIL
         FROM DB_CLIENTE_PESS
        WHERE DB_CLIP_COD         = @PWL_CLIENTE
          AND NOT DB_CLIP_EMAIL  IS NULL
          AND DB_CLIP_EMAIL_PARA  = 0
         OPEN CUR
		FETCH NEXT FROM CUR
         INTO @VVNOME, @VVEMAIL
        WHILE @@FETCH_STATUS = 0
		BEGIN
          IF @VVEMAIL IS NOT NULL
          BEGIN
             SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
             SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
          END;
        FETCH NEXT FROM CUR
         INTO @VVNOME, @VVEMAIL
		END;
   CLOSE CUR
   DEALLOCATE CUR
END
IF @PWL_ACAO = 14
BEGIN
   DECLARE CUR CURSOR
   FOR SELECT DB_CLIP_NOME, DB_CLIP_EMAIL
         FROM DB_CLIENTE_PESS
        WHERE DB_CLIP_COD         = @PWL_CLIENTE
          AND NOT DB_CLIP_EMAIL  IS NULL
          AND DB_CLIP_EMAIL_PARA  = 1
         OPEN CUR
        FETCH NEXT FROM CUR
         INTO @VVNOME, @VVEMAIL
        WHILE @@FETCH_STATUS = 0
        BEGIN
          IF @VVEMAIL IS NOT NULL
          BEGIN
             SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
             SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
          END;
        FETCH NEXT FROM CUR
         INTO @VVNOME, @VVEMAIL
        END;
   CLOSE CUR
   DEALLOCATE CUR
END
IF @PWL_ACAO = 15
BEGIN
   DECLARE CUR CURSOR
   FOR SELECT DB_CLIP_NOME, DB_CLIP_EMAIL
         FROM DB_CLIENTE_PESS
        WHERE DB_CLIP_COD         = @PWL_CLIENTE
          AND NOT DB_CLIP_EMAIL  IS NULL
          AND DB_CLIP_EMAIL_PARA  = 2
         OPEN CUR
        FETCH NEXT FROM CUR
         INTO @VVNOME, @VVEMAIL
        WHILE @@FETCH_STATUS = 0
        BEGIN
          IF @VVEMAIL IS NOT NULL
          BEGIN
             SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
             SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
          END;
         FETCH NEXT FROM CUR
          INTO @VVNOME, @VVEMAIL
        END;
   CLOSE CUR
   DEALLOCATE CUR
END     
IF @PWL_ACAO = 21
BEGIN
   IF @PWL_PEDIDO > 0
   BEGIN
      SELECT @VVNOME = DB_TBREP_NOME, @VVEMAIL = DB_TBREP_EMAIL
        FROM DB_PEDIDO, DB_TB_REPRES
       WHERE DB_PED_NRO      = @PWL_PEDIDO
         AND DB_TBREP_CODIGO = DB_PED_REPRES;
      IF @VVEMAIL IS NOT NULL
      BEGIN
         SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
         SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
      END
   END
   ELSE
   IF @PWL_NOTA > 0
   BEGIN
      SELECT @VVNOME = DB_TBREP_NOME, @VVEMAIL = DB_TBREP_EMAIL
        FROM DB_NOTA_FISCAL, DB_TB_REPRES
       WHERE DB_NOTA_EMPRESA = @PWL_EMPRESA
         AND DB_NOTA_NRO     = @PWL_NOTA
         AND DB_NOTA_SERIE   = @PWL_SERIE
         AND DB_TBREP_CODIGO = DB_NOTA_REPRES;
      IF @VVEMAIL IS NOT NULL
      BEGIN
         SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
         SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
      END;
   END
   ELSE
   BEGIN
      DECLARE CUR CURSOR
      FOR SELECT DB_TBREP_NOME, DB_TBREP_EMAIL
            FROM DB_CLIENTE_REPRES, DB_TB_REPRES
           WHERE DB_CLIR_CLIENTE = @PWL_CLIENTE
             AND DB_TBREP_CODIGO = DB_CLIR_REPRES
            OPEN CUR
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           WHILE @@FETCH_STATUS = 0
           BEGIN
             IF @VVEMAIL IS NOT NULL
             BEGIN
                SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
                SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
             END;
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           END;
      CLOSE CUR
      DEALLOCATE CUR
   END  -- IF @PWL_NOTA > 0
END  -- IF @PWL_ACAO = 21
IF @PWL_ACAO = 22 
BEGIN
   DECLARE CUR CURSOR
   FOR SELECT DB_TBREP_NOME, DB_TBREP_EMAIL
         FROM DB_CLIENTE_REPRES, DB_TB_REPRES
        WHERE DB_CLIR_CLIENTE = @PWL_CLIENTE
          AND DB_TBREP_CODIGO = DB_CLIR_REPRES
         OPEN CUR
        FETCH NEXT FROM CUR
         INTO @VVNOME, @VVEMAIL
        WHILE @@FETCH_STATUS = 0
        BEGIN
          IF @VVEMAIL IS NOT NULL
          BEGIN
             SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
             SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
          END;
       FETCH NEXT FROM CUR
        INTO @VVNOME, @VVEMAIL
     END;
   CLOSE CUR
   DEALLOCATE CUR
END
IF @PWL_ACAO = 23
BEGIN
   IF @PWL_PEDIDO > 0
   BEGIN
      SELECT @VVNOME = REP2.DB_TBREP_NOME, @VVEMAIL = REP2.DB_TBREP_EMAIL
        FROM DB_PEDIDO, DB_TB_REPRES  REP1, DB_TB_REPRES  REP2
       WHERE DB_PED_NRO           = @PWL_PEDIDO
         AND REP1.DB_TBREP_CODIGO = DB_PED_REPRES
         AND REP2.DB_TBREP_CODIGO = REP1.DB_TBREP_SUPERIOR;
      IF @VVEMAIL IS NOT NULL
      BEGIN
         SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
         SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
      END;
   END
   ELSE IF @PWL_NOTA > 0
   BEGIN
      SELECT @VVNOME = REP2.DB_TBREP_NOME, @VVEMAIL = REP2.DB_TBREP_EMAIL
        FROM DB_NOTA_FISCAL, DB_TB_REPRES  REP1, DB_TB_REPRES  REP2
       WHERE DB_NOTA_EMPRESA      = @PWL_EMPRESA 
         AND DB_NOTA_NRO          = @PWL_NOTA 
         AND DB_NOTA_SERIE        = @PWL_SERIE 
         AND REP1.DB_TBREP_CODIGO = DB_NOTA_REPRES
         AND REP2.DB_TBREP_CODIGO = REP1.DB_TBREP_SUPERIOR;
      IF @VVEMAIL IS NOT NULL 
      BEGIN
         SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;                   
         SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
      END;
   END
   ELSE
   BEGIN
      DECLARE CUR CURSOR
      FOR SELECT REP2.DB_TBREP_NOME, REP2.DB_TBREP_EMAIL
            FROM DB_CLIENTE_REPRES, DB_TB_REPRES REP1, DB_TB_REPRES REP2
           WHERE DB_CLIR_CLIENTE      = @PWL_CLIENTE
             AND REP1.DB_TBREP_CODIGO = DB_CLIR_REPRES
             AND REP2.DB_TBREP_CODIGO = REP1.DB_TBREP_SUPERIOR
            OPEN CUR
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           WHILE @@FETCH_STATUS = 0
           BEGIN
             IF @VVEMAIL IS NOT NULL
             BEGIN
                SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
                SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
             END;
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           END;
      CLOSE CUR
      DEALLOCATE CUR
   END;
END
-- EMAIL PARA PROXIMO LIBERADOR 
IF @PWL_ACAO = 24 
BEGIN
      DECLARE CUR_USUARIOS_ALCADAS CURSOR
      FOR SELECT NOME, EMAIL
            FROM DB_PEDIDO_ALCADA  a
               , DB_ALCADA_USUARIO b
               , DB_USUARIO      c
           WHERE DB_PEDAL_PEDIDO = @PWL_PEDIDO
             and db_alcu_alcada  = DB_PEDAL_ALCADA
             and c.codigo        = b.db_alcu_usuario
             AND DB_PEDAL_STATUS = 0
			 AND c.BLOQUEADO <> 1
            OPEN CUR_USUARIOS_ALCADAS
           FETCH NEXT FROM CUR_USUARIOS_ALCADAS
            INTO @VVNOME, @VVEMAIL
           WHILE @@FETCH_STATUS = 0
           BEGIN
			   IF @VVEMAIL IS NOT NULL 
			   BEGIN
				  SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;                   
				  SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
			   END;
           FETCH NEXT FROM CUR_USUARIOS_ALCADAS
            INTO @VVNOME, @VVEMAIL
           END;
      CLOSE CUR_USUARIOS_ALCADAS
      DEALLOCATE CUR_USUARIOS_ALCADAS
END
IF @PWL_ACAO = 30
BEGIN
   SELECT @VVNOME = SU1_NOME, @VVEMAIL = SU1_EMAIL 
     FROM MSU1
    WHERE SU1_USUARIO = @PWL_USUARIO;
   IF @VVEMAIL IS NOT NULL 
   BEGIN
      SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;                   
      SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
   END;
END    
IF @PWL_ACAO = 31
BEGIN       
   IF @PWL_FLAGGERAL = 1
   BEGIN
      DECLARE CUR CURSOR
      FOR SELECT WF1_EMAIL EMAIL1, WF1_EMAIL EMAIL2
            FROM MWF1
           WHERE WF1_SITUACAO = @PWL_SITUACAO 
             AND WF1_ACAO     = 31
            OPEN CUR
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           WHILE @@FETCH_STATUS = 0
           BEGIN
             IF @VVEMAIL IS NOT NULL 
             BEGIN
                SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;                   
                SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
             END;
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           END;
      CLOSE CUR
      DEALLOCATE CUR
      DECLARE CUR CURSOR
      FOR SELECT SU1_NOME, SU1_EMAIL
            FROM MSU1
           WHERE SU1_USUARIO = @PWL_USUARIO
            OPEN CUR
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           WHILE @@FETCH_STATUS = 0
           BEGIN
             IF @VVEMAIL IS NOT NULL
             BEGIN
                SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
                SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
             END;
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           END;
      CLOSE CUR
      DEALLOCATE CUR
   END
   ELSE
   BEGIN
      DECLARE CUR CURSOR
      FOR SELECT WF2_EMAIL AS EMAIL1, WF2_EMAIL AS EMAIL2
            FROM MWF2
           WHERE WF2_SITUACAO = @PWL_SITUACAO
             AND WF2_ACAO     = 31
            OPEN CUR
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           WHILE @@FETCH_STATUS = 0
           BEGIN
             IF @VVEMAIL IS NOT NULL
             BEGIN
                SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
                SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
             END;
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           END;
      CLOSE CUR
      DEALLOCATE CUR
      DECLARE CUR CURSOR
      FOR SELECT SU1_NOME EMAIL1, SU1_EMAIL EMAIL2
            FROM MSU1
           WHERE SU1_USUARIO = @PWL_USUARIO
            OPEN CUR
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           WHILE @@FETCH_STATUS = 0
           BEGIN
                   IF @VVEMAIL IS NOT NULL
                   BEGIN
                      SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
                      SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
                   END;
                   FETCH NEXT FROM CUR
				      INTO @VVNOME, @VVEMAIL
				END;
      CLOSE CUR
      DEALLOCATE CUR
   END;   
END;
IF @PWL_ACAO = 51
BEGIN
	SELECT @VVNOME	= NOME,
           @VVEMAIL	= EMAIL
      FROM DB_USUARIO
	 WHERE USUARIO = @PWL_USUARIO
	   AND DB_USUARIO.BLOQUEADO <> 1
   IF ISNULL(@VVEMAIL, '') <> ''
   BEGIN
      SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
      SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
   END;
END
IF @PWL_ACAO = 52
BEGIN
     SELECT @VVEMAIL = DB_USUARIO.EMAIL, 
            @VVNOME  = DB_USUARIO.NOME       
       FROM DB_PEDIDO_COMPL,
            DB_USUARIO
      WHERE DB_PEDC_NRO = @PWL_PEDIDO
        AND DB_PEDC_USU_CRIA = DB_USUARIO.USUARIO
		AND DB_USUARIO.BLOQUEADO <> 1;
   IF ISNULL(@VVEMAIL, '') <> ''
   BEGIN
      SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
      SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
   END
END
IF @PWL_ACAO = 99
BEGIN
   IF @PWL_FLAGGERAL = 1
   BEGIN
      DECLARE CUR CURSOR
      FOR SELECT WF1_EMAIL EMAIL1, WF1_EMAIL  EMAIL2
            FROM MWF1
           WHERE WF1_SITUACAO = @PWL_SITUACAO
             AND WF1_ACAO     = 99
            OPEN CUR
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           WHILE @@FETCH_STATUS = 0
           BEGIN
             IF @VVEMAIL IS NOT NULL
             BEGIN
                SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
                SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
             END;
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           END;
      CLOSE CUR
      DEALLOCATE CUR
   END
   ELSE
   BEGIN
      DECLARE CUR CURSOR
      FOR SELECT WF2_EMAIL  EMAIL1, WF2_EMAIL  EMAIL2
            FROM MWF2
           WHERE WF2_CLIENTE  = @PWL_CLIENTE
             AND WF2_SITUACAO = @PWL_SITUACAO
             AND WF2_ACAO     = 99
            OPEN CUR
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           WHILE @@FETCH_STATUS = 0
           BEGIN
             IF @VVEMAIL IS NOT NULL
             BEGIN
                SET @VWL_DEST_NOME = @VWL_DEST_NOME + ';' + @VVNOME;
                SET @VWL_DEST_ENDE = @VWL_DEST_ENDE + ';' + @VVEMAIL;
             END;
           FETCH NEXT FROM CUR
            INTO @VVNOME, @VVEMAIL
           END;
      CLOSE CUR
      DEALLOCATE CUR
   END;
END;
SET @POUT_WL_DEST_NOME  = SUBSTRING(REPLACE(@VWL_DEST_NOME, ' ', ''), 2, 2000);
SET @POUT_WL_DEST_ENDE  = SUBSTRING(REPLACE(@VWL_DEST_ENDE, ' ', ''), 2, 2000);
END TRY
	BEGIN CATCH
		SET @VERRO = 'ERRO :'  + ERROR_MESSAGE();
		INSERT INTO DBS_ERROS_TRIGGERS (DBS_ERROS_ERRO, DBS_ERROS_DATA, DBS_ERROS_OBJETO) VALUES (@VERRO, GETDATE(), 'WORKFLOW_DEST');
    --COMMIT;
	END CATCH
END;
