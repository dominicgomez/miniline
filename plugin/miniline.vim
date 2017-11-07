" if exists('g:loaded_miniline')
"     finish
" endif
" let g:loaded_miniline = 1

function! s:ProcessFormatStringList(elems, sep)
    let l:str = ''
    for l:fmt_str in a:elems
        let l:str .= s:InterpolateFormatString(l:fmt_str)
        let l:str .= a:sep
    endfor
endfunction

function! s:InterpolateFormatString(fmt_str)
    let l:str = ''
    let l:i = 0
    while l:i < strchars(a:fmt_str)
        if a:fmt_str[l:i] == '\'
            let l:i += 1
            if l:i >= strchars(a:fmt_str)
                echoerr 'ERROR'
                finish
            endif
            let l:str .= a:fmt_str[l:i]
        elseif a:fmt_str[l:i] == '{'
            let l:end = stridx(a:fmt_str, '}', l:i+1)
            if l:end == -1
                echoerr 'ERROR'
                finish
            endif
            let l:str .= s:ReplaceFormatPlaceholder(a:fmt_str[l:i+1:l:end-1])
            let l:i = l:end + 1
        else
            let l:str .= a:fmt_str[l:i]
        endif
        let l:i += 1
    endwhile
    return l:str
endfunction

function! s:ReplaceFormatPlaceholder(fmt_p)
    if stridx(a:fmt_p, '_flag') != -1
        return s:GetFlagOutput(a:fmt_p)
    elseif a:fmt_p == 'mode'
        return s:miniline_mode_output[mode(1)]
    else
        return 'IDK'
    endif
endfunction

function! s:GetFlagOutput(flag)
    let l:flag_prefix = a:flag[:stridx(a:flag, '_')-1]
    return s:miniline_flag_output[a:flag][eval('&' . l:flag_prefix)]
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
    \ 'modified_flag': ['', '[+]'],
    \ 'paste_flag': ['', '[PASTE]'],
    \ 'previewwindow_flag': ['', '[PREVIEW]'],
    \ 'readonly_flag': ['', '[RO]'],
    \ 'spell_flag': ['', '[SPELL]']
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
    \ s:ProcessFormatStringList(s:miniline_left_format,
    \                           s:miniline_left_separator)
let s:miniline_right =
    \ s:ProcessFormatStringList(s:miniline_right_format,
    \                           s:miniline_right_separator)

let s:miniline = s:miniline_left . '%=' . s:miniline_right

" TESTING
echom s:ReplaceFormatPlaceholder('mode')

echom s:ReplaceFormatPlaceholder('modified_flag')
echom s:ReplaceFormatPlaceholder('paste_flag')
echom s:ReplaceFormatPlaceholder('previewwindow_flag')
echom s:ReplaceFormatPlaceholder('readonly_flag')
echom s:ReplaceFormatPlaceholder('spell_flag')

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
