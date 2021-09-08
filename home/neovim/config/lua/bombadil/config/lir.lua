local icons = require "nvim-nonicons"

require("nvim-web-devicons").setup {
  lir_folder_icon = {
    icons = icons.get "file",
    color = "#7ebae4",
    name = "LirFolderNode",
  },
}

local actions = require "lir.actions"
local clipboard_actions = require "lir.clipboard.actions"
local mark_actions = require "lir.mark.actions"
local lir = require "lir"
local lir_utils = require "lir.utils"
local lvim = require "lir.vim"
local Path = require "plenary.path"

local get_context = lvim.get_context

local custom_actions = {}

custom_actions.up = function()
  local up = actions.up
  -- TODO: Handle initial ups, e.g. from dashboard or the initial buffer
  up()
end

custom_actions.new = function()
  local ctx = get_context()

  local name = vim.fn.input(ctx.dir)
  if name == "" then
    return
  end

  local path = Path:new(ctx.dir .. name)
  if path:exists() then
    lir_utils.error "Pathname already exists"
    local ln = ctx:indexof(name)
    if ln then
      vim.cmd(tostring(ln))
    end
    return
  end

  local pathsep = Path.path.sep
  if name:sub(-#pathsep) == pathsep then
    path:mkdir()
  else
    path:touch { parents = true }
  end
  actions.reload()

  vim.schedule(function()
    local ln = lvim.get_context():indexof(name)
    if ln then
      vim.cmd(tostring(ln))
    end
  end)
end

local fsize = function(bytes)
  -- TODO: Human-readable
  return bytes .. "b"
end

local username = function(uid)
  -- TODO: Convert uid to username
  return uid
end

local strftime = function(dt)
  -- TODO: posix-long-iso =: greater than six months -> year instead of time
  return os.date("%d %b %H:%M", dt)
end

local fname = function(path)
  -- TODO: show link target
  return vim.fn.fnamemodify(path, ":t")
end

local fs_stat = function(path)
  local lfs = require "lfs"
  local res = lfs.attributes(path)
  local attrs = {}

  attrs.permissions = res.permissions
  attrs.size = fsize(res.size)
  attrs.user = username(res.uid)
  attrs.mtime = strftime(res.modification)
  attrs.name = fname(path)

  return attrs
end

custom_actions.stat = function()
  local ctx = get_context()
  local path = ctx.dir .. ctx:current_value()
  local attrs = fs_stat(path)
  print(attrs.permissions .. " " .. attrs.size .. " " .. attrs.user .. " " .. attrs.mtime .. " " .. attrs.name)
end

custom_actions.yank_basename = function()
  local ctx = get_context()
  local path = ctx:current_value()
  vim.fn.setreg(vim.v.register, path)
  print(path)
end

custom_actions.yank_path = function()
  local ctx = get_context()
  local path = ctx.dir .. ctx:current_value()
  vim.fn.setreg(vim.v.register, path)
  print(path)
end

custom_actions.toggle_mark_down = function()
  mark_actions.toggle_mark()
  vim.cmd "normal! j"
end

custom_actions.toggle_mark_up = function()
  mark_actions.toggle_mark()
  vim.cmd "normal! k"
end

custom_actions.clear_marks = function()
  local ctx = get_context()
  for _, f in ipairs(ctx:get_marked_items()) do
    f.marked = false
  end
  actions.reload()
end

-- TODO: This could delete multiple buffers if there are multiple buffers open for the same
-- filename.
custom_actions.delete = function()
  local bdelete = require("bufdelete").bufdelete
  local delete = actions.delete
  local ctx = get_context()
  local fname = ctx:current_value()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    local bname = vim.fn.bufname(b)
    if bname:sub(-#fname) == fname then
      if vim.api.nvim_buf_is_loaded(b) then
        bdelete(b, true)
      else
        vim.api.nvim_buf_delete(b, { force = true })
      end
    end
  end
  delete()
end

lir.setup {
  show_hidden_files = true,
  devicons_enable = true,
  float = { winblend = 15 },
  hide_cursor = true,

  mappings = {
    ["<cr>"] = actions.edit,
    ["<c-v>"] = actions.vsplit,
    ["<c-s>"] = actions.split,

    ["<tab>"] = custom_actions.toggle_mark_down,
    ["<s-tab>"] = custom_actions.toggle_mark_up,
    S = custom_actions.clear_marks,

    ["-"] = custom_actions.up,
    q = actions.quit,

    a = custom_actions.new,
    r = actions.rename,
    y = custom_actions.yank_path,
    Y = custom_actions.yank_basename,

    d = custom_actions.delete,
    c = clipboard_actions.copy,
    x = clipboard_actions.cut,
    p = clipboard_actions.paste,

    ["."] = actions.toggle_show_hidden,
    K = custom_actions.stat,
  },
}

require("lir.git_status").setup {
  show_ignored = false,
}

vim.keymap.nnoremap { "-", ":e %:h<cr>" }
