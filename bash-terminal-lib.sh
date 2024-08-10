#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------

function __tput_support () {    # Return true if tput installed and supported
    type tput > /dev/null 2>&1
}

function __color() {
    if [ $1 = light ]; then
        local light=1; shift
    else
        local light=0
    fi

    local color="$1"; shift
    declare -A colors
    local colors=([black]=0 [red]=1 [green]=2 [yellow]=3 [blue]=4 [magenta]=5 [cyan]=6 [gray]=7 [grey]=7)

    if type tput > /dev/null 2>&1; then
        local bold="$(tput bold)"
        local reset="$(tput sgr0)"

        if tput setf 0 > /dev/null 2>&1; then
            colors=([black]=0 [blue]=1 [green]=2 [cyan]=3 [red]=4 [magenta]=5 [yellow]=6 [gray]=7 [grey]=7)
            local i=${colors[$color]:-0}
            local s=$(tput setf $i)
        else
            local i=${colors[$color]:-0}
            local s=$(tput setaf $i)
        fi
    else
        # Use ANSI colors
        local bold="\033[1m"
        local reset="\033[0m$gray"

        local s="\033[3${i}m"
    fi
    echo -n "$reset"
    (( light )) && echo -n "$bold"
    echo "$s"
}

function term () {
    local action="$1"; shift


    case "$action" in
        info)
            echo TERM is \"$TERM\"
            __tput_support && echo tput supported || echo tput NOT supported

            ;;
        setcolor)
            __color "$@"
            ;;
        setbgcolor)
            echo NOT IMPLEMENTED >&2
            return 1
            ;;
        resetattributes)
            echo NOT IMPLEMENTED >&2
            return 1
            ;;
        setbold)
            echo NOT IMPLEMENTED >&2
            return 1
           ;;
    esac
}

