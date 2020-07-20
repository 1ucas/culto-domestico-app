import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/local/data/cultinhos_local_data.dart';

class CultinhoService {

  Future<List<Cultinho>> listarCultinhosFeitos() async {
    return await CultinhosLocalData.listarCultinhosFeitos();
  }

  Future<void> removerCultinho({String id}) async {
    CultinhosLocalData.removerCultinho(id: id);
  }

  Future<void> salvarCultinho({Cultinho cultinho}) async {
    CultinhosLocalData.salvarNovoCultinho(cultinho: cultinho);
  }
}
