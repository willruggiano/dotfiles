if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.ipp,*.tpp setfiletype cpp
augroup END

