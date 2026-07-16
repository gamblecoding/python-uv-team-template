# Python uv Team Template

チーム共通プレイブックに沿った、Pythonプロジェクトの開始用テンプレートです。`uv` による環境・依存関係管理、Ruffによる静的検査と整形、pytest、VS Code共通設定、GitHub Actionsを含みます。

## 前提条件

- Git
- [uv](https://docs.astral.sh/uv/)
- VS Code（任意）

## このテンプレートから始める

GitHubの「Use this template」から新しいリポジトリを作成し、次を実行します。

```powershell
git clone https://github.com/<organization>/<repository>.git
cd <repository>
uv sync
uv run src/main.py
```

仮想環境を手動で有効化する必要はありません。

## 日常の開発

依存パッケージは `pip install` ではなく、`uv` で管理します。

```powershell
uv add requests
uv add --dev pytest
uv remove requests
uv sync --locked
```

品質チェックは次のコマンドで実行します。

```powershell
uv run ruff check .
uv run ruff format --check .
uv run pytest
```

自動修正と整形を行う場合：

```powershell
uv run ruff check --fix .
uv run ruff format .
```

## 環境変数

秘密情報をGitへ登録しないでください。必要な場合はサンプルをコピーします。

```powershell
Copy-Item .env.example .env
```

変数名とダミー値だけを `.env.example` に記載し、実値は `.env` に保存します。

## 構成

```text
.
├── .github/workflows/ci.yml
├── .vscode/
├── src/main.py
├── tests/test_main.py
├── .env.example
├── .gitignore
├── pyproject.toml
├── uv.lock
└── README.md
```

## テンプレート利用後の変更箇所

1. `pyproject.toml` の `name`、`description`、ライセンスを更新する
2. このREADMEをプロジェクト固有の概要・前提条件・起動方法に書き換える
3. `.env.example` に必要な変数名を追加する
4. `uv lock` を実行し、`pyproject.toml` と `uv.lock` をコミットする

## ライセンス

MIT License

