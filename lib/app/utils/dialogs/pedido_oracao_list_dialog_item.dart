
import 'package:culto_domestico_app/app/pedidos_oracao/models/pedido_oracao.dart';
import 'package:meta/meta.dart';
import 'package:culto_domestico_app/app/utils/dialogs/list_dialog_item.dart';

class PedidoOracaoListDialogItem extends ListDialogItem<PedidoOracao> {
  
  @override
  String get title => item.texto;

  PedidoOracaoListDialogItem({@required PedidoOracao pedidoOracao}) : super(item: pedidoOracao);

}