ALTER FUNCTION mercf_Verifica_Igualdade_Filtros(@p_filtro  varchar(30),
												 @p_chave   varchar(30),
												 @p_exceto  int,
												 @p_flag    bit         ) returns bit
begin
    if isnull(@p_filtro, '') <> ''
    begin
		  if @p_exceto = 1
		  begin
			 if @p_chave = @p_filtro and @p_flag = 1 
			   return 0 
		  end
		  else
		  begin
			 if @p_chave <> @p_filtro and @p_flag = 1 
			   return 0        
		  end     
    end
    return @p_flag
 end
