#!/bin/bash
set -Ce

if [[ -z "$1" ]]; then
    echo "Access log target is not specified!!"
    echo "Target host is not specified. Please setup \"~/.ssh/config\" and pass username and host name as 1st argument."
    echo "\t${username}@${hostname}"
    exit 0
fi

if [[ -z "$2" ]]; then
    echo "Mysql slow query log target is not specified!!"
    echo "Target host is not specified. Please setup \"~/.ssh/config\" and pass username and host name as 1st argument."
    echo "\t${username}@${hostname}"
    exit 0
fi

# Dependencies check
dependencies=("alp" "pt-query-digest")
for d in "${dependencies[@]}";
do
    if !(type $d > /dev/null 2>&1); then
        echo "${d}:\tNot Found"
        exit 0
    fi
done

# Declare file names and create directory
dir_name=`date +%m%d-%H%M%S`
mkdir -p "log/$dir_name"

access_file="log/${dir_name}/access.log"
slow_file="log/${dir_name}/slow.log"

# Fetch logs
ssh -t $1 "sudo cp /var/log/nginx/access.log ~/access.log"
scp $1:~/access.log $access_file

ssh -t $2 "sudo cp /var/log/mysql/slow.log ~/slow.log"
scp $2:~/slow.log $slow_file


# Post results to slack
function send_profile_result() {
    payload="
    {
        \"blocks\": [
            {
                \"type\": \"section\",
                \"text\": {
                    \"type\": \"plain_text\",
                    \"text\": \"計測結果が更新されました \",
                    \"emoji\": true
                }
            },
            {
                \"type\": \"section\",
                \"text\": {
                    \"type\": \"mrkdwn\",
                    \"text\": \"$1\"
                }
            },
        ]
    }
    "
    curl -X POST \
        -H 'Content-Type: application/json' \
        -d "$(echo "$payload")"\
        $SLACK_WEBHOOK
}

# Profile access log with "alp"
printf "### alp\n" >| alpmsg
cat $access_file | alp ltsv -r --format md --query-string -m '/api/condition/*','/api/isu/[0-9a-zA-Z\-]+','/isu/[0-9a-zA-Z\-]','/\?jwt=.*' | head -n20 >> alpmsg
printf "\n" >> alpmsg

# Profile slow log with "pt-query-digest"
printf "\n### qt-query-digest\n\`\`\`\n" >| ptqmsg
pt-query-digest $slow_file >> ptqmsg
printf "\n\`\`\`" >> ptqmsg

if [[ "$(cat ./.dest)" == "" ]]; then
    # Create issue on "ushmz/isucon-utils"
    url=`gh issue create --title "計測記録" --body "$(cat alpmsg)$(cat ptqmsg)"`
    echo $url > ./.dest
else
    url=`gh issue comment "$(cat ./.dest)" --body "$(cat alpmsg)$(cat ptqmsg)"`
fi

# Stinky code
rm -f alpmsg ptqmsg

# Send issue link to slack
send_profile_result "$url"
