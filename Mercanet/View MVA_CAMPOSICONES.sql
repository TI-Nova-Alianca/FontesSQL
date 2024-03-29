ALTER VIEW MVA_CAMPOSICONES AS
 select CODIGO_CADASTRO      codigo_ICON,
        ABA                  aba_ICON,
        AREA                 area_ICON,
        CAMPO                campo_ICON,
        SEQUENCIA            sequencia_ICON,
        VALOR                valor_ICON,
        ICONE                icone_ICON,
        campo.usuario
   from DB_WEB_CAMPOS_ICONES, MVA_CAMPOS campo
    where campo.codigo_CAMP = CODIGO_CADASTRO AND campo.aba_CAMP = ABA AND campo.area_CAMP = AREA AND campo.campo_CAMP = CAMPO
