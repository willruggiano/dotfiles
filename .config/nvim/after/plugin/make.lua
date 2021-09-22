vim.cmd [[
  fun! ListBuildTargets(A,L,P)
    let binary_dir = luaeval('require("make").config().binary_dir')
    return system("cmake --build " . binary_dir . " --target help | grep -v / | cut -d: -f1")
  endfun
]]

-- TODO: It would be nice to have MakeGenerate force (re)generate if <bang> is given
vim.cmd [[command! -bang MakeGenerate lua require("make").generate()]]
vim.cmd [[command! MakeToggle lua require("make").toggle()]]
vim.cmd [[command! MakeInfo lua require("make").info()]]
vim.cmd [[command! -nargs=1 MakeTarget lua require("make").compile({ build_target = <q-args> })]]
vim.cmd [[command! Make lua require("make").compile()]]
vim.cmd [[command! -nargs=1 -complete=custom,ListBuildTargets MakeTarget lua require("make").compile({ build_target = <q-args> })]]
vim.cmd [[command! Make lua require("make").compile()]]
vim.cmd [[command! MakePersistent lua require("make").compile({ open_quickfix_on_error = false })]]
vim.cmd [[command! MakeClean lua require("make").clean()]]
vim.cmd [[command! MakeStatus lua require("make").status()]]
vim.cmd [[command! -nargs=1 SetBuildType lua require("make").set_build_type(<q-args>)]]
vim.cmd [[command! -nargs=1 SetBuildTarget lua require("make").set_build_target(<q-args>)]]
vim.cmd [[command! -nargs=1 -complete=custom,ListBuildTargets SetBuildTarget lua require("make").set_build_target(<q-args>)]]
