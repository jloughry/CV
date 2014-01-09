#!/bin/sh

#
# This is a script to fix orphaned commits accidentally done as "Joe Loughry"
# (rjl@applied-math.org) instead of "jloughry" (joe.loughry@gmail.com) back
# before I established my current GitHub account. I don't want to lose the
# history of those changes, so reset them to the correct identity so they get
# credited properly in `git blame` from now on.
#
# Modified from Chapter 6 in Scott Chacon, "Pro Git" (New York: Apress, 2009).
#

git filter-branch -f --commit-filter '
	if [ "$GIT_AUTHOR_EMAIL" = "rjl@applied-math.org" ] || [ "$GIT_AUTHOR_EMAIL" = "joe.loughry@stx.ox.ac.uk" ]
	then
		GIT_AUTHOR_NAME="jloughry"
		GIT_AUTHOR_EMAIL="joe.loughry@gmail.com"
		git commit-tree "$@"
	else
		git commit-tree "$@"
	fi' HEAD

