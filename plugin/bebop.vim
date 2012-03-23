if !exists("g:bebop_loaded")
    let g:bebop_loaded = 1
else
    finish
endif

if !exists('g:bebop_complete')
   let g:bebop_complete = 0
endif

if !exists('g:bebop_disabled')
   let g:bebop_disabled = 0
endif

if !exists('g:bebop_enable_javascript')
   let g:bebop_enable_javascript = 1
endif

if !exists('g:bebop_enable_coffee')
   let g:bebop_enable_coffee = 1
endif

python <<EOF
import sys
import vim

# add vimbop to syspath
sys.path.append(vim.eval("expand('<sfile>:p:h')")  + '/lib/')

try:
    import vimbop.coffee
    import vimbop.js
except ImportError:
    vim.command('let g:bebop_disabled = 1')
EOF
