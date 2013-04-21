_filedir ()
{
    local IFS='
' xspec;
    _expand || return 0;
    local toks=() tmp;
    while read -r tmp; do
        [[ -n $tmp ]] && toks[${#toks[@]}]=$tmp;
    done < <( compgen -d -- "$(quote_readline "$cur")" );
    if [[ "$1" != -d ]]; then
        xspec=${1:+"!*.$1"};
        while read -r tmp; do
            [[ -n $tmp ]] && toks[${#toks[@]}]=$tmp;
        done < <( compgen -f -X "$xspec" -- "$(quote_readline "$cur")" );
    fi;
    chs=($(chsdir "x$1" "$cur"))
    COMPREPLY=( "${COMPREPLY[@]}" "${toks[@]}" "${chs[@]}" )
}

_filedir_xspec ()
{
    local IFS cur xspec;
    IFS='
';
    COMPREPLY=();
    cur=`_get_cword`;
    _expand || return 0;
    xspec=$( sed -ne '/^complete .*[ 	]'${1##*/}'\([ 	]\|$\)/{p;q;}' 		  $BASH_COMPLETION );
    xspec=${xspec#*-X };
    xspec=${xspec%% *};
    local toks=() tmp;
    while read -r tmp; do
        [[ -n $tmp ]] && toks[${#toks[@]}]=$tmp;
    done < <( compgen -d -- "$(quote_readline "$cur")" );
    while read -r tmp; do
        [[ -n $tmp ]] && toks[${#toks[@]}]=$tmp;
    done < <( eval compgen -f -X $xspec -- "\$(quote_readline "\$cur")" );
    chs=($(chsdir "x$1" "$cur"))
    COMPREPLY=( "${toks[@]}" "${chs[@]}" )
}
