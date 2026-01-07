return {
  'rmagatti/auto-session',
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim', -- Required for session picker
  },

  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    auto_save = true,
    auto_restore = true,
    auto_create = true,
    use_git_branch = true,

    -- Use default session directory (vim.fn.stdpath('data') .. '/sessions/')
    -- auto_session_root_dir is set to default, sessions will be saved per working directory

    suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },

    -- Enable telescope integration
    session_lens = {
      load_on_setup = true,
      picker_opts = { border = true },
      previewer = false,
      -- Optional: customize telescope layout
      theme = 'dropdown', -- Can be: dropdown, ivy, cursor
      -- Optional: pass telescope layout options
      layout_config = {
        width = 0.8,
        height = 0.6,
      },
    },
  },

  config = function(_, opts)
    local auto_session = require 'auto-session'
    auto_session.setup(opts)

    -- Telescope integration keymaps
    vim.keymap.set('n', '<leader>ts', '<cmd>AutoSession search<CR>', { desc = 'Find sessions' })
  end,
}
