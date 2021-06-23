---@diagnostic disable: unused-function, undefined-global
-- require "e0"
-- require "e0.globals"

-- local fn = vim.fn
-- local has = e0.has
-- local is_work = has "mac"
-- local is_home = not is_work
-- local fmt = string.format

local PACKER_COMPILED_PATH = vim.fn.stdpath "cache" .. "/plugin/packer_compiled.vim"

local function setup_packer()
  --- use a wildcard to match on local and upstream versions of packer
  local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/*/packer.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    print "Downloading packer.nvim..."
    print(vim.fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd "packadd! packer.nvim"
    require("packer").sync()
  -- elseif not vim.env.DEVELOPING then
  --   vim.cmd "packadd! packer.nvim"
  -- else
  --   vim.cmd "packadd! local-packer.nvim"
  end
end

-- local PACKER_COMPILED_PATH = vim.fn.stdpath "cache" .. "/plugin/packer_compiled.vim"
-- Make sure packer is installed on the current machine and load
-- the dev or upstream version depending on if we are at work or not
setup_packer()

-- cfilter plugin allows filter down an existing quickfix list
vim.cmd "packadd! cfilter"

e0.augroup("PackerSetupInit", {
    {
      events = { "BufWritePost" },
      targets = { "*/e0/plugins/*.lua" },
      command = function()
        e0.invalidate("e0.plugins", true)
        require("packer").compile()
        vim.notify "packer compiled..."
      end
    }
  }
)

e0.nnoremap("<leader>ps", [[<Cmd>PackerSync<CR>]])
e0.nnoremap("<leader>pc", [[<Cmd>PackerClean<CR>]])

---Require a plugin config
---@param name string
---@return function
local function conf(name)
  return require(string.format("e0.plugins.%s", name))
end

--[[
  NOTE "use" functions cannot call *upvalues* i.e. the functions
  passed to setup or config etc. cannot reference aliased function
  or local variables
--]]
require("packer").startup {
  function(use)
    use "wbthomason/packer.nvim"
    -- use_rocks "penlight"

    -- use {
    --   "airblade/vim-rooter",
    --   config = function()
    --     vim.g.rooter_silent_chdir = 1
    --     vim.g.rooter_resolve_links = 1
    --   end
    -- }

    use {
      "RRethy/vim-illuminate",
      setup = function()
        vim.g.Illuminate_ftblacklist = {'NvimTree'}
      end
      }

    use {
      "rmagatti/goto-preview",
      config = function()
        require("goto-preview").setup {
          default_mappings = true
        }
      end
      }

    use {
      "nvim-telescope/telescope.nvim",
      config = conf "telescop3",
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-writer.nvim",
        {"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
        {
          "nvim-telescope/telescope-frecency.nvim",
          requires = "tami5/sql.nvim",
          after = "telescope.nvim"
        }
      }
    }
    use "nvim-telescope/telescope-cheat.nvim"

    use "folke/lua-dev.nvim"
    use "nanotee/luv-vimdocs"
    use "milisims/nvim-luaref"
    use "bfredl/nvim-luadev"
    use "tjdevries/nlua.nvim"
    use "euclidianAce/BetterLua.vim"

    use "pechorin/any-jump.vim"
    use "neovimhaskell/haskell-vim"
    use "cespare/vim-toml"
    use "elzr/vim-json"
    use "JuliaEditorSupport/julia-vim"
    use "monaqa/dial.nvim"
    use "tjdevries/astronauta.nvim"

    use {
      "andymass/vim-matchup",
      setup = function()
        vim.g.matchup_matchparen_offscreen = {
          method = "popup",
          fullwidth = true,
          highlight = "Normal",
          }
      end,
      }
    -- use {
    --   "antoinemadec/FixCursorHold.nvim",
    --   config = function()
    --     vim.g.cursorhold_updatime = 1000
    --   end
    --   }

    use {
      "editorconfig/editorconfig-vim",
        config = function()
          vim.g.EditorConfig_exclude_patterns = {"fugitive://.*", "scp://.*"}
          vim.g.EditorConfig_max_line_indicator = "none"
          vim.g.EditorConfig_preserve_formatoptions = 1
        end
      }

  use {
      "neovim/nvim-lspconfig",
      config = conf "lspconfigg",
      requires = {
          "nvim-lua/lsp-status.nvim",
          config = function()
            local status = require("lsp-status")
              status.config {
                indicator_hint = "",
                indicator_info = "",
                indicator_errors = "✗",
                indicator_warnings = "",
                status_symbol = " "
              }
            status.register_progress()
          end
        }
    }
  use {
      "kosayoda/nvim-lightbulb",
        config = function()
          e0.augroup("NvimLightbulb", {
            {
              events =  {"CursorHold", "CursorHoldI"},
              targets = {"*"},
              command = function()
                require("nvim-lightbulb").update_lightbulb {
                  sign = {enabled = false},
                  virtual_text = {enabled = true}
                    }
                end,
              },
            }
          )
          end,
          }

  use {
      "glepnir/lspsaga.nvim",
        config = conf "lspsagah"
      }
  use {
      "kabouzeid/nvim-lspinstall",
        config = function()
          require("lspinstall").post_install_hook = function()
            e0.lsp.setup_servers()
            vim.cmd("bufdo e")
          end
        end
      }

    use "ray-x/lsp_signature.nvim"

    use {
      "hrsh7th/nvim-compe",
        confg = conf "comp3"
    }

    use {
      "hrsh7th/vim-vsnip",
      requires = {
        "hrsh7th/vim-vsnip-integ",
        "rafamadriz/friendly-snippets",
        "hrsh7th/nvim-compe"
      },
      config = function()
        vim.g.vsnip_snippet_dir = vim.g.vim_dir .. "/snippets/textmate"
        local opts = {expr = true}
        e0.imap("<c-l>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'", opts)
        e0.smap("<c-l>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'", opts)
        e0.imap("<c-h>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'", opts)
        e0.smap("<c-h>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'", opts)
        e0.xmap("<c-j>", [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']], opts)
        e0.imap("<c-j>", [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']], opts)
        e0.smap("<c-j>", [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']], opts)
      end
    }

    use {
      "kevinhwang91/nvim-bqf",
        config = conf "bQf"
    }

    use {
      "arecarn/vim-fold-cycle",
      config = function()
        vim.g.fold_cycle_default_mapping = 0
        e0.nmap("<BS>", "<Plug>(fold-cycle-close)")
      end
    }

    use {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup {
          close_triple_quotes = true,
          check_ts = false
          }
        end
      }

    use "psliwka/vim-smoothie"

    use {
      "itchyny/vim-highlighturl",
      config = function()
        vim.g.highlighturl_guifg = require("e0.highlights").hl_value("Keyword", "fg")
      end
    }

    -- NOTE: marks are currently broken in neovim i.e. deleted marks are resurrected on restarting nvim
    use {
      "mbbill/undotree",
      -- cmd = "UndotreeToggle",
      -- keys = "<leader>u",
      config = function()
        vim.g.undotree_TreeNodeShape = "◦" -- Alternative: '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
        require("which-key").register{
          ["<leader>u"] = {"<cmd>UndotreeToggle<CR>", "toggle undotree"}}
      end
    }
    use {
      "vim-test/vim-test",
      -- cmd = {"TestFile", "TestNearest", "TestSuite"},
      -- keys = {"<localleader>tf", "<localleader>tn", "<localleader>ts"},
      setup = function()
        vim.cmd [[
          let test#strategy = "neovim"
          let test#neovim#term_position = "vert botright"
        ]]
        require("which-key").register(
          {
            t = {
              name = "+vim-test",
              f = {"<cmd>TestFile<CR>", "test: file"},
              n = {"<cmd>TestNearest<CR>", "test: nearest"},
              s = {"<cmd>TestSuite<CR>", "test: suite"}
            }
          },
          {prefix = "<localleader>"}
        )
      end
    }

    use {"folke/which-key.nvim", config = conf "whichkey"}

    use {
      "iamcco/markdown-preview.nvim",
      run = ":call mkdp#util#install()",
      -- ft = {"markdown"},
      setup = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
      end
    }

    use {
      "junegunn/fzf",
        setup = function()
          vim.cmd(string.format("!%s/install -all", conf.install_path))
          vim.cmd(string.format("!ln -s %s ~/.fzf", conf.install_path))
        end
    }

    use "junegunn/fzf.vim"

    use {
      "norcalli/nvim-colorizer.lua",
        cmd = "ColorizerToggle",
        config = function()
          require("colorizer").setup(
          {"*"},
          {
            RGB = true,
            mode = "foreground"
          }),
        end,
      }


    use {
      "lukas-reineke/indent-blankline.nvim",
        branch = "lua",
        config = conf "indentline"
      }


    -- FIXME: If nvim-web-devicons is specified before
    -- it is used this errors that it is used twice
    use {
      "folke/trouble.nvim",
      -- keys = {"<leader>ld"},
      -- cmd = {"TroubleToggle"},
      requires = "nvim-web-devicons",
      config = function()
        require("which-key").register(
          {
            ["<leader>ld"] = {"<cmd>TroubleToggle lsp_workspace_diagnostics<CR>", "trouble: toggle"},
            ["<leader>lr"] = {"<cmd>TroubleToggle lsp_references<cr>", "trouble: lsp references"}
          }
        )
        require("e0.highlights").all {
          {"TroubleNormal", {link = "PanelBackground"}},
          {"TroubleText", {link = "PanelBackground"}},
          {"TroubleIndent", {link = "PanelVertSplit"}},
          {"TroubleFoldIcon", {guifg = "yellow", gui = "bold"}}
        }
        require("trouble").setup {auto_close = true, auto_preview = true}
      end
    }

    use {
        "folke/todo-comments.nvim",
          requires = "nvim-lua/plenary.nvim",
          setup = function()
            require("todo-comments").setup{}
          end
      }

    use {
      "kyazdani42/nvim-tree.lua",
        requires = "nvim-web-devicons",
        config =  conf "nvim-tre3"
      }
    -- use "kyazdani42/nvim-web-devicons"
    -- use {
    --   "vhyrro/neorg",
    --   opt = true,
    --   requires = {"nvim-lua/plenary.nvim"},
    --   config = function()
    --     require("neorg").setup {
    --       load = {
    --         ["core.defaults"] = {}, -- Load all the default modules
    --         ["core.norg.concealer"] = {} -- Enhances the text editing experience by using icons
    --       }
    --     }
    --   end
    -- }

   use "tpope/vim-eunuch"
   use "tpope/vim-repeat"
   use "tpope/vim-scriptease"
   use "tpope/vim-apathy"
   use {
     "tpope/vim-surround",
       config = function()
         e0.vmap("s", "<Plug>VSurround")
         e0.vmap("s", "<Plug>VSurround")
      end
      }
  use {"kassio/neoterm"}
   -- use {
   --    "tpope/vim-abolish",
   --    config = function()
   --      local opts = {silent = false}
   --      e0.nnoremap("<localleader>[", ":S/<C-R><C-W>//<LEFT>", opts)
   --      e0.nnoremap("<localleader>]", ":%S/<C-r><C-w>//c<left><left>", opts)
   --      e0.vnoremap("<localleader>[", [["zy:%S/<C-r><C-o>"//c<left><left>]], opts)
   --    end
   --  }

    -- sets searchable path for filetypes like go so 'gf' works
    -- ft = {"go", "python", "javascript", "typescript", "lua", "rust", "julia", "haskell", "cpp"}}


    use "NTBBloodbath/doom-one.vim"
    -- use "romgrk/doom-one.nvim"
    use "monsonjeremy/onedark.nvim"
    use "Th3Whit3Wolf/one-nvim"
    use "glepnir/zephyr-nvim"
    use {"ChristianChiarulli/nvcode-color-schemes.vim"}


    use {
      "nvim-treesitter/nvim-treesitter",
        config = conf "threesitter",
        run = ":TSUpdate"
      }

    use {
      "nvim-treesitter/playground",
        requires = "nvim-treesitter",
        after = "nvim-treesitter",
      -- keys = "<leader>E",
      -- cmd = {"TSPlaygroundToggle", "TSHighlightCapturesUnderCursor"},
      config = function()
        require("which-key").register {
          ["<leader>E"] = {
            "<Cmd>TSHighlightCapturesUnderCursor<CR>",
            "treesitter: highlight cursor group"
            }
          }
      end,
      }

    use {"nvim-treesitter/nvim-treesitter-textobjects", requires = "nvim-treesitter"}

    use {"p00f/nvim-ts-rainbow", requires = "nvim-treesitter"}

    use {"RRethy/nvim-treesitter-textsubjects", requires = "nvim-treesitter"}

    use {
      "junegunn/vim-easy-align",
        config = function()
          e0.nmap("ga", "<Plug>EasyAlign")
          e0.xmap("ga", "<Plug>EasyAlign")
          e0.vmap("ga", "<Plug>EasyAlign")
        end,
      }

    -- use {
    --   "lewis6991/spellsitter.nvim",
    --   config = function()
    --     require("spellsitter").setup {hl = "SpellBad", captures = {"comment"}}
    --   end
    -- }

    use "plasticboy/vim-markdown"
    use "mtdl9/vim-log-highlighting"

    use {"lewis6991/gitsigns.nvim", config = conf "gitsign5"}


    use {
      "TimUntersberger/neogit",
      -- cmd = "Neogit",
      -- keys = {"<localleader>gs", "<localleader>gl", "<localleader>gp"},
      requires = "plenary.nvim",
      config = conf "neogit"
    }

    use {
      "pwntester/octo.nvim",
      -- cmd = "Octo",
      -- keys = {"<localleader>opl"},
      config = function()
        require("octo").setup()
        require("which-key").register(
          {
            o = {name = "+octo", p = {l = {"<cmd>Octo pr list<CR>", "PR List"}}}
          },
          {prefix = "<localleader>"}
        )
      end
    }

    use {
      "chaoren/vim-wordmotion",
      config = function()
        -- Restore Vim's special case behavior with dw and cw:
        e0.nmap("dw", "de")
        e0.nmap("cw", "ce")
        e0.nmap("dW", "dE")
        e0.nmap("cW", "cE")
     end
    }

    use {
      "b3nj5m1n/kommentary",
      config = function()
        require("kommentary.config").configure_language("lua", {prefer_single_line_comments = true})
      end
    }


    use "wellle/targets.vim"

    use {
      "kana/vim-textobj-user",
      requires = {
        "kana/vim-operator-user",
        {
          "glts/vim-textobj-comment",
          config = function()
            vim.g.textobj_comment_no_default_key_mappings = 1
            e0.xmap("ax", "<Plug>(textobj-comment-a)")
            e0.omap("ax", "<Plug>(textobj-comment-a)")
            e0.xmap("ix", "<Plug>(textobj-comment-i)")
            e0.omap("ix", "<Plug>(textobj-comment-i)")
          end
        }
      }
    }

    use {
      "phaazon/hop.nvim",
      -- keys = {{"n", "s"}},
      setup = function()
        local hop = require("hop")
        -- remove h,j,k,l from hops list of keys
        hop.setup {keys = "etovxqpdygfbzcisuran"}
        e0.nnoremap("s", hop.hint_char1)
      end
    }
    use {
      "norcalli/nvim-terminal.lua",
      config = function()
        require("terminal").setup()
      end
    }

    use {"rafcamlet/nvim-luapad"}
    use {
      "akinsho/nvim-bufferline.lua",
        -- requires = "nvim-web-devicons",
        config = conf "nvim-buffline"
    }
    use {
      "akinsho/nvim-toggleterm.lua",
      config = function()
        require("toggleterm").setup {
          persist_size = false,
          open_mapping = [[<c-\>]],
          shade_filetypes = {"none"},
          direction = "horizontal",
          float_opts = {border = "curved"},
          size = function(term)
            if term.direction == "horizontal" then
              return 15
            elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
          end,
        }

        local lazygit =
          require("toggleterm.terminal").Terminal:new {
          cmd = "lazygit",
          dir = "git_dir",
          hidden = true,
          direction = "float",
          on_open = function(term)
            vim.cmd("startinsert!")
            if vim.fn.mapcheck("kj", "t") ~= "" then
              vim.api.nvim_buf_del_keymap(term.bufnr, "t", "kj")
              vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
            end
         end
        }

        local function toggle()
          lazygit:toggle()
        end,
        require("which-key").register {
          ["<leader>lg"] = {toggle, "toggleterm: toggle lazygit"}
          },
      end,
    }
  end,

  config = {
    compile_path = PACKER_COMPILED_PATH,
    display = {
      prompt_border = "rounded",
      open_cmd = "silent topleft 65vnew Packer"
    },
    profile = {
      enable = true,
      threshold = 1
    }
  }
}

e0.command {
  "PackerCompiledEdit",
  function()
    vim.cmd(string.format("edit %s", PACKER_COMPILED_PATH))
  end
}

e0.command {
  "PackerCompiledDelete",
  function()
    vim.fn.delete(PACKER_COMPILED_PATH)
    vim.notify(string.format("Deleted %s"))
  end
}

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  vim.cmd(string.format("source %s", PACKER_COMPILED_PATH))
  vim.g.packer_compiled_loaded = true
end