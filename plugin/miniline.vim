" Prevent this script from being run more than once.
" if exists('g:loaded_miniline')
"     finish
" endif
" let g:loaded_miniline = 1

" Before changing anything, save the current value of 'statusline' in case
" miniline is disabled.
let s:_statusline = &statusline

let s:miniline_statusline = ''

let s:miniline_l_fmt_def = [
    \ '{mode}',
    \ '{full_path}',
    \ '{readonly_flag}',
    \ '{modified_flag}',
    \ '{spell_flag}',
    \ '{paste_flag}'
    \ ]
let s:miniline_l_sep_def = '|'
let s:miniline_r_fmt_def = [
    \ '{filetype}',
    \ '{file_encoding}',
    \ '{file_format}',
    \ '{current_line}:{current_column}',
    \ '{total_lines}'
    \ ]
let s:miniline_r_sep_def = '|'
let s:miniline_filetype_fmt_def = '[%]'

function! s:GetMode()
    let l:cur_mode = mode()
    if l:cur_mode ==? 'n'
        return 'NORMAL'
    elseif l:cur_mode ==? 'v' || l:cur_mode ==? ''
        return 'VISUAL'
    elseif l:cur_mode ==? 's' || l:cur_mode ==? ''
        return 'SELECT'
    elseif l:cur_mode ==? 'i'
        return 'INSERT'
    elseif l:cur_mode ==# 'R'
        return 'REPLACE'
    endif
endfunction

function! s:GetPasteStatus()
    return (&paste ? 'PASTE' : '')
endfunction

function! s:GetSpellStatus()
    return (&spell ? 'SPELL' : '')
endfunction

function! s:Interpolate(miniline_item)
    if a:miniline_item ==? 'filetype'
        return '%y'
    elseif a:miniline_item ==? 'full_path'
        return '%F'
    elseif a:miniline_item ==? 'mode'
        return s:GetMode()
    elseif a:miniline_item ==? 'modified_flag'
        return '%m'
    elseif a:miniline_item ==? 'paste_flag'
        return s:GetPasteStatus()
    elseif a:miniline_item ==? 'readonly_flag'
        return '%r'
    elseif a:miniline_item ==? 'spell_flag'
        return s:GetSpellStatus()
    endif
endfunction

" This matches anything (even nothing) between curly braces:
" {.\{-}}


let s:miniline_l_fmt = get(g:, 'miniline_l_fmt', s:miniline_l_fmt_def)
let s:miniline_l_sep = get(g:, 'miniline_l_sep', s:miniline_l_sep_def)
let s:miniline_r_fmt = get(g:, 'miniline_r_fmt', s:miniline_r_fmt_def)
let s:miniline_r_sep = get(g:, 'miniline_r_sep', s:miniline_r_sep_def)

" Enable, conditionally enable, or disable miniline.
" function! s:MinilineSetState(state)
"     let &laststatus = a:state
" endfunction

" Extract the attributes from a highlight group, and return them as a
" dictionary.
" function! s:ExtractHighlightAttrs(hl_group)
"     if !hlexists(a:hl_group)
"         return {}
"     endif

"     let l:hl_args = split(execute('highlight ' . a:hl_group), '\s\+')[2:]

"     if l:hl_args[0] ==? 'cleared'
"         return {}
"     endif

"     if l:hl_args[0] ==? 'links'
"         return s:ExtractHighlightAttrs(l:hl_args[2])
"     endif

"     let l:attrs = {}
"     for l:hl_arg in l:hl_args
"         let [l:key, l:val] = split(l:hl_arg, '=')
"         let attrs[l:key]=l:val
"     endfor

"     return l:attrs
" endfunction

" Generate a string of {key}={val} highlight arguments from a dictionary of
" highlight attributes.
" function! s:GenerateHighlightArgs(hl_attrs)
"     let l:hl_args=''
"     for [l:key, l:val] in items(a:hl_attrs)
"         let l:hl_args .= (l:key . '=' . l:val . ' ')
"     endfor

"     return l:hl_args
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
