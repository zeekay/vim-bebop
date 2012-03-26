if g:bebop_enable_coffee
    function! BebopCoffeeComplete(findstart, base)
        let line = getline('.')
        let start = col('.') - 1
        if a:findstart
            while start >= 0 && line[start - 1] =~ '\k'
                let start -= 1
            endwhile
            return start
        else
            py vim.command('return ' + vimbop.coffee.complete(*[vim.eval(x) for x in ('line', 'a:base', 'start')]))
        endif
    endfunction

    function! s:BebopCoffeeCmdComplete(arglead, line, pos)
        py vim.command('return ' + vimbop.js.complete(vim.eval('a:line')[12:], '', vim.eval('a:pos'), cmdline=True))
    endfunction

    command! -nargs=* -complete=customlist,s:BebopCoffeeCmdComplete BebopCoffeeEval py vimbop.coffee.eval(<f-args>)
    command! -nargs=0 BebopCoffeeEvalBuffer py vimbop.coffee.eval_buffer()
    command! -nargs=0 BebopCoffeeEvalLine   py vimbop.coffee.eval_line()
    nnoremap <buffer> <leader>ee :BebopCoffeeEval<space>
    nnoremap <buffer> <leader>eb :BebopCoffeeEvalBuffer<cr>
    nnoremap <buffer> <leader>el :BebopCoffeeEvalLine<cr>
    vnoremap <buffer> <leader>e  :py vimbop.coffee.eval_range()<cr>
endif
