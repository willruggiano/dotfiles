function until --description "Until you succeed, I say!"
  set -l i 1
  while ! $argv
    set i (math "$i + 1")
    sleep 1
  end
  if test $status -eq 0
    printf "\n$argv succeeded after $i iterations\n"
    if test -z "$SSH_CONNECTION"
      notify-send "$argv succeeded after $i iterations"
    end
  end
end
