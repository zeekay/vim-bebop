if !exists("g:bebop_loaded")
    let g:bebop_loaded = 1
else
    finish
endif

let s:default_opts = {
    \ 'bebop_enabled': 1,
    \ 'bebop_host': '"127.0.0.1"',
    \ 'bebop_port': 1985,
    \ 'bebop_auto_connect': 1,
    \ 'bebop_enable_js': 1,
    \ 'bebop_enable_coffee': 1,
    \ 'bebop_complete_js': 1,
    \ 'bebop_complete_coffee': 1,
    \ 'bebop_preview_window': 1,
    \ 'bebop_preview_location': '"botright 10"',
    \ 'bebop_enable_neocomplcache_patterns': 1
\ }

for kv in items(s:default_opts)
    let k = 'g:'.kv[0]
    let v = kv[1]
    if !exists(k)
        exe 'let '.k.'='.v
    endif
endfor

python <<EOF
import sys
import vim
# add vimbop to syspath
sys.path.append(vim.eval("expand('<sfile>:p:h')")  + '/lib/')

try:
    import vimbop
    import vimbop.js
    import vimbop.coffee
except ImportError:
    vim.command('let g:bebop_not_installed = 1')
EOF

if exists('g:bebop_not_installed')
    finish
endif

func! bebop#Init()
    command! -nargs=0 BebopConnect      py vimbop.connect(host=vim.eval('g:bebop_host'), port=int(vim.eval('g:bebop_port')))
    command! -nargs=0 BebopList         py vimbop.list_websocket_clients()
    command! -nargs=1 BebopSwitch       py vimbop.set_active_client(<f-args>); vimbop.list_websocket_clients()
    command! -bang -nargs=* BebopReload py vimbop.reload("<bang>", <f-args>)
    command! -nargs=0 BebopBroadcast    py vimbop.toggle_broadcast()

    nnoremap <leader>bl :BebopList<cr>
    nnoremap <leader>br :BebopReload<cr>
    nnoremap <leader>bR :BebopReload!<cr>
    nnoremap <leader>bs :BebopSwitch<space>
    nnoremap <leader>bc :BebopConnect<cr>
    BebopConnect
endf

func! bebop#Enable()
    let g:bebop_enabled = 1
    call bebop#Init()
    exe 'set ft='.&ft
endf

func! bebop#EnableCompletion()
    if eval('g:bebop_enable_js') && eval('g:bebop_complete_js')
        au FileType javascript setlocal omnifunc=BebopJsComplete
        if &filetype == "javascript"
            setlocal omnifunc=BebopJsComplete
        endif
    endif

    if eval('g:bebop_enable_coffee') && eval('g:bebop_complete_coffee')
        au FileType coffee setlocal omnifunc=BebopCoffeeComplete
        if &filetype == "coffee"
            setlocal omnifunc=BebopCoffeeComplete
        endif
    endif

    if eval('g:bebop_enable_neocomplcache_patterns') && exists('g:neocomplcache_omni_patterns')
        " let g:neocomplcache_omni_patterns.coffee = '[^. *\t]\w*\|[^. *\t]\.\%(\h\w*\)\?|[^. *\t]\w*::\%(\w*\)\?'
        let g:neocomplcache_omni_patterns.coffee = '\S*\|\S*::\S*?'
        let g:neocomplcache_omni_patterns.javascript = '[^. *\t]\w*\|[^. *\t]\.\%(\h\w*\)\?'
    endif
endf

func! bebop#DisableCompletion()
    au FileType javascript,coffee setlocal omnifunc=javascriptcomplete#CompleteJS
    setlocal omnifunc=javascriptcomplete#CompleteJS
endf

if eval('g:bebop_enabled')
    call bebop#Init()
else
    command! -nargs=0 BebopEnable call bebop#Enable()
    nnoremap <leader>be :BebopEnable<cr>
endif
