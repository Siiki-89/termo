# 🎮 Jogo Termo em Flutter

## 📁 Código Fonte

**Requisitos:**
- Flutter instalado (versão 3.0 ou superior recomendada)
- Editor recomendado: VS Code ou Android Studio

**Dependências:**
Nenhuma dependência externa além do Flutter SDK.

**Como executar o projeto:**
1. Clone ou baixe o projeto.
2. Coloque o arquivo `dicionario.dart` no diretório `lib/` contendo a função `sortearPalavra()` que retorna uma palavra aleatória de 5 letras em maiúsculo.
3. No terminal, acesse o diretório do projeto e execute:
   ```bash
   flutter pub get
   flutter run
   ```

---

### 🎯 Objetivo do Jogo
Criar um jogo interativo no estilo **Termo**, onde o jogador deve adivinhar uma palavra de 5 letras em até 6 tentativas. Após cada tentativa, o jogo indica letras corretas (verde), letras presentes em posição errada (amarelo) e letras ausentes (cinza).

---

### 🔧 Principais Funcionalidades

- **Tabuleiro 6x5:** exibe as tentativas com cores de feedback.
- **Teclado virtual integrado:** entrada das letras, backspace e enter.
- **Validação de tentativa:** compara com a palavra sorteada.
- **Mensagens de vitória ou derrota:** exibidas com `AlertDialog`.

---

### 🧱 Desafios Enfrentados

- **Gerenciamento de estado por linha e coluna:** controlar onde o usuário digita, apaga ou confirma.
- **Lógica de comparação de letras com repetição:** para tratar corretamente acertos e posições erradas.
- **Interface responsiva e intuitiva:** organização de layouts para diferentes tamanhos de tela.

---

### 📘 Conclusões e Aprendizados

- Prática com **StatefulWidget** e **setState** para atualização dinâmica.
- Uso de **cores personalizadas** para representar estados do jogo.
- Fortalecimento na manipulação de **listas**, **métodos auxiliares** e **componentização de widgets**.
- Entendimento melhor de **como construir interfaces interativas** com Flutter.

                                                                                                               ![alt text](image.png)
