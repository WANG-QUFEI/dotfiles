if status is-login
    fish_ssh_agent
    set -x GTK_IM_MODULE fcitx
    set -x QT_IM_MODULE fcitx
    set -x XMODIFIERS '@im=fcitx'

    if test -z $WAYLAND_DISPLAY && test $XDG_VTNR -eq 1
        exec sway
    end
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
