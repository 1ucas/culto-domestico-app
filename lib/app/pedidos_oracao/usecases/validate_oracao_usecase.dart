import '../models/pedido_oracao.dart';

class ValidateOracaoUseCase {

  String? validarDescricao(String? texto) {
    if (texto == null || texto == "") {
      return "Informação é um campo obrigatório";
    } else if (texto.length < 10) {
      return "Descreva melhor seu pedido de oração";
    } else {
      return null;
    }
  }

  String? validarCategoria(Categoria? categoria) {
    if (categoria == null) {
      return "Categoria é um campo obrigatório";
    } else {
      return null;
    }
  }
  
}
