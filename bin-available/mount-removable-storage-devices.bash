#!/bin/bash

##
 # This file is part of the `src-run/server-scripts` project.
 #
 # (c) https://github.com/src-run/server-scripts/graphs/contributors
 #
 # For the full copyright and license information, please view the LICENSE.md
 # file that was distributed with this source code.
 ##

#
# internal variables
#
readonly _SELF_PATH="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

#
# configuration variables
#
readonly PATH_USER_MOUNT="${HOME}/.removable-storage-device-mounts"

#
# source dependencies
#
source "${_SELF_PATH}/../lib/core-library/core.bash" || exit 255

#
# setup global-scope variable containing active mount info
#
declare -Ag mount_data=(["path"]="" ["uuid"]="" ["opts"]="" ["type"]="")

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

  write_newline
  write_header "Config"
  write_definition "mounts-config" "${PATH_USER_MOUNT}"
  for dependency_name in "${!_DEPS_RESOLVED[@]}"; do
    write_definition "depend-${dependency_name}" "${_DEPS_RESOLVED[$dependency_name]}"
  done

  write_newline
  write_header "Mounts"
  for m in $(get_mount_conf); do
    write_definition "mount-dir-$(printf "%03d" ${i})" "${m}"
    i=$(($i + 1))
  done

  write_newline
}

#
# run show mount status on all paths
#
function action_run_status() {
  local i=1

  write_newline
  write_header "Status"

  for m in $(get_mount_conf); do
    run_status_on "${m}" "${i}"
    i=$(($i + 1))
  done

  write_newline
}

#
# run dismount operations on all paths
#
function action_run_dismount() {
  _user_require_root

  write_newline
  write_header "Unmount"

  for m in $(get_mount_conf); do
    run_dismount_on "${m}"
  done

  write_newline
}

#
# run mount operations on all paths
#
function action_run_mount() {
  _user_require_root

  write_newline
  write_header "Mount"

  for m in $(get_mount_conf); do
    run_mount_on "${m}"
  done

  write_newline
}

#
# main function
#
function main() {
  is_mount_config_present

  case "${1,,}" in
    s|status)
      is_mount_config_valid
      action_run_status
      ;;

    m|mount|up|on)
      is_mount_config_valid
      action_run_mount
      ;;

    u|umount|unmount|dn|off)
      is_mount_config_valid
      action_run_dismount
      ;;

    c|cfg|config)
      action_out_config
      ;;

    usage|*)
      action_out_usage
      ;;
  esac
}

# go!
main "${1}"
