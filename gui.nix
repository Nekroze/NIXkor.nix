{ desktop ? false }:
{ config, pkgs, lib, ... }:
with lib;

let
  laptop = !desktop;
  fontSize = if desktop then "12" else "10";
in{
  services.unclutter.enable = mkForce false;
  services.xbanish.enable = mkForce true;
  fonts.fonts = [ pkgs.fira-code ];
  environment.systemPackages = with pkgs; [
    firefox
  ];

  services.xserver.windowManager.i3 = {
    enable = mkForce true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      kitty
      rofi
      xcape
      dunst
      xorg.xsetroot
      compton
      i3status
      i3lock-fancy
      scrot
    ]
    ++ optional laptop xorg.xbacklight
    ++ optional config.hardware.pulseaudio.enable pulseaudioLight;

    configFile = pkgs.writeText "i3.config" ''
      set $mod Mod4
      font pango:Fira Code ${fontSize}
      focus_follows_mouse no
      floating_modifier $mod
      bindsym $mod+Return exec kitty --config /etc/kitty.conf
      bindsym $mod+d kill
      bindsym $mod+semicolon exec rofi -show
      bindsym $mod+h focus left
      bindsym $mod+j focus down
      bindsym $mod+k focus up
      bindsym $mod+l focus right
      bindsym $mod+Shift+h move left
      bindsym $mod+Shift+j move down
      bindsym $mod+Shift+k move up
      bindsym $mod+Shift+l move right
      bindsym $mod+v split h
      bindsym $mod+g split v
      bindsym $mod+f fullscreen toggle
      bindsym $mod+s layout stacking
      bindsym $mod+w layout tabbed
      bindsym $mod+e layout toggle split
      bindsym $mod+Shift+space floating toggle
      bindsym $mod+space focus mode_toggle
      bindsym $mod+a focus parent
      bindsym $mod+x focus child
      bindsym $mod+1 workspace 1
      bindsym $mod+2 workspace 2
      bindsym $mod+3 workspace 3
      bindsym $mod+4 workspace 4
      bindsym $mod+5 workspace 5
      bindsym $mod+6 workspace 6
      bindsym $mod+7 workspace 7
      bindsym $mod+8 workspace 8
      bindsym $mod+9 workspace 9
      bindsym $mod+0 workspace 10
      bindsym $mod+Shift+1 move container to workspace 1
      bindsym $mod+Shift+2 move container to workspace 2
      bindsym $mod+Shift+3 move container to workspace 3
      bindsym $mod+Shift+4 move container to workspace 4
      bindsym $mod+Shift+5 move container to workspace 5
      bindsym $mod+Shift+6 move container to workspace 6
      bindsym $mod+Shift+7 move container to workspace 7
      bindsym $mod+Shift+8 move container to workspace 8
      bindsym $mod+Shift+9 move container to workspace 9
      bindsym $mod+Shift+0 move container to workspace 10
      bindsym $mod+Shift+r restart
      bindsym $mod+Pause exec i3lock-fancy -pf "Fira-Code-Regular" -t "Go Away!" -- scrot -z
      bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'pkill ssh-agent gpg-agent; i3-msg exit'"
      mode "resize" {
              bindsym h resize shrink width 10 px or 10 ppt
              bindsym k resize grow height 10 px or 10 ppt
              bindsym j resize shrink height 10 px or 10 ppt
              bindsym l resize grow width 10 px or 10 ppt
              bindsym Return mode "default"
              bindsym Escape mode "default"
      }
      bindsym $mod+r mode "resize"
      bar {
        status_command i3status
        colors {
          separator #dc322f
          background #073642
          statusline #268bd2
          focused_workspace #fdf6e3 #859900 #fdf6e3
          active_workspace #fdf6e3 #6c71c4 #fdf6e3
          inactive_workspace #586e75 #93a1a1 #002b36
          urgent_workspace #dc322f #dc322f #fdf6e3
        }
      }
      client.focused #859900 #859900 #fdf6e3 #859900
      client.focused_inactive #859900 #073642 #eee8d5 #6c71c4
      client.unfocused #586e75 #002b36 #93a1a1 #586e75
      client.urgent #dc322f #dc322f #fdf6e3 #dc322f
      for_window [class="^.*"] border pixel 1
      ${optionalString (config.services.xserver.windowManager.i3.package == pkgs.i3-gaps) ''
      gaps inner ${if laptop then "10" else "20"}
      gaps outer 0
      smart_gaps on
      smart_borders on
      ''}
      ${optionalString config.hardware.pulseaudio.enable ''
      bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +10%
      bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -10%
      bindsym Shift+XF86MonBrightnessUp exec --no-startup-id pactl set-sink-volume 0 +10%
      bindsym Shift+XF86MonBrightnessDown exec --no-startup-id pactl set-sink-volume 0 -10%
      bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle
      ''}
      ${optionalString laptop ''
      bindsym XF86MonBrightnessUp exec xbacklight -inc 10
      bindsym XF86MonBrightnessDown exec xbacklight -dec 10
      ''}
      exec --no-startup-id xsetroot -solid "#002b36"
      exec --no-startup-id dunst -config /etc/dunstrc
      exec --no-startup-id xcape
      exec compton -bc -o 0.5 -r 3 -l 2 -t 2 --shadow-exclude '_GTK_FRAME_EXTENTS@:c' --shadow-exclude 'class_g = "i3-frame"' --xinerama-shadow-crop
    '';
  };

  environment.etc."i3status.conf".text = ''
    general {
      colors = true
      interval = 5
    }
    order += "volume master"
    order += "cpu_temperature 1"
    order += "disk /"
    order += "${if desktop then "ethernet enp2s0" else "wireless wlp1s0"}"
    order += "load"
    ${optionalString laptop ''order += "battery 0"''}
    order += "tztime local"
    order += "tztime local_date"
    ethernet enp2s0 {
      format_up = "E: %ip"
      format_down = "E: down"
    }
    tztime local_date {
      format = "%Y-%m-%d"
    }
    tztime local {
      format = "%H:%M"
    }
    load {
      format = "L: %1min"
    }
    disk "/" {
      format = "%free"
    }
    volume master {
      format = "♪: %volume"
      device = "default"
      mixer = "Master"
      mixer_idx = 0
    }
    cpu_temperature 1 {
      format = "T: %degrees °C"
      path = "/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input"
    }
    battery 0 {
      format = "%status %percentage %remaining %emptytime"
      format_down = "No battery"
      status_chr = "CHR"
      status_bat = "BAT"
      status_unk = "? UNK"
      status_full = "☻ FULL"
      path = "/sys/class/power_supply/BAT/uevent"
      low_threshold = 10
    }
    wireless wlp1s0 {
      format_up = "W: (%quality at %essid, %bitrate) %ip"
      format_down = "W: down"
    }
  '';

  environment.etc."X11/Xresources".text = ''
    rofi.color-enabled:     true
    rofi.theme:             solarized
    rofi.location:          0
    rofi.font:              Fira Code 10
    rofi.terminal:          kitty --config /etc/kitty.conf
    rofi.case-sensitive:    false
    rofi.scroll-method:     1
    rofi.modi:              drun
    rofi.parse-known-hosts: false
    rofi.matching:          glob
  '';

  environment.etc."dunstrc".text = ''
    [global]
      font                 = Source Code Pro 10
      allow_markup         = yes
      plain_text           = no
      format               = "%s\n%b"
      transparency         = 0
      ignore_newline       = no
      show_indicators      = yes
      separator_color      = frame
      sort                 = yes
      alignment            = left
      bounce_freq          = 0
      word_wrap            = yes
      indicate_hidden      = yes
      show_age_threshold   = 60
      idle_threshold       = 120
      geometry             = "300x100-0+0"
      shrink               = no
      line_height          = 0
      notification_height  = 100
      separator_height     = 2
      padding              = 8
      horizontal_padding   = 12
      monitor              = 0
      follow               = keyboard
      sticky_history       = yes
      history_length       = 20
      icon_position        = off
      startup_notification = false
    [frame]
      width = 1
      color = "#002b36"
    [shortcuts]
      close     = ctrl+space
      close_all = ctrl+shift+space
      history   = ctrl+grave
      context   = ctrl+shift+period
    [urgency_low]
      background = "#b58900"
      foreground = "#002b36"
      timeout = 10
    [urgency_normal]
      background = "#cb4b16"
      foreground = "#002b36"
      timeout = 5
    [urgency_critical]
      background = "#dc322f"
      foreground = "#002b36"
      timeout = 0
  '';

  environment.etc."kitty.conf".text = ''
    shell                 zsh
    font_family           Fira Code
    font_size             11.0
    cursor                #586e75
    cursor_shape          block
    url_color             #2aa198
    url_style             curly
    active_border_color   #859900
    inactive_border_color #586e75
    foreground            #839496
    background            #073642
    selection_foreground  #657b83
    selection_background  #fdf6e3
    color0                #002b36
    color8                #073642
    color1                #dc322f
    color9                #d75f00
    color2                #859900
    color10               #585858
    color3                #b58900
    color11               #626262
    color4                #268bd2
    color12               #808080
    color5                #d33682
    color13               #5f5faf
    color6                #2aa198
    color14               #8a8a8a
    color7                #839496
    color15               #93a1a1
  '';
}
