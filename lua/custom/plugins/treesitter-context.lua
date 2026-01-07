return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = 'BufReadPost',
  opts = {
    enable = true,
    max_lines = 3, -- How many context lines to show (default: 3)
    min_window_height = 0, -- Minimum editor window height to enable context
    line_numbers = true, -- Show line numbers in context
    multiline_threshold = 20, -- Max lines for a single context
    trim_scope = 'outer', -- Which context lines to discard if max_lines exceeded
    mode = 'cursor', -- 'cursor' or 'topline' - line used to calculate context
    separator = nil, -- Character for separator line (nil = no separator)
    zindex = 20, -- Z-index of the context window
  },
  keys = {
    {
      '<leader>tc',
      function()
        require('treesitter-context').toggle()
      end,
      desc = '[T]oggle Treesitter [C]ontext',
    },
  },
}
