local autocmd = {}

function autocmd.setup()
  local definitions = {
    local fn = vim.fn
    local api = vim.api
    local fmt = string.format
    local contains = vim.tbl_contains

    e0.augroup(
      "VimrcIncSearchHighlight",
      {
        {
          -- automatically clear search highlight once leaving the commandline
          events = {"CmdlineEnter"},
          targets = {"[/\\?]"},
          command = ":set hlsearch  | redrawstatus"
        },
        {
          events = {"CmdlineLeave"},
          targets = {"[/\\?]"},
          command = ":set nohlsearch | redrawstatus"
        }
      }
    )

    local smart_close_filetypes = {
      "help",
      "git-status",
      "git-log",
      "gitcommit",
      "dbui",
      "fugitive",
      "fugitiveblame",
      "NvimTree",
      "log",
      "tsplayground",
      "qf"
    }

    local function smart_close()
      if fn.winnr("$") ~= 1 then
        api.nvim_win_close(0, true)
      end
    end

    e0.augroup(
      "SmartClose",
      {
        {
          -- Auto open grep quickfix window
          events = {"QuickFixCmdPost"},
          targets = {"*grep*"},
          command = "cwindow"
        },
        {
          -- Close certain filetypes by pressing q.
          events = {"FileType"},
          trgets = {"*"},
          command = function()
            local is_readonly =
              (vim.bo.readonly or not vim.bo.modifiable) and fn.hasmapto("q", "n") == 0

            local is_eligible =
              vim.bo.buftype ~= "" or is_readonly or vim.wo.previewwindow or
              contains(smart_close_filetypes, vim.bo.filetype)

            if is_eligible then
              e0.nnoremap("q", smart_close, {buffer = 0, nowait = true})
            end
          end
        },
        {
          -- Close quick fix window if the file containing it was closed
          events = {"BufEnter"},
          targets = {"*"},
          command = function()
            if fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then
              api.nvim_buf_delete(0, {force = true})
            end
          end
        },
        {
          -- automatically close corresponding loclist when quitting a window
          events = {"QuitPre"},
          targets = {"*"},
          modifiers = {"nested"},
          command = function()
            if vim.bo.filetype ~= "qf" then
              vim.cmd("silent! lclose")
            end
          end
        }
      }
    )


    e0.augroup(
      "ExternalCommands",
      {
        {
          -- Open images in an image viewer (probably Preview)
          events = {"BufEnter"},
          targets = {"*.png,*.jpg,*.gif"},
          command = function()
            vim.cmd(fmt('silent! "%s | :bw"', vim.g.open_command .. " " .. fn.expand("%")))
          end
        }
      }
    )

    e0.augroup(
      "CheckOutsideTime",
      {
        {
          -- automatically check for changed files outside vim
          events = {"WinEnter", "BufWinEnter", "BufWinLeave", "BufRead", "BufEnter", "FocusGained"},
          targets = {"*"},
          command = "silent! checktime"
        }
      }
    )

    --- automatically clear commandline messages after a few seconds delay
    --- source: http//unix.stackexchange.com/a/613645
    e0.augroup(
      "ClearCommandMessages",
      {
        {
          events = {"CmdlineLeave", "CmdlineChanged"},
          targets = {":"},
          command = function()
            vim.defer_fn(
              function()
                if fn.mode() == "n" then
                  vim.cmd([[echon '']])
                end
              end,
              10000
            )
          end
        }
      }
    )

    if vim.env.TMUX ~= nil then
      e0.augroup(
        "External",
        {
          {
            events = {"BufEnter"},
            targets = {"*"},
            command = function()
              vim.o.titlestring = require("e0.external").title_string()
            end
          },
          {
            events = {"VimLeavePre"},
            targets = {"*"},
            command = function()
              require("e0.external").tmux.set_statusline(true)
            end
          },
          {
            events = {"ColorScheme", "FocusGained"},
            targets = {"*"},
            command = function()
              require("e0.external").tmux.set_statusline()
            end
          }
        }
      )
    end

    e0.augroup(
      "TextYankHighlight",
      {
        {
          -- don't execute silently in case of errors
          events = {"TextYankPost"},
          targets = {"*"},
          command = function()
            require("vim.highlight").on_yank(
              {
                timeout = 200,
                on_visual = true,
                higroup = "IncSearch"
              }
            )
          end
        }
      }
    )

    local column_exclude = {"gitcommit"}
    local column_clear = {"startify", "vimwiki", "vim-plug", "help", "fugitive", "mail"}

    --- Set or unset the color column depending on the filetype of the buffer and its eligibility
    ---@param leaving boolean?
    local function check_color_column(leaving)
      if contains(column_exclude, vim.bo.filetype) then
        return
      end

      local not_eligible =
        not vim.bo.modifiable or vim.wo.pvw or not vim.bo.buflisted or vim.bo.bt ~= ""

      if contains(column_clear, vim.bo.filetype) or not_eligible then
        vim.wo.colorcolumn = ""
        return
      end
      if api.nvim_win_get_width(0) <= 120 or leaving then
        -- only reset this value when it doesn't already exist
        vim.wo.colorcolumn = ""
      elseif vim.wo.colorcolumn == "" then
        vim.cmd("setlocal colorcolumn=+1")
      end
    end

    e0.augroup(
      "CustomColorColumn",
      {
        {
          -- Update the cursor column to match current window size
          events = {"BufEnter", "VimResized", "FocusGained", "WinEnter"},
          targets = {"*"},
          command = function()
            check_color_column()
          end
        },
        {
          events = {"WinLeave"},
          targets = {"*"},
          command = function()
            check_color_column(true)
          end
        }
      }
    )
    e0.augroup(
      "UpdateVim",
      {
        -- NOTE: This takes ${VIM_STARTUP_TIME} duration to run
        --[[ autocmd BufWritePost $DOTFILES/**/nvim/configs/*.vim,$MYVIMRC ++nested
              \  luafile $MYVIMRC | redraw | silent doautocmd ColorScheme |
              \  call utils#message("sourced ".fnamemodify($MYVIMRC, ":t"), "Title") ]]
        {
          events = {"FocusLost"},
          targets = {"*"},
          command = "silent! wall"
        },
        -- Make windows equal size when vim resizes
        {
          events = {"VimResized"},
          targets = {"*"},
          command = "wincmd ="
        }
      }
    )

    e0.augroup(
      "WindowBehaviours",
      {
        {
          -- map q to close command window on quit
          events = {"CmdwinEnter"},
          targets = {"*"},
          command = "nnoremap <silent><buffer><nowait> q <C-W>c"
        },
        -- Automatically jump into the quickfix window on open
        {
          events = {"QuickFixCmdPost"},
          targets = {"[^l]*"},
          modifiers = {"nested"},
          command = "cwindow"
        },
        {
          events = {"QuickFixCmdPost"},
          targets = {"l*"},
          modifiers = {"nested"},
          command = "lwindow"
        }
      }
    )

    local function should_show_cursorline()
      return vim.bo.buftype ~= "terminal" and not vim.wo.previewwindow and vim.wo.winhighlight == "" and
        vim.bo.filetype ~= ""
    end

    e0.augroup(
      "Cursorline",
      {
        {
          events = {"BufEnter"},
          targets = {"*"},
          command = function()
            if should_show_cursorline() then
              vim.wo.cursorline = true
            end
          end
        },
        {
          events = {"BufLeave"},
          targets = {"*"},
          command = function()
            vim.wo.cursorline = false
          end
        }
      }
    )

    local save_excluded = {"lua.luapad"}
    local function can_save()
      return e0.empty(vim.bo.buftype) and not e0.empty(vim.bo.filetype) and vim.bo.modifiable and
        not vim.tbl_contains(save_excluded, vim.bo.filetype)
    end

    e0.augroup(
      "Utilities",
      {
        {
          -- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
          events = {"BufReadCmd"},
          targets = {"file:///*"},
          command = function()
            vim.cmd(fmt("bd!|edit %s", vim.uri_from_fname("<afile>")))
          end
        },
        {
          -- When editing a file, always jump to the last known cursor position.
          -- Don't do it for commit messages, when the position is invalid, or when
          -- inside an event handler (happens when dropping a file on gvim).
          events = {"BufReadPost"},
          targets = {"*"},
          command = function()
            local pos = fn.line('\'"')
            if vim.bo.ft ~= "gitcommit" and pos > 0 and pos <= fn.line("$") then
              vim.cmd('keepjumps normal g`"')
            end
          end
        },
        {events = {"FileType"}, targets = {"gitcommit", "gitrebase"}, command = "set bufhidden=delete"},
        {
          events = {"BufWritePre", "FileWritePre"},
          targets = {"*"},
          command = "silent! call mkdir(expand('<afile>:p:h'), 'p')"
        },
        {
          events = {"BufLeave"},
          targets = {"*"},
          command = function()
            if can_save() then
              vim.cmd("silent! update")
            end
          end
        },
        {
          events = {"BufWritePost"},
          targets = {"*"},
          modifiers = {"nested"},
          command = function()
            if e0.empty(vim.bo.filetype) or fn.exists("b:ftdetect") == 1 then
              vim.cmd [[
                unlet! b:ftdetect
                filetype detect
                echom 'Filetype set to ' . &ft
              ]]
            end
          end
        },
        {
          events = {"Syntax"},
          targets = {"*"},
          command = "if 5000 < line('$') | syntax sync minlines=200 | endif"
        }
      }
    );
  }

end

return autocmd
