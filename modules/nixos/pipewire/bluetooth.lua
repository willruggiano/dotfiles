bluez_monitor.properties = {
  ["bluez5.enable-msbc"] = true,
  ["bluez5.enable-sbc-xq"] = true,
  ["bluez5.enable-hw-volume"] = true,
  ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",

  rules = {
    {
      matches = {
        {
          { "device.name", "matches", "bluez_card.*" },
        },
      },
      apply_properties = {
        ["bluez5.auto-connect"] = "[ hfp_hf hsp_hs a2dp_sink ]",
      },
    },
  },
}
