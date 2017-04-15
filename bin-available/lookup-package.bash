#!/bin/bash

function getWork()
{
	local file="${1}"
	local work="$(grep -P 'dev-master"' ${file} | grep -P -o '"[0-9]\.[0-9]\-dev"'), name: $(grep -P '^  "name"' $file | grep -P -o '"src-run/[^"]+"')"

	echo "${work}"
}

function main()
{
	local path="${1}"
	local work=""

	for file in `ls ${path}`
	do
		work="$(getWork ${file})"
		echo "version: ${work}";
	done
}

main "${1}"
