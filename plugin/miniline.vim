" if exists('g:loaded_miniline')
"     finish
" endif
" let g:loaded_miniline = 1

" 'ml_fmt_strs' is a list of miniline format strings. Returns a parallel list
" of statusline format strings.
function! s:ProcessMinilineFormatStringList(ml_fmt_strs)
    let l:stl_strs = []
    for l:ml_fmt_str in a:ml_fmt_strs
        call add(l:stl_strs, s:InterpolateMinilineFormatString(l:ml_fmt_str))
    endfor
    return l:stl_strs
endfunction

" 'ml_fmt_str' is a single miniline format string. Returns the equivalent
" statusline format string.
function! s:InterpolateMinilineFormatString(ml_fmt_str)
    let l:stl_str = ''
    let l:i = 0
    let l:ml_fmt_str_len = strchars(a:ml_fmt_str)
    while l:i < l:ml_fmt_str_len

        if a:ml_fmt_str[l:i] == '\'
            let l:i += 1
            if l:i >= l:ml_fmt_str_len
                echo 'ERROR'
                return ''
            endif
            let l:stl_str .= a:ml_fmt_str[l:i]
            let l:i += 1

        elseif a:ml_fmt_str[l:i] == '{'
            let l:ml_fmt_str_end = stridx(a:ml_fmt_str, '}', l:i+1)
            if l:ml_fmt_str_end == -1
                echo 'ERROR'
                return ''
            endif
            let l:stl_str .= s:ReplaceMinilineFormatPlaceholder(
                \ a:ml_fmt_str[l:i+1:l:ml_fmt_str_end-1])
            let l:i = l:ml_fmt_str_end + 1

        elseif match(a:ml_fmt_str, '\S') != -1
            let l:stl_str .= a:ml_fmt_str[l:i]
            let l:i += 1

        elseif a:ml_fmt_str[l:i] == ' '
            let l:stl_str .= '\ '
            let l:i += 1

        else
            echo 'ERROR'
            return ''
        endif
    endwhile
    return l:stl_str
endfunction

" 'ml_fmt_ph' is a miniline format placeholder without the surrounding curly
" brackets. Returns either the equivalent printf-style ('%') statusline item or
" an expression that the statusline can evaluate to yield the appropriate
" value.
function! s:ReplaceMinilineFormatPlaceholder(ml_fmt_ph)
    "
    " ONLY USE SINGLE QUOTES HERE!
    " ----------------------------
    " Using double quotes will mess up the assignment to 'statusline'.
    "
    if a:ml_fmt_ph == 'absolute_path'
        return '%F'
    elseif a:ml_fmt_ph == 'buffer_number'
        return '%n'
    elseif a:ml_fmt_ph == 'cur_col'
        return '%c'
    elseif a:ml_fmt_ph == 'cur_line'
        return '%l'
    elseif a:ml_fmt_ph == 'filename'
        return '%t'
    elseif a:ml_fmt_ph == 'filetype'
        return '%{&filetype}'
    elseif a:ml_fmt_ph == 'file_encoding'
        return '%{&fileencoding}'
    elseif a:ml_fmt_ph == 'file_format'
        return '%{&fileformat}'
    elseif a:ml_fmt_ph == 'mode'
        return '%{g:miniline_mode_output[mode(1)]}'
    elseif a:ml_fmt_ph == 'modified_flag'
        return '%{g:miniline_flag_output[''modified_flag''][&modified]}'
    elseif a:ml_fmt_ph == 'paste_flag'
        return '%{g:miniline_flag_output[''paste_flag''][&paste]}'
    elseif a:ml_fmt_ph == 'percent_through_file'
        let g:pct = 'string(round(((line(''.'') * 1.0) / line(''$'')) * 100))'
        let l:fmt = '[:stridx(eval(g:pct), ''.'')-1]'
        return '%{' . g:pct . l:fmt . '}'
    elseif a:ml_fmt_ph == 'previewwindow_flag'
        return '%{g:miniline_flag_output' .
             \ '[''previewwindow_flag''][&previewwindow]}'
    elseif a:ml_fmt_ph == 'readonly_flag'
        return '%{g:miniline_flag_output[''readonly_flag''][&readonly]}'
    elseif a:ml_fmt_ph == 'relative_path'
        return '%f'
    elseif a:ml_fmt_ph == 'spell_flag'
        return '%{g:miniline_flag_output[''spell_flag''][&spell]}'
    elseif a:ml_fmt_ph == 'total_lines'
        return '%L'
    elseif a:ml_fmt_ph == 'virtual_col'
        return '%v'
    else
        echo 'ERROR'
        return ''
    endif
endfunction

" The global version of this dictionary is used because 'statusline' accesses
" it to display the appropriate string for the current mode, which changes
" during runtime.
let s:ml_mode_output =
    \ {
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
    call extend(g:miniline_mode_output, s:ml_mode_output, 'keep')
else
    let g:miniline_mode_output = s:ml_mode_output
endif

" The global version of this dictionary is used because 'statusline' accesses
" it to display the appropriate string for the current states of these flag,
" which change during runtime.
let s:ml_flag_output =
    \ {
    \ 'modified_flag': ['', '[+]'],
    \ 'paste_flag': ['', '[PASTE]'],
    \ 'previewwindow_flag': ['', '[PREVIEW]'],
    \ 'readonly_flag': ['', '[RO]'],
    \ 'spell_flag': ['', '[SPELL]']
    \ }
if exists('g:miniline_flag_output')
    call extend(g:miniline_flag_output, s:ml_flag_output, 'keep')
else
    let g:miniline_flag_output = s:ml_flag_output
endif

" Save the user's statusline in the event that miniline is disabled.
let s:user_statusline = &statusline

let s:ml_exclude_filetypes = get(g:, 'miniline_exclude_filetypes', [])
let s:ml_include_filetypes = get(g:, 'miniline_include_filetypes', [])

let s:ml_left_separator = get(g:, 'miniline_left_separator', '|')
let s:ml_left_format = get(g:, 'miniline_left_format',
    \ [
    \ '{mode}',
    \ '{filename}',
    \ '{readonly_flag}',
    \ '{modified_flag}',
    \ '{spell_flag}',
    \ '{paste_flag}'
    \ ])

let s:ml_right_separator = get(g:, 'miniline_right_separator', '|')
let s:ml_right_format = get(g:, 'miniline_right_format',
    \ [
    \ '{filetype}',
    \ '{file_encoding}',
    \ '{file_format}',
    \ '{cur_line}:{cur_col}',
    \ '{total_lines}',
    \ '{percent_through_file}'
    \ ])

let s:ml_left = s:ProcessMinilineFormatStringList(s:ml_left_format)
echom string(s:ml_left)

let s:ml_right = s:ProcessMinilineFormatStringList(s:ml_right_format)
echom string(s:ml_right)

" let s:ml = s:ml_left . '%=' . s:ml_right

" execute 'let &statusline = "' . s:ml . '"'
