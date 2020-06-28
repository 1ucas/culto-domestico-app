import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/local/data/cultinhos_local_data.dart';

class CultinhoService {
  List<Cultinho> listarCultinhosFeitos() {
    return CultinhoLocalData.listarCultinhosFeitos();
  }
}
