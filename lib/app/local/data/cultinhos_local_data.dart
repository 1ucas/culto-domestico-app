import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:culto_domestico_app/app/cultinhos/models/cultinho.dart';

class CultinhosLocalData {
  static Future<List<Cultinho>> listarCultinhosFeitos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = prefs.get("cultinhos");
    if (data != null) {
      var parsed = json.decode(data).cast<Map<String, dynamic>>();
      if (parsed != null) {
        var cultinhos =
            parsed.map<Cultinho>((json) => Cultinho.fromJson(json)).toList();
        return cultinhos;
      }
    }
    return [];
  }

  static Future<void> removerCultinho({String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cultinhos = await listarCultinhosFeitos();
    cultinhos.removeWhere((element) => element.id == id);
    var encoded = json.encode(cultinhos);
    prefs.setString("cultinhos", encoded);
  }

  static Future<void> salvarNovoCultinho({Cultinho cultinho}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cultinhos = await listarCultinhosFeitos();
    cultinhos.add(cultinho);
    var encoded = json.encode(cultinhos);
    prefs.setString("cultinhos", encoded);
  }
}
