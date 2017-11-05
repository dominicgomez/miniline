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

let s:plain_statusline = &statusline

let g:miniline_custom_colors = 1

let g:miniline_cursor_position_format = {
    \ 'line': 'plain',
    \ ':': 'plain',
    \ 'column': 'plain'
    \ }

let g:miniline_left_format = {
    \ 'mode': 'plain',
    \ 'full_path': 'title',
    \ 'modified_flag': 'warning',
    \ 'readonly_flag': 'error',
    \ 'spell_flag': 'reverse',
    \ 'paste_flag': 'reverse'
    \ }

let g:miniline_left_separator_char = { '|': 'plain' }

let g:miniline_right_format = {
    \ 'filetype': 'plain',
    \ 'file_encoding': 'plain',
    \ 'file_format': 'plain',
    \ 'cursor_position': 'plain',
    \ 'total_lines': 'plain'
    \ }

let g:miniline_right_separator_char = { '|': 'plain' }

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
