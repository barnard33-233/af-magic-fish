function _git_branch_name
    echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
    echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function _python_env_name
    if test $CONDA_DEFAULT_ENV
        set -l py_env '('$CONDA_DEFAULT_ENV')'
        echo $py_env
    else
        echo ''
    end
end

function prompt_pwd_full
    set -q fish_prompt_pwd_dir_length; or set -l fish_prompt_pwd_dir_length 1

    if [ $fish_prompt_pwd_dir_length -eq 0 ]
        set -l fish_prompt_pwd_dir_length 99999
    end

    set -l realhome ~
    echo $PWD | sed -e "s|^$realhome|~|" -e 's-\([^/.]{'"$fish_prompt_pwd_dir_length"'}\)[^/]*/-\1/-g'
end

function fish_prompt
    set -l cyan (set_color cyan)
    set -l brcyan (set_color brcyan)
    set -l brgreen (set_color brgreen)
    set -l brblack (set_color brblack)
    set -l bryellow (set_color bryellow)
    set -l normal (set_color normal)
    set -l brblue (set_color brblue)
    set -l brpurple (set_color brpurple)

    
    set -l sttysizeout (string split " " (stty size))
    set -l python_env_len (string length (_python_env_name))
    set -l separator_len (math -s0 $sttysizeout[2] - $python_env_len)
    if [ $fish_key_bindings = "fish_vi_key_bindings" ]
        set separator_len (math -s0 $separator_len - 5)
        # Minus 5 to fix the conflict with the symbol appears in the vi mode
    end

    set -l separator $brblack(_python_env_name)(string repeat -n $separator_len "-")
  
    set -l arrow $brpurple"»"
    set -l cwd $brblue(prompt_pwd_full)
    
    # git info
    if [ (_git_branch_name) ]
        set -l parenthesis_start $brblue"("
        set -l parenthesis_end $brblue")"

        set git_info $brgreen(_git_branch_name)
        set git_info "$parenthesis_start$git_info"

        if [ (_is_git_dirty) ]
            set -l dirty $bryellow"*"
            set git_info "$git_info$dirty"
        end

        set git_info "$git_info$parenthesis_end"
    end

    # print prompt
    echo -s $separator
    echo -n -s $cwd $git_info $normal ' ' $arrow ' ' $normal
end
