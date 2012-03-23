f g:bebop_disabled == 1
    finish
endif

function! BebopComplete(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start >= 0 && line[start - 1] =~ '\k'
            let start -= 1
        endwhile
        return start
    else
        py vim.command('return ' + bebop.coffee.complete(vim.eval('a:base')))
    endif
endfunction

au FileType coffee setlocal omnifunc=BebopComplete
au FileType coffee command! -nargs=* BebopEval     py bebop.coffee.eval(<f-args>)
au FileType coffee command! -nargs=0 BebopEvalLine   py bebop.coffee.eval_line()
au FileType coffee command! -nargs=0 BebopEvalBuffer py bebop.coffee.eval_buffer()
au FileType coffee nnoremap <leader>ee :BebopEval<space>
au FileType coffee nnoremap <leader>eb :BebopEvalBuffer<cr>
au FileType coffee nnoremap <leader>el :BebopEvalLine<cr>
au FileType coffee vnoremap <leader>er :py bebop.coffee.eval_range()<cr>
