# -*- shell-script -*-
# alias.sh - gdb-like "alias" debugger command
#
#   Copyright (C) 2008 Rocky Bernstein rocky@gnu.org
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

_Dbg_help_add alias \
'alias NAME DEBUGGER-COMMAND	-- Make name be an alias for debugger-command.'

_Dbg_do_alias() {
  _Dbg_alias_add $1 $2
}

_Dbg_help_add unalias \
'unalias NAME	-- Remove debugger command alias NAME.'

_Dbg_do_unalias() {
  _Dbg_alias_remove $1
}