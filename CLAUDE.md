# Notas para o Claude Code

## Este repositório é público

Nada de identidade local pode entrar num commit. Antes de commitar, confira que
o diff não traz:

- **Team ID da Apple**, certificados, perfis de provisionamento, Apple ID
- **Keystore do Android**, senhas, alias de chave
- **UDIDs** de iPhone/iPad ou de simulador
- **Caminhos absolutos** da máquina (`/Users/<nome>/...`)
- E-mails pessoais fora do que já está no histórico

Uma varredura rápida no que está para ser commitado:

```sh
git diff --cached | grep -niE "DEVELOPMENT_TEAM|PROVISIONING|keystore|storePassword|/Users/|[0-9A-F]{8}-[0-9A-F]{4}"
```

## Assinatura fica fora do git, nas duas plataformas

Cada plataforma lê a assinatura de um arquivo ignorado. Os dois seguem o mesmo
padrão: um arquivo real ignorado, e um `.example` commitado que documenta o
formato.

| Plataforma | Arquivo ignorado | Template commitado |
|---|---|---|
| Android | `android/key.properties` | — |
| iOS | `ios/Flutter/Signing.xcconfig` | `ios/Flutter/Signing.xcconfig.example` |

`Debug.xcconfig` e `Release.xcconfig` puxam o arquivo de assinatura com
`#include?` — o `?` faz com que a ausência não quebre o build. Quem clona o
repo sem criar o `Signing.xcconfig` continua compilando para o simulador; só o
build para device pede o Team ID.

### A armadilha

`flutter create --platforms=ios` e o Xcode **escrevem o `DEVELOPMENT_TEAM`
direto no `ios/Runner.xcodeproj/project.pbxproj`** quando detectam uma conta de
desenvolvedor na máquina. São três ocorrências, uma por configuração (Debug,
Release, Profile), e elas passam despercebidas num diff grande.

Sempre que regerar a pasta `ios/` ou mexer em assinatura pelo Xcode, remova-as:

```sh
sed -i '' '/^[[:space:]]*DEVELOPMENT_TEAM = /d' ios/Runner.xcodeproj/project.pbxproj
```

O `pbxproj` tem precedência sobre o `.xcconfig`, então deixar a linha lá não só
vaza o Team ID como também ignora silenciosamente o `Signing.xcconfig`.

## Outras armadilhas de iOS já mapeadas

- `flutter install` falha em iOS 17+ (usa um caminho antigo). Para instalar num
  device: `xcrun devicectl device install app --device <udid> <app>`.
- `xcrun simctl status_bar --time` no Xcode 27 exige ISO **com milissegundos**
  (`2026-09-16T21:00:00.000-03:00`); `"21:00"` é recusado.
- Escrever `SharedPreferences` num simulador pelo `defaults write` não funciona
  (não alcança o sandbox). Escreva o plist do container e reinicie o simulador,
  senão o `cfprefsd` devolve o valor velho. Receita completa em `promo/README.md`.

## Convenções

- Commits, documentação e nomes de código em português.
- Não abrir issue no GitHub sem pedido explícito.
- `pubspec.lock` só muda quando a intenção é mexer em dependência — `flutter
  create` tende a rebaixar versões de brinde; nesse caso, descarte a mudança.
