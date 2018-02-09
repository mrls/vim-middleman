" middleman.vim - A Middleman wrapper
" Maintainer:	Mauro Morales <https://mrls.xyz>
" Version: 1.0.1

if exists('g:loaded_middleman') || &cp
  finish
endif
let g:loaded_middleman = 1

function! MiddlemanDetect(...) abort
  if exists('b:middleman_root')
    return 1
  endif
  let fn = fnamemodify(a:0 ? a:1 : expand('%'), ':p')
  "fn: /home/mauro/Dropbox/src/mrls.xyz/
  "what is this pattern looking for????
  if fn =~# ':[\/]\{2\}'
    return 0
  endif
  if !isdirectory(fn)
    let fn = fnamemodify(fn, ':h')
  endif
  let file = findfile('config.rb', escape(fn, ', ').';')
  if !empty(file) && isdirectory(fnamemodify(file, ':p:h') . '/source')
    let b:middleman_root = fnamemodify(file, ':p:h')
    return 1
  endif
endfunction

if !MiddlemanDetect(getcwd())
  finish
endif

function! s:Version() abort
  let l:output = system('bundle exec middleman version')
  "let l:matches = matchlist(l:output, 'Middleman \(\d\+\)\.\(\d\+\)\.\(\d\+\)')
  let l:matches = matchlist(l:output, 'Middleman \(\d\+\.\d\+\.\d\+\)')
  if len(l:matches) > 1
    echo l:matches[1]
  else
    echo l:output
  endif
endfunction

function! s:Server() abort
  if exists('s:srv_id')
    echo 'Server already running with pid: '.s:srv_id
  else
    let s:srv_id = jobstart('bundle exec middleman server')
    echom 'Middleman server has been started'
  endif
endfunction

function! s:ServerStop() abort
  if exists('s:srv_id')
    jobstop(s:srv_id)
    echom 'Middleman server has been stopped'
  else
    echo 'Middleman server is not running'
  endif
endfunction

command! Mversion :execute  s:Version()
command! Mserver :execute s:Server()
command! MserverStop :execute s:ServerStop()

function! MiddlemanDetectBlog() abort
  let l:output = system('bundle list middleman-blog')
  if !v:shell_error
    return 1
  end
endfunction

if !MiddlemanDetectBlog()
  finish
endif

function! s:Article(str) abort
  echom 'Creating middleman article with title'
  let l:output = system('bundle exec middleman article "' . a:str . '"') let l:matches = matchlist(l:output, 'create  \(.*\.html\.markdown\)') if len(l:matches) > 1 execute 'edit' l:matches[1] else echom 'Could not open article' endif endfunction command! -nargs=+ Marticle :execute s:Article(<q-args>)
