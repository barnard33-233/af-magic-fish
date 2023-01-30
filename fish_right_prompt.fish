function fish_right_prompt 
  set_color brblack
  printf ' [%s] ' (date +%H:%M:%S)
  whoami
  printf '@'
  printf $hostname
  set_color normal
end
