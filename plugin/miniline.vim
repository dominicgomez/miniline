" =============================================================================
" Filename: plugin/miniline.vim
" Author: Dominic Gomez
" Version: 0.0
" License: MIT
" =============================================================================

" =============================================================================
" Functions:
" =============================================================================
" Enable, conditionally enable, or disable miniline.
function! s:MinilineSetState(state)
    let &laststatus = a:state
endfunction

" =============================================================================
" Options: Global variables provided by miniline and their default values.
" =============================================================================
let g:miniline_custom_colors = 1

" =============================================================================
" User Commands:
" =============================================================================
if !exists(':MinilineEnable')
    command MinilineEnable call s:MinilineSetState(2)
endif
if !exists(':MinilineConditionallyEnable')
    command MinilineConditionallyEnable call s:MinilineSetState(1)
endif
if !exists(':MinilineDisable')
    command MinilineDisable call s:MinilineSetState(0)
endif
