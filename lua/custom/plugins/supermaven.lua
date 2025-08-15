return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup {
      keymaps = {
        accept_suggestion = '<C-y>',
        clear_suggestion = '<C-]>',
        accept_word = '<C-l>',
      },
      disable_inline_completion = false,
    }
  end,
}
