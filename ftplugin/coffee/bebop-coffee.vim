if !eval('g:bebop_enabled') || !eval('g:bebop_enable_coffee')
    finish
endif

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
    py vim.command('return ' + vimbop.Coffee.complete(vim.eval('a:line')[12:], '', vim.eval('a:pos'), cmdline=True))
endfunction

" It is insufficient to use function! to define our operator function as it
" may already be referenced by operatorfunc and vim doesn't allow redefining
" the function in that case.
if !exists('*BebopCoffeeOperator')
    function! BebopCoffeeOperator(type, ...)
        if a:0
            " Invoked from Visual mode, use '< and '> marks.
            silent exe "silent normal! `<" . a:type . "`>y"
        elseif a:type ==# 'char'
            silent exe "normal! `[v`]y"
        elseif a:type ==# 'line'
            silent exe "normal! '[V']y"
        elseif a:type ==# 'block'
            silent exe "normal! `[\<C-V>`]y"
        else
            return
        endif
        py vimbop.Coffee.eval(vim.eval('@@'))
    endfunction
endif

command! -nargs=* -complete=customlist,s:BebopCoffeeCmdComplete BebopCoffeeEval py vimbop.Coffee.eval(<f-args>)
command! -nargs=0 BebopCoffeeEvalBuffer py vimbop.Coffee.eval_buffer()
command! -nargs=0 BebopCoffeeEvalLine   py vimbop.Coffee.eval_line()

" Mappings
nnoremap <buffer> <leader>e  :set operatorfunc=BebopCoffeeOperator<cr>g@
vnoremap <buffer> <leader>e  :py vimbop.Coffee.eval_range()<cr>
nnoremap <buffer> <leader>ee :BebopCoffeeEval<space>
nnoremap <buffer> <leader>eb :BebopCoffeeEvalBuffer<cr>
nnoremap <buffer> <leader>el :BebopCoffeeEvalLine<cr>
