# 本番前にやること

## 性能チェック

**scripts/spec_check.sh**

- [ ] 各マシンの大まかな性能を確認しておく

モニタリングするなら以下

```shell
watch -d -n 1 vmstat -n -w
```

## ベンチ準備

```sh
make prepare
```

- [ ] 競技用 app のディレクトリ構成・配置位置に合わせて変更する．
- [ ] 競技用 app の起動方法に合わせて再起動方法を変更する．
      もしくは `APP_NAME=isucari sh prepare_bench.sh`のように実行時に渡してもよい．

```Makefile
# Update application code
# [TODO] : 当日のディレクトリ構成に応じて変更
scp-app:
	scp ./webapp/go/${APPNAME} ${APP}:~/webapp/go/${APPNAME}
	wait

# Restart application
# [TODO] : 当日のアプリケーション起動方法に応じて変更
restart-app:
	ssh ${APP} "sudo systemctl restart ${APPNAME}.go"
	wait

```

## プロファイリング

```sh
make profile
```

- [ ] 一度ベンチを回してみて，まとめても良さそうな URL があればオプションを追加する．
      alp は `-m` オプションで URL を正規表現でまとめられる．
      URL は `,` 区切りで複数指定できる．

```
alp -m '/api/condition/*','/api/isu/[0-9a-zA-Z\-]+','/isu/[0-9a-zA-Z\-]','/\?jwt=.*'
```
