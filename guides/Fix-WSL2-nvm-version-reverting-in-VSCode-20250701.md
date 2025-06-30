# WSL2 環境の VS Code で Node.js のバージョンが元に戻る問題の解決ガイド

- **日付:** 2025-07-01
- **関連技術:** WSL2, Ubuntu, VS Code, nvm, Node.js, bash

## 事実情報（問題と解決策）

### 問題

WSL2(Ubuntu)環境において、`nvm`を使用して特定の Node.js バージョン（例: v24.3.0）をインストールし、デフォルトに設定しても、VS Code で新しい統合ターミナルを開くたびに、別の古いバージョン（例: v22.16.0）に自動的に戻ってしまう。

### 解決策

根本原因は、VS Code Server プロセスが古い環境情報（PATH など）をキャッシュしており、新しいターミナルセッションにその汚染された状態を「注入」していたためであった。このキャッシュは VS Code を再起動することでクリアされ、問題は解消した。

ただし、このようなキャッシュ汚染やシェルの複雑な起動シーケンス（`.profile`が`.bashrc`の後に実行されるなど）に影響されない堅牢な対策として、`.bashrc`に`PROMPT_COMMAND`を利用したフックを実装した。これにより、プロンプトが表示される直前に必ず`nvm`のデフォルトバージョンが読み込まれるようになり、問題が再発しない状態を維持できる。

## 実行された手順

1.  **問題の切り分け:** Windows 標準のターミナルから WSL を起動した場合と、VS Code の統合ターミナルで挙動が異なることを確認。原因が VS Code とシェルの相互作用にあると特定した。
2.  **シェルの起動スクリプトの調査:** `.bashrc`と`.profile`の読み込み順序と内容を調査し、`nvm`の設定が他のプロセスによって上書きされる可能性を特定した。
3.  **`PROMPT_COMMAND`による対策の実装:** 起動プロセスの最後に強制的に`nvm`を有効化するため、`.bashrc`に`PROMPT_COMMAND`フックを追加。これにより、Node.js のバージョンが意図通りに固定されることを確認した。
4.  **副次的問題の解決:** `PROMPT_COMMAND`の実装に伴い発生した`sed`エラーをデバッグ。`nvm`の内部的なバージョンチェック処理がエラーの原因と特定し、チェック処理を省略したシンプルな関数に書き換えることでエラーを解消した。
5.  **根本原因の判明:** 最終的に、VS Code 自体の再起動によって問題が完全に解消。これにより、根本原因が VS Code Server のキャッシュ汚染であったと結論づけた。対策として実装した`PROMPT_COMMAND`は、同様の問題の再発を防ぐための恒久的な対策として有効である。

## 技術的詳細

- **使用ツール:**
  - WSL2 (Ubuntu)
  - Visual Studio Code (Remote - WSL 拡張機能)
  - nvm (Node Version Manager)
  - bash
- **関連ファイル:** `~/.bashrc`, `~/.profile`
- **エラーと対処法:**
  - **現象:** `node --version`がターミナルを開きなおすと元に戻る。
    - **対処:** 起動シーケンスの最後に`nvm use default`を実行する`PROMPT_COMMAND`を`.bashrc`に設定。
  - **エラー:** `sed: -e expression #1, char 318: unterminated address regex`
    - **原因:** `PROMPT_COMMAND`から`nvm`の内部関数（バージョンチェックなど）を呼び出した際に、VS Code のリモート環境との相互作用で発生。
    - **対処:** `PROMPT_COMMAND`から呼び出す関数を、バージョンチェックを行わないシンプルな`nvm use default`の直接実行に切り替えた。

## 実行されたコマンド（最終的な.bashrc 設定）

以下の設定を`.bashrc`の末尾に追加することで、問題の解決と再発防止を実現した。

```bash
# Add Claude CLI to PATH
export PATH="$HOME/.claude/local:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# --- NVM Auto-Loader using PROMPT_COMMAND ---
# This ensures the correct NVM version is loaded just before the prompt appears,
# overriding any other settings that might have interfered.

# Define a function to load the default NVM version.
load_nvm_default() {
  # If nvm.sh exists, silently load the default version unconditionally.
  [ -s "$NVM_DIR/nvm.sh" ] && nvm use default --silent > /dev/null 2>&1
}

# Add the function to PROMPT_COMMAND.
# Check if PROMPT_COMMAND is already set and append, otherwise set it.
if [[ -z "$PROMPT_COMMAND" ]]; then
  PROMPT_COMMAND="load_nvm_default"
elif [[ "$PROMPT_COMMAND" != *"load_nvm_default"* ]]; then
  PROMPT_COMMAND="load_nvm_default; $PROMPT_COMMAND"
fi
# --- End of NVM Auto-Loader ---
```
