-- lua/plugins/git-worktree.lua
return {
  {
    'ThePrimeagen/git-worktree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      -- List/switch worktrees
      {
        '<leader>gw',
        function()
          require('telescope').extensions.git_worktree.git_worktrees()
        end,
        desc = 'Worktrees: list/switch',
      },

      -- Create a new worktree
      {
        '<leader>gW',
        function()
          require('telescope').extensions.git_worktree.create_git_worktree()
        end,
        desc = 'Worktrees: create new',
      },
    },
    config = function()
      local Worktree = require 'git-worktree'

      -- Setup according to the documentation
      Worktree.setup {
        -- Use default change_directory_command which should work
        change_directory_command = 'cd',
        update_on_change = true,
        update_on_change_command = 'e .',
        clearjumps_on_change = true,
        autopush = false,
      }

      -- Load telescope extension
      require('telescope').load_extension 'git_worktree'

      -- Hook for worktree operations using the documented API
      Worktree.on_tree_change(function(op, metadata)
        if op == Worktree.Operations.Switch then
          -- metadata has .path and .prev_path for Switch
          print("Switched from " .. (metadata.prev_path or "unknown") .. " to " .. metadata.path)
          -- Update zoxide database
          vim.fn.system('zoxide add ' .. vim.fn.shellescape(metadata.path))
        elseif op == Worktree.Operations.Create then
          -- metadata has .path, .branch, .upstream for Create
          print("Created worktree at " .. metadata.path .. " for branch " .. metadata.branch)
          -- Update zoxide database
          vim.fn.system('zoxide add ' .. vim.fn.shellescape(metadata.path))
        elseif op == Worktree.Operations.Delete then
          -- metadata has .path for Delete
          print("Deleted worktree at " .. metadata.path)
        end
      end)
    end,
  },
}