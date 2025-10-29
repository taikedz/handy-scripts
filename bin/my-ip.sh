set -x
ip addr | grep 'state UP' -A2 | grep inet | grep -v inet6|awk '{print $2}'|grep -vP '^(192\.168|172\.)'
