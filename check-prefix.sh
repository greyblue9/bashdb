#!/bin/bash
set -x
export top_srcdir="$( dirname "${BASH_SOURCE[0]}" )"
typeset -p 1>&2
export PATH="$top_srcdir:$abs_top_srcdir:$ac_abs_top_srcdir:$SRCDIR:$top_srcdir:$PATH"
if [[ $# != 2 ]]; then
    echo  >&2 "Usage $0 BASH_PROGRAM PREFIX"
    exit 3
fi
SH_PROG=$1
PREFIX=$2
typeset -i rc=0
bash_loc=$($SH_PROG -c 'echo ${SHELL}')
rc=$?
if (( rc != 0 )) ; then
    echo  >&2 "Something went wrong in getting \$SHELL for $SH_PROG"
    exit $rc
fi
if [[ -z $bash_loc ]] ; then
    echo  >&2 "Something went wrong in setting bash location from \$SHELL for $SH_PROG"
    exit 3
fi

check_loc=$(command . compute-prefix.sh $SH_PROG)
if [[ $PREFIX != $check_loc ]] ; then
    echo  >&2 "bash says prefix should be $check_loc. You gave $PREFIX"
    exit 4
fi
exit 0
