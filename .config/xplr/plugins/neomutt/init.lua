local function setup(args)
  local xplr = xplr

  args = args or {}
  args.key = args.key or "M"
  args.mode = args.mode or "action"

  xplr.config.modes.builtin[args.mode].key_bindings.on_key[args.key] = {
    help = "neomutt",
    messages = {
      "PopMode",
      { SwitchModeCustom = "neomutt" },
    },
  }

  xplr.config.modes.custom.neomutt = {
    name = "neomutt",
    key_bindings = {
      on_key = {
        a = {
          help = "attach",
          messages = {
            {
              BashExec = [===[
                FILES=$(cat "${XPLR_PIPE_RESULT_OUT:?}")
                neomutt -a $FILES
              ]===],
            },
            "PopMode",
          },
        },
        i = {
          help = "include",
          messages = {
            {
              BashExec = [===[
                FILES=$(cat "${XPLR_PIPE_RESULT_OUT:?}")
                neomutt -i $FILES
              ]===],
            },
          },
        },
        esc = {
          help = "cancel",
          messages = {
            "PopMode",
          },
        },
      },
    },
  }
end

return {
  setup = setup,
}
