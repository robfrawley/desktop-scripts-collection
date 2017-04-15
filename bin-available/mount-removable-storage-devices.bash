#!/bin/bash

#
# configuration variables
#
FILEPATH_BRIGHT_LIB="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../lib/bright-library/bright.bash"
FILEPATH_MOUNT_CONF="${HOME}/.removable-storage-device-mounts"

# home directory path environment variable required
if [[ -z ${HOME} ]]; then
  echo "Required environment variable missing: \$HOME"
  exit 1
fi

# ensure required bright library exists
if [[ ! -f "${FILEPATH_BRIGHT_LIB}" ]]; then
  echo "Required dependency missing: ${FILEPATH_BRIGHT_LIB}"
  exit 1
fi

# ensure required mount configuration file exists
if [[ ! -f "${FILEPATH_MOUNT_CONF}" ]]; then
  echo "Required mount configuration file missing: ${FILEPATH_MOUNT_CONF}"
  exit 1
fi

# source bright library
source "${FILEPATH_BRIGHT_LIB}"

#
# output newline character
#
function out_newline() {
  echo -en "\n"
}

#
#output space character
#
function out_space() {
  echo -en " "
}

#
# output error message
#
function out_error() {
  local error="${1:-An undefined error occurred!}"

  bright_out_builder " ERROR " "color:white" "color_bg:red" "control:style bold"
  bright_out_builder " ${error}...\n" "color:white"
}

#
# output command header
#
function out_header() {
  local header="${1}"

  bright_out_builder " -- ${header^^} -- \n" "color:magenta" "control:style bold" "control:style reverse"
}

#
# output command status
#
function out_status() {
  local index="${1}"
  local value="${2}"
  local color_fb="${3}"
  local color_bg="${4}"
  local style_bold="${5:-0}"

  out_section_beg "${index}"
  if [[ ${style_bold} -eq 0 ]]; then
    bright_out_builder " ${value} " "color:${color_fb}" "control:style reverse" "color_bg:${color_bg}" "control:style bold"
  else
    bright_out_builder " ${value} " "color:${color_fb}" "control:style reverse" "color_bg:${color_bg}"
  fi

  out_section_end
}

#
# output command status okay
#
function out_status_okay() {
  out_status "${1}" "${2:-okay}" green black
}

#
# output command status warn
#
function out_status_warn() {
  out_status "${1}" "${2:-warn}" red white
}

#
# output command status skip
#
function out_status_skip() {
  out_status "${1}" "${2:-skip}" blue black 1
}

#
# output whole section
#
function out_section() {
  local section="${1}"
  local value="${2}"
  local style="${3:-none}"

  out_section_beg "${section}"
  out_section_val "${value}" "white" "${style}"
  out_section_end
}

#
# output section name and beginning delimiter
#
function out_section_beg() {
  local section="${1}"

  bright_out_builder "${section}=[" "color:white" "control:style bright"
}

#
# output section contents
#
function out_section_val() {
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
# output the basic mount information from the global array
#
function out_mount_info() {
  out_section "uuid" "${mount_info[uuid]}"
  out_section "path" "${mount_info[path]}" bold
  out_section "type" "${mount_info[type]}"
  out_section "opts" "${mount_info[opts]}"
}

#
# output section ending delimiter
#
function out_section_end() {
  bright_out_builder "] " "color:white" "control:style bright"
}

#
# output configuration index and value
#
function out_config() {
  local index="${1}"
  local value="${2}"

  out_section_beg "${index}"
  out_section_val "${value}"
  out_section_end
  out_newline
}

#
# output usage parameter and description
#
function out_usage_parameter() {
  local parameter="${1}"
  local description="${2}"

  printf "\t%-7s %s" ${parameter}
  out_space
  bright_out_builder "${description}" "control:style bright"
  out_newline
}

#
# output usage command information
#
function out_usage_command() {
  bright_out_builder "Usage:\n\t./${0##*/}" "control:style bold"

  for parameter in ${@}; do
    bright_out_builder " [${parameter}]" "control:style bold" "control:style bright"
  done

  out_newline
  out_newline
}

#
# require elevated privileges or display error
#
function req_root() {
  if [[ $EUID -ne 0 ]]; then
    out_error "This action must be run with elevated privileges. Perhaps you should use \"sudo\"?"
    exit 1
  fi
}

#
# get mount paths
#
function get_mounts() {
    echo "$(cat ${FILEPATH_MOUNT_CONF})"
}

#
# get the mount info for the provided path
#
function get_mount_info() {
  local path="${1}"
  declare -Ag mount_info=([path]="" [info]="" [uuid]="" [opts]="" [type]="")

  mount_info[path]="${path}"
  mount_info[info]="$(mount | grep ${mount_info[path]})"
  mount_info[uuid]="$(cat /etc/fstab | grep ${mount_info[path]} | grep -oP 'UUID=[a-z0-9-]+' | cut -c 6-)"
  mount_info[opts]="$(cat /etc/fstab | grep ${mount_info[path]} | grep -oP 'defaults[^\s]+')"
  mount_info[type]="$(cat /etc/fstab | grep ${mount_info[path]} | grep -oP "${mount_info[path]}\s+[^\s]+" | grep -oP '\s[^\s]+' | cut -c 2-)"
  mount_info[stat]=1

  if [[ ${mount_info[info]} ]]; then
    mount_info[stat]=0
  fi
}

#
# ensure some (at least one) mount(s) exist
#
function run_ensure_mounts() {
  if [[ ! $(get_mounts) ]]; then
    out_error "No mounts definied in your configuration file (${FILEPATH_MOUNT_CONF})"
    exit 2
  fi
}

#
# output mount status on single path
#
function run_status_on() {
  get_mount_info "${1}"

  if [[ ${mount_info[stat]} -eq 1 ]]; then
    out_status_warn status down
  else
    out_status_okay status
  fi

  out_mount_info
  out_newline
}

#
# unmount single path
#
function run_unmount_on() {
  get_mount_info "${1}"

  if [[ ${mount_info[stat]} -eq 0 ]]; then
    umount ${mount_info[path]} &> /dev/null
    if [[ $? -ne 0 ]] || [[ $(mount | grep ${mount_info[path]}) ]]; then
      out_status_warn unmount
    else
      out_status_okay unmount
    fi
  else
    out_status_skip unmount
  fi

  out_mount_info
  out_newline
}

#
# mount single path
#
function run_mount_on() {
  get_mount_info "${1}"

  if [[ ${mount_info[stat]} -eq 1 ]]; then
    mount ${mount_info[path]} &> /dev/null
    if [[ $? -eq 0 ]] || [[ $(mount | grep ${mount_path}) ]]; then
      out_status_okay mount
    else
      out_status_warn mount
    fi
  else
    out_status_skip mount
  fi

  out_mount_info
  out_newline
}

#
# output command usage information
#
function run_action_usage() {
  out_usage_command "c|config" "s|status" "m|mount|on|up" "u|umount|off|dn"

  out_usage_parameter "status"  "Display the status and configuration of defined mount points"
  out_usage_parameter "mount"   "Mount all configured mount paths (skipping those already mounted)"
  out_usage_parameter "unmount" "Unmount all configured mount paths (if possible and not in use)"
  out_usage_parameter "config"  "Display the active configuration information (mounts, paths, etc)"
}

#
# run show mount status on all paths
#
function run_action_config() {
  local i=1

  out_header "Config"
  out_config "mounts-cfg" "${FILEPATH_MOUNT_CONF}"
  out_config "bright-lib" "${FILEPATH_BRIGHT_LIB}"
  out_newline

  out_header "Mounts"
  for m in $(get_mounts); do
    out_config "mount-$(printf "%03d" ${i})" "${m}"
    i=$(($i + 1))
  done
}

#
# run show mount status on all paths
#
function run_action_status() {
  local i=1

  out_header "Status"

  for m in $(get_mounts); do
    run_status_on "${m}" "${i}"
    i=$(($i + 1))
  done
}

#
# run unmount operations on all paths
#
function run_action_unmount() {
  req_root
  out_header "Unmount"

  for m in $(get_mounts); do
    run_unmount_on "${m}"
  done
}

#
# run mount operations on all paths
#
function run_action_mount() {
  req_root
  out_header "Mount"

  for m in $(get_mounts); do
    run_mount_on "${m}"
  done
}

#
# main function
#
function main() {
  case "${1:-usage}" in
    c|config)
      run_ensure_mounts
      run_action_config
      ;;

    s|status)
      run_ensure_mounts
      run_action_status
      ;;

    m|mount|up|on)
      run_ensure_mounts
      run_action_mount
      ;;

    u|unmount|dn|off)
      run_ensure_mounts
      run_action_unmount
      ;;

    usage|*)
      run_action_usage
      ;;
  esac
}

# go!
main "${1}"