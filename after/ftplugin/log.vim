" wrapping is expensive dont do it for huge log files
if line2byte(line("$") + 1) > 300000
  setlocal nowrap
  syntax clear
else
  setlocal wrap
endif

setlocal foldmethod=manual
setlocal colorcolumn=
setlocal nolist
setlocal nonu nornu
setlocal signcolumn=yes:2
