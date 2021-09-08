autocmd CmdlineEnter * ++once call s:wilder_init()

function! s:wilder_init() abort
    call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#cmdline_pipeline({
      \       'use_python': 0,
      \       'fuzzy': 1,
      \       'fuzzy_filter': wilder#lua_fzy_filter(),
      \     }),
      \     wilder#vim_search_pipeline(),
      \   ),
      \ ])
    call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': [
      \   wilder#lua_pcre2_highlighter(),
      \   wilder#lua_fzy_highlighter(),
      \ ],
      \ 'left': [
      \   wilder#popupmenu_devicons(),
      \ ],
      \ }))
endfunction
