local function setup(args)
  local xplr = xplr

  args = args or {}
  args.key = args.key or "Q"
  args.mode = args.mode or "action"
  args.send_options = args.send_options or ""
  args.receive_options = args.receive_options or ""

  xplr.config.modes.builtin[args.mode].key_bindings.on_key[args.key] = {
    help = "send/receive via QR",
    messages = {
      "PopMode",
      { SwitchModeCustom = "qrcp" },
    },
  }

  xplr.config.modes.custom.qrcp = {
    name = "qrcp",
    key_bindings = {
      on_key = {
        s = {
          help = "send",
          messages = {
            {
              BashExec = [===[
                FILES=$(cat "${XPLR_PIPE_RESULT_OUT:?}")
                qrcp send ]===] .. args.send_options .. [===[ -- $FILES
              ]===],
            },
            "ClearSelection",
            "PopMode",
          },
        },
        r = {
          help = "receive",
          messages = {
            { BashExec = "qrcp receive " .. args.receive_options },
            "PopMode",
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

return { setup = setup }
