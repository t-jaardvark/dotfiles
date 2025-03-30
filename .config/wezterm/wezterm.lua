local wezterm = require 'wezterm'

-- Define your custom color scheme converted from kitty.conf
local my_colors = {
  background = "#202020",
  foreground = "#d0d0d0",
  cursor_bg = "#d0d0d0",
  selection_bg = "#eecb8b",
  selection_fg = "#232323",
  -- ANSI colors (color0..color7)
  ansi = {
    "#151515", -- color0
    "#ac4142", -- color1
    "#7e8d50", -- color2
    "#e5b566", -- color3
    "#6c99ba", -- color4
    "#9e4e85", -- color5
    "#7dd5cf", -- color6
    "#d0d0d0", -- color7
  },
  -- Bright colors (color8..color15)
  brights = {
    "#505050", -- color8
    "#ac4142", -- color9
    "#7e8d50", -- color10
    "#e5b566", -- color11
    "#6c99ba", -- color12
    "#9e4e85", -- color13
    "#7dd5cf", -- color14
    "#f5f5f5", -- color15
  },
}

return {
  -- Use the custom color scheme
  colors = my_colors,

  -- Example launch menu to pick different shells
  launch_menu = {
    {
      label = "Git Bash",
      args = {"C:\\Program Files\\Git\\bin\\bash.exe", "-l"},
    },
    {
      label = "WSL2 Debian",
      args = {"wsl.exe", "-d", "Debian"},
    },
    {
      label = "Command Prompt",
      args = {"cmd.exe"},
    },
    {
      label = "PowerShell",
      args = {"powershell.exe", "-NoLogo"},
    },
  },

  -- Set a default program; this should match one of your launch_menu items
  default_prog = {"C:\\Program Files\\Git\\bin\\bash.exe", "-l"},

  -- Keybindings
  keys = {
    -- Close current tab with Ctrl+W (no confirmation)
    {
      key = "w",
      mods = "CTRL",
      action = wezterm.action.CloseCurrentTab { confirm = false },
    },
    -- Close current pane with Ctrl+Shift+W (no confirmation)
    {
      key = "w",
      mods = "CTRL|SHIFT",
      action = wezterm.action.CloseCurrentPane { confirm = false },
    },
    -- Open a new tab with default program (Ctrl+T and Ctrl+N)
    {
      key = "t",
      mods = "CTRL",
      action = wezterm.action.SpawnTab("DefaultDomain"),
    },
    {
      key = "n",
      mods = "CTRL",
      action = wezterm.action.SpawnTab("DefaultDomain"),
    },
    -- Open launcher to choose a tab type (Ctrl+Shift+T and Ctrl+Shift+N)
    {
      key = "t",
      mods = "CTRL|SHIFT",
      action = wezterm.action.ShowLauncher,
    },
    {
      key = "n",
      mods = "CTRL|SHIFT",
      action = wezterm.action.ShowLauncher,
    },
  },

  -- Override default mouse bindings so we can reassign middle-click for tabs
  disable_default_mouse_bindings = true,
  mouse_bindings = {
    -- Close tab on middle-click without confirmation
    {
      event = { Down = { streak = 1, button = "Middle" } },
      mods = "NONE",
      action = wezterm.action.CloseCurrentTab { confirm = false },
    },
    -- Add other mouse bindings here if desired...
  },

  -- Optional UI settings
  font = wezterm.font("JetBrains Mono"),
  font_size = 12,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,
  window_close_confirmation = "NeverPrompt",
}
