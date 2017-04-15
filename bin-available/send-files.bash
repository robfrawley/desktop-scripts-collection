#!/usr/bin/env bash

if [[ "${1:-x}" == "x" ]]; then
  FROM_PATH="$HOME/torrents/done/"
else
  FROM_PATH="${1}"
fi

if [[ "${2:-x}" == "x" ]]; then
  TO_PATH="/s/media/video/queue/"
else
  TO_PATH="${2}"
fi

if [[ "${3:-x}" == "x" ]]; then
  TO_IP="192.168.1.185"
else
  TO_IP="${3}"
fi

if [[ ! -d ${FROM_PATH} ]]; then
  echo "Invalid directory "${FROM_PATH}"!"
  exit 255
fi

echo "SEND-FILES"
echo
echo "From Path : ${FROM_PATH}"
echo "To Path   : ${TO_PATH}"
echo "Remote IP : ${TO_IP}"
echo
echo "Sending files in 3 seconds (^C to cancel)..."
echo

sleep 3

rsync -avp --verbose --progress $FROM_PATH/* rmf@${TO_IP}:${TO_PATH}

echo
echo "Completed sending files."
echo
