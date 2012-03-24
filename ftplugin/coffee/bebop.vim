if g:bebop_enable_coffee
    function! BebopCoffeeComplete(findstart, base)
        if a:findstart
            let line = getline('.')
            let start = col('.') - 1
            while start >= 0 && line[start - 1] =~ '\k'
                let start -= 1
            endwhile
            return start
        else
            py vim.command('return ' + vimbop.coffee.complete(vim.eval('a:base')))
        endif
    endfunction

    command! -nargs=* BebopCoffeeEval     py vimbop.coffee.eval(<f-args>)
    command! -nargs=0 BebopCoffeeEvalLine   py vimbop.coffee.eval_line()
    command! -nargs=0 BebopCoffeeEvalBuffer py vimbop.coffee.eval_buffer()
    nnoremap <leader>ee :BebopCoffeeEval<space>
    nnoremap <leader>eb :BebopCoffeeEvalBuffer<cr>
    nnoremap <leader>el :BebopCoffeeEvalLine<cr>
    vnoremap <leader>er :py vimbop.coffee.eval_range()<cr>
endif
