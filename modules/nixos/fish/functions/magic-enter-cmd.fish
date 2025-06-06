function magic-enter-cmd --description "jj > git > pwd"
  set -l cmd pwd
  if command jj root &>/dev/null
    set cmd "jj status"
  else if command git rev-parse --is-inside-work-tree &>/dev/null
    set cmd "git status -sb"
  end
  echo $cmd
end
