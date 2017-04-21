#!/bin/bash

#
# configuration variables
#
PATH_BRIGHT_LIB="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../lib/bright-library/bright.bash"
PATH_USER_MOUNT="${HOME}/.removable-storage-device-mounts"

#
# source the bright library
#
if [[ ! -f "${PATH_BRIGHT_LIB}" ]]; then
  echo "Unable to source required \"bright library\" dependency at \"${PATH_BRIGHT_LIB}\"."
  exit -1
else
  source "${PATH_BRIGHT_LIB}"
fi

#
# setup global-scope variable containing active mount info
#
declare -Ag mount_data=(["path"]="" ["uuid"]="" ["opts"]="" ["type"]="")

#
# write out space character
#
function write_space() {
  echo -en " "
}

#
# write out newline character
#
function write_newline() {
  echo -en "\n"
}

#
# write out error message and optionally exit
#
function write_error() {
  local returns="${1:-0}"
  local message="${2:-An undefined error occurred!}"

  bright_out_builder " ERROR " "color:white" "color_bg:red" "control:style bold"
  bright_out_builder " ${message}...\n" "color:white"

  if [[ ${returns} -ne 0 ]]; then
    exit ${returns}
  fi
}

#
# write out command header
#
function write_header() {
  local header="${1}"

  bright_out_builder " -- ${header^^} -- \n" "color:magenta" "control:style bold" "control:style reverse"
}

#
# write out command status
#
function write_status() {
  local index="${1}"
  local value="${2}"
  local color_fb="${3}"
  local color_bg="${4}"
  local style_bold="${5:-0}"

  write_section_init "${index}"

  if [[ ${style_bold} -eq 0 ]]; then
    bright_out_builder " ${value} " "color:${color_fb}" "control:style reverse" "color_bg:${color_bg}" "control:style bold"
  else
    bright_out_builder " ${value} " "color:${color_fb}" "control:style reverse" "color_bg:${color_bg}"
  fi

  write_section_stop
}

#
# write out command status okay
#
function write_status_okay() {
  write_status "${1}" "${2:-okay}" green black
}

#
# write out command status warn
#
function write_status_warn() {
  write_status "${1}" "${2:-warn}" red white
}

#
# write out command status skip
#
function write_status_skip() {
  write_status "${1}" "${2:-skip}" blue black 1
}

#
# write out whole section
#
function write_section() {
  local section="${1}"
  local value="${2}"
  local style="${3:-none}"

  write_section_init "${section}"
  write_section_data "${value}" "white" "${style}"
  write_section_stop
}

#
# write out section name and beginning delimiter
#
function write_section_init() {
  local section="${1}"

  bright_out_builder "${section}=[" "color:white" "control:style bright"
}

#
# write out section contents
#
function write_section_data() {
  local value="${1}"
  local color="${2:-white}"
  local style="${3:-none}"

  if [[ "${style}" == "none" ]]; then
    bright_out_builder "${value}" "color:${color}"
  else
    bright_out_builder "${value}" "color:${color}" "control:style ${style}"
  fi
}

#
# write out section ending delimiter
#
function write_section_stop() {
  bright_out_builder "] " "color:white" "control:style bright"
}

#
# write out definition name and value
#
function write_definition() {
  local index="${1}"
  local value="${2}"

  write_section_init "${index}"
  write_section_data "${value}"
  write_section_stop

  write_newline
}

#
# write out usage cli parameter and description
#
function write_cli_option() {
  local parameter="${1}"
  local description="${2}"

  printf "\t%-7s %s" ${parameter}
  write_space
  bright_out_builder "${description}" "control:style bright"

  write_newline
}

#
# write out usage command information
#
function write_cli_commands() {
  bright_out_builder "Usage:\n\t./${0##*/}" "control:style bold"

  for parameter in ${@}; do
    bright_out_builder " [${parameter}]" "control:style bold" "control:style bright"
  done

  write_newline
  write_newline
}

#
# write out the basic mount information from the global array
#
function write_mount_information() {
  write_section "uuid" "${mount_data["uuid"]}"
  write_section "path" "${mount_data["path"]}" bold
  write_section "type" "${mount_data["type"]}"
  write_section "opts" "${mount_data["opts"]}"
}

#
# require elevated privileges or display error
#
function is_user_root() {
  if [[ $EUID -ne 0 ]]; then
    write_error 255 "This action MUST be run with elevated privileges. Perhaps you should use \"sudo\" to do so"
  fi
}

#
# ensure mount config file is not empty
#
function is_mount_config_valid() {
  if [[ ! $(get_mount_conf) ]]; then
    write_error 200 "The user mount configuration file \"${PATH_USER_MOUNT}\" appears to be empty"
  fi
}

#
# ensure mount config file exists
#
function is_mount_config_present() {
  if [[ ! -f "${PATH_USER_MOUNT}" ]]; then
    write_error 201 "The user mount configuration file \"${PATH_USER_MOUNT}\" does not exist"
  fi
}

#
# get mount paths
#
function get_mount_conf() {
  echo "$(cat ${PATH_USER_MOUNT})"
}

#
# get the mount info for the provided path
#
function get_mount_data() {
  local path="${1}"
  declare -Ag mount_data=(["path"]="" ["uuid"]="" ["opts"]="" ["type"]="")

  mount_data["path"]="${path}"
  mount_data["uuid"]="$(get_mount_data_uuid ${path})"
  mount_data["opts"]="$(get_mount_data_opts ${path})"
  mount_data["type"]="$(get_mount_data_type ${path})"
  mount_data["stat"]=1

  if [[ $(get_mount_data_stat ${path}) ]]; then
    mount_data["stat"]=0
  fi
}

#
# helper to retrieve mount info data from path
#
function get_mount_data_stat() {
  local path="${1}"
  local work=""

  work="$(mount | grep ${path} 2>/dev/null)"

  echo "${work}"
}

#
# helper to retrieve mount uuid data from path
#
function get_mount_data_uuid() {
  local path="${1}"
  local work=""

  work="$(cat /etc/fstab | grep ${path} 2>/dev/null)"
  work="$(echo ${work} | grep -oP 'UUID=[a-z0-9-]+' 2>/dev/null)"
  work="$(echo ${work} | cut -c 6- 2>/dev/null)"

  echo "${work}"
}

#
# helper to retrieve mount options data from path
#
function get_mount_data_opts() {
  local path="${1}"
  local work=""

  work="$(cat /etc/fstab | grep ${path} 2>/dev/null)"
  work="$(echo ${work} | grep -oP 'defaults[^\s]+' 2>/dev/null)"

  echo "${work}"
}

#
# helper to retrieve mount type data from path
#
function get_mount_data_type() {
  local path="${1}"
  local work=""

  work="$(cat /etc/fstab | grep -oP "${path}\s+[^\s]+" 2>/dev/null)"
  work="$(echo ${work} | grep -oP '\s[^\s]+' 2>/dev/null)"
  work="$(echo ${work} | cut -c 1- 2>/dev/null)"

  echo "${work}"
}

#
# output mount status on single path
#
function run_status_on() {
  get_mount_data "${1}"

  if [[ ${mount_data["stat"]} -eq 1 ]]; then
    write_status_warn status down
  else
    write_status_okay status
  fi

  write_mount_information
  write_newline
}

#
# unmount single path
#
function run_dismount_on() {
  get_mount_data "${1}"

  if [[ ${mount_data["stat"]} -eq 0 ]]; then
    umount ${mount_data["path"]} &> /dev/null
    if [[ $? -ne 0 ]] || [[ $(mount | grep ${mount_data["path"]} 2>/dev/null) ]]; then
      write_status_warn unmount
    else
      write_status_okay unmount
    fi
  else
    write_status_skip unmount
  fi

  write_mount_information
  write_newline
}

#
# mount single path
#
function run_mount_on() {
  get_mount_data "${1}"

  if [[ ${mount_data["stat"]} -eq 1 ]]; then
    mount ${mount_data["path"]} &> /dev/null
    if [[ $? -eq 0 ]] || [[ $(mount | grep ${mount_data["path"]} 2> /dev/null) ]]; then
      write_status_okay mount
    else
      write_status_warn mount
    fi
  else
    write_status_skip mount
  fi

  write_mount_information
  write_newline
}

#
# output command usage information
#
function action_out_usage() {
  write_cli_commands "c|config" "s|status" "m|mount|on|up" "u|umount|off|dn"

  write_cli_option "status"  "Display the status and configuration of defined mount points"
  write_cli_option "mount"   "Mount all configured mount paths (skipping those already mounted)"
  write_cli_option "unmount" "Unmount all configured mount paths (if possible and not in use)"
  write_cli_option "config"  "Display the active configuration information (mounts, paths, etc)"
}

#
# run show mount status on all paths
#
function action_out_config() {
  local i=1

  write_header "Config"
  write_definition "mounts-cfg" "${PATH_USER_MOUNT}"
  write_definition "bright-lib" "${PATH_BRIGHT_LIB}"
  write_newline

  write_header "Mounts"
  for m in $(get_mount_conf); do
    write_definition "mount-$(printf "%03d" ${i})" "${m}"
    i=$(($i + 1))
  done
}

#
# run show mount status on all paths
#
function action_run_status() {
  local i=1

  write_header "Status"

  for m in $(get_mount_conf); do
    run_status_on "${m}" "${i}"
    i=$(($i + 1))
  done
}

#
# run dismount operations on all paths
#
function action_run_dismount() {
  is_user_root
  write_header "Unmount"

  for m in $(get_mount_conf); do
    run_dismount_on "${m}"
  done
}

#
# run mount operations on all paths
#
function action_run_mount() {
  is_user_root
  write_header "Mount"

  for m in $(get_mount_conf); do
    run_mount_on "${m}"
  done
}

#
# main function
#
function main() {
  is_mount_config_present

  case "${1:-usage}" in
    s|status)
      is_mount_config_valid
      action_run_status
      ;;

    m|mount|up|on)
      is_mount_config_valid
      action_run_mount
      ;;

    u|unmount|dn|off)
      is_mount_config_valid
      action_run_dismount
      ;;

    c|config)
      action_out_config
      ;;

    usage|*)
      action_out_usage
      ;;
  esac
}

# go!
main "${1}"
