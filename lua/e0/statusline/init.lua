--- =====================================================================
--- Resources:
--- =====================================================================
--- 1. https://gabri.me/blog/diy-vim-statusline
--- 2. https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
--- 3. https://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
--- 4. Right sided truncation - https://stackoverflow.com/a/20899652

local utils = require("e0.statusline.utils")
local H = require("e0.highlights")

local P = e0.style.palette
local M = {}

--- NOTE: Unicode characters including vim devicons should NOT be highlighted
--- as italic or bold, this is because the underlying bold font is not necessarily
--- patched with the nerd font characters
--- terminal emulators like kitty handle this by fetching nerd fonts elsewhere
--- but this is not universal across terminals so should be avoided
local function colors()
  local error_color = H.set_hl("LspDiagnosticsDefaultError", "fg")
  local info_color = H.set_hl("LspDiagnosticsDefaultInformation", "fg")
  local indicator_color = P.bright_blue
  local bg_color = H.darken_color(H.set_hl("Normal", "bg"), -16)
  local normal_fg = H.set_hl("Normal", "fg")
  local pmenu_bg = H.set_hl("Pmenu", "bg")
  local string_fg = H.set_hl("String", "fg")
  local comment_fg = H.set_hl("Comment", "fg")
  local comment_gui = H.set_hl("Comment", "gui")
  local number_fg = H.set_hl("Number", "fg")
  local warning_fg = P.light_yellow
  local identifier_fg = H.set_hl("Identifier", "fg")
  local inc_search_bg = H.set_hl("Search", "bg")

  H.all {
    {"StMetadata", {guifg = comment_fg, guibg = bg_color, gui = "italic"}},
    {"StMetadataPrefix", {guibg = bg_color, guifg = comment_fg}},
    {"StIndicator", {guibg = bg_color, guifg = indicator_color}},
    {"StModified", {guifg = string_fg, guibg = bg_color}},
    {"StGit", {guifg = P.light_red, guibg = bg_color}},
    {"StGreen", {guifg = string_fg, guibg = bg_color}},
    {"StBlue", {guifg = P.dark_blue, guibg = bg_color, gui = "bold"}},
    {"StNumber", {guifg = number_fg, guibg = bg_color}},
    {"StCount", {guifg = "bg", guibg = indicator_color, gui = "bold"}},
    {"StPrefix", {guibg = pmenu_bg, guifg = normal_fg}},
    {"StDirectory", {guibg = bg_color, guifg = "Gray", gui = "italic"}},
    {"StParentDirectory", {guibg = bg_color, guifg = string_fg, gui = "bold"}},
    {"StIdentifier", {guifg = identifier_fg, guibg = bg_color}},
    {"StTitle", {guibg = bg_color, guifg = "LightGray", gui = "bold"}},
    {"StComment", {guibg = bg_color, guifg = comment_fg, gui = comment_gui}},
    {"StInactive", {guifg = bg_color, guibg = P.comment_grey}},
    {"StatusLine", {guibg = bg_color}},
    {"StatusLineNC", {guibg = bg_color, gui = "NONE"}},
    {"StInfo", {guifg = info_color, guibg = bg_color, gui = "bold"}},
    {"StWarning", {guifg = warning_fg, guibg = bg_color}},
    {"StError", {guifg = error_color, guibg = bg_color}},
    {
      "StFilename",
      {guibg = bg_color, guifg = "LightGray", gui = "italic"}
    },
    {
      "StFilenameInactive",
      {guifg = P.comment_grey, guibg = bg_color, gui = "bold"}
    },
    {"StModeNormal", {guibg = bg_color, guifg = P.whitesmoke, gui = "bold"}},
    {"StModeInsert", {guibg = bg_color, guifg = P.dark_blue, gui = "bold"}},
    {"StModeVisual", {guibg = bg_color, guifg = P.magenta, gui = "bold"}},
    {"StModeReplace", {guibg = bg_color, guifg = P.dark_red, gui = "bold"}},
    {"StModeCommand", {guibg = bg_color, guifg = inc_search_bg, gui = "bold"}}
  }
end

--- @param tbl table
--- @param next string
--- @param priority table
local function append(tbl, next, priority)
  priority = priority or 0
  local component, length = unpack(next)
  if component and component ~= "" and next and tbl then
    table.insert(tbl, {component = component, priority = priority, length = length})
  end
end

--- @param statusline table
--- @param available_space number
local function display(statusline, available_space)
  local str = ""
  local items = utils.prioritize(statusline, available_space)
  for _, item in ipairs(items) do
    if type(item.component) == "string" then
      str = str .. item.component
    end
  end
  return str
end

---Aggregate pieces of the statusline
---@param tbl table
---@return function
local function make_status(tbl)
  return function(...)
    for i = 1, select("#", ...) do
      local item = select(i, ...)
      append(tbl, unpack(item))
    end
  end
end

local separator = {"%="}
local end_marker = {"%<"}

local item = utils.item
local item_if = utils.item_if

---A very over-engineered statusline, heavily inspired by doom-modeline
---@return string
function _G.statusline()
  -- use the statusline global variable which is set inside of statusline
  -- functions to the window for *that* statusline
  local curwin = vim.g.statusline_winid or 0
  local curbuf = vim.api.nvim_win_get_buf(curwin)

  -- TODO reduce the available space whenever we add
  -- a component so we can use it to determine what to add
  local available_space = vim.api.nvim_win_get_width(curwin)

  local ctx = {
    bufnum = curbuf,
    winid = curwin,
    bufname = vim.fn.bufname(curbuf),
    preview = vim.wo[curwin].previewwindow,
    readonly = vim.bo[curbuf].readonly,
    filetype = vim.bo[curbuf].ft,
    buftype = vim.bo[curbuf].bt,
    modified = vim.bo[curbuf].modified,
    fileformat = vim.bo[curbuf].fileformat,
    shiftwidth = vim.bo[curbuf].shiftwidth,
    expandtab = vim.bo[curbuf].expandtab
  }
  ----------------------------------------------------------------------------//
  -- Modifiers
  ----------------------------------------------------------------------------//
  local plain = utils.is_plain(ctx)
  local file_modified = utils.modified(ctx, "●")
  local inactive = vim.api.nvim_get_current_win() ~= curwin
  local focused = vim.g.vim_in_focus or true
  local minimal = plain or inactive or not focused
  ----------------------------------------------------------------------------//
  -- Setup
  ----------------------------------------------------------------------------//
  local statusline = {}
  local add = make_status(statusline)

  add(
    {item_if("▌", not minimal, "StIndicator", {before = "", after = ""}), 0},
    {utils.spacer(1), 0}
  )
  ----------------------------------------------------------------------------//
  -- Filename
  ----------------------------------------------------------------------------//
  local segments = utils.file(ctx, minimal)
  local dir, parent, file = segments.dir, segments.parent, segments.file
  local dir_item = utils.item(dir.item, dir.hl, dir.opts)
  local parent_item = utils.item(parent.item, parent.hl, parent.opts)
  local file_item = utils.item(file.item, file.hl, file.opts)
  local readonly_item = utils.item(utils.readonly(ctx), "StError")
  ----------------------------------------------------------------------------//
  -- Mode
  ----------------------------------------------------------------------------//
  -- show a minimal statusline with only the mode and file component
  ----------------------------------------------------------------------------//
  if minimal then
    add({readonly_item, 1}, {dir_item, 3}, {parent_item, 2}, {file_item, 0})
    return display(statusline, available_space)
  end
  -----------------------------------------------------------------------------//
  -- Variables
  -----------------------------------------------------------------------------//
  local status = vim.b.gitsigns_status_dict or {}
  local updates = vim.g.git_statusline_updates or {}
  local ahead = updates.ahead and tonumber(updates.ahead) or 0
  local behind = updates.behind and tonumber(updates.behind) or 0

  -- Github notifications
  local notifications = vim.g.github_notifications

  -- LSP Diagnostics
  local diagnostics = utils.diagnostic_info(ctx)
  -----------------------------------------------------------------------------//
  -- Left section
  -----------------------------------------------------------------------------//
  add(
    {item_if(file_modified, ctx.modified, "StModified"), 1},
    {readonly_item, 2},
    {item(utils.mode()), 0},
    {item(utils.search_count(), "StCount"), 1},
    {dir_item, 3},
    {parent_item, 2},
    {file_item, 0},
    -- LSP Status
    {
      item(
        utils.current_function(),
        "StMetadata",
        {before = "  ", prefix = "", prefix_color = "StIdentifier"}
      ),
      4
    },
    -- Local plugin dev indicator
    {
      item_if(
        available_space > 100 and "local dev" or "",
        vim.env.DEVELOPING ~= nil,
        "StComment",
        {prefix = "", padding = "none", before = "  ", prefix_color = "StWarning", small = 1}
      ),
      2
    },
    {separator},
    -----------------------------------------------------------------------------//
    -- Middle section
    -----------------------------------------------------------------------------//
    -- Neovim allows unlimited alignment sections so we can put things in the
    -- middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
    -----------------------------------------------------------------------------//
    -- Start of the right side layout
    {separator},
    -----------------------------------------------------------------------------//
    -- Right section
    -----------------------------------------------------------------------------//
    {item(utils.lsp_status(), "StMetadata"), 4},
    {
      item_if(
        diagnostics.error.count,
        diagnostics.error,
        "StError",
        {prefix = diagnostics.error.sign}
      ),
      1
    },
    {
      item_if(
        diagnostics.warning.count,
        diagnostics.warning,
        "StWarning",
        {prefix = diagnostics.warning.sign}
      ),
      3
    },
    {
      item_if(diagnostics.info.count, diagnostics.info, "StInfo", {prefix = diagnostics.info.sign}),
      4
    },
    {item(notifications, "StTitle", {prefix = ""}), 3},
    -- Git Status
    {item(status.head, "StBlue", {prefix = "", prefix_color = "StGit"}), 1},
    {item(status.changed, "StTitle", {prefix = "", prefix_color = "StWarning"}), 3},
    {item(status.removed, "StTitle", {prefix = "", prefix_color = "StError"}), 3},
    {item(status.added, "StTitle", {prefix = "", prefix_color = "StGreen"}), 3},
    {
      item(
        ahead,
        "StTitle",
        {prefix = "⇡", prefix_color = "StGreen", after = behind > 0 and "" or " ", before = ""}
      ),
      5
    },
    {item(behind, "StTitle", {prefix = "⇣", prefix_color = "StNumber", after = " "}), 5},
    -- Current line number/total line number,  alternatives 
    {
      utils.line_info(
        {
          prefix = "ℓ",
          prefix_color = "StMetadataPrefix",
          current_hl = "StTitle",
          total_hl = "StComment",
          sep_hl = "StComment"
        }
      ),
      7
    },
    -- (Unexpected) Indentation
    {
      item_if(
        ctx.shiftwidth,
        ctx.shiftwidth > 2 or not ctx.expandtab,
        "StTitle",
        {prefix = ctx.expandtab and "Ξ" or "⇥", prefix_color = "PmenuSbar"}
      ),
      6
    },
    {end_marker}
  )
  -- removes 5 columns to add some padding
  return display(statusline, available_space - 5)
end

local function setup_autocommands()
  e0.augroup(
    "CustomStatusline",
    {
      {events = {"FocusGained"}, targets = {"*"}, command = "let g:vim_in_focus = v:true"},
      {events = {"FocusLost"}, targets = {"*"}, command = "let g:vim_in_focus = v:false"},
      {
        events = {"VimEnter", "ColorScheme"},
        targets = {"*"},
        command = colors
      },
      {events = {"VimEnter"}, targets = {"*"}, command = utils.git_updates},
      {
        events = {"VimEnter"},
        targets = {"*"},
        command = utils.github_notifications
      },
      {
        events = {"DirChanged"},
        targets = {"*"},
        command = utils.git_update_toggle
      },
      --- NOTE: enable to update search count on cursor move
      -- {
      --   events = {"CursorMoved", "CursorMovedI"},
      --   targets = {"*"},
      --   command = utils.update_search_count
      -- },
      -- NOTE: user autocommands can't be joined into one autocommand
      {
        events = {"User AsyncGitJobComplete"},
        command = utils.git_updates_refresh
      },
      {
        events = {"User NeogitStatusRefresh"},
        command = utils.git_updates_refresh
      },
      {
        events = {"User FugitiveChanged"},
        command = utils.git_updates_refresh
      },
      {
        events = {"User FugitiveChanged"},
        command = "redrawstatus!"
      }
    }
  )
end

-- attach autocommands
setup_autocommands()

-- :h qf.vim, disable qf statusline
vim.g.qf_disable_statusline = 1

-- set the statusline
vim.o.statusline = "%!v:lua.statusline()"

return M
