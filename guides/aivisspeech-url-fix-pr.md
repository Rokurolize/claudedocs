# AIVISSPEECH URL修正プルリクエスト

## 事実情報

The AIVISSPEECH official website URL in README.md was `https://aivis.la/`.

The URL `https://aivis.la/` returns DNS_PROBE_FINISHED_NXDOMAIN error.

The correct URL is `https://aivis-project.com/#products-aivisspeech`.

## 実行された手順

1. README.md:13行目のURLを更新
2. 新規ブランチ`fix/update-aivisspeech-url`を作成
3. 変更をコミット（コミットハッシュ: 8f3398d）
4. GitHub CLIでリポジトリをフォーク（`Rokurolize/mcp-simple-aivisspeech`）
5. フォークをリモートとして追加
6. ブランチをフォークにプッシュ
7. プルリクエスト#1を作成

## プルリクエスト詳細

- **PR番号**: #1
- **PR URL**: https://github.com/tegnike/mcp-simple-aivisspeech/pull/1
- **対象リポジトリ**: tegnike/mcp-simple-aivisspeech
- **ソースブランチ**: Rokurolize:fix/update-aivisspeech-url
- **変更ファイル**: README.md（1行変更）

## 技術的詳細

フォーク作成にはGitHub CLI (`gh repo fork`)を使用。

プルリクエスト作成には`gh pr create`コマンドを使用。

権限エラー（403）のため、直接プッシュではなくフォーク経由でのPR作成が必要。

## コマンド実行記録

```bash
git checkout -b fix/update-aivisspeech-url
git add README.md
git commit -m "fix: update AIVISSPEECH official website URL"
gh repo fork --clone=false
git remote add fork https://github.com/Rokurolize/mcp-simple-aivisspeech.git
git push -u fork fix/update-aivisspeech-url
gh pr create --repo tegnike/mcp-simple-aivisspeech --head Rokurolize:fix/update-aivisspeech-url
```