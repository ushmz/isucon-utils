#!/bin/sh

# To make if statement simple
function has() {
    type "${1:?too few arguments}" &>/dev/null
}

# Dependencies check
dependencies=("alp" "pt-query-digest")
for d in "${dependencies[@]}";
do
    if has $d
    then
        echo "${d}:\tOK!"
    else
        echo "${d}:\tNot Found"
        exit 0
    fi
done

dir_name=`date +%H%M%S`
mkdir -p "log/$dir_name"

access_file="log/${dir_name}/access.log"
slow_file="log/${dir_name}/slow.log"

cp ./access.log $access_file
cp ./slow.log $slow_file


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
                    \"text\": \"<$1|Issue on Github>\"
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
                    \"text\": \"<$2|Issue on Github>\"
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

echo "\`\`\`\n" > b
cat $access_file | alp ltsv >> b
echo "\n\`\`\`" >> b
export msg=$(cat b)
alp_url=`gh issue create --title "alp@$(date +%H:%M)" --body "$msg"`

echo "\`\`\`\n" > b
pt-query-digest $slow_file >> b
echo "\n\`\`\`" >> b
export msg=$(cat b)
ptd_url=`gh issue create --title "pt-query-digest@$(date +%H:%M)" --body "$msg"`

# Stinky code
rm -f b

send_profile_result "$alp_url" "$ptd_url"
