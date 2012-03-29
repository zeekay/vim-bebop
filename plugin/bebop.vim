if !exists("g:bebop_loaded")
    let g:bebop_loaded = 1
else
    finish
endif

if !exists("g:bebop_enabled")
    let g:bebop_enabled = 1
endif

if !exists('g:bebop_host')
   let g:bebop_host = '127.0.0.1'
endif

if !exists('g:bebop_port')
   let g:bebop_port = 1985
endif

if !exists('g:bebop_auto_connect')
   let g:bebop_auto_connect = 1
endif

if !exists('g:bebop_enable_js')
   let g:bebop_enable_js = 1
endif

if !exists('g:bebop_enable_coffee')
   let g:bebop_enable_coffee = 1
endif

if !exists('g:bebop_complete_js')
   let g:bebop_complete_js = 1
endif

if !exists('g:bebop_complete_coffee')
   let g:bebop_complete_coffee = 1
endif

if !exists('g:bebop_preview_window')
   let g:bebop_preview_window = 1
endif

if !exists('g:bebop_preview_location')
   let g:bebop_preview_location = 'botright 10'
endif

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
endf

func! bebop#DisableCompletion()
    au FileType javascript,coffee setlocal omnifunc=javascriptcomplete#CompleteJS
    setlocal omnifunc=javascriptcomplete#CompleteJS
endf

python <<EOF
import sys
import vim
# add vimbop to syspath
sys.path.append(vim.eval("expand('<sfile>:p:h')")  + '/lib/')

import vimbop
import vimbop.js
import vimbop.coffee
EOF

command! -nargs=0 BebopConnect      py vimbop.connect(host=vim.eval('g:bebop_host'), port=int(vim.eval('g:bebop_port')))
command! -nargs=0 BebopList         py vimbop.list_websocket_clients()
command! -nargs=1 BebopSwitch       py vimbop.set_active_client(<f-args>)
command! -bang -nargs=* BebopReload py vimbop.reload("<bang>", <f-args>)
command! -nargs=0 BebopBroadcast    py vimbop.toggle_broadcast()

if eval('g:bebop_auto_connect')
    BebopConnect
endif
