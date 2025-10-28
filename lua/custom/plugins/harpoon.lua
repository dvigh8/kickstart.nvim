return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup()

    vim.keymap.set('n', '<leader>la', function()
      harpoon:list():add()
    end)
    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)
    vim.keymap.set('n', '<C-u>', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<C-i>', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<C-k>', function()
      harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<C-x>', function()
      harpoon:list():select(4)
    end)
    vim.keymap.set('n', '<leader><C-u>', function()
      harpoon:list():replace_at(1)
    end)
    vim.keymap.set('n', '<leader><C-i>', function()
      harpoon:list():replace_at(2)
    end)
    vim.keymap.set('n', '<leader><C-k>', function()
      harpoon:list():replace_at(3)
    end)
    vim.keymap.set('n', '<leader><C-x>', function()
      harpoon:list():replace_at(4)
    end)
  end,
}
