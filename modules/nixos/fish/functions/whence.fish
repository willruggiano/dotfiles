function whence --description "From whence ye came, little path?"
  set -l path (command -v $argv[1])
  realpath $path
end
