if g:bebop_disabled == 1
    finish
endif

function! BebopJsComplete(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start >= 0 && line[start - 1] =~ '\k'
            let start -= 1
        endwhile
        return start
    else
        py vim.command('return ' + bebop.js.complete(vim.eval('a:base')))
    endif
endfunction

au FileType javascript setlocal omnifunc=BebopJsComplete
au FileType javascript command! -nargs=0 BebopJsEvalBuffer py bebop.js.eval_buffer()
au FileType javascript command! -nargs=* BebopJsEval     py bebop.js.eval_code(<f-args>)
au FileType javascript command! -nargs=0 BebopJsEvalLine   py bebop.js.eval_line()
au FileType javascript nnoremap <leader>eb :BebopJsEvalBuffer<cr>
au FileType javascript nnoremap <leader>ee :BebopJsEval<space>
au FileType javascript nnoremap <leader>el :BebopJsEvalLine<cr>
au FileType javascript vnoremap <leader>er :py bebop.js.eval_range()<cr>
