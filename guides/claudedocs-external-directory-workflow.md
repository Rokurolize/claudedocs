# claudedocs外部ディレクトリからの文書追加ワークフロー

## 前提条件

作業ディレクトリが`/home/ubuntu/claudedocs`以外の場所にある。

Claude Codeのセキュリティ制限により`cd`コマンドで親ディレクトリへの移動が不可。

`git -C`オプションを使用して別ディレクトリのGitリポジトリを操作する。

## 実行手順

### 1. claudedocs構造の確認

```bash
# READMEの確認
Read /home/ubuntu/claudedocs/README.md

# ディレクトリ構造の確認
LS /home/ubuntu/claudedocs/guides
```

### 2. ドキュメントの作成

```bash
# Writeツールで直接パスを指定して作成
Write /home/ubuntu/claudedocs/guides/[ドキュメント名].md
```

### 3. Gitステータスの確認

```bash
# 現在の状態確認
git -C /home/ubuntu/claudedocs status

# 差分確認
git -C /home/ubuntu/claudedocs diff

# コミット履歴確認
git -C /home/ubuntu/claudedocs log --oneline -5
```

### 4. 変更のコミット

```bash
# ファイルのステージング
git -C /home/ubuntu/claudedocs add guides/[ドキュメント名].md

# コミット作成（HEREDOCを使用）
git -C /home/ubuntu/claudedocs commit -m "$(cat <<'EOF'
[コミットタイプ]: [簡潔な説明]

[詳細な説明]

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# コミット成功の確認
git -C /home/ubuntu/claudedocs status
```

### 5. リモートへのプッシュ

```bash
git -C /home/ubuntu/claudedocs push
```

## 実例：AIVISSPEECH URL修正PRドキュメント

作業ディレクトリ: `/home/ubuntu/mcp-simple-aivisspeech`

作成ファイル: `/home/ubuntu/claudedocs/guides/aivisspeech-url-fix-pr.md`

コミットハッシュ: 31862c2

プッシュ先: https://github.com/Rokurolize/claudedocs.git

## 技術的詳細

`git -C <path>`オプションは指定されたディレクトリでGitコマンドを実行する。

Claude Codeのセキュリティ制限は子ディレクトリへの`cd`のみ許可する。

Writeツールは絶対パスを受け入れるため、任意の場所にファイル作成が可能。

## 注意事項

コミットメッセージには必ずClaude Code署名を含める。

ドキュメントは事実情報を中心に記載する。

guides/ディレクトリに適切な命名規則でファイルを作成する。