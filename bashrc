# .bashrc
export BASHRC=1
export PATH="$HOME/bin:/usr/pgsql-9.0/bin:/opt/perl/current/bin:/opt/local/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/usr/sbin:/sbin:/usr/java/jre1.5.0/bin"

# User specific aliases and functions
alias ls='ls --time-style=long-iso -aF --color'
alias who='who -H -u -T'
alias mutt='mutt -y'
alias root='root_login';
alias screen="TERM=ansi screen"

#
# Interactive Shells only
if [ "$PS1" ]; then
	stty erase ^?
	shopt -s checkwinsize cdspell dotglob histappend nocaseglob no_empty_cmd_completion cmdhist

	export HISTCONTROL="ignoredups"
	export HISTIGNORE="&:ls:[bf]g:exit"

    if [ "$PROFILED" != "0" ]; then
        . $HOME/.bash_profile
    fi;
fi;

# Source global definitions
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# Perl Brew
if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
	 source ~/perl5/perlbrew/etc/bashrc
fi


#
# For some reason this fjorks things.
unset LS_COLORS

function root_login () 
{
	local timeout=1800;
	local keyActive=`ssh-add -l |grep 'administrator.dsa'|wc -l`;

	local adminKey="$HOME/.ssh/administrator.dsa";

	if [ -f "$adminKey" ] || [ "$keyActive" -gt "0" ]; then

		local hasAgent="$keyActive";
		if [ "$SSH_AUTH_SOCK" ] && [ -e "$SSH_AUTH_SOCK" ]; then
			hasAgent=1;
		fi;
	
		if [ "$hasAgent" -gt "0" ]; then		
	
			if [ "$keyActive" -eq "0" ]; then
				ssh-add -t $timeout $adminKey;
			fi;
	
			ssh -l root $*;
	
		else
			echo ">>> SSH Agent not running";
			ssh -i $adminKey -l root $*;
		fi;
	else
		echo ">>> Admin Key not found: ($adminKey)";
		ssh -l root $*;
	fi;
	
}
