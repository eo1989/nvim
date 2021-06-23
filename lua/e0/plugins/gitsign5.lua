-- vim.cmd "packadd gitsigns.nvim"
-- require('gitsigns').setup {
--  signs = {
--    add = {hl = 'GreenSign', text = '│', numhl = 'GitSignsAddNr'},
--     change = {hl = 'BlueSign', text = '│', numhl = 'GitSignsChangeNr'},
--     delete = {hl = 'RedSign', text = '│', numhl = 'GitSignsDeleteNr'},
--     topdelete = {hl = 'RedSign', text = '│', numhl = 'GitSignsDeleteNr'},
--     changedelete = {hl = 'PurpleSign', text = '│', numhl = 'GitSignsChangeNr'}
--   }
-- }
return function()
  local gitsigns = require "gitsigns"

  require("which-key").register({
    ["<leader>h"] = {
      name = "+gitsigns hunk",
      s = "stage",
      u = "undo stage",
      r = "reset hunk",
      p = "preview current hunk",
      b = "blame current line"
    },
    ["<localleader>g"] = {
      name = "+git",
      w = { "<cmd>Gitsigns stage_buffer<CR>", "gitsigns: stage entire buffer" },
      r = {
        name = "+reset",
        e = { "<cmd>Gitsigns reset_buffer<CR>", "gitsigns: reset entire buffer" }
      },
      b = {
        name = "+blame",
        l = "gitsigns: blame current line",
      },
    },
    ["[h"] = "go to next git hunk",
    ["]h"] = "go to previous git hunk",
  }
)

  gitsigns.setup {
    debug_mode = false,
    signs = {
      add = {hl = "GitGutterAdd", text = "▌"},
      change = {hl = "GitGutterChange", text = "▌"},
      delete = {hl = "GitGutterDelete", text = "▌"},
      topdelete = {hl = "GitGutterDelete", text = "▌"},
      changedelete = {hl = "GitGutterChange", text = "▌"}
    },
    numhl = false,
    keymaps = {
      -- Default keymap options
      noremap = true,
      buffer = true,
      ["n [h"] = {
        expr = true,
        "&diff ? \']h\' : \'<cmd>lua require\"gitsigns\".next_hunk()<CR>\'",
      },
      ["n ]h"] = {
        expr = true,
        "&diff ? \'[h\' : \'<cmd>lua require\"gitsigns\".prev_hunk()<CR>\'",
      },
      -- Text objects
      ["o ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
      ["x ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
      ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
      ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
      ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
      ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
      ["n <localleader>gbl"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
    },
  }
end
