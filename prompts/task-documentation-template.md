# タスク完了後のclaudedocs文書化プロンプト

## 使用方法

タスク完了後、以下のプロンプトをClaude Codeに入力して実行内容を文書化します：

---

## プロンプトテンプレート

```
先ほど完了したタスクについて、claudedocsプロジェクトに文書を作成してください。以下の手順に従ってください：

1. まず `/home/ubuntu/claudedocs/README.md` を読み込み、文書化のスタイルと構造を確認してください
2. 完了したタスクの事実情報を整理し、以下の構成で文書を作成してください：
   - 事実情報（何が問題で、何が解決策だったか）
   - 実行された手順（番号付きリスト）
   - 技術的詳細（使用したツール、コマンド、エラーと対処法）
   - 実行されたコマンド（```bashブロック内）
3. ファイル名は `[タスクの内容を表す名前]-[日付YYYYMMDD].md` の形式にしてください
4. 適切なディレクトリに配置してください（通常は`guides/`）
5. 文書作成後、変更をコミットしてプッシュしてください

注意：エラーが発生した場合でも、最終的に成功した方法を文書化してください。試行錯誤の過程も価値ある情報です。
```

---

## プロンプト使用時の内部処理フロー

### 1. コンテキスト読み込み
```bash
Read /home/ubuntu/claudedocs/README.md
LS /home/ubuntu/claudedocs/guides
```

### 2. 文書作成
```bash
Write /home/ubuntu/claudedocs/guides/[適切なファイル名].md
```

### 3. Git操作（外部ディレクトリから）
```bash
git -C /home/ubuntu/claudedocs status
git -C /home/ubuntu/claudedocs add guides/[ファイル名].md
git -C /home/ubuntu/claudedocs commit -m "[適切なコミットメッセージ]"
git -C /home/ubuntu/claudedocs push
```

## 文書化の原則

- **事実ベース**: 主観的な解釈を避け、客観的事実を記載
- **再現可能性**: 他のClaude Codeインスタンスが同じ結果を得られるよう詳細に記載
- **エラー対応**: エラーとその解決方法も含める
- **構造化**: 一貫した見出しとセクション構成を維持

## ファイル命名規則

- 小文字とハイフンを使用: `task-name-description.md`
- 日付が重要な場合は末尾に追加: `task-name-20240629.md`
- 明確で検索しやすい名前を選択

## コミットメッセージ形式

```
docs: [簡潔な説明]

[詳細な説明（必要に応じて）]

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```