-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

-- This is where you actually apply your config choices.


-- or, changing the font size and color scheme.
config.font_size = 11
config.font = wezterm.font '0xProto Nerd Font Mono'
config.color_scheme = 'GruvboxDarkHard'

config.animation_fps = 100
config.max_fps = 120
config.warn_about_missing_glyphs = false

config.keys = {
  {
    key = '|',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for workspace',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          wezterm.mux.rename_workspace(
            wezterm.mux.get_active_workspace(),
            line
          )
        end
      end),
    },
  },

  { key = "LeftArrow",  mods = 'CTRL|SHIFT', action = wezterm.action { ActivateTabRelative = -1 } },
  { key = "RightArrow", mods = 'CTRL|SHIFT', action = wezterm.action { ActivateTabRelative = 1 } },

  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'R',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          wezterm.mux.rename_workspace(
            wezterm.mux.get_active_workspace(),
            line
          )
        end
      end),
    },
  },
  {
    key = 'L',
    mods = 'CTRL|SHIFT',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
  {
    key = '0',
    mods = 'CTRL',
    action = act.PaneSelect {
    },
  },
  {
    key = '!',
    mods = 'CTRL | SHIFT',
    action = wezterm.action_callback(function(win, pane)
      local tab, window = pane:move_to_new_window()
    end),
  },

}
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action { CompleteSelectionOrOpenLinkAtMouseCursor = "Clipboard" },
    -- NOTE: the default action is:
    -- action=wezterm.action{CompleteSelectionOrOpenLinkAtMouseCursor="PrimarySelection"},
  },
}
-- making window titles more distinct
wezterm.on('format-window-title', function()
  local title = '[' .. wezterm.mux.get_active_workspace() .. ']'
  return title
end)
local process_icons = {
  ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
  ["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ["cargo"] = wezterm.nerdfonts.dev_rust,
  ["curl"] = wezterm.nerdfonts.mdi_flattr,
  ["docker"] = wezterm.nerdfonts.linux_docker,
  ["docker-compose"] = wezterm.nerdfonts.linux_docker,
  ["gh"] = wezterm.nerdfonts.dev_github_badge,
  ["git"] = wezterm.nerdfonts.fa_git,
  ["go"] = wezterm.nerdfonts.seti_go,
  ["htop"] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ["kubectl"] = wezterm.nerdfonts.linux_docker,
  ["kuberlr"] = wezterm.nerdfonts.linux_docker,
  ["lazydocker"] = wezterm.nerdfonts.linux_docker,
  ["lazygit"] = wezterm.nerdfonts.oct_git_compare,
  ["lua"] = wezterm.nerdfonts.seti_lua,
  ["make"] = wezterm.nerdfonts.seti_makefile,
  ["node"] = wezterm.nerdfonts.mdi_hexagon,
  ["nvim"] = wezterm.nerdfonts.custom_vim,
  ["psql"] = "󱤢",
  ["ruby"] = wezterm.nerdfonts.cod_ruby,
  ["stern"] = wezterm.nerdfonts.linux_docker,
  ["sudo"] = wezterm.nerdfonts.fa_hashtag,
  ["usql"] = "󱤢",
  ["vim"] = wezterm.nerdfonts.dev_vim,
  ["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
  ["zsh"] = wezterm.nerdfonts.dev_terminal,
}

-- Return the Tab's current working directory
local function get_cwd(tab)
  return tab.active_pane.current_working_dir.file_path or ""
end

-- Remove all path components and return only the last value
local function remove_abs_path(path) return path:gsub("(.*[/\\])(.*)", "%2") end

-- Return the pretty path of the tab's current working directory
local function get_display_cwd(tab)
  local current_dir = get_cwd(tab)
  local HOME_DIR = string.format("file://%s", os.getenv("HOME"))
  return current_dir == HOME_DIR and "~/" or remove_abs_path(current_dir)
end

-- Return the concise name or icon of the running process for display
local function get_process(tab)
  if not tab.active_pane or tab.active_pane.foreground_process_name == "" then return "[?]" end

  local process_name = remove_abs_path(tab.active_pane.foreground_process_name)
  if process_name:find("kubectl") then process_name = "kubectl" end

  return process_icons[process_name] or string.format("[%s]", process_name)
end

-- Pretty format the tab title
local function format_title(tab)
  local cwd = get_display_cwd(tab)
  local process = get_process(tab)

  local active_title = tab.active_pane.title
  if active_title:find("- NVIM") then active_title = active_title:gsub("^([^ ]+) .*", "%1") end

  local description = (not active_title or active_title == cwd) and "~" or active_title
  return string.format("%s %s/ %s ", process, cwd, description)
end


-- Returns manually set title (from `tab:set_title()` or `wezterm cli set-tab-title`) or creates a new one
local function get_tab_title(tab)
  local title = tab.tab_title
  if title and #title > 0 then return title end
  return format_title(tab)
end



-- On format tab title events, override the default handling to return a custom title
-- Docs: https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html
---@diagnostic disable-next-line: unused-local
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = get_tab_title(tab)
  if tab.is_active then
    return {
      { Background = { Color = '#9D0006' } },
      { Text = ' ' .. title .. ' ' },
    }
  end
  return title
end)

-- Finally, return the configuration to wezterm:
return config
