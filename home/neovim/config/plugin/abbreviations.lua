vim.cmd [[iabbrev <expr> NOW   strftime("%Y-%m-%d %R")]]
vim.cmd [[iabbrev <expr> TODAY strftime("%Y-%m-%d")]]
vim.cmd [[iabbrev <expr> TODO  "TODO(" . strftime("%Y-%m-%d") . "," . $USER . "):"]]
vim.cmd [[iabbrev <expr> USER  $USER]]
