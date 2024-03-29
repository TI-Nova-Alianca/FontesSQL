ALTER FUNCTION MERCF_VALIDA_LISTA( @VVALOR               VARCHAR(8000),      -- VALOR A SER VALIDADO
                                                                 @VLISTA                 VARCHAR(8000),      -- LISTA DE VALORES VALIDOS
                                                                 @VEXCETO                INT,        -- OPCAO DE EXCLUIR (EXCETO) O VALOR  0 - VALIDO LISTA / 1 - EXCLUIR LISTA
                                                                 @VDELIMITADOR     VARCHAR = ';' -- DELIMITADOR
                                                             )RETURNS INTEGER                         -- 0 - NAO VALIDO / 1 - VALIDO
BEGIN
DECLARE @VDATA               DATETIME;
DECLARE @VERRO               VARCHAR(1000) SELECT @VERRO = 'MERCF_VALIDA_LISTA';
DECLARE @VSTRING_RET         VARCHAR(1000);
DECLARE @VRETORNO            INT;
DECLARE @VQTDE               INT;
DECLARE @VAUX                INT SELECT @VAUX = 1;
----------------------------------------------------------------------------------------------------------------------------
---  VERSAO   DATA        AUTOR          ALTERACAO
---  1.00001  28/02/2012  ALENCAR BOITO  DSENVOLVIMENTO - ROTINA QUE RETORNA SE O VALOR DA LISTA EH VERDADEIRO OU FALSO
---                                      USADA PARA VALIDAR LISTAS NUM SELECT
---  1.00002  19/04/2013  tiago          replace na lista
----------------------------------------------------------------------------------------------------------------------------
      -- SEMPRE QUE A LISTA EH NULA TODOS OS VALORES SAO VALIDOS
      IF @VLISTA IS NULL OR @VLISTA = ''
            RETURN 1;
      -- SEMPRE QUE O VALOR EH NULO INTERPRETA COMO INVALIDO
      IF @VVALOR IS NULL
            RETURN 0;  
	  set @VLISTA = replace(@VLISTA, ';', ',')
      --TESTE PARA ENCONTRAR A QUANTIDADE DE ITENS DA LISTA
      SET @VQTDE = LEN(@VLISTA) - LEN(REPLACE(@VLISTA, @VDELIMITADOR, '')) + 1;
      --QUANDO OPCAO EXCLUIR DEVE INVERTER O @VRETORNO
      IF @VEXCETO = 1
            SET @VRETORNO = 1;
      ELSE        
            SET @VRETORNO = 0;
      WHILE @VAUX <= @VQTDE
      BEGIN
        SELECT @VSTRING_RET = DBO.MERCF_PIECE(@VLISTA,',', @VAUX)                    
            IF @VSTRING_RET = @VVALOR
                  IF @VEXCETO = 0
                        RETURN 1;
                  ELSE
                        RETURN 0;
            SET @VAUX = @VAUX + 1;
      END -- FIM WHILE
      RETURN @VRETORNO;
END
