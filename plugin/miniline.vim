" if exists('g:loaded_miniline')
"     finish
" endif
" let g:loaded_miniline = 1

function! s:ProcessFormatStringList(fmt_strs, sep)
    let l:str = ''
    for l:fmt_str in a:fmt_strs
        echom s:InterpolateFormatString(l:fmt_str)
        let l:str .= s:InterpolateFormatString(l:fmt_str)
        let l:str .= a:sep
    endfor
    return l:str
endfunction

function! s:InterpolateFormatString(fmt_str)
    let l:str = ''
    let l:i = 0
    while l:i < strchars(a:fmt_str)
        if a:fmt_str[l:i] == '\'
            let l:i += 1
            if l:i >= strchars(a:fmt_str)
                echo 'ERROR'
                return ''
            endif
            let l:str .= a:fmt_str[l:i]
            let l:i += 1
        elseif a:fmt_str[l:i] == '{'
            let l:end = stridx(a:fmt_str, '}', l:i+1)
            if l:end == -1
                echo 'ERROR'
                return ''
            endif
            let l:str .= s:ReplaceFormatPlaceholder(a:fmt_str[l:i+1:l:end-1])
            let l:i = l:end + 1
        elseif a:fmt_str[l:i] == ' '
            let l:str .= '\ '
            let l:i += 1
        else
            let l:str .= a:fmt_str[l:i]
            let l:i += 1
        endif
    endwhile
    return l:str
endfunction

function! s:ReplaceFormatPlaceholder(fmt_p)
    if stridx(a:fmt_p, '_flag') != -1
        return s:GetFlagOutput(a:fmt_p)
    elseif a:fmt_p == 'absolute_path'
        return '%F'
    elseif a:fmt_p == 'buffer_number'
        return '%n'
    elseif a:fmt_p == 'cur_col'
        return '%c'
    elseif a:fmt_p == 'cur_line'
        return '%l'
    elseif a:fmt_p == 'filename'
        return '%t'
    elseif a:fmt_p == 'filetype'
        return &filetype
    elseif a:fmt_p == 'file_encoding'
        return &fileencoding
    elseif a:fmt_p == 'file_format'
        return &fileformat
    elseif a:fmt_p == 'mode'
        return s:miniline_mode_output[mode(1)]
    elseif a:fmt_p == 'percent_through_file'
        " FIXME: Output an integer (v:t_number), not a float
        return round(((line('.') * 1.0) / line('$')) * 100)
    elseif a:fmt_p == 'relative_path'
        return '%f'
    elseif a:fmt_p == 'total_lines'
        return '%L'
    elseif a:fmt_p == 'virtual_col'
        return '%v'
    else
        return 'IDK'
    endif
endfunction

function! s:GetFlagOutput(flag)
    let l:flag_prefix = a:flag[:stridx(a:flag, '_')-1]
    if !has_key(s:miniline_flag_output, a:flag)
        echo 'ERROR'
        return ''
    endif
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

" let s:miniline_left =
"     \ s:ProcessFormatStringList(s:miniline_left_format,
"     \                           s:miniline_left_separator)
" let s:miniline_right =
"     \ s:ProcessFormatStringList(s:miniline_right_format,
"     \                           s:miniline_right_separator)

" let s:miniline = s:miniline_left . '%=' . s:miniline_right

" TESTING
" echom s:ReplaceFormatPlaceholder('mode')

" echom s:ReplaceFormatPlaceholder('modified_flag')
" echom s:ReplaceFormatPlaceholder('paste_flag')
" echom s:ReplaceFormatPlaceholder('previewwindow_flag')
" echom s:ReplaceFormatPlaceholder('readonly_flag')
" echom s:ReplaceFormatPlaceholder('spell_flag')

" echom s:InterpolateFormatString('{mode}')
" echom s:InterpolateFormatString('{paste_flag}{spell_flag}')
" echom s:InterpolateFormatString('{error_flag}')
" echom s:InterpolateFormatString('{spell_flag} {paste_flag}')
" echom s:InterpolateFormatString('Dominic')
" echom s:InterpolateFormatString('Mode: {mode}')
" echom s:InterpolateFormatString('\{mode\}')
" echom s:InterpolateFormatString('\{modified_flag}')

let s:test_format_1 = ['MODE: {mode}', '{readonly_flag}', '{modified_flag}']
echom s:ProcessFormatStringList(s:test_format_1, '|')
