ALTER VIEW MVA_VALORITEMPEDIDOCOLUNAS AS
SELECT VLRITEMCOL.CODIGO			codigo_VLRITEMCOL,
       VLRITEMCOL.SEQUENCIA			sequencia_VLRITEMCOL,
       VLRITEMCOL.ID				id_VLRITEMCOL,
       VLRITEMCOL.COLUNA_CONSULTA	colunaCons_VLRITEMCOL
  FROM DB_MOB_VALOR_ITEM_COL		VLRITEMCOL
