#!/bin/bash

echo "start_apps begin"
echo $SERVER_ADDR
echo $PASSWORD

exec "$@"
