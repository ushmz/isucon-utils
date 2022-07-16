
if !(type vmstat > /dev/null 2>&1); then
    echo "vmstat not found"
    echo "Try \"apt get procps\" "
    exit 1
fi

watch -d -n 1 vmstat -n -w
