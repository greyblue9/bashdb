# -*- shell-script -*-
# save-restore.sh - Bourne Again Shell Debugger Utility Functions
#
#   Copyright (C) 2002, 2003, 2004, 2005, 2007, 2008 Rocky Bernstein
#   rocky@gnu.org
#
#   bashdb is free software; you can redistribute it and/or modify it under
#   the terms of the GNU General Public License as published by the Free
#   Software Foundation; either version 2, or (at your option) any later
#   version.
#
#   bashdb is distributed in the hope that it will be useful, but WITHOUT ANY
#   WARRANTY; without even the implied warranty of MERCHANTABILITY or
#   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#   for more details.
#   
#   You should have received a copy of the GNU General Public License along
#   with bashdb; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

# Does things to after on entry of after an eval to set some debugger
# internal settings  
function _Dbg_set_debugger_internal {
  IFS="$_Dbg_space_IFS";
  PS4='+ dbg (${BASH_SOURCE}:${LINENO}[$BASH_SUBSHELL]): ${FUNCNAME[0]}\n'
}

function _Dbg_restore_user_vars {
  IFS="$_Dbg_space_IFS";
  set -$_Dbg_old_set_opts
  IFS="$_Dbg_old_IFS";
  PS4="$_Dbg_old_PS4"
}

# Do things for debugger entry. Set some global debugger variables
# Remove trapping ourselves. 
# We assume that we are nested two calls deep from the point of debug
# or signal fault. If this isn't the constant 2, then consider adding
# a parameter to this routine.

function _Dbg_set_debugger_entry {

  # Nuke DEBUG trap
  trap '' DEBUG

  _cur_fn=${FUNCNAME[2]}
  let _curline=${BASH_LINENO[1]}
  ((_curline < 1)) && let _curline=1

  _Dbg_old_IFS="$IFS"
  _Dbg_old_PS4="$PS4"
  _cur_source_file=${BASH_SOURCE[2]:-$_Dbg_bogus_file}
  _Dbg_stack_pos=$_Dbg_STACK_TOP
  _Dbg_listline=_curline
  _Dbg_set_debugger_internal
  _cur_source_file="`_Dbg_resolve_expand_filename $_cur_source_file`"
  _cur_filevar="`_Dbg_file2var $_cur_source_file`"
}

function _Dbg_set_to_return_from_debugger {
  _Dbg_rc=$?

  _Dbg_currentbp=0
  _Dbg_stop_reason=''
  if (( $1 != 0 )) ; then
    _Dbg_last_bash_command="$_Dbg_bash_command"
    _Dbg_last_curline="$_curline"
    _Dbg_last_source_file="$_cur_source_file"
  else
    _Dbg_last_curline==${BASH_LINENO[1]}
    _Dbg_last_source_file=${BASH_SOURCE[2]:-$_Dbg_bogus_file}
    _Dbg_last_bash_command="**unsaved _bashdb command**"
  fi

  if (( _Dbg_restore_debug_trap )) ; then
    trap '_Dbg_debug_trap_handler 0 "$BASH_COMMAND" "$@"' DEBUG
  else
    trap - DEBUG
  fi  

  _Dbg_restore_user_vars
}