" middleman.vim - A Middleman wrapper
" Maintainer:	Mauro Morales <https://mrls.xyz>
" Version: 1.0

if exists('g:loaded_middleman') || &cp
  finish
endif
let g:loaded_middleman = 1

command! -nargs=+ Marticle :execute s:Article(<q-args>)
command! Mserver :execute s:Server()
command! MserverStop :execute s:ServerStop()

function! s:Article(str) abort
  echom 'Creating middleman article with title'
  let l:output = system('bundle exec middleman article "' . a:str . '"')
  let l:matches = matchlist(l:output, 'create  \(.*\.html\.markdown\)')
  if len(l:matches) > 1
    execute 'edit' l:matches[1]
  else
    echom 'Could not open article'
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
