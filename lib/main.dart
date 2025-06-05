import 'package:flutter/material.dart';
import 'package:termo/dicionario.dart';

void main() {
  runApp(const MaterialApp(home: MeuApp(), debugShowCheckedModeBanner: false));
}

// Classe principal do app com estado (StatefulWidget)
class MeuApp extends StatefulWidget {
  const MeuApp({super.key});

  @override
  State<MeuApp> createState() => _MeuAppEstado();
}

// Representa uma célula com uma letra e suas cores
class CelulaLetra {
  String letra;
  Color corFundo;
  Color corBorda;

  CelulaLetra(this.letra, this.corFundo, this.corBorda);
}

class _MeuAppEstado extends State<MeuApp> {
  final String palavraSorteada = sortearPalavra();
  late List<String> letrasSorteadasSeparadas;

  // Tabuleiro: 6 linhas x 5 colunas, cada célula é uma letra com cor de fundo e borda
  List<List<CelulaLetra>> tabuleiro = List.generate(
    6,
    (_) => List.generate(
      5,
      (_) => CelulaLetra('', const Color(0xFF605458), const Color(0xFF605458)),
    ),
  );

  int linhaAtual = 0; // Linha que o usuário está digitando
  int colunaAtual = 0; // Próxima coluna a ser preenchida na linha atual
  bool jogoEncerrado = false; // Indica se o jogo terminou

  @override
  void initState() {
    super.initState();
    letrasSorteadasSeparadas = palavraSorteada.toUpperCase().split('');
  }

  /// Trata o evento de pressionar uma tecla do teclado virtual.
  /// Se o jogo acabou, ignora as teclas.
  void aoPressionarTecla(String tecla) {
    if (jogoEncerrado) return;
    setState(() {
      if (linhaAtual >= 6) return;

      if (tecla == '⌫') {
        // Remove a última letra digitada na linha atual
        if (colunaAtual > 0) {
          colunaAtual--;
          tabuleiro[linhaAtual][colunaAtual] = CelulaLetra(
            '',
            const Color(0xFF605458),
            const Color(0xFF605458),
          );
        }
      } else if (tecla == 'ENTER') {
        // Só verifica se a linha está completa
        if (colunaAtual == 5) {
          verificarPalavra();
        }
      } else if (colunaAtual < 5) {
        // Adiciona a letra pressionada na próxima célula disponível
        tabuleiro[linhaAtual][colunaAtual] = CelulaLetra(
          tecla,
          const Color(0xFF87727A),
          const Color(0xFF605458),
        );
        colunaAtual++;
      }
    });
  }

  /// Verifica se a palavra digitada está correta e atualiza as cores das células.
  /// Mostra um diálogo de vitória ou derrota e encerra o jogo se necessário.
  void verificarPalavra() {
    List<String> tentativa = tabuleiro[linhaAtual].map((c) => c.letra).toList();
    List<String> copiaPalavra = List.from(letrasSorteadasSeparadas);
    List<Color> cores = List.filled(5, const Color(0xFF302A2C));

    // Marca letras corretas na posição correta (verde)
    for (int i = 0; i < 5; i++) {
      if (tentativa[i] == copiaPalavra[i]) {
        cores[i] = const Color(0xFF4BA294);
        copiaPalavra[i] = '';
      }
    }

    // Marca letras corretas na posição errada (amarelo)
    for (int i = 0; i < 5; i++) {
      if (cores[i] != const Color(0xFF4BA294) &&
          copiaPalavra.contains(tentativa[i])) {
        cores[i] = const Color(0xFFCFAE6C);
        copiaPalavra[copiaPalavra.indexOf(tentativa[i])] = '';
      }
    }

    // Atualiza o tabuleiro com as cores da tentativa
    for (int i = 0; i < 5; i++) {
      tabuleiro[linhaAtual][i] = CelulaLetra(tentativa[i], cores[i], cores[i]);
    }

    // Verifica vitória
    if (cores.every((c) => c == const Color(0xFF4BA294))) {
      jogoEncerrado = true;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Parabéns!"),
          content: const Text("Você acertou a palavra!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else if (linhaAtual < 5) {
      // Passa para a próxima linha se ainda houver tentativas
      linhaAtual++;
      colunaAtual = 0;
    } else {
      // Fim de jogo: usuário não acertou a palavra
      jogoEncerrado = true;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Fim de jogo"),
          content: Text("A palavra era $palavraSorteada."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF6E5C62),
        body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 800,
                  maxWidth: 400,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100,),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                children: List.generate(
                                  6,
                                  (linha) => Expanded(
                                    child: Row(
                                      children: List.generate(
                                        5,
                                        (coluna) => Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: construirCelulaLetra(
                                              tabuleiro[linha][coluna],
                                              linha,
                                              coluna,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
                      child: construirTeclado(),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

  /// Constrói cada célula do tabuleiro, destacando a próxima célula editável.
  Widget construirCelulaLetra(CelulaLetra celula, int linha, int coluna) {
    Color corFundo = celula.corFundo;
    if (linha == linhaAtual && celula.letra.isEmpty) {
      corFundo = const Color(
        0xFF87727A,
      ); // Destaque para a próxima célula editável
    }

    return Container(
      decoration: BoxDecoration(
        color: corFundo,
        border: Border.all(color: celula.corBorda, width: 5),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        celula.letra,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  /// Constrói o teclado virtual inferior.
  /// O teclado é desabilitado quando o jogo termina.
  Widget construirTeclado() {
    final linha1 = 'QWERTYUIOP'.split('');
    final linha2 = [...'ASDFGHJKL'.split(''), '⌫'];
    final linha3 = [...'ZXCVBNM'.split(''), 'ENTER'];

    Widget construirLinhaTeclas(List<String> teclas) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: teclas.map((letra) {
          final bool especial = letra == 'ENTER' || letra == '⌫';
          return Expanded(
            flex: especial ? 2 : 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 2,
              ),
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: jogoEncerrado ? null : () => aoPressionarTecla(letra),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(letra, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        construirLinhaTeclas(linha1),
        const SizedBox(height: 6),
        construirLinhaTeclas(linha2),
        const SizedBox(height: 6),
        construirLinhaTeclas(linha3),
      ],
    );
  }
}
