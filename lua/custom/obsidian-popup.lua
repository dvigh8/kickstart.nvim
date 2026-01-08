local M = {}

local vault_path = vim.fn.expand("~/Documents/Avidity")

local function get_git_root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    result = result:gsub("%s+$", "")
    if result ~= "" then
      return result
    end
  end
  return nil
end

local function get_project_name()
  local git_root = get_git_root()
  if git_root then
    return vim.fn.fnamemodify(git_root, ":t")
  end
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

local function open_popup(file_path, title)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = vim.api.nvim_create_buf(false, false)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })

  vim.cmd("edit " .. vim.fn.fnameescape(file_path))

  local final_buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = final_buf,
    once = true,
    callback = function()
      if vim.bo[final_buf].modified then
        vim.api.nvim_buf_call(final_buf, function()
          vim.cmd("silent write")
        end)
      end
    end,
  })

  vim.keymap.set("n", "q", function()
    if vim.bo[final_buf].modified then
      vim.cmd("silent write")
    end
    vim.api.nvim_win_close(0, true)
  end, { buffer = final_buf, nowait = true })
end

function M.quick_note()
  vim.ui.input({ prompt = "Note title: " }, function(title)
    if not title or title == "" then
      return
    end

    local scratch_dir = vault_path .. "/scratch"
    ensure_dir(scratch_dir)

    local date = os.date("%Y-%m-%d")
    local safe_title = title:gsub("%s+", "-"):gsub("[^%w%-_]", ""):lower()
    local filename = date .. "-" .. safe_title .. ".md"
    local file_path = scratch_dir .. "/" .. filename

    local display_title = "scratch/" .. filename
    open_popup(file_path, display_title)

    if vim.fn.filereadable(file_path) == 0 then
      local header = "# " .. title .. "\n\n"
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(header, "\n"))
      vim.cmd("silent write")
    end
  end)
end

function M.project_note()
  local project_name = get_project_name()
  local project_dir = vault_path .. "/projects/" .. project_name
  ensure_dir(project_dir)

  local file_path = project_dir .. "/notes.md"
  local display_title = "projects/" .. project_name .. "/notes.md"

  open_popup(file_path, display_title)

  if vim.fn.filereadable(file_path) == 0 or vim.fn.getfsize(file_path) == 0 then
    local header = "# " .. project_name .. "\n\n## Notes\n\n"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(header, "\n"))
    vim.cmd("silent write")
  end
end

function M.find_notes()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  require("telescope.builtin").find_files({
    prompt_title = "Find Notes",
    cwd = vault_path,
    find_command = { "rg", "--files", "--glob", "*.md" },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          local file_path = vault_path .. "/" .. selection.value
          local rel_path = selection.value
          open_popup(file_path, rel_path)
        end
      end)
      return true
    end,
  })
end

function M.search_notes()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  require("telescope.builtin").live_grep({
    prompt_title = "Search Notes",
    cwd = vault_path,
    glob_pattern = "*.md",
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          local file_path = vault_path .. "/" .. selection.filename
          local rel_path = selection.filename
          local lnum = selection.lnum
          open_popup(file_path, rel_path)
          if lnum then
            vim.api.nvim_win_set_cursor(0, { lnum, 0 })
          end
        end
      end)
      return true
    end,
  })
end

return M
