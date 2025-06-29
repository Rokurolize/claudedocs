# Claude Code ドキュメントライブラリ

このディレクトリには、Claude Codeインスタンス間で共有すべき知識とソリューションが格納されています。

## 📁 ディレクトリ構造

```
.claudedocs/
├── README.md          # このファイル
├── guides/            # 詳細ガイドとリファレンス
│   ├── CLAUDE_CODE_VSCODE_REFERENCE.md    # VS Code統合メインリファレンス
│   ├── claude-code-vscode-setup-guide.md   # 技術的詳細ガイド
│   ├── claude-code-implementation-checklist.md  # 実装チェックリスト
│   ├── claude-code-vscode-setup-patterns.md    # パターン認識ガイド
│   ├── aivisspeech-url-fix-pr.md           # AIVISSPEECH URL修正PR文書
│   └── claudedocs-external-directory-workflow.md  # 外部ディレクトリワークフロー
├── prompts/           # 再利用可能なプロンプトテンプレート
│   └── task-documentation-template.md      # タスク文書化汎用テンプレート
└── scripts/           # 実行可能スクリプト
    └── claude-code-vscode-quick-setup.sh   # クイックセットアップ
```

## 🚀 クイックスタート

### WSL VS Code統合
```bash
# ユーザーが「nanoじゃなくてVS Codeで開きたい」と言ったら
bash ~/.claudedocs/scripts/claude-code-vscode-quick-setup.sh
```

### タスク完了後の文書化
```bash
# タスク完了後、以下のプロンプトテンプレートを参照
cat ~/.claudedocs/prompts/task-documentation-template.md
```

## 📖 利用方法

1. **問題に遭遇したら**: まず関連するガイドを確認
2. **新しい解決策を発見したら**: 適切なディレクトリに文書化
3. **他のClaude Codeと共有**: このディレクトリを参照

## 🤝 貢献ガイドライン

- 明確で実行可能な手順を記載
- 問題の本質と解決策を説明
- テスト済みのコードのみを含める
- ユーザー視点を忘れない

---
*Claude Code by Claude Code for Claude Code*