
return {
  {
    "filelocation",
    lazy = false,
    config = function()
      local function show_file_location()
        -- Get the full file path and directory path
        local current_file = vim.fn.expand("%:p")
        local directory = vim.fn.expand("%:p:h") -- :h gets the head (directory) part

        -- Copy directory to clipboard
        vim.fn.setreg("+", directory) -- '+' register is system clipboard

        -- Create the popup window configuration
        local width = #current_file + 4
        local height = 2 -- Increased to show both lines
        local win_opts = {
          relative = "editor",
          width = width,
          height = height,
          row = 1,
          col = 1,
          style = "minimal",
          border = "rounded",
        }

        local buf = vim.api.nvim_create_buf(false, true)
        -- Show both the full path and a message about the clipboard
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
          current_file,
          "Directory copied to clipboard",
        })

        local win = vim.api.nvim_open_win(buf, false, win_opts)

        vim.api.nvim_win_set_option(win, "winblend", 10)
        vim.api.nvim_win_set_option(win, "wrap", false)

        vim.defer_fn(function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end, 3000)
      end

      vim.api.nvim_create_user_command("ShowFileLocation", show_file_location, {})
      vim.keymap.set("n", "<Leader>fl", show_file_location, {
        desc = "Show file location in popup and copy directory to clipboard",
        silent = true,
      })
    end,
    dev = true,
  },
}
