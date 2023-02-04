{
  pkgs,
  eww-vol,
  ...
}: ''
  (defwidget bar []
    (centerbox :orientation "h"
      (workspaces)
      (music)
      (sidestuff)))

  (defwidget sidestuff []
    (box :class "sidestuff" :orientation "h" :space-evenly false :halign "end"
      (metric :label "🔊"
              :value volume
              :onchange "${pkgs.alsa-utils}/bin/amixer sset Master {}%")
      (metric :label ""
              :value {EWW_RAM.used_mem_perc}
              :onchange "")
      (metric :label "💾"
              :value {round((1 - (EWW_DISK["/"].free / EWW_DISK["/"].total)) * 100, 0)}
              :onchange "")
      time))

  (defwidget workspaces []
    (box :class "workspaces"
         :orientation "h"
         :space-evenly true
         :halign "start"
         :spacing 10
      (button :onclick "hyprctl dispatch workspace 1" 1)
      (button :onclick "hyprctl dispatch workspace 2" 2)
      (button :onclick "hyprctl dispatch workspace 3" 3)
      (button :onclick "hyprctl dispatch workspace 4" 4)
      (button :onclick "hyprctl dispatch workspace 5" 5)
      (button :onclick "hyprctl dispatch workspace 6" 6)
      (button :onclick "hyprctl dispatch workspace 7" 7)
      (button :onclick "hyprctl dispatch workspace 8" 8)
      (button :onclick "hyprctl dispatch workspace 9" 9)))

  (defwidget music []
    (box :class "music"
         :orientation "h"
         :space-evenly false
         :halign "center"
      {music != "" ? "🎵''${music}" : ""}))


  (defwidget metric [label value onchange]
    (box :orientation "h"
         :class "metric"
         :space-evenly false
      (box :class "label" label)
      (scale :min 0
             :max 101
             :active {onchange != ""}
             :value value
             :onchange onchange)))



  (deflisten music :initial ""
    "${pkgs.playerctl}/bin/playerctl --follow metadata --format '{{ artist }} - {{ title }}' || true")

  (defpoll volume :interval "1s"
    "${eww-vol}/bin/eww-vol")

  (defpoll time :interval "10s"
    "date '+%H:%M %b %d, %Y'")

  (defwindow bar
    :monitor 0
    :windowtype "dock"
    :geometry (geometry :x "0%"
                        :y "0%"
                        :width "100%"
                        :height "5px"
                        :anchor "top center")
    :reserve (struts :side "top" :distance "4%")
    (bar))
''
