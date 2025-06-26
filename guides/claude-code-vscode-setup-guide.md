# Claude Code用: WSL環境でホストVS Codeをデフォルトエディタにする完全ガイド

## 問題の本質
WSL環境でユーザーがnanoではなくホストOSのVS Codeでファイルを編集したいとき、Claude Codeが直接`code`コマンドを実行すると、VS Codeの出力がClaude側で捕獲されてしまい、ホストOSのVS Codeが開かない。

## 解決策: PowerShell経由での起動

### ステップ1: PowerShell VS Code起動スクリプトの作成

```bash
# Write tool を使用
Write /home/ubuntu/vscode-launcher.sh
```

内容:
```bash
#!/bin/bash
# VS Code launcher via PowerShell - bypasses Claude Code capture

# Get the file path
if [ $# -eq 0 ]; then
    # No arguments, open current directory
    FILE_PATH="."
else
    FILE_PATH="$1"
fi

# Get absolute path
ABS_PATH=$(realpath "$FILE_PATH")

# Convert WSL path to Windows path
WIN_PATH=$(wslpath -w "$ABS_PATH")

# Launch VS Code via PowerShell with proper working directory
cd /mnt/c && powershell.exe -NoProfile -Command "Start-Process code.cmd -ArgumentList \"$WIN_PATH\" -NoNewWindow" 2>/dev/null &

echo "VS Code opened: $FILE_PATH"
```

### ステップ2: スクリプトを実行可能にする

```bash
Bash: chmod +x /home/ubuntu/vscode-launcher.sh
```

### ステップ3: .bashrcの更新

```bash
# 既存のエディタ設定を確認
Bash: tail -n 10 /home/ubuntu/.bashrc

# エイリアスを更新（既にcodeのエイリアスがある場合）
Edit /home/ubuntu/.bashrc
old_string: alias edit="code"
alias e="code"
new_string: alias edit="/home/ubuntu/vscode-launcher.sh"
alias e="/home/ubuntu/vscode-launcher.sh"

# エイリアスがない場合は追加
Bash: echo 'alias edit="/home/ubuntu/vscode-launcher.sh"' >> ~/.bashrc && echo 'alias e="/home/ubuntu/vscode-launcher.sh"' >> ~/.bashrc

# エディタ環境変数も設定
Bash: echo 'export EDITOR="code --wait"' >> ~/.bashrc && echo 'export VISUAL="code --wait"' >> ~/.bashrc
```

### ステップ4: Git設定の更新

```bash
# Gitのエディタもホスト側VS Codeを使うように設定
Bash: git config --global core.editor "/home/ubuntu/vscode-launcher.sh --wait"
```

### ステップ5: テストと確認

```bash
# 現在のセッションでエイリアスを有効化
Bash: alias edit='/home/ubuntu/vscode-launcher.sh' && alias e='/home/ubuntu/vscode-launcher.sh'

# テストファイルを作成して開く
Write /home/ubuntu/test_vscode.txt
内容: Test file for VS Code

# VS Codeで開く（これでユーザーのホストOSのVS Codeが開く）
Bash: /home/ubuntu/vscode-launcher.sh /home/ubuntu/test_vscode.txt
```

## 重要な注意点

1. **直接実行しない**: Claude Codeが`edit`や`code`を直接実行すると、出力が捕獲される
2. **PowerShell経由**: `Start-Process`を使うことで、プロセスがホストOS側で独立して起動
3. **作業ディレクトリ**: `/mnt/c`に移動してからPowerShellを実行（UNCパスエラー回避）
4. **バックグラウンド実行**: `&`で非同期実行し、Claude Codeのプロセスと分離

## ユーザーへの説明

設定完了後、以下のようにユーザーに伝える:

```
設定完了！WSL環境でVS Codeがデフォルトエディタとして設定されました。

新しいターミナルを開いてから以下をお試しください：
- `edit ファイル名` → VS Codeで開く
- `e ファイル名` → VS Codeで開く（短縮版）
- `git commit` → コミットメッセージもVS Codeで編集

私（Claude Code）がファイルを作成・編集した後は、そのパスを表示するので、
あなたが直接`edit`コマンドで開いてください！
```

## トラブルシューティング

### VS Codeが開かない場合
```bash
# PowerShellでcodeコマンドが使えるか確認
Bash: powershell.exe -Command "Get-Command code" 2>/dev/null
```

### エイリアスが効かない場合
```bash
# 新しいシェルで確認
Bash: bash -c 'source ~/.bashrc && alias | grep edit'
```

## まとめ

このソリューションの核心は、Claude Codeの出力捕獲を回避するためにPowerShell経由でVS Codeを起動することです。ユーザーは通常のコマンドと同じように`edit`を使えますが、裏ではPowerShellがホストOSのVS Codeを独立したプロセスとして起動します。