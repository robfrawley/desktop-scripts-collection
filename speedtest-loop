#!/bin/bash

if [[ "${1:-x}" == "x" ]]; then
    SLEEP_SECONDS=1200
else
    SLEEP_SECONDS="${1}"
fi

clear

function out_about()
{
    echo -en "\nAUTOMATED SPEED TEST\n\n"
    echo -en "Author : Rob Frawley 2nd\n"
    echo -en "License: MIT License\n\n"
}

function out_time()
{
  local time="${1}"
  if [[ ${time} == 1 ]]
  then
    echo -en "${time} second"
  elif [[ ${time} -lt 60 ]]
  then
    echo -en "${time} seconds"
  elif [[ $(echo "scale=2;  ${time} / 60" | bc) == "1.00" ]]
  then
    echo -en "$(echo "scale=2;  ${time} / 60" | bc) minute"
  elif [[ $(echo "scale=0; ${time} / 60" | bc) == 60 ]]
  then
    echo -en "$(echo "scale=0;  ${time} / 60 / 60" | bc) hour"
  elif [[ $(echo "scale=0; ${time} / 60" | bc) -gt 59 ]]
  then
    echo -en "$(echo "scale=2;  ${time} / 60 / 60" | bc) hours"
  else
    echo -en "$(echo "scale=2;  ${time} / 60" | bc) minutes"
  fi
}

function out_config()
{
  echo -en "[CONFIGURATION]\n"
  echo -en "Binary  : $(which speedtest-cli)\n"
  echo -en "Runtime : Every "
  out_time ${SLEEP_SECONDS}
  echo -en "\n"
}

function do_sleep() {
    local seconds=${1:-5}

    echo -en "\n(sleeping for "
    out_time ${seconds}
    echo -en ")\n"
    sleep ${seconds}
}

function do_speedtest_loop()
{
    local dl_results=()
    local up_results=()
    local pg_results=()
    local dl_total=0
    local up_total=0
    local pg_total=0
    local dl_average=0
    local up_average=0
    local pg_average=0
    local dl_last=0
    local up_last=0
    local pg_last=0

    clear

    while true
    do
        dl_total=0
        up_total=0
        pg_total=0

        echo -en "\n---\n\nRunning speed test at \"$(date +"%H:%M:%S")\" on \"$(date +"%A, %B %d %Y")\"...\n\n" | tee -a /tmp/speedtest-cli.log

        speedtest-cli --simple                                      | tee -a /tmp/speedtest-cli.log &> /dev/null

        dl_last="$(cat /tmp/speedtest-cli.log | tail -n2 | head -n 1 | grep -oP '[0-9]+\.[0-9]+\s+[a-zA-Z/]+')"
        up_last="$(cat /tmp/speedtest-cli.log | tail -n1 | head -n 1 | grep -oP '[0-9]+\.[0-9]+\s+[a-zA-Z/]+')"
        pg_last="$(cat /tmp/speedtest-cli.log | tail -n3 | head -n 1 | grep -oP '[0-9]+\.[0-9]+\s[a-z]+')"
        dl_results+=("${dl_last}")
        up_results+=("${up_last}")
        pg_results+=("${pg_last}")

        for result in "${dl_results[@]}"
        do
            dl_last_int=$(echo ${result} | grep -oP '[0-9]+\.[0-9]+')
            dl_total=$(echo "scale=2; ${dl_total} + ${dl_last_int}" | bc)
            dl_average=$(echo "scale=2; ${dl_total} / ${#dl_results[@]}" | bc)
        done

        for result in "${up_results[@]}"
        do
            up_last_int=$(echo ${result} | grep -oP '[0-9]+\.[0-9]+')
            up_total=$(echo "scale=2; ${up_total} + ${up_last_int}" | bc)
            up_average=$(echo "scale=2; ${up_total} / ${#up_results[@]}" | bc)
        done

        for result in "${pg_results[@]}"
        do
            pg_last_int=$(echo ${result} | grep -oP '[0-9]+\.[0-9]+')
            pg_total=$(echo "scale=2; ${pg_total} + ${pg_last_int}" | bc)
            pg_average=$(echo "scale=2; ${pg_total} / ${#pg_results[@]}" | bc)
        done

        echo -en "[ LATEST SPEED  ]"
        echo -en " Download: $(printf '%.2f' $(echo ${dl_last} | grep -oP '[0-9]+\.[0-9]+')) $(echo ${dl_last} | grep -oP '[a-zA-Z/]+'),"
        echo -en " Upload: $(printf '%.2f' $(echo ${up_last} | grep -oP '[0-9]+\.[0-9]+')) $(echo ${up_last} | grep -oP '[a-zA-Z/]+'),"
        echo -en " Ping: $(printf '%.2f' $(echo ${pg_last} | grep -oP '[0-9]+\.[0-9]+')) $(echo ${pg_last} | grep -oP '[a-zA-Z/]+')\n"
        echo -en "[ AVERAGE SPEED ]"
        echo -en " Download: $(printf '%.2f' ${dl_average}) $(echo ${dl_last} | grep -oP '[a-zA-Z/]+'),"
        echo -en " Upload: $(printf '%.2f' ${up_average}) $(echo ${up_last} | grep -oP '[a-zA-Z/]+'),"
        echo -en " Ping: $(printf '%.2f' ${pg_average}) $(echo ${pg_last} | grep -oP '[a-zA-Z/]+')\n"

      do_sleep ${SLEEP_SECONDS}
    done
}

out_about
out_config
do_sleep 5
do_speedtest_loop
w
