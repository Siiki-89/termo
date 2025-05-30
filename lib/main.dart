import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// Classe para representar cada célula do tabuleiro com uma letra e uma cor
class LetraCelula {
  String letra;
  Color cor;
  Color corBorda;

  LetraCelula(this.letra, this.cor, this.corBorda);
}

class _MyAppState extends State<MyApp> {
  final String palavraSorteada = "FLAME"; // Palavra que o jogador precisa acertar
  late List<String> sorteadaSeparada; // Lista com as letras da palavra separadas

  // Criação do tabuleiro 6x5 preenchido inicialmente com letras vazias e cor cinza escuro
  List<List<LetraCelula>> board = List.generate(
    6,
    (_) => List.generate(5, (_) => LetraCelula('', Color(0xFF605458), Color(0xFF605458))),
  );

  int currentRow = 0; // Linha atual onde o jogador está digitando
  int currentCol = 0; // Coluna atual onde a letra será inserida

  @override
  void initState() {
    super.initState();
    sorteadaSeparada = palavraSorteada.toUpperCase().split(''); // Divide a palavra em letras
  }

  // Função chamada ao pressionar uma tecla
  void teclaPressionada(String tecla) {
    setState(() {
      if (tecla == '⌫') { // Apagar letra
        if (currentCol > 0) {
          currentCol--;
          board[currentRow][currentCol] = LetraCelula('', Color(0xFF605458), Color(0xFF605458));
        }
      } else if (tecla == 'ENTER') { // Verificar palavra
        if (currentCol == 5) {
          verificarPalavra();
        }
      } else if (currentCol < 5) { // Inserir letra se não atingiu o limite
        board[currentRow][currentCol] = LetraCelula(tecla, Color(0xFF605458), Color(0xFF605458));
        currentCol++;
      }
    });
  }

  // Função que compara o chute com a palavra correta
  void verificarPalavra() {
    List<String> chute = board[currentRow].map((c) => c.letra).toList(); // Pega a palavra digitada
    List<String> tempSorteada = List.from(sorteadaSeparada); // Cópia da palavra correta
    List<Color> cores = List.filled(5, Color(0xFF302A2C)); // Inicializa todas as letras como erradas

    // Verifica letras na posição correta
    for (int i = 0; i < 5; i++) {
      if (chute[i] == tempSorteada[i]) {
        cores[i] = Color(0xFF4BA294); // Cor verde para letra correta no lugar certo
        tempSorteada[i] = ''; // Remove letra da verificação
      }
    }

    // Verifica letras que existem, mas estão na posição errada
    for (int i = 0; i < 5; i++) {
      if (cores[i] != Color(0xFF4BA294) && tempSorteada.contains(chute[i])) {
        cores[i] = Color(0xFFCFAE6C); // Cor amarela para letra certa no lugar errado
        tempSorteada[tempSorteada.indexOf(chute[i])] = ''; // Remove da lista
      }
    }

    // Atualiza as cores do tabuleiro
    for (int i = 0; i < 5; i++) {
      board[currentRow][i] = LetraCelula(chute[i], cores[i], Color(0xFF605458));
    }

    // Verifica se todas as letras estão corretas
    if (cores.every((c) => c == Color(0xFF4BA294))) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Parabéns!"),
          content: const Text("Você acertou a palavra!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
    } else if (currentRow < 5) {
      // Passa para a próxima linha se ainda houver tentativas
      currentRow++;
      currentCol = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Teclas do teclado virtual
    final letras = [
      ...'QWERTYUIOP'.split(''),
      ...'ASDFGHJKL'.split(''),
      ...'ZXCVBNM'.split(''),
      'ENTER',
      '⌫'
    ];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900, // Fundo da tela
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 60), // Espaço acima do tabuleiro
              Expanded(
                flex: 3,
                child: Column(
                  children: List.generate(
                    6, // 6 linhas do tabuleiro
                    (row) => Expanded(
                      child: Row(
                        children: List.generate(
                          5, // 5 colunas por linha
                          (col) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: buildConteinerLetra(board[row][col], row, col), // Constrói a célula
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: buildTeclado(letras), // Teclado virtual
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Constrói uma célula do tabuleiro
 Widget buildConteinerLetra(LetraCelula celula, int row, int col) {
  Color corFundo = celula.cor;

  // Se a célula estiver na linha atual e vazia, usa a cor de destaque
  if (row == currentRow && celula.letra.isEmpty) {
    corFundo = const Color(0xFF87727A);
  }

  return Container(
    decoration: BoxDecoration(
      color: corFundo,
      border: Border.all(color: celula.corBorda, width: 3),
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: Text(
      celula.letra,
      style: const TextStyle(fontSize: 24, color: Colors.white),
    ),
  );
}


  // Constrói o teclado virtual
  Widget buildTeclado(List<String> letras) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: letras.map((letra) {
        return SizedBox(
          width: letra == 'ENTER' || letra == '⌫' ? 70 : 48, // Teclas maiores para ENTER e apagar
          height: 48,
          child: ElevatedButton(
            onPressed: () => teclaPressionada(letra), // Chama a função ao pressionar
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              letra,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      }).toList(),
    );
  }
}
