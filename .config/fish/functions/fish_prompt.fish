function __get_prompt
  switch $fish_bind_mode
    case default
      set_color red
      echo -n '❰❰ '
    case insert
      set_color magenta
      echo -n '❱❱ '
    case replace_one
      set_color magenta
      echo -n '❱❱ '
    case visual
      set_color --bold brmagenta
      echo -n '❱❱ '
    case '*'
      set_color normal
      echo -n '? '
  end
  set_color normal
end

function fish_prompt
    if test $status -eq 0
        set errored (set_color normal)
    else
        set errored (set_color $fish_color_error)
    end

    set -g c0 (set_color blue)
    set -g c1 (set_color magenta)
    set -g c2 (set_color yellow)
    set -g c3 (set_color green)
    set -g c4 (set_color red)
    set -g c5 (set_color brblack)
    set -g c6 (set_color normal)

    set -l path (string replace $HOME '~' (pwd))
    set -l last_command (history | head -1)
    
    printf '%s%s%s ' $c3 $path $c0

    printf '\n'
    if test (id -u) -eq 0
        printf '%s⚡ ' $c2
    end
    printf '%s' $errored
    __get_prompt
    printf $c6
end
