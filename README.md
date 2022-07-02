# isucon utils

## Usage

**profile_slack.sh**

環境変数 `SLACK_WEBHOOK` に webhook URL を設定

```.env
SLACK_WEBHOOK=https://webhook.url
```

ホームディレクトリに，アクセスログを `access.log`，スロークエリログを `slow.log` という名称でそれぞれ配置．
`sh ./profile_slack.sh` このリポジトリに Issue が作成され，URLが Slack に送信される．
