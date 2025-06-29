# ガイド: シェル関数の永続的な上書き問題のデバッグ

## 1. 事実情報

### 問題

-   `claude` コマンドが、本来の実行ファイルではなく、意図しない高コストな設定を持つ古いBash関数によって上書きされていた。
-   `source ~/.bashrc` を実行すると一時的に解決するが、新しいターミナルセッションを開始すると問題が再発した。

### 解決策

-   根本原因は、VSCodeのPython拡張機能が管理する環境変数キャッシュファイル (`.../python_files/deactivate/bash/envVars.txt`) に、古い `claude` 関数の定義が `BASH_FUNC_claude%%` という形式で永続化されていたことだった。
-   この `envVars.txt` ファイルの中身を `truncate` コマンドで空にし、WSLを完全に再起動することで、シェルの起動時に古い関数が読み込まれるのを防ぎ、問題を恒久的に解決した。

## 2. 実行された手順

1.  **現状確認:** `type -a claude` コマンドを実行し、`claude` が関数として定義されていることを確認。問題の切り分けを開始した。
2.  **一時的対処:** `unset -f claude` で現在のセッションから関数を削除し、`source ~/.bashrc` で設定を再読み込み。これにより、そのセッションでは問題が解決することを確認した。
3.  **再発確認:** 新しいターミナルを起動すると問題が再発することから、根本原因が `.bashrc` の読み込み順序の後、あるいは別の起動プロセスにあると推測した。
4.  **犯人の捜索 (Grep):** `grep --color=always -r "🔥 LAUNCHING CLAUDE CODE" ~/` を実行し、特徴的な文字列を含むファイルをホームディレクトリ全体から検索した。
5.  **犯人の特定:** 検索結果から、VSCodeのPython拡張機能ディレクトリ内にある `/home/ubuntu/.vscode-server/extensions/ms-python.python-2025.8.0-linux-x64/python_files/deactivate/bash/envVars.txt` が、古い関数定義を含んでいることを発見した。
6.  **犯人の無力化:** `truncate -s 0 [ファイルパス]` コマンドで、対象の `envVars.txt` ファイルを安全に空にした。
7.  **完全な再起動:** Windows側で `wsl --shutdown` を実行し、すべてのWSLプロセスを終了させた。
8.  **最終確認:** 新しいターミナルを起動し、`type -a claude` を再度実行。`claude` が本来の実行ファイルのみを指していることを確認し、問題解決とした。

## 3. 技術的詳細

-   **主要ツール:**
    -   `type -a`: コマンドがエイリアス、関数、実行ファイルのいずれであるかを特定するために不可欠。
    -   `grep -r`: 広範囲のファイルから特定の文字列を検索し、設定のゴースト（意図しない古い定義）を発見するために使用。
    -   `truncate`: ファイルを削除せずに中身を空にする安全な方法。拡張機能が管理するファイルを壊さずに無力化するのに適している。
    -   `unset -f`: シェルセッションから関数定義を削除する。
-   **重要な概念:**
    -   **シェルの起動シーケンス:** シェルは `.bash_profile` や `.bashrc` など複数のファイルを順に読み込む。問題の原因は、この読み込みシーケンスのどこに隠れているかを探ることが重要だった。
    -   **`BASH_FUNC_...%%`:** Bashが `export -f` で関数をエクスポートする際に使用する内部的な表現形式。これを知っていると、環境変数として保存された関数を特定しやすくなる。
-   **エラーと対処の要点:**
    -   `source` で一時的に直る問題は、起動時の読み込み順序やキャッシュが原因であることが多い。
    -   犯人と思われるファイルが特定できない場合は、よりユニークな文字列で検索範囲を広げて `grep` するのが有効な戦略である。

## 4. 実行された主要コマンド

```bash
# 問題の初期確認
type -a claude

# 広範囲での犯人捜索
grep --color=always -r "🔥 LAUNCHING CLAUDE CODE" ~/

# 犯人ファイルの中身を確認（例）
cat /home/ubuntu/.vscode-server/extensions/ms-python.python-2025.8.0-linux-x64/python_files/deactivate/bash/envVars.txt

# 犯人ファイルの無力化
truncate -s 0 /home/ubuntu/.vscode-server/extensions/ms-python.python-2025.8.0-linux-x64/python_files/deactivate/bash/envVars.txt

# WSLの完全な再起動（WindowsのPowerShellで実行）
wsl --shutdown

# 解決後の最終確認
type -a claude
