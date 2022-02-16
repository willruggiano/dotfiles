if pcall(require, "cmp") then
  return
end

vim.cmd [[
  call wilder#setup({'modes': [':', '/', '?']})
]]
vim.cmd [[
  call wilder#set_option('pipeline', [
    \   wilder#branch(
    \     wilder#python_file_finder_pipeline({
    \       'file_command': {_, arg -> stridx(arg, '.') != -1 ? ['fd', '-tf', '-H'] : ['fd', '-tf']},
    \       'dir_command': ['fd', '-td'],
    \       'filters': ['cpsm_filter'],
    \     }),
    \     wilder#cmdline_pipeline({
    \       'use_python': 0,
    \       'fuzzy': 1,
    \       'fuzzy_filter': wilder#lua_fzy_filter(),
    \     }),
    \     wilder#vim_search_pipeline(),
    \   ),
    \ ])
]]
vim.cmd [[
  call wilder#set_option('renderer', wilder#popupmenu_renderer({
    \   'highlighter': [
    \     wilder#lua_fzy_highlighter(),
    \   ],
    \   'left': [
    \     wilder#popupmenu_devicons(),
    \   ],
    \ }))
]]
