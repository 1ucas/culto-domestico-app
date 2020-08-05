class ValidateOracaoUseCase {

  String validarDescricao(texto) {
    if (texto == null || texto.isEmpty) {
      return "Informação é um campo obrigatório";
    } else if (texto.length < 10) {
      return "Descreva melhor seu pedido de oração";
    } else {
      return null;
    }
  }

  String validarCategoria(texto) {
    if (texto == null || texto == "") {
      return "Categoria é um campo obrigatório";
    } else {
      return null;
    }
  }
  
}
