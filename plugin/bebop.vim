if !exists("g:bebop_loaded")
    let g:bebop_loaded = 1
else
    finish
endif

if !exists('g:bebop_complete')
   let g:bebop_complete = 0
endif

if !exists('g:bebop_complete')
   let g:bebop_complete = 0
endif

if !exists('g:bebop_enable_javascript')
   let g:bebop_enable_javascript = 1
endif

if !exists('g:bebop_enable_coffee')
   let g:bebop_enable_coffee = 1
endif

" Try to import bebop, if it's unavailable we'll quit with an error and
" disable bebop.
python <<EOF
import vim
try:
    import bebop
except ImportError:
    vim.command('echoerr "%s"' % 'Unable to import bebop!')
    vim.command('let g:bebop_disabled = 1')
    vim.command('finish')
EOF
