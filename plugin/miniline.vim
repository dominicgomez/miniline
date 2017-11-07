" if exists('g:loaded_miniline')
"     finish
" endif
" let g:loaded_miniline = 1

function! s:Interpolate(items, sep)
endfunction

function! s:GetModeOutput()
    return s:miniline_mode_output[mode(1)]
endfunction

function! GetFlagOutput(flag)
    return s:miniline_flag_output[a:flag][eval('&' . a:flag)]
endfunction

let s:user_statusline = &statusline

let s:miniline_exclude_filetypes = get(g:, 'miniline_exclude_filetypes', [])
let s:miniline_include_filetypes = get(g:, 'miniline_include_filetypes', [])

let s:miniline_mode_output = {
    \ 'n': 'NORMAL',
    \ 'no': 'NORMAL',
    \ 'v': 'VISUAL',
    \ 'V': 'VISUAL',
    \ '': 'VISUAL',
    \ 's': 'SELECT',
    \ 'S': 'SELECT',
    \ '': 'SELECT',
    \ 'i': 'INSERT',
    \ 'ic': 'INSERT',
    \ 'ix': 'INSERT',
    \ 'R': 'REPLACE',
    \ 'Rc': 'REPLACE',
    \ 'Rv': 'REPLACE',
    \ 'Rx': 'REPLACE',
    \ 'c': 'COMMAND',
    \ 'cv': 'EX',
    \ 'ce': 'EX',
    \ 'r': 'PROMPT',
    \ 'rm': 'PROMPT',
    \ 'r?': 'CONFIRM',
    \ '!': 'EXTERNAL COMMAND',
    \ 't': 'TERMINAL JOB'
    \ }

if exists('g:miniline_mode_output')
    call extend(s:miniline_mode_output, g:miniline_mode_output, 'force')
endif

let s:miniline_flag_output = {
    \ 'modified': ['', '[+]'],
    \ 'paste': ['', '[PASTE]'],
    \ 'previewwindow': ['', '[PREVIEW]'],
    \ 'readonly': ['', '[RO]'],
    \ 'spell': ['', '[SPELL]']
    \ }

if exists('g:miniline_flag_output')
    call extend(s:miniline_flag_output, g:miniline_flag_output, 'force')
endif

let s:miniline_left_separator = get(g:, 'miniline_left_separator', '|')
let s:miniline_left_format = get(g:, 'miniline_left_format',
    \ [
    \ '{mode}',
    \ '{filename}',
    \ '{readonly_flag}',
    \ '{modified_flag}',
    \ '{spell_flag}',
    \ '{paste_flag}'
    \ ])

let s:miniline_right_separator = get(g:, 'miniline_right_separator', '|')
let s:miniline_right_format = get(g:, 'miniline_right_format',
    \ [
    \ '{filetype}',
    \ '{file_encoding}',
    \ '{file_format}',
    \ '{cur_line}:{cur_col}',
    \ '{total_lines}',
    \ ])

let s:miniline_left =
    \ s:Interpolate(s:miniline_left_format, s:miniline_left_separator)
let s:miniline_right =
    \ s:Interpolate(s:miniline_right_format, s:miniline_right_separator)

let s:miniline = s:miniline_left . '%=' . s:miniline_right

" This matches anything (even nothing) between curly braces:
" {.\{-}}

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

" if !exists(':MinilineEnable')
"     command MinilineEnable call s:MinilineSetState(2)
" endif
" if !exists(':MinilineConditionallyEnable')
"     command MinilineConditionallyEnable call s:MinilineSetState(1)
" endif
" if !exists(':MinilineDisable')
"     command MinilineDisable call s:MinilineSetState(0)
" endif
