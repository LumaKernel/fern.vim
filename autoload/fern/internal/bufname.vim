let s:PATTERN = '^$~.*[]\'

function! fern#internal#bufname#parse(bufname) abort
  let bufname = a:bufname[-1:] ==# '$'
        \ ? a:bufname[:-2]
        \ : a:bufname
  if bufname[:6] ==# 'fern://'
    return fern#fri#parse(bufname)
  endif
  let expr = bufname =~# '^[^\w]\+://'
        \ ? bufname
        \ : fern#scheme#file#fri#to_fri(bufname)
  let out = {
        \ 'scheme': 'fern',
        \ 'authority': '',
        \ 'path': s:escape_uri(expr),
        \ 'query': {},
        \ 'fragment': '',
        \}
  return out
endfunction

function! s:escape_uri(uri) abort
  let uri = a:uri
  " escape characters which cannot be used in Windows
  let uri = substitute(uri, escape('?', s:PATTERN), '%3F', 'g')
  let uri = substitute(uri, escape('*', s:PATTERN), '%2A', 'g')
  " escape characters which used in FRI
  let uri = substitute(uri, escape(';', s:PATTERN), '%3B', 'g')
  let uri = substitute(uri, escape('#', s:PATTERN), '%23', 'g')
  return uri
endfunction
