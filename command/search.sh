# search.sh - Some search commands
#
#   Copyright (C) 2009, 2010 Rocky Bernstein
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
# /search/
_Dbg_do_search_back() {
  typeset delim_search_pat=$1
  if [[ -z "$1" ]] ; then
    _Dbg_msg "Need a search pattern"
    return 1
  fi
  shift

  case "$delim_search_pat" in
    [?] )
      ;;
    [?]* )
      typeset -a word
      word=($(_Dbg_split '?' $delim_search_pat))
      _Dbg_last_search_pat=${word[0]}
      ;;
    # Error
    * )
      _Dbg_last_search_pat=$delim_search_pat
  esac
  typeset -i i
  for (( i=_Dbg_listline-1; i > 0 ; i-- )) ; do
    typeset source_line
    _Dbg_get_source_line $i "$_Dbg_frame_last_filename"
    eval "$_seteglob"
    if [[ $source_line == *$_Dbg_last_search_pat* ]] ; then
      eval "$_resteglob"
      _Dbg_do_list $i 1
      _Dbg_listline=$i
      return 0
    fi
    eval "$_resteglob"
  done
  _Dbg_msg "search pattern: $_Dbg_last_search_pat not found."
  return 1

}

_Dbg_help_add '/' \
'/search/ -- Search forward and list line of a script.'

# /search/
_Dbg_do_search() {
  typeset delim_search_pat=${1}
  if [[ -z "$1" ]] ; then
    _Dbg_msg "Need a search pattern"
    return 1
  fi
  shift
  typeset search_pat
  case "$delim_search_pat" in
    / )
      ;;
    /* )
      typeset -a word
      word=($(_Dbg_split '/' $delim_search_pat))
      _Dbg_last_search_pat=${word[0]}
      ;;
    * )
      _Dbg_last_search_pat=$delim_search_pat
  esac

  typeset max_line
  max_line=$(_Dbg_get_maxline "$_Dbg_frame_last_filename")

  typeset -i i
  for (( i=_Dbg_listline+1; i < max_line ; i++ )) ; do
    typeset source_line
    _Dbg_get_source_line $i "$_Dbg_frame_last_filename"
    eval "$_seteglob"
    if [[ $source_line == *$_Dbg_last_search_pat* ]] ; then
      eval "$_resteglob"
      _Dbg_do_list $i 1
      _Dbg_listline=$i
      return 0
    fi
    eval "$_resteglob"
  done
  _Dbg_msg "search pattern: $_Dbg_last_search_pat not found."
  return 1

}
