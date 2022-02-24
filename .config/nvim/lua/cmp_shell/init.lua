local Job = require "plenary.job"
local cmp = require "cmp"

local function handle_response(params, lines)
  local value = table.concat(lines, "\n")
  return {
    {
      label = value,
      -- TODO: This isn't working. We're just trying to replace the keyword!
      -- textEdit = {
      --   range = {
      --     start = {
      --       line = params.context.cursor.row - 1,
      --       character = params.context.cursor.col - params.offset,
      --     },
      --     ["end"] = {
      --       line = params.context.cursor.row - 1,
      --       character = params.context.cursor.col - 1,
      --     },
      --   },
      --   newText = value,
      -- },
    },
  }
end

local function run_command(cmd, params, callback)
  Job
    :new({
      command = vim.env.SHELL,
      args = { "-c", cmd },
      cwd = vim.fn.getcwd(),
      on_exit = vim.schedule_wrap(function(job)
        local items = handle_response(params, job:result())
        callback { items = items, isIncomplete = false }
      end),
    })
    :start()
end

local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_debug_name = function()
  return "shell"
end

source.get_keyword_pattern = function()
  return [[`!(.+)`]]
end

source.get_trigger_characters = function()
  return { "`" }
end

function source:is_available()
  return true
end

function source:complete(params, callback)
  local cmd = params.context.cursor_before_line:match [[`!(.+)`]]
  local manual = params.completion_context.triggerKind == cmp.lsp.CompletionTriggerKind.Invoked
  if cmd ~= nil and manual then
    run_command(cmd, params, callback)
  else
    return callback()
  end
end

return {
  setup = function()
    require("cmp").register_source("shell", source.new())
  end,
}
