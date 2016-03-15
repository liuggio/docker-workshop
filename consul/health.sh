#!/usr/bin/env bash

FREE=$(df -m / | tail -1 | awk '{ print $4 }')
TOTAL=$(df -m / | tail -1 | awk '{ print $2 }')
TIME=$(date)

cat <<-EOF
<free>$FREE</free>
<total>$TOTAL</total>
<processes>$PROCESSES</processes>
<used>$((TOTAL-FREE))</used>
<time>$TIME</time>
EOF

if [ $((TOTAL-FREE)) -lt $(($TOTAL/10)) ]; then
    exit 2
elif [ $((TOTAL-FREE)) -lt $(($TOTAL/30)) ]; then
    exit 1
fi

exit 0