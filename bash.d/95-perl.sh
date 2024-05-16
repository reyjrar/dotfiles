# Perl Brew
if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
    source ~/perl5/perlbrew/etc/bashrc
elif [ -d ~/perl5 ] && perl -Mlocal::lib &> /dev/null; then
    eval $(perl -Mlocal::lib)
fi
