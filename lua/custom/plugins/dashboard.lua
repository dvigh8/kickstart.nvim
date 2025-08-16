return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'folke/persistence.nvim', -- Add persistence as dependency
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Find Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          -- Session management shortcuts
          {
            icon = ' ',
            desc = 'Restore Session',
            group = 'DiagnosticInfo',
            action = function()
              require('persistence').load()
            end,
            key = 's',
          },
          {
            icon = ' ',
            desc = 'Last Session',
            group = '@property',
            action = function()
              require('persistence').load { last = true }
            end,
            key = 'l',
          },
          {
            icon = '󰁯 ',
            desc = 'Select Session',
            group = 'DiagnosticHint',
            action = function()
              require('persistence').select()
            end,
            key = 'S',
          },
          {
            icon = ' ',
            desc = 'Recent Files',
            group = 'DiagnosticHint',
            action = 'Telescope oldfiles',
            key = 'r',
          },
          {
            icon = ' ',
            desc = 'New File',
            group = 'Number',
            action = 'enew',
            key = 'n',
          },
          {
            icon = ' ',
            desc = 'Config',
            group = '@variable',
            action = 'edit ~/.config/nvim/init.lua',
            key = 'c',
          },
          {
            icon = '󰒲 ',
            desc = 'Update Plugins',
            group = 'Label',
            action = 'Lazy update',
            key = 'u',
          },
          {
            icon = '󰗼 ',
            desc = 'Quit',
            group = 'DiagnosticError',
            action = 'quit',
            key = 'q',
          },
        },
        packages = { enable = true },
        project = {
          enable = true,
          limit = 8,
          icon = ' ',
          label = 'Recent Projects',
          action = 'Telescope find_files cwd=',
        },
        mru = {
          enable = true,
          limit = 10,
          icon = ' ',
          label = 'Recent Files',
          cwd_only = false,
        },
        footer = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return {
            '',
            '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms',
          }
        end,
      },
    }
  end,
}
