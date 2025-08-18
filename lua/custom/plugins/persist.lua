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
      theme_conf = { border = true },
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

    -- Auto-restore session for git repo even when opening a specific file
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        -- Check if we opened with a file argument
        if vim.fn.argc() > 0 then
          -- Get the git root
          local git_root = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
          if vim.v.shell_error == 0 and git_root ~= '' then
            -- Change to git root directory
            vim.cmd('cd ' .. git_root)
            -- Restore the session for the git root
            require('auto-session').RestoreSessionFromDir(git_root)
          end
        end
      end,
      nested = true,
    })

    -- Telescope integration keymaps
    vim.keymap.set('n', '<leader>ts', require('auto-session.session-lens').search_session, {
      desc = 'Find sessions (Telescope)',
    })

    -- Alternative: if you prefer using Telescope command
    vim.keymap.set('n', '<leader>tS', '<cmd>Telescope session-lens<CR>', {
      desc = 'Find sessions (Telescope command)',
    })
  end,
}
