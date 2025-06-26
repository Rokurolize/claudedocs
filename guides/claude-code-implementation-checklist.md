# Claude Code実装チェックリスト: WSL VS Codeセットアップ

## ユーザーが「nanoじゃなくてVS Codeで開きたい」と言ったら

### ☐ 1. 即座にTodoWriteで計画を作成
```yaml
todos:
  - PowerShell経由VS Code起動スクリプト作成
  - .bashrcへのエイリアス設定
  - Git設定の更新
  - 動作テストと最適化
```

### ☐ 2. 核心的解決策の実装
```bash
# これを一番最初に実行（理由: Claude Codeが直接codeを実行すると出力が捕獲される）
Write /home/ubuntu/vscode-launcher.sh
```

### ☐ 3. PowerShellの重要性を説明
ユーザーに説明: 「Claude Code経由でeditコマンドを実行すると、VS Codeの出力が私側で捕獲されてしまい、あなたのホストOSのVS Codeに届きません。PowerShell経由で解決します。」

### ☐ 4. 必須の設定項目
- [ ] vscode-launcher.sh作成（PowerShell経由起動）
- [ ] chmod +x で実行可能に
- [ ] .bashrcにエイリアス追加/更新
- [ ] git configでエディタ設定
- [ ] 現在のセッションでエイリアス有効化

### ☐ 5. 絶対に避けるべきこと
- ❌ Claude Codeから直接 `code filename` を実行
- ❌ 通常の `code --wait` をEDITOR変数に設定するだけで終わる
- ❌ sudo update-alternativesだけに頼る（パスワード問題あり）

### ☐ 6. テスト手順
```bash
# 1. スクリプト直接実行でテスト
/home/ubuntu/vscode-launcher.sh test.txt

# 2. 出力確認（"VS Code opened: test.txt"が表示されればOK）
```

### ☐ 7. ユーザーへの最終説明テンプレート
```
完成！PowerShell経由でホストVS Codeを起動します🚀

今すぐ試す：
source ~/.bashrc
edit test.txt

私がファイルを作成・編集した後は、そのパスを表示するので、
あなたが直接`edit`コマンドで開いてください！
```

## 実装の急所

1. **問題の本質**: Claude Codeがcodeコマンドを実行 → 出力捕獲 → ホストに届かない
2. **解決策**: PowerShell + Start-Process → 独立プロセス → ホストで開く
3. **UNCパス対策**: cd /mnt/c してからPowerShell実行
4. **即効性**: 現在のセッションでもaliasコマンドで即座に使えるように

## 時間短縮のコツ

1. 最初から/home/ubuntu/claude-code-vscode-quick-setup.shを作成して実行
2. ユーザーに「このスクリプトを実行すれば一発で設定完了」と伝える
3. 試行錯誤せず、PowerShell経由の解決策に直行する

---
このチェックリストに従えば、5分以内にユーザーのニーズを満たせます。