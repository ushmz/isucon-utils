#!/bin/bash
set -Ce

if [[ -z "$1" ]]; then
    echo "Target host is not specified. Please setup \"~/.ssh/config\" and pass host name as 1st argument."
    exit 0
fi

if [[ -z "$2" ]]; then
    echo "Target username is not specified. Please setup \"~/.ssh/config\" and pass username as 2nd argument."
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
dir_name=`date +%H%M%S`
mkdir -p "log/$dir_name"

access_file="log/${dir_name}/access.log"
slow_file="log/${dir_name}/slow.log"

# Fetch logs
# scp $1:/var/log/nginx/access.log $access_file
# scp $1:/var/log/mysql/slow.log $slow_file

# If above doesn't work...
ssh -t $1 "sudo cp /var/log/nginx/access.log ~/access.log; sudo chown $2:$2 ~/access.log"
scp $1:~/access.log $access_file

ssh -t $1 "sudo cp /var/log/mysql/slow.log ~/slow.log; sudo chown $2:$2 ~/slow.log"
scp $1:~/slow.log $slow_file


# Post results to slack
function send_profile_result() {
    payload="
    {
        \"blocks\": [
            {
                \"type\": \"header\",
                \"text\": {
                    \"type\": \"plain_text\",
                    \"text\": \"alp result \",
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
            {
                \"type\": \"header\",
                \"text\": {
                    \"type\": \"plain_text\",
                    \"text\": \"pt-query-digest result \",
                    \"emoji\": true
                }
            },
            {
                \"type\": \"section\",
                \"text\": {
                    \"type\": \"mrkdwn\",
                    \"text\": \"$2\"
                }
            }
        ]
    }
    "
    curl -X POST \
        -H 'Content-Type: application/json' \
        -d "$(echo "$payload")"\
        $SLACK_WEBHOOK
}

# Profile access log with "alp"
echo "\`\`\`\n" > b
cat $access_file | alp ltsv >> b
echo "\n\`\`\`" >> b
export msg=$(cat b)
# Create issue on "ushmz/isucon-utils"
alp_url=`gh issue create --title "alp@$(date +%H:%M)" --body "$msg"`

# Profile slow log with "pt-query-digest"
echo "\`\`\`\n" >| b
pt-query-digest $slow_file >> b
echo "\n\`\`\`" >> b
export msg=$(cat b)
# Create issue on "ushmz/isucon-utils"
ptd_url=`gh issue create --title "pt-query-digest@$(date +%H:%M)" --body "$msg"`

# Stinky code
rm -f b

# Send issue link to slack
send_profile_result "$alp_url" "$ptd_url"
