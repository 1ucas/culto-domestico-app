# Material promocional

Imagens das lojas e do repositório. Nada aqui entra no app — são só os
arquivos que subimos na Play Store e na App Store.

```
promo/
  banner.png                  cabeçalho do README da raiz (1280×720)
  android/
    feature-graphic.png       Play Store · gráfico de destaque (1024×500)
    screenshots/              Play Store · 6 capturas (1080×2160)
  ios/
    screenshots/              App Store · 6 capturas (1320×2868, 6,9")
  tools/
    dados_demo.py             gera os dados fictícios das capturas
```

As seis capturas contam a mesma história nas duas lojas, na mesma ordem:

| # | Arquivo | Tela |
|---|---------|------|
| 1 | `01-cultinhos` | Início: último cultinho, ritmo e jornada |
| 2 | `02-ritmo-jornada` | Ritmo da família e a jornada pela Bíblia inteira |
| 3 | `03-oracoes` | Lista de oração, aba "Em oração" |
| 4 | `04-deus-respondeu` | A celebração de um pedido respondido |
| 5 | `05-respostas` | Lista de oração, aba "Respostas" |
| 6 | `06-historico` | O histórico de cultinhos por mês |

## Como refazer as capturas

As capturas usam dados fictícios — uma família com 8 cultinhos, 6 semanas
seguidas, 8 livros lidos e 8 pedidos de oração. O roteiro está em
`tools/dados_demo.py`, que imprime os dois JSONs que o app guarda
(`cultinhos` e `oracoes`), separados por `@@@SPLIT@@@`.

As datas são fixas em setembro de 2026. Se refizer as capturas noutra data,
ajuste as datas do script — o "ritmo da família" e o "neste mês" são
relativos ao dia de hoje.

### iOS

Simulador do iPhone 17 Pro Max (1320×2868 é o tamanho que a App Store pede
para 6,9"), tema escuro e barra de status fixa:

```bash
flutter build ios --simulator --debug
```

```bash
UDID=$(xcrun simctl list devices available | grep "iPhone 17 Pro Max" | grep -o "[0-9A-F-]\{36\}" | head -1)
BID=br.com.manobray.cultoDomesticoApp
xcrun simctl boot "$UDID"; xcrun simctl ui "$UDID" appearance dark
xcrun simctl install "$UDID" build/ios/iphonesimulator/Runner.app
xcrun simctl launch "$UDID" "$BID" && sleep 3 && xcrun simctl terminate "$UDID" "$BID"
```

Os dados vão direto no `NSUserDefaults` do app — o `shared_preferences`
prefixa as chaves com `flutter.`. É preciso reiniciar o simulador depois de
escrever o plist, senão o `cfprefsd` devolve o valor velho:

```bash
python3 promo/tools/dados_demo.py > /tmp/demo.out
C=$(xcrun simctl get_app_container "$UDID" "$BID" data)
python3 -c "
import plistlib,sys
l=open('/tmp/demo.out').read().split('@@@SPLIT@@@')
plistlib.dump({'flutter.cultinhos':l[0].strip(),'flutter.oracoes':l[1].strip()},
              open(sys.argv[1],'wb'))" "$C/Library/Preferences/$BID.plist"
xcrun simctl shutdown "$UDID" && xcrun simctl boot "$UDID"
```

Com o simulador de volta, fixe a barra de status, abra o app e capture. O
`--time` exige ISO com milissegundos (Xcode 27 recusa `21:00`).

A barra de status fixa só muda o relógio desenhado no topo — o app continua
lendo a hora real para a saudação, e de manhã as capturas sairiam com "Bom
dia". Para ter "Boa noite" a qualquer hora, abra o app num fuso em que já é
noite; `Etc/GMT-12` é UTC+12 (atenção ao sinal invertido). Confira que a data
nesse fuso ainda é a mesma de hoje, senão o ritmo e o "neste mês" mudam:

```bash
xcrun simctl ui "$UDID" appearance dark
xcrun simctl status_bar "$UDID" override --time "2026-09-16T21:00:00.000-03:00" \
  --dataNetwork wifi --wifiMode active --wifiBars 3 \
  --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100
TZ=Etc/GMT-12 date "+o app vai ler: %d/%m %H:%M"
SIMCTL_CHILD_TZ=Etc/GMT-12 xcrun simctl launch "$UDID" "$BID"
xcrun simctl io "$UDID" screenshot promo/ios/screenshots/01-cultinhos.png
```

### Android

Mesmo roteiro num emulador 1080×2160 com o tema escuro ligado. As chaves do
`SharedPreferences` são `cultinhos` e `oracoes`, sem prefixo, em
`/data/data/br.com.manobray.culto_domestico_app/shared_prefs/`.
