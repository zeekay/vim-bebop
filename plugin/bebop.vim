if !exists("g:bebop_loaded")
    let g:bebop_loaded = 1
else
    finish
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

python <<EOF
import sys
import vim

# add vimbop to syspath
sys.path.append(vim.eval("expand('<sfile>:p:h')")  + '/lib/')

import vimbop
EOF

if eval('g:bebop_enable_js') && eval('g:bebop_complete_js')
    autocmd FileType javascript set omnifunc=BebopJsComplete
endif

if eval('g:bebop_enable_coffee') && eval('g:bebop_complete_coffee')
    autocmd FileType coffee set omnifunc=BebopCoffeeComplete
endif

command! -nargs=* BebopActive       py vimbop.active(<f-args>)
command! -nargs=0 BebopListeners    py vimbop.listeners()
command! -nargs=0 BebopSync         py vimbop.sync()
