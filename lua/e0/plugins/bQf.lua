require('bqf').setup({
    auto_enable = true,
    magic_window = true,
    auto_resize_height = true,
    preview = {
        auto_preview = true,
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 40,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'}
    },
    func_map = {
        vsplit = '',
        ptogglemode = 'z,',
        stoggleup = ''
    },
    filter = {
        fzf = {
            action_for = {
              ['ctrl-t'] = {enable = 'tabedit'},
              ['ctrl-v'] = {enable = 'vsplit'},
              ['ctrl-x'] = {enable = 'split'},
              ['ctrl-q'] = {enable = 'signtoggle'}
            },
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
        }
    }
})
