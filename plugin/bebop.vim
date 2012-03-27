if !exists("g:bebop_loaded")
    let g:bebop_loaded = 1
else
    finish
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

python <<EOF
import sys
import vim
# add vimbop to syspath
sys.path.append(vim.eval("expand('<sfile>:p:h')")  + '/lib/')

import vimbop
import vimbop.js
import vimbop.coffee
EOF

if eval('g:bebop_enable_js') && eval('g:bebop_complete_js')
    au FileType javascript set omnifunc=BebopJsComplete
endif

if eval('g:bebop_enable_coffee') && eval('g:bebop_complete_coffee')
    au FileType coffee set omnifunc=BebopCoffeeComplete
endif

command! -nargs=0 BebopConnect      py vimbop.connect(host=vim.eval('g:bebop_host'), port=int(vim.eval('g:bebop_port')))
command! -nargs=0 BebopList         py vimbop.list_clients()
command! -nargs=1 BebopSwitch       py vimbop.switch(<f-args>)
command! -bang -nargs=* BebopReload py vimbop.reload("<bang>", <f-args>)
command! -nargs=0 BebopSync         py vimbop.sync()

if eval('g:bebop_auto_connect')
    BebopConnect
endif
