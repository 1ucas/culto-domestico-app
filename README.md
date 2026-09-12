# Culto Doméstico APP

## Um aplicativo para gerenciar e guardar o histórico de seus cultos domésticos.

![alt text](promo/banner.png?raw=true "promo")

## Funcionalidades:

- [x] Novo cultinho, com data, leitura e quem orou
- [x] Deletar cultinho
- [x] Anexar ao cultinho os pedidos levados naquele dia
- [x] Novo pedido de oração, com categoria e tipo
- [x] Deletar pedido de oração
- [x] Marcar oração respondida por Deus (e voltar atrás)
- [x] Limitação de capítulos de acordo com o livro
- [x] Histórico com resumo do mês
- [x] Tema claro e escuro

## Tecnologia / Stack:

Flutter (Material 3), `provider` para estado e `shared_preferences` para
armazenamento local. Os dados continuam no mesmo formato das versões
anteriores — quem já usava o app não perde o histórico ao atualizar.

Para rodar:

```sh
flutter pub get
flutter test
flutter run
```

## Links para Download:
- [X] [Android](https://play.google.com/store/apps/details?id=br.com.manobray.culto_domestico_app)
- [ ] iOS (em construção)

## Política de Privacidade:

Este App não faz uso de nenhum dado sensível nem compartilha nenhuma informação sua. Suas informações nunca saem de seu dispositivo.

### Iconografia
Ícones feitos por [Freepik](https://www.flaticon.com/authors/freepik), [bqlqn](https://www.flaticon.com/authors/bqlqn) e [monkik](https://www.flaticon.com/authors/monkik) em [flaticon.com](https://www.flaticon.com)

### Tipografia
[Plus Jakarta Sans](https://fonts.google.com/specimen/Plus+Jakarta+Sans), sob a
SIL Open Font License 1.1 (cópia em `assets/fonts/`).
