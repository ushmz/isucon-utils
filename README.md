# isucon utils

## Usage

**./scripts/prepare_bench.darwin.sh**

第 1 引数にホスト名を与えて実行

```sh

# ~/.ssh/config に以下のように設定されている前提で
# ---
# Host isucon
#     Hostname hoge.fuga
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa

sh ./scripts/prepare_bench.darwin.sh isucon
```

- nginx, mysql のログファイルの再生成（alp の `--pos` オプションを使用することで不要かも[FYI](https://github.com/tkuchiki/alp/blob/834b8d0b45556e158a8d2f51c1d5b14d46a3ffbc/docs/usage_samples.ja.md#--pos-tmpalppos)）
- nginx, mysql の再起動

**./scripts/prepare_bench.sh**

本番環境(ベンチ対象アプリケーションが動いているマシン)上で実行する．

- キャッシュを退避させる
- サービスの設定を再読み込みする．
- nginx, mysql のログファイルの再生成（alp の `--pos` オプションを使用することで不要かも[FYI](https://github.com/tkuchiki/alp/blob/834b8d0b45556e158a8d2f51c1d5b14d46a3ffbc/docs/usage_samples.ja.md#--pos-tmpalppos)）
- nginx, mysql の再起動

**./scripts/profile.darwin.sh**

環境変数 `SLACK_WEBHOOK` に webhook URL を設定

```.env
SLACK_WEBHOOK=https://webhook.url
```

第 1 引数にホスト名
第 2 引数にユーザ名を与えて実行

```sh

# ~/.ssh/config に以下のように設定されている前提で
# ---
# Host isucon
#     Hostname hoge.fuga
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa

sh ./scripts/profile.darwin.sh isucon ubuntu
```

- 指定したサーバから nginx のアクセスログ (`/var/log/access.log`) および mysql のスロークエリログ (`/var/log/mysql/slow.log`) を取得し，alp, pt-query-digest を用いてプロファイリングを行う．
- 結果の内容でこのリポジトリに Issue が作成され，URL が Slack に送信される．
