let g:twiddle_case_state = -1
let g:twiddle_case_offset = 1
function! TwiddleCaseInit(str)
  let g:twiddle_case_string = a:str
  "echo 'init done, press alt+` in normal to change the case'
  let @" = TwiddleCase("repeat")
endfunction
vnoremap <a-`> y:call TwiddleCaseInit(@")<cr>gv""p

"With the following (for example, in vimrc), you can visually select text then press ~ to convert the text to  UPPER CASE, then to lower case, then to Title Case. Keep pressing ~ until you get the case you want.
function! TwiddleCase(mode)
  let str = g:twiddle_case_string
  if a:mode ==# "forward" 
    let g:twiddle_case_offset = 1
  elseif a:mode ==# "repeat"
    let g:twiddle_case_offset = 0
  elseif  a:mode ==# "backward" 
    let g:twiddle_case_offset = -1
  endif
  let g:twiddle_case_state += g:twiddle_case_offset

  let upper = toupper(str)
  let lower = tolower(str)
  set noignorecase
  let splitted_lower = tolower(substitute(str,'[a-z]\@<=\([A-Z]\)',' \1','g'))
  let title = substitute(splitted_lower,'[-_]',' ','g')
  let title = substitute(title,'\(\<\w\+\>\)', '\u\1', 'g')
  let hyphen = substitute(splitted_lower,'[ _]', '-', 'g')
  let snake = substitute(hyphen,'-', '_', 'g')
  let camel = substitute(title,' ','','g')
  let camel = substitute(camel,'\(\<\w\+\>\)', '\l\1', 'g')
  let lower_no_space = tolower( substitute(str,'\([A-Z]\)', ' \1', 'g') )
  set ignorecase

  if g:twiddle_case_state == 0
    echo "upper case"
    let result = toupper(str)
  elseif g:twiddle_case_state == 1
    echo "lower case"
    let result = tolower(str)
  elseif g:twiddle_case_state == 2
    echo "title case"
    let result = title
  elseif g:twiddle_case_state == 3
    echo "hyphen case"
    let result = hyphen
  elseif g:twiddle_case_state == 4
    echo "snake case"
    let result = snake
  elseif g:twiddle_case_state == 5
    echo "camel case"
    let result = camel
  else
    echo "reset case"
    let result = str
    if a:mode ==# 'forward'
      let g:twiddle_case_state = -1
    else
      let g:twiddle_case_state = 6
    endif
  endif
  return result
endfunction

nnoremap <a-`> gvy:call setreg('', TwiddleCase("forward"), getregtype(''))<CR>gv""P
nnoremap <a-~> gvy:call setreg('', TwiddleCase("backward"), getregtype(''))<CR>gv""P
