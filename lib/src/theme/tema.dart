import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cores.dart';
import 'tipografia.dart';

abstract final class AppTema {
  static ThemeData get claro => _montar(Brightness.light, AppCores.claro);
  static ThemeData get escuro => _montar(Brightness.dark, AppCores.escuro);

  static ThemeData _montar(Brightness brilho, AppCores cores) {
    final escuro = brilho == Brightness.dark;

    final esquema = ColorScheme(
      brightness: brilho,
      primary: cores.marca,
      onPrimary: cores.marcaConteudo,
      secondary: cores.marcaTom.cor,
      onSecondary: cores.marcaConteudo,
      surface: cores.superficie,
      onSurface: cores.texto,
      surfaceContainerHighest: cores.superficieAlt,
      error: cores.perigo.cor,
      onError: Colors.white,
      outline: cores.borda,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brilho,
      colorScheme: esquema,
      scaffoldBackgroundColor: cores.fundo,
      canvasColor: cores.fundo,
      extensions: [cores],
      fontFamily: Fontes.familia,
      splashFactory: InkSparkle.splashFactory,
      textTheme: TextTheme(
        displayMedium: Tipo.display,
        headlineSmall: Tipo.displayMedio,
        titleLarge: Tipo.titulo,
        titleMedium: Tipo.secao,
        titleSmall: Tipo.cartaoTitulo,
        bodyLarge: Tipo.corpo,
        bodyMedium: Tipo.corpo,
        bodySmall: Tipo.apoio,
        labelLarge: Tipo.botao,
        labelSmall: Tipo.micro,
      ).apply(bodyColor: cores.texto, displayColor: cores.texto),
      appBarTheme: AppBarTheme(
        backgroundColor: cores.fundo,
        foregroundColor: cores.texto,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        titleTextStyle: Tipo.titulo.copyWith(color: cores.texto),
        systemOverlayStyle: escuro
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: cores.fundo,
                systemNavigationBarIconBrightness: Brightness.light,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: cores.fundo,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cores.marca,
          foregroundColor: cores.marcaConteudo,
          disabledBackgroundColor: cores.marca.withValues(alpha: 0.45),
          disabledForegroundColor: cores.marcaConteudo.withValues(alpha: 0.8),
          minimumSize: const Size(0, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          textStyle: Tipo.botao,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Raio.botao)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cores.marcaTom.cor,
          textStyle: Tipo.botao,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Raio.chip)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cores.texto,
          backgroundColor: cores.superficie,
          minimumSize: const Size(0, 56),
          textStyle: Tipo.botao,
          side: BorderSide(color: cores.borda),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Raio.botao)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cores.superficie,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        hintStyle: Tipo.campo.copyWith(color: cores.textoSuave),
        errorStyle: Tipo.apoio.copyWith(color: cores.perigo.cor),
        border: _borda(cores.borda),
        enabledBorder: _borda(cores.borda),
        focusedBorder: _borda(cores.marcaTom.cor, largura: 1.6),
        errorBorder: _borda(cores.perigo.cor),
        focusedErrorBorder: _borda(cores.perigo.cor, largura: 1.6),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cores.superficie,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: Tipo.secao.copyWith(color: cores.texto),
        contentTextStyle: Tipo.corpo.copyWith(color: cores.textoSuave),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cores.fundo,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: cores.borda,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: escuro ? cores.superficieAlt : const Color(0xFF23262E),
        contentTextStyle: Tipo.apoioForte.copyWith(color: Colors.white),
        actionTextColor: escuro ? cores.marcaTom.cor : const Color(0xFFA8BEE8),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Raio.bloco)),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: cores.superficie,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        headerBackgroundColor: cores.marca,
        headerForegroundColor: cores.marcaConteudo,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: Tipo.corpoForte.copyWith(color: cores.texto),
        subtitleTextStyle: Tipo.apoio.copyWith(color: cores.textoSuave),
      ),
      dividerTheme:
          DividerThemeData(color: cores.borda, thickness: 1, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cores.marcaTom.cor,
        circularTrackColor: cores.borda,
      ),
    );
  }

  static OutlineInputBorder _borda(Color cor, {double largura = 1}) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(Raio.bloco)),
      borderSide: BorderSide(color: cor, width: largura),
    );
  }
}
