local source = {}

local Job = require "plenary.job"
local function get_shell(callback)
  Job
    :new({
      command = "zsh",
      args = { "-c", "" },
      cwd = vim.fn.getcwd(),
      on_exit = vim.schedule_wrap(function(job)
        callback { items = job:result(), isIncomplete = false }
      end),
    })
    :start()
end

function source:is_available()
  return true
end

function source:get_debug_name()
  return "cmp_shell"
end

function source:get_trigger_characters()
  return { "`" }
end

function source:complete(params, callback)
  callback {
    -- TODO: See #803
  }
end

require("cmp").register_source("shell", source.new())
