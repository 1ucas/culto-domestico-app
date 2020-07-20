import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';
import 'package:culto_domestico_app/app/local/data/cultinhos_mock_data.dart';

class CultinhoService {
  List<Cultinho> listarCultinhosFeitos() {
    return CultinhoMockData.listarCultinhosFeitos();
  }

  void removerCultinho({String id}) {
    CultinhoMockData.removerCultinho(id: id);
  }

  void salvarCultinho({Cultinho cultinho}) {
    CultinhoMockData.salvarNovoCultinho(cultinho: cultinho);
  }
}
