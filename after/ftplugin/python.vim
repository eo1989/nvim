setl autoindent
setl cindent
setl cinwords=if,elif,else,for,while,try,except,finally,def,class,with
setl colorcolumn=80
setl copyindent
setl expandtab
setl formatoptions=jntcoql
setl nosmartindent
setl shiftwidth=4
setl smarttab
setl softtabstop=4
setl tabstop=8

python << EOF
import os
import sys
import vim
for p in sys.path:
  # add ea dir in sys.path, if it exists.
  if os.path.isdir(p):
    # Command 'set' needs backslash before ea space.
    vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF
