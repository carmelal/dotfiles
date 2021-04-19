" Hybrid and absolute mix when working
set nu rnu
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set nu rnu " hybrid when in normal or visual
  autocmd BufLeave,FocusLost,InsertEnter * set nornu " absolute when in insert
augroup END

let showcase=0 " showcase is off
