" if exists('g:loaded_miniline')
"     finish
" endif
" let g:loaded_miniline = 1

function! s:ProcessFormatStringList(fmt_strs, sep)
    let l:str = ''
    for l:fmt_str in a:fmt_strs
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

" ONLY USE SINGLE QUOTES HERE.
" Using double quotes will mess up the assignment to 'statusline' since it's
" wrapped in double quotes.
function! s:ReplaceFormatPlaceholder(fmt_p)
    " 'paste_flag'
    " 'previewwindow_flag'
    " 'readonly_flag'
    " 'spell_flag'
    if a:fmt_p == 'absolute_path'
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
        return '%{&filetype}'
    elseif a:fmt_p == 'file_encoding'
        return '%{&fileencoding}'
    elseif a:fmt_p == 'file_format'
        return '%{&fileformat}'
    elseif a:fmt_p == 'mode'
        return '%{g:miniline_mode_output[mode(1)]}'
    elseif a:fmt_p == 'modified_flag'
        return '%{g:miniline_flag_output[''modified_flag''][&modified]}'
    elseif a:fmt_p == 'paste_flag'
        return '%{g:miniline_flag_output[''paste_flag''][&paste]}'
    elseif a:fmt_p == 'percent_through_file'
        let g:pct = 'string(round(((line(''.'') * 1.0) / line(''$'')) * 100))'
        let l:fmt = '[:stridx(eval(g:pct), ''.'')-1]'
        return '%{' . g:pct . l:fmt . '}'
    elseif a:fmt_p == 'previewwindow_flag'
        return '%{g:miniline_flag_output' .
             \ '[''previewwindow_flag''][&previewwindow]}'
    elseif a:fmt_p == 'readonly_flag'
        return '%{g:miniline_flag_output[''readonly_flag''][&readonly]}'
    elseif a:fmt_p == 'relative_path'
        return '%f'
    elseif a:fmt_p == 'spell_flag'
        return '%{g:miniline_flag_output[''spell_flag''][&spell]}'
    elseif a:fmt_p == 'total_lines'
        return '%L'
    elseif a:fmt_p == 'virtual_col'
        return '%v'
    else
        echo 'ERROR'
        return ''
    endif
endfunction

" The global version of this dictionary is used because 'statusline' accesses
" it to display the appropriate string for the current mode, which changes
" during runtime.
let s:_miniline_mode_output = {
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
    call extend(g:miniline_mode_output, s:_miniline_mode_output, 'keep')
else
    let g:miniline_mode_output = s:_miniline_mode_output
endif

let s:_miniline_flag_output = {
    \ 'modified_flag': ['', '[+]'],
    \ 'paste_flag': ['', '[PASTE]'],
    \ 'previewwindow_flag': ['', '[PREVIEW]'],
    \ 'readonly_flag': ['', '[RO]'],
    \ 'spell_flag': ['', '[SPELL]']
    \ }
if exists('g:miniline_flag_output')
    call extend(g:miniline_flag_output, s:_miniline_flag_output, 'keep')
else
    let g:miniline_flag_output = s:_miniline_flag_output
endif

let s:user_statusline = &statusline

let s:miniline_exclude_filetypes = get(g:, 'miniline_exclude_filetypes', [])
let s:miniline_include_filetypes = get(g:, 'miniline_include_filetypes', [])

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
    \ '{percent_through_file}'
    \ ])

let s:miniline_left =
    \ s:ProcessFormatStringList(s:miniline_left_format,
    \                           s:miniline_left_separator)
let s:miniline_right =
    \ s:ProcessFormatStringList(s:miniline_right_format,
    \                           s:miniline_right_separator)

let s:miniline = s:miniline_left . '%=' . s:miniline_right

execute 'let &statusline = "' . s:miniline . '"'
