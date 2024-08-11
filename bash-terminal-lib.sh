#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------

function __color() {
    # echo __color "$@" >&2
    local cmd="$1"; shift
    local light="$1"; shift
    local color="$1"; shift     # Ignored if cmd is not color

    declare -A colors
    local colors=([black]=0 [red]=1 [green]=2 [yellow]=3 [blue]=4 [magenta]=5 [cyan]=6 [gray]=7 [grey]=7)
    local i=${colors[$color]:-0} 2> /dev/null # Color index

    if type tput > /dev/null 2>&1; then
        [[ "$light" = true ]] && local bold="$(tput bold)"
        local reset="$(tput sgr0)"

        if tput setf 0 > /dev/null 2>&1; then
            # setf uses a distinct color order
            colors=([black]=0 [blue]=1 [green]=2 [cyan]=3 [red]=4 [magenta]=5 [yellow]=6 [gray]=7 [grey]=7)
            local i=${colors[$color]:-0} 2> /dev/null
            local s=$(tput setf $i)
        else
            local s=$(tput setaf $i)
        fi
    else
        # No tput, use ANSI colors
        [[ "$light" = true ]] && local bold="\033[1m"
        local reset="\033[0m$gray"

        local s="\033[3${i}m"
    fi

    echo -n "$reset"
    if [[ "$cmd" = color ]]; then
       [[ "$light" = true ]] && echo -n "$bold"
       echo -n "$s"
    fi
}

function bterm () {
    local action="$1"; shift
    local light=false

    if [[ "$1" = light ]]; then
        local light=true
        shift
    fi

    local color="$1"; shift

    case "$action" in
        color)
            __color color "$light" "$color"
            ;;
        reset-attr)
            __color reset false none
            return 1
            ;;
        bgcolor|bold|underline)
            echo NOT IMPLEMENTED >&2
            return 1
            ;;
        *)
            echo "bterm: Unknown command \"$action\"" >&2
            return 1
    esac
}
