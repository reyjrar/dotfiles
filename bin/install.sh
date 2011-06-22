#!/bin/bash

function rel2abs() {
	local relative=$1
	local cwd=$(pwd);

	cd $relative;
	absolute=$(pwd);
	cd $cwd;

	echo $absolute;
}

bindir=`dirname $0`;
basedir=`rel2abs ${bindir/bin}`;

for rc in `ls -1 $basedir`; do
	if [ -f $rc ] && [ "$rc" != "README" ]; then
		final="$HOME/.$rc";
		whereilive="$basedir/$rc";
		echo -n "setting up $final .. ";
		if [ -f $final ] || [ -L $final ]; then
			echo -n "removing current file .. ";
			rm -f $final;
		fi;
		echo -n "linking to $whereilive .. ";
		ln -s $whereilive $final;
		echo "done.";
	fi;
done;


