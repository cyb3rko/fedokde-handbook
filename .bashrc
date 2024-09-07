...

alias update="sudo yt-dlp -U && sudo flatpak update -v -y && sudo dnf upgrade"
alias autoremove="sudo dnf autoremove && dnf clean all && flatpak uninstall --unused -y"
alias lsa="ls -la"
alias jump="ssh root@jump.langen.cyb3rko"
