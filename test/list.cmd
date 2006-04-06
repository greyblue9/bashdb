# Test of debugger 'list' command
#
### List default location
list 
### Should list next set of lines
l
#
# Should not see anything since we ran off the top
# 
list 999
#########################################################
### 'list file:line' and canonicalization of filenames...
list ./dbg-test1.sh:1
list ../test/dbg-test1.sh:20
list dbg-test1.sh:30
list ./dbg-test1.sh:999
list ./badfile:1
#########################################################
### list of functions...
list fn1
list bogus
#########################################################
### Testing window command..."
window 
###  Testing '.'
l . 
# 
# Should see lines up to current execution line.
###  Trying '-'...
-
###  Testing set/show listsize
show listsize
###  Setting listsize to 3...
set listsize 3
l 10
###  Window command...
w
p "- command..."
-
###  Setting listsize to 4...
set listsize 4
show listsize
l 10
###  Window command...
w
###  '-' command...
-
#<-This comment doesn't have a space after 
#the initial `#'
quit
