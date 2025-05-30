import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class LetraCelula {
  String letra;
  Color cor;
  Color corBorda;

  LetraCelula(this.letra, this.cor, this.corBorda);
}

class _MyAppState extends State<MyApp> {
  final String palavraSorteada = "FACIL";
  late List<String> sorteadaSeparada;

  List<List<LetraCelula>> board = List.generate(
    6,
    (_) => List.generate(
      5,
      (_) => LetraCelula('', Color(0xFF605458), Color(0xFF605458)),
    ),
  );

  int currentRow = 0;
  int currentCol = 0;

  @override
  void initState() {
    super.initState();
    sorteadaSeparada = palavraSorteada.toUpperCase().split('');
  }

  void teclaPressionada(String tecla) {
    setState(() {
      if (currentRow >= 6) return;

      if (tecla == '⌫') {
        if (currentCol > 0) {
          currentCol--;
          board[currentRow][currentCol] = LetraCelula(
            '',
            Color(0xFF605458),
            Color(0xFF605458),
          );
        }
      } else if (tecla == 'ENTER') {
        if (currentCol == 5) {
          verificarPalavra();
        }
      } else if (currentCol < 5) {
        board[currentRow][currentCol] = LetraCelula(
          tecla,
          const Color(0xFF87727A),
          Color(0xFF605458),
        );
        currentCol++;
      }
    });
  }

  void verificarPalavra() {
    List<String> chute = board[currentRow].map((c) => c.letra).toList();
    List<String> tempSorteada = List.from(sorteadaSeparada);
    List<Color> cores = List.filled(5, Color(0xFF302A2C));

    for (int i = 0; i < 5; i++) {
      if (chute[i] == tempSorteada[i]) {
        cores[i] = Color(0xFF4BA294);
        tempSorteada[i] = '';
      }
    }

    for (int i = 0; i < 5; i++) {
      if (cores[i] != Color(0xFF4BA294) && tempSorteada.contains(chute[i])) {
        cores[i] = Color(0xFFCFAE6C);
        tempSorteada[tempSorteada.indexOf(chute[i])] = '';
      }
    }

    for (int i = 0; i < 5; i++) {
      board[currentRow][i] = LetraCelula(chute[i], cores[i], cores[i]);
    }

    if (cores.every((c) => c == Color(0xFF4BA294))) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
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
    } else if (currentRow < 5) {
      currentRow++;
      currentCol = 0;
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
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
        backgroundColor: Color(0xFF6E5C62),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 150),
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
                            (row) => Expanded(
                              child: Row(
                                children: List.generate(
                                  5,
                                  (col) => Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: buildConteinerLetra(
                                        board[row][col],
                                        row,
                                        col,
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
                padding: const EdgeInsets.only(bottom: 20),
                child: buildTecladoPC(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConteinerLetra(LetraCelula celula, int row, int col) {
    Color corFundo = celula.cor;
    if (row == currentRow && celula.letra.isEmpty) {
      corFundo = const Color(0xFF87727A);
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

  Widget buildTecladoPC() {
    final linha1 = 'QWERTYUIOP'.split('');
    final linha2 = [...'ASDFGHJKL'.split(''), '⌫'];
    final linha3 = [...'ZXCVBNM'.split(''), 'ENTER'];

    Widget buildLinha(List<String> letras) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            letras.map((letra) {
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
                      onPressed: () => teclaPressionada(letra),
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
        buildLinha(linha1),
        const SizedBox(height: 6),
        buildLinha(linha2),
        const SizedBox(height: 6),
        buildLinha(linha3),
      ],
    );
  }
}
