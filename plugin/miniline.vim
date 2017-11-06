" Prevent this script from being run more than once.
" if exists('g:loaded_miniline')
"     finish
" endif
" let g:loaded_miniline = 1

" Before changing anything, save the current value of 'statusline' in case
" miniline is disabled.
let s:user_statusline = &statusline

" =============================================================================
" Functions:
" =============================================================================

" Extract the attributes from a highlight group, and return them as a
" dictionary.
function! s:ExtractHighlightAttrs(hl_group)
    if !hlexists(a:hl_group)
        return {}
    endif

    let l:hl_args = split(execute('highlight ' . a:hl_group), '\s\+')[2:]

    if l:hl_args[0] ==? 'cleared'
        return {}
    endif

    if l:hl_args[0] ==? 'links'
        return s:ExtractHighlightAttrs(l:hl_args[2])
    endif

    let l:attrs = {}
    for l:hl_arg in l:hl_args
        let [l:key, l:val] = split(l:hl_arg, '=')
        let attrs[l:key]=l:val
    endfor

    return l:attrs
endfunction

" Generate a string of {key}={val} highlight arguments from a dictionary of
" highlight attributes.
function! s:GenerateHighlightArgs(hl_attrs)
    let l:hl_args=''
    for [l:key, l:val] in items(a:hl_attrs)
        let l:hl_args .= (l:key . '=' . l:val . ' ')
    endfor

    return l:hl_args
endfunction




let s:standard_attrs = s:ExtractHighlightAttrs('StatusLine')
let s:title_attrs = s:ExtractHighlightAttrs('Title')
let s:warning_attrs = s:ExtractHighlightAttrs('WarningMsg')
let s:error_attrs = s:ExtractHighlightAttrs('Error')


let s:standard_args = s:GenerateHighlightArgs(s:standard_attrs)
let s:title_args = s:GenerateHighlightArgs(s:title_attrs)
let s:warning_args = s:GenerateHighlightArgs(s:warning_attrs)
let s:error_args = s:GenerateHighlightArgs(s:error_attrs)


execute 'highlight MinilineStandard ' . s:standard_args
execute 'highlight MinilineTitle ' . s:title_args
execute 'highlight MinilineWarning ' . s:warning_args
execute 'highlight MinilineError ' . s:error_args




" " Enable, conditionally enable, or disable miniline.
" function! s:Miniline_setState(state)
"     let &laststatus = a:state
" endfunction

" " =============================================================================
" " Options: Global variables provided by miniline and their default values.
" " =============================================================================

" let s:plain_statusline = &statusline

" let g:miniline_custom_colors = 1

" let g:miniline_cursor_position_format = {
"     \ 'line': 'plain',
"     \ ':': 'plain',
"     \ 'column': 'plain'
"     \ }

" let g:miniline_left_format = {
"     \ 'mode': 'plain',
"     \ 'full_path': 'title',
"     \ 'modified_flag': 'warning',
"     \ 'readonly_flag': 'error',
"     \ 'spell_flag': 'reverse',
"     \ 'paste_flag': 'reverse'
"     \ }

" let g:miniline_left_separator_char = { '|': 'plain' }

" let g:miniline_right_format = {
"     \ 'filetype': 'plain',
"     \ 'file_encoding': 'plain',
"     \ 'file_format': 'plain',
"     \ 'cursor_position': 'plain',
"     \ 'total_lines': 'plain'
"     \ }

" let g:miniline_right_separator_char = { '|': 'plain' }

" " =============================================================================
" " User Commands:
" " =============================================================================

" if !exists(':MinilineEnable')
"     command MinilineEnable call s:MinilineSetState(2)
" endif
" if !exists(':MinilineConditionallyEnable')
"     command MinilineConditionallyEnable call s:MinilineSetState(1)
" endif
" if !exists(':MinilineDisable')
"     command MinilineDisable call s:MinilineSetState(0)
" endif
