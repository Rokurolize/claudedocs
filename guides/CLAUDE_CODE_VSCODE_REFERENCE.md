# 🎯 Claude Code VS Code統合リファレンス

## 概要
WSL環境でnanoの代わりにホストOSのVS Codeを使いたいユーザーのための完全ガイド。
Claude Codeが実行時に出力を捕獲してしまう問題を、PowerShell経由で解決する。

## 📚 ドキュメント一覧

### 1. [完全ガイド](./claude-code-vscode-setup-guide.md)
技術的詳細と段階的実装手順。問題の本質から解決策まで。

### 2. [クイックセットアップスクリプト](./claude-code-vscode-quick-setup.sh)
```bash
# 一発実行でセットアップ完了
bash /home/ubuntu/claude-code-vscode-quick-setup.sh
```

### 3. [実装チェックリスト](./claude-code-implementation-checklist.md)
Claude Code向け。必須項目と避けるべきことのリスト。

### 4. [パターン認識ガイド](./claude-code-vscode-setup-patterns.md)
ユーザー要求パターンとトラブルシューティング。

## ⚡ 最速実装（3分以内）

```bash
# 1. セットアップスクリプト実行
bash /home/ubuntu/claude-code-vscode-quick-setup.sh

# 2. 現在のセッションに適用
source ~/.bashrc

# 3. 動作確認
edit test.txt
```

## 🔑 キーポイント

1. **問題**: Claude Codeが`code`を実行 → 出力捕獲 → ホストに届かない
2. **解決**: PowerShell + `Start-Process` → 独立プロセス → ホストで開く
3. **実装**: vscode-launcher.sh → エイリアス設定 → 完了

## 💡 Claude Code向けアドバイス

- TodoWriteで計画を立てる
- PowerShell経由の解決策に直行する
- ユーザーに原理を簡潔に説明する
- quick-setup.shの存在を伝える

## 🎉 成功の証

ユーザーが以下のように言えば成功：
- 「edit test.txtで俺のVS Codeが開いた！」
- 「もうnanoは見たくない」
- 「理想通りの結果」

---
*Created by Claude Code for Claude Code*
*Mission: WSLでもVS Codeで快適に*