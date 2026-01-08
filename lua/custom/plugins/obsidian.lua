return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        local path = vim.fn.expand("%:p")
        if path:match(vim.fn.expand("~") .. "/Documents/Avidity") then
          vim.opt_local.conceallevel = 2
        end
      end,
    })
  end,
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Documents/Avidity/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Documents/Avidity/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>oq", function() require("custom.obsidian-popup").quick_note() end, desc = "[O]bsidian [Q]uick note" },
    { "<leader>op", function() require("custom.obsidian-popup").project_note() end, desc = "[O]bsidian [P]roject note" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "[O]bsidian [N]ew note" },
    { "<leader>oo", function() require("custom.obsidian-popup").find_notes() end, desc = "[O]bsidian [O]pen note" },
    { "<leader>os", function() require("custom.obsidian-popup").search_notes() end, desc = "[O]bsidian [S]earch" },
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "[O]bsidian [D]aily note" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "[O]bsidian [L]inks" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "[O]bsidian [B]acklinks" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "[O]bsidian [T]emplate" },
  },
  opts = {
    workspaces = {
      {
        name = "avidity",
        path = "~/Documents/Avidity",
      },
    },
    notes_subdir = "notes",
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily" },
    },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    completion = {
      nvim_cmp = false,
      min_chars = 2,
    },
    new_notes_location = "notes_subdir",
    preferred_link_style = "wiki",
    picker = {
      name = "telescope.nvim",
      note_mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
    },
    sort_by = "modified",
    sort_reversed = true,
    open_notes_in = "current",
    ui = {
      enable = true,
      checkboxes = {
        [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        ["x"] = { char = "✔", hl_group = "ObsidianDone" },
        [">"] = { char = "→", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "~", hl_group = "ObsidianTilde" },
      },
    },
    attachments = {
      img_folder = "assets/imgs",
    },
  },
}
