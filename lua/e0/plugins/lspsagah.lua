---@diagnostic disable: undefined-global
-- require "e0"
-- require "e0.globals"
return function()
  local saga = require "lspsaga"

  saga.init_lsp_saga {
    use_saga_diagnostic_sign = false,
    finder_action_keys = {
      vsplit = "v",
      split = "s",
      quit = {"q", "<ESC>"}
    },
    code_action_icon = "💡",
    code_action_prompt = {
      enable = false,
      sign = false,
      virtual_text = false
    }
  }

  require("e0.highlights").set_hl("LspSagaLightbulb", {guifg = "NONE", guibg = "NONE"})

  e0.vnoremap("<leader>ca", ":<c-u>lua require('lspsaga.codeaction').range_code_action()<CR>")
  e0.inoremap("<c-k>", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>")
  -- e0.nnoremap("<c-k>", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>")
  e0.nnoremap("K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")
  -- scroll down hover doc
  e0.nnoremap("<C-f>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>")
  -- scroll up hover doc
  e0.nnoremap("<C-b>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")

  require("which-key").register(
    {
      ["<leader>rn"] = {require("lspsaga.rename").rename, "lsp: rename"},
      ["<leader>ca"] = {require("lspsaga.codeaction").code_action, "lsp: code action"},
      ["gp"] = {require("lspsaga.provider").preview_definition, "lsp: preview definition"},
      ["gh"] = {require("lspsaga.provider").lsp_finder, "lsp: finder"},

      -- jump diagnostic
      ["[c"] = {require("lspsaga.diagnostic").lsp_jump_diagnostic_prev, "lsp: previous diagnostic"},
      ["]c"] = {require("lspsaga.diagnostic").lsp_jump_diagnostic_next, "lsp: next diagnostic"}
    }
  )

  e0.augroup(
    "LspSagaCursorCommands",
    {
      {
        events = {"CursorHold"},
        targets = {"*"},
        command = "lua require('lspsaga.diagnostic').show_cursor_diagnostics()"
      }
    }
  )
end
