" Prevent this script from being run more than once.
" if exists('g:loaded_miniline')
"     finish
" endif
" let g:loaded_miniline = 1

" Before changing anything, save the current value of 'statusline' in case
" miniline is disabled.
let s:_statusline = &statusline

let s:miniline_statusline = ''

" =============================================================================
" OPTION DEFAULTS:
" =============================================================================

" --------------------------------
" Included And Excluded Filetypes:
" --------------------------------

let s:miniline_excl_filetypes_def = []
let s:miniline_incl_filetypes_def = []

" ------------------------
" Individual Item Formats:
" ------------------------

" Mode
let s:miniline_mode_fmt_def = {
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

" Cursor information
let s:miniline_cur_line_fmt_def = '{cur_line}'
let s:miniline_cur_col_fmt_def = '{cur_col}'
let s:miniline_perc_in_file_fmt_def = '--{perc}%--'

" File information
let s:miniline_buffer_num_fmt_def = '{buffer_num}'
let s:miniline_filename_fmt_def = '{abs_path}{tail}'
let s:miniline_filetype_fmt_def = '[{filetype}]'
let s:miniline_file_encoding_fmt_def = '[{file_encoding}]'
let s:miniline_file_format_fmt_def = '[{file_format}]'
let s:miniline_total_lines_fmt_def = '{total_lines}'

" Flags
let s:miniline_help_buffer_flag_def = ['[HELP]', '']
let s:miniline_modified_flag_fmt_def = ['[+]', '']
let s:miniline_paste_flag_fmt_def = ['[PASTE]', '']
let s:miniline_preview_window_flag_def = ['[PREVIEW]', '']
let s:miniline_readonly_flag_fmt_def = ['[RO]', '']
let s:miniline_spell_flag_fmt_def = ['[SPELL]', '']

" ------------------
" Statusline Format:
" ------------------

" Left
let s:miniline_left_separator_def = '|'
let s:miniline_left_fmt_def = [
    \ '{mode}',
    \ '{file}',
    \ '{readonly_flag}',
    \ '{modified_flag}',
    \ '{spell_flag}',
    \ '{paste_flag}'
    \ ]

" Right
let s:miniline_right_separator_def = '|'
let s:miniline_right_fmt_def = [
    \ '{filetype}',
    \ '{file_encoding}',
    \ '{file_format}',
    \ '{cur_line}:{cur_col}',
    \ '{total_lines}'
    \ ]

" =============================================================================
" OPTION ASSIGNMENT:
" =============================================================================

" --------------------------------
" Included And Excluded Filetypes:
" --------------------------------

let s:miniline_excl_filetypes =
    \ get(g:, 'miniline_excl_filetypes', s:miniline_excl_filetypes_def)
let s:miniline_incl_filetypes =
    \ get(g:, 'miniline_incl_filetypes', s:miniline_incl_filetypes_def)

" ------------------------
" Individual Item Formats:
" ------------------------

" Mode
" The user may only reassign to some keys, so merge the default items with the
" user's items.
let s:miniline_mode_fmt = s:miniline_mode_fmt_def
if exists('g:miniline_mode_fmt')
endif

" Cursor information
let s:miniline_cur_line_fmt =
    \ get(g:, 'miniline_cur_line_fmt', s:miniline_cur_line_fmt_def)
let s:miniline_cur_col_fmt =
    \ get(g:, 'miniline_cur_col_fmt', s:miniline_cur_col_fmt_def)
let s:miniline_perc_in_file_fmt =
    \ get(g:, 'miniline_perc_in_file_fmt', s:miniline_perc_in_file_fmt_def)

" File information
let s:miniline_buffer_num_fmt =
    \ get(g:, 'miniline_buffer_num_fmt', s:miniline_buffer_num_fmt_def)
let s:miniline_filename_fmt =
    \ get(g:, 'miniline_filename_fmt', s:miniline_filename_fmt_def)
let s:miniline_filetype_fmt =
    \ get(g:, 'miniline_filetype_fmt', s:miniline_filetype_fmt_def)

" Flags


" let s:miniline_file_encoding_fmt_def = '[{file_encoding}]'
" let s:miniline_file_format_fmt_def = '[{file_format}]'
" let s:miniline_total_lines_fmt_def = '{total_lines}'

" " Flags
" let s:miniline_help_buffer_flag_def = ['[HELP]', '']
" let s:miniline_modified_flag_fmt_def = ['[+]', '']
" let s:miniline_paste_flag_fmt_def = ['[PASTE]', '']
" let s:miniline_preview_window_flag_def = ['[PREVIEW]', '']
" let s:miniline_readonly_flag_fmt_def = ['[RO]', '']
" let s:miniline_spell_flag_fmt_def = ['[SPELL]', '']

" ------------------
" Statusline Format:
" ------------------

" Left
let s:miniline_left_separator =
    \ get(g:, 'miniline_left_sep', s:miniline_left_separator_def)
let s:miniline_left_fmt =
    \ get(g:, 'miniline_left_fmt', s:miniline_left_fmt_def)

" Right
let s:miniline_right_sep =
    \ get(g:, 'miniline_right_separator', s:miniline_right_separator_def)
let s:miniline_right_fmt =
    \ get(g:, 'miniline_right_fmt', s:miniline_right_fmt_def)

" =============================================================================
" FUNCTIONS:
" =============================================================================

function! s:GetMode()
    let l:full_mode = mode(1)
    if has_key(g:miniline_mode_fmt, l:full_mode)
        return g:miniline_mode_fmt[l:full_mode]
    else
        echoerr 'ERROR: Mode (' . l:full_mode . ') not recognized.'
    endif
endfunction

" function! s:GetPasteStatus()
"     return (&paste ? 'PASTE' : '')
" endfunction

" function! s:GetSpellStatus()
"     return (&spell ? 'SPELL' : '')
" endfunction

" function! s:Interpolate(miniline_item)
"     if a:miniline_item ==? 'filename'
"         return '%F'
"     elseif a:miniline_item ==? 'filetype'
"         return '%y'
"     elseif a:miniline_item ==? 'mode'
"         return s:GetMode()
"     elseif a:miniline_item ==? 'modified_flag'
"         return '%m'
"     elseif a:miniline_item ==? 'paste_flag'
"         return s:GetPasteStatus()
"     elseif a:miniline_item ==? 'readonly_flag'
"         return '%r'
"     elseif a:miniline_item ==? 'spell_flag'
"         return s:GetSpellStatus()
"     endif
" endfunction

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
