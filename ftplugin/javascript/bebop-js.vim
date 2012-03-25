if eval('g:bebop_enable_js')
    function! BebopJsComplete(findstart, base)
        if a:findstart
            let line = getline('.')
            let start = col('.') - 1
            while start >= 0 && line[start - 1] =~ '\k'
                let start -= 1
            endwhile
            return start
        else
            py vim.command('return ' + vimbop.js.complete(vim.eval('a:base')))
        endif
    endfunction

    function! s:BebopJsCmdComplete(arglead, line, pos)
        py vim.command('return ' + vimbop.js.complete(vim.eval('a:line')[11:], True))
    endfunction

    command! -nargs=* -complete=customlist,s:BebopJsCmdComplete BebopJsEval py vimbop.js.eval(<f-args>)
    command! -nargs=0 BebopJsEvalBuffer py vimbop.js.eval_buffer()
    command! -nargs=0 BebopJsEvalLine   py vimbop.js.eval_line()
    nnoremap <leader>eb :BebopJsEvalBuffer<cr>
    nnoremap <leader>ee :BebopJsEval<space>
    nnoremap <leader>el :BebopJsEvalLine<cr>
    vnoremap <leader>er :py vimbop.js.eval_range()<cr>
endif
