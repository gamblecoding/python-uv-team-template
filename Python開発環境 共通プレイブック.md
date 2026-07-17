# Python開発環境 共通プレイブック
 
このドキュメントは、チーム全員が同一の環境でスムーズに開発を行うための共通ルールです。暗黙知をなくし、開発のトラブルを未然に防ぐために、全員がこの手順を厳守してください。
 
## 📁 1. ディレクトリ（フォルダ）構成のルール
 
VM内のフォルダ構成を統一します。パスがバラバラだとトラブルシューティングが困難になるため、必ず以下の構成に従ってください。
 
 
```

C:\ (または ~/ ユーザーディレクトリ)

└── projects/              <-- 【共通ルール】開発用プロジェクトはすべてここに置く

    └── [プロジェクト名]/   <-- 各プロジェクトのルート

        ├── .git/

        ├── .venv/          <-- 仮想環境（※自動生成されます。Git管理対象外）

        ├── .vscode/        <-- VS Code設定フォルダ（Git管理対象）

        │   ├── settings.json

        │   └── extensions.json

        ├── .gitignore      <-- 不要なファイルをGitに上げない設定

        ├── pyproject.toml  <-- プロジェクト定義 ＆ ライブラリ管理

        ├── uv.lock         <-- バージョン固定ファイル（※自動生成されます）

        ├── README.md       <-- このプロジェクトの取扱説明書

        └── src/            <-- ソースコード（プログラム本体）を置くフォルダ

            └── main.py
 
```
 
## 📄 2. 各プロジェクトに「必ず」入れる3大基本ファイル
 
新しいプロジェクトを立ち上げる際は、ルート直下に以下の3つのファイルを必ず作成・配置してください。
 
### ① `.gitignore`（Gitのゴミ箱フィルター）
 
不要なキャッシュや仮想環境フォルダ、プライベートな設定ファイルをGitにコミットしないための除外設定です。
 
 
```

# --- Pythonキャッシュ ---

__pycache__/

*.pyc
 
# --- 仮想環境フォルダ（絶対にGitに上げない！） ---

.venv/

venv/

env/
 
# --- VS Codeの一時ファイルやOS生成ファイル ---

.history/

.DS_Store

Thumbs.db
 
```
 
### ② `pyproject.toml`（プロジェクトの設計図）
 
プロジェクトのメタデータと、使用するPythonのバージョン、必要な外部ライブラリを管理する中心ファイルです。
 
```

[project]

name = "my-python-project"

version = "0.1.0"

description = "チーム共通のプロジェクトテンプレート"

requires-python = ">=3.10"

dependencies = [

    # 必要なライブラリは uv add コマンドで自動追記されます

]
 
```
 
### ③ `README.md`（プロジェクトの取扱説明書）
 
プロジェクトの概要と、起動までの手順を簡潔にまとめたドキュメントです。
 
Markdown
 
```

# プロジェクト名
 
## 概要

〇〇の処理を自動化するためのプログラムです。
 
## 前提条件

- `uv` がインストールされていること
 
## 起動方法

1. `uv sync` を実行して環境を構築する

2. `uv run src/main.py` で実行する
 
```
 
## 3. 【手順書】プロジェクト開始の共通ステップ（uv編）
 
各VM上で新しいプロジェクトの開発に参加する際の手順です。
 
1.リポジトリをダウンロード（クローン）する:

作業時間: 1分.
 
PowerShellなどのターミナルを開き、共通の `projects` フォルダへ移動してから、Gitクローンを実行します。
 
PowerShell
 
```

cd C:\projects

git clone https://github.com/your-team/your-project.git

cd your-project
 
```
 
**2.環境を自動同期する（uv sync）:**作業時間: 30秒（初回のみ）.
 
プロジェクトのフォルダ内で、以下のコマンドを実行します。
 
PowerShell
 
```

uv sync
 
```
 
> 💡 **何が起きる？**
> 
> `pyproject.toml` に記載された適切なPythonバージョンを自動で用意し、フォルダ直下に仮想環境 `.venv` を作成、必要なライブラリも一気にインストールされます。
 
**3.プログラムを実行する:**作業時間: 10秒.
 
仮想環境をアクティベート（有効化）する必要はありません。`uv run` を使って直接プログラムを動かします。
 
PowerShell
 
```

uv run src/main.py　＜--srcフォルダにあるmain.pyを、現在の仮想環境で実行するよ！の意味
 
```
 
> 💡 **ポイント**
> 
> `uv run` を頭につけるだけで、背後で自動的に `.venv` 内のPythonとライブラリを使って実行されます。
 
## 🤝 4. 開発時の「これだけは守る」新しい共通約束
 
環境のズレによるエラーを100%防ぐための、日々の開発ルールです。
 
> 📌 **約束1：ライブラリの追加は必ず `uv add` コマンドを使う**
> 
> `pip` は直接使わず、以下のコマンドでライブラリを追加します。
> 
> PowerShell
> 
> ```
> uv add pandas
> 
> ```
> 
> これにより、自分の仮想環境へインストールされると同時に、`pyproject.toml` と `uv.lock` が自動更新され、チーム全員に構成が共有されます。
 
> 📌 **約束2：Gitからコードを引いたら、まずは `uv sync`**
> 
> 毎朝や作業前に `git pull` を行い、他人の更新内容を取り込んだら、必ず一度 `uv sync` を実行して自分の仮想環境を最新状態に同期してください。
 
## 🛠️ 5. VS Codeを使用するメンバーへの補足
 
チームでVS Codeを使用するうえで、VS Codeの設定をリポジトリ内に共通化しておくことで、「コード補完が動かない」「赤波線の警告が出る」といったトラブルを自動で解消できます。また、「つい癖で `pip install` や `python src/main.py` と打ってしまう」というミスを防ぐため、自動で `uv` コマンドに翻訳して実行してくれるお助け機能もここに組み込みます。
 
各プロジェクトのルートに `.vscode` フォルダを作り、以下の3つのファイルをコミットしておきましょう。
 
### ① `.vscode/settings.json`（VS Codeの設定共通化）
 
VS Codeに対し、スムーズに開発でき、コードの品質を均一にするための設定です。プロジェクト直下の `.venv` にあるPythonを常に使用し、保存時にコードを自動整形（Ruffを使用）するように指示したり、ターミナル起動時に自動ロードする設定です。

JSON
 
```

{

  // ==========================================

  // 1. Python & 仮想環境(venv) の自動認識設定

  // ==========================================

  // プロジェクト直下の .venv を自動でPython環境として認識させます

  "python.defaultInterpreterPath": "${workspaceFolder}/.venv",

  "python.terminal.activateEnvInTerminal": true,
 
  // ==========================================

  // 2. コード自動整形・エラーチェック（Ruff）の強制

  // ==========================================

  // 標準のフォーマッター（整形ツール）を「Ruff」に指定します

  "[python]": {

    "editor.defaultFormatter": "charliermarsh.ruff",

    // ファイル保存時、自動でコードのインデントや見た目をきれいに整形する

    "editor.formatOnSave": true,

    "editor.codeActionsOnSave": {

      // ファイル保存時、使っていないライブラリのインポートを自動削除＆並び替え

      "source.organizeImports": "explicit"

    }

  },
 
  // ==========================================

  // 3. ファイルの「お作法」の統一（Gitの衝突防止）

  // ==========================================

  // ファイルの末尾には必ず「空行（改行）」を1行入れる（POSIX規格に合わせる）

  "files.insertFinalNewline": true,

  // 行末の不要なスペース（ゴミスペース）を保存時に自動で削除する

  "files.trimTrailingWhitespace": true,

  // 改行コードを「LF」に統一する（WindowsとMac/Linux間の見えないズレを防止）

  "files.eol": "\n",
 
  // ==========================================

  // 4. 初心者が開発しやすくなる画面表示

  // ==========================================

  // 1マスのインデント（スペース4つ）を視覚的に分かりやすく縦線で表示する

  "editor.guides.indentation": true,

  // 編集中のファイルのタブに、Gitで変更があったかどうかの色（緑や黄）を付ける

  "scm.decorations.enabled": true,
 
  // ==========================================

  // 5. 【お助け機能】ターミナル起動時に警告＆コマンド自動変換スクリプトを読み込む

  // ==========================================

  "terminal.integrated.profiles.windows": {

    "PowerShell (uv-enforced)": {

      "source": "PowerShell",

      "icon": "terminal-powershell",

      "args": ["-NoExit", "-File", "${workspaceFolder}/.vscode/enable-uv-warnings.ps1"]

    }

  },

  "terminal.integrated.defaultProfile.windows": "PowerShell (uv-enforced)"

}

```
 
### ② `.vscode/extensions.json`（おすすめ拡張機能の自動通知）
 
プロジェクトを開いた瞬間に、メンバーの画面に「この拡張機能をインストールしますか？」と通知を出し、1クリックで全員に同じプラグインを入れさせる設定です。

JSON
 
```

{

  "recommendations": [

    "ms-python.python",      // Microsoft公式 Pythonサポート

    "ms-python.vscode-pylance", // 賢いコード補完・エラー検知 (超重要)

    "charliermarsh.ruff",    // 2026年標準：超高速コード自動整形＆エラーチェック (Ruff)

    "donjayamanne.githistory" // Gitの履歴を見やすくする

  ]

}
 
```
 
### ③ `.vscode/enable-uv-warnings.ps1`（警告＆コマンド自動変換スクリプト）
 
VS Code内のターミナル（PowerShell）で、癖で古いコマンドを打ってしまった際に、「注意を促しつつ、自動的に正しい `uv` コマンドに翻訳して実行してくれる」スクリプトです。
 
`.vscode` フォルダの中に、新規ファイルとして **`enable-uv-warnings.ps1`** を作成し、以下をそのまま貼り付けて保存してください。
 
PowerShell
 
```

# ==========================================================

# VS Code用 お助けスクリプト (pip / python の uv 自動変換)

# ==========================================================
 
# --- pip install を自動で uv add に変換 ---

function pip {

    if ($args[0] -eq "install" -and $args.Length -gt 1) {

        $packages = $args[1..($args.Length-1)]

        Write-Host "`n[💡 NOTICE] pip install ではなく 'uv add' を使いましょう！" -ForegroundColor Yellow

        Write-Host "自動的に 'uv add $packages' に変換して実行します...`n" -ForegroundColor Cyan

        uv add $packages

    } else {

        # install 以外のコマンド（pip list など）はそのまま通す
& (Get-Command pip.exe -All | Select-Object -First 1) @args

    }

}
 
# --- python xxx.py を自動で uv run python xxx.py に変換 ---

function python {

    # ファイルの直接実行（引数があり、それが - から始まらない場合）

    if ($args.Length -gt 0 -and $args[0] -notlike "-*") {

        Write-Host "`n[💡 NOTICE] python 直接実行ではなく 'uv run' を使いましょう！" -ForegroundColor Yellow

        Write-Host "自動的に 'uv run python $args' に変換して実行します...`n" -ForegroundColor Cyan

        uv run python @args

    } else {

        # 引数なし（対話シェル起動）や、python --version などのオプションはそのまま通す
& (Get-Command python.exe -All | Select-Object -First 1) @args

    }

}

```