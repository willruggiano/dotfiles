-- Adapted from https://github.com/ggandor/leap-spooky.nvim
--
-- TODO:
-- [ ] it'd be really nice to label matches, then selecting wouldn't require the normal 2 leap chars
--
local api = vim.api

local function get_motion_force()
  local force = ""
  local mode = vim.fn.mode(1)
  if mode:sub(2) == "oV" then
    force = "V"
  elseif mode:sub(2) == "o" then
    force = ""
  end
  return force
end

local function spooky_action(action, kwargs)
  return function(target)
    local op_mode = vim.fn.mode(1):match "o"
    local operator = vim.v.operator
    local on_return = kwargs.on_return
    local keeppos = kwargs.keeppos
    local saved_view = vim.fn.winsaveview()
    -- Handle cross-window operations.
    local source_win = vim.fn.win_getid()
    local cross_window = target.wininfo and target.wininfo.winid ~= source_win
    -- Set an extmark as an anchor, so that we can execute remote delete
    -- commands in the backward direction, and move together with the text.
    local ns = api.nvim_create_namespace "leap-spooky"
    local anchor = api.nvim_buf_set_extmark(0, ns, saved_view.lnum - 1, saved_view.col, {})

    -- Jump.
    if cross_window then
      api.nvim_set_current_win(target.wininfo.winid)
    end
    api.nvim_win_set_cursor(0, { target.pos[1], target.pos[2] - 1 })
    -- Execute :normal action. (Intended usage: select some text object.)
    vim.cmd("normal " .. action()) -- don't use bang - custom text objects should work too
    -- (The operation itself will be executed after exiting.)

    -- Follow-up:
    if (keeppos or on_return) and op_mode then -- sanity check
      api.nvim_create_autocmd("ModeChanged", {
        -- Trigger on any mode change, including returning to Insert
        -- (possible i_CTRL-O), except for change operations (then
        -- we first enter Insert mode for doing the change itself, and
        -- should wait for returning to Normal).
        pattern = operator == "c" and "*:n" or "*:*",
        once = true,
        callback = function()
          if keeppos then
            if cross_window then
              api.nvim_set_current_win(source_win)
            end
            vim.fn.winrestview(saved_view)
            local anchorpos = api.nvim_buf_get_extmark_by_id(0, ns, anchor, {})
            api.nvim_win_set_cursor(0, { anchorpos[1] + 1, anchorpos[2] })
            api.nvim_buf_clear_namespace(0, ns, 0, -1) -- remove the anchor
          end
          if on_return then
            vim.cmd("normal " .. on_return)
          end
        end,
      })
    end
  end
end

local default_affixes = {
  remote = { window = "r", cross_window = "R" },
  magnetic = { window = "m", cross_window = "M" },
}

local default_text_objects = {
  ["iu"] = "inside unit",
  ["iw"] = "inside word",
  ["iW"] = "Inside WORD",
  ["is"] = "inside sentence",
  ["ip"] = "inside paragraph",
  ["i["] = "inside [",
  ["i]"] = "inside ]",
  ["i("] = "inside (",
  ["i)"] = "inside )",
  ["ib"] = "inside block from [{ and }]",
  ["i>"] = "same as i<",
  ["i<"] = "inside <>",
  ["it"] = "inside tag",
  ["i{"] = "inside {",
  ["i}"] = "inside }",
  ["iB"] = "inside Block from [{ and }]",
  ['i"'] = [[inside "]],
  ["i'"] = "inside '",
  ["i`"] = "inside `",
  ["au"] = "around unit",
  ["aw"] = "around word",
  ["aW"] = "Around WORD",
  ["as"] = "around sentence",
  ["ap"] = "around parapgraph",
  ["a["] = "around [",
  ["a]"] = "around ]",
  ["a("] = "around (",
  ["a)"] = "around )",
  ["ab"] = "around block",
  ["a>"] = "same as a<",
  ["a<"] = "around <>",
  ["at"] = "around tag",
  ["a{"] = "same as aB",
  ["a}"] = "same as aB",
  ["aB"] = "around Block from [{ and }]",
  ['a"'] = [[around "]],
  ["a'"] = "around '",
  ["a`"] = "around `",
}

local function setup(kwargs)
  local kwargs = kwargs or {}
  local affixes = kwargs.affixes
  local yank_paste = kwargs.paste_on_remote_yank or kwargs.yank_paste

  local v_exit = function()
    local mode = vim.fn.mode(1)
    if mode:match "o" then
      return ""
    end
    -- v/V/<C-v> exits the corresponding Visual mode if already in it.
    return mode:sub(1, 1)
  end

  local mappings = {}
  for kind, scopes in pairs(affixes or default_affixes) do
    local keeppos = kind == "remote"
    for scope, key in pairs(scopes) do
      for textobj, desc in pairs(default_text_objects) do
        table.insert(mappings, {
          scope = scope,
          keeppos = keeppos,
          lhs = textobj:sub(1, 1) .. key .. textobj:sub(2),
          action = function()
            return v_exit() .. "v" .. vim.v.count1 .. textobj .. get_motion_force()
          end,
          desc = desc,
        })
      end
      -- Special case: remote lines.
      table.insert(mappings, {
        scope = scope,
        keeppos = keeppos,
        lhs = key .. key,
        action = function()
          -- Note: a simple [count]V would not work, its behaviour
          -- depends on the previous Visual operation, see `:h V`.
          local n_js = vim.v.count1 - 1
          return v_exit() .. "V" .. (n_js > 0 and (tostring(n_js) .. "j") or "")
        end,
      })
    end
  end

  for _, mapping in ipairs(mappings) do
    for _, mode in ipairs { "x", "o" } do
      -- Don't map "remote" keys in Visual.
      if mode == "o" or not mapping.keeppos then
        vim.keymap.set(mode, mapping.lhs, function()
          local target_windows = nil
          if mapping.scope == "window" then
            target_windows = { vim.fn.win_getid() }
          elseif mapping.scope == "cross_window" then
            target_windows = require("leap.util").get_enterable_windows()
          end
          local yank_paste = (yank_paste and mapping.keeppos and vim.v.operator == "y" and vim.v.register == '"')
          require("leap").leap {
            action = spooky_action(mapping.action, {
              keeppos = mapping.keeppos,
              on_return = yank_paste and "p",
            }),
            target_windows = target_windows,
          }
        end, (mapping.desc and { desc = mapping.desc } or {}))
      end
    end
  end
end

return {
  spooky_action = spooky_action,
  spookify = setup,
  setup = setup,
}
