ALTER VIEW MVA_LISTAPRECOPRODUTOS_DELETE AS
SELECT DB_PRECOP_CODIGO LISTAPRECO_LIPRP,
          DB_PRECOP_PRODUTO PRODUTO_LIPRP,
          DB_PRECOP_SEQ SEQUENCIA_LIPRP,
          CASE
             WHEN isnull(DB_PRECOP_DTALTER, '') > isnull(DB_PRECOP_ALT_CORP, '')
             THEN
                DB_PRECOP_DTALTER
             ELSE
                DB_PRECOP_ALT_CORP
          END
             DATAALTER,
       USU.USUARIO
     FROM DB_PRECO_PROD PRECO, DB_USUARIO USU
    WHERE DB_PRECOP_SITUACAO NOT IN ('A', 'A')
          AND DB_PRECOP_CODIGO IN (SELECT CODIGO_LIPRE
                                     FROM MVA_LISTAPRECO
                                    WHERE USU.USUARIO = USUARIO)
