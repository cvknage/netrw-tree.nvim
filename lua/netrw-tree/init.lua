local M = {}

local system_seperator = package.config:sub(1, 1)
local is_nix_system = system_seperator == "/"

local defaults = {
  -- Netew winsize
  -- @default = 20
  netrw_winsize = 20,

  -- Netrw banner
  -- 0 : Disable banner
  -- 1 : Enable banner
  netrw_banner = 0,

  -- Keep the current directory and the browsing directory synced.
  -- This helps you avoid the move files error.
  netrw_keepdir = 1,

  -- Show directories first (sorting)
  netrw_sort_sequence = [[[\/]$,*]],

  -- Human-readable files sizes
  netrw_sizestyle = "H",

  -- Netrw list style
  -- 0 : thin listing (one file per line)
  -- 1 : long listing (one file per line with timestamp information and file size)
  -- 2 : wide listing (multiple files in columns)
  -- 3 : tree style listing
  netrw_liststyle = 3,

  -- Patterns for hiding files, e.g. node_modules
  -- NOTE: this works by reading '.gitignore' file
  netrw_list_hide = vim.fn["netrw_gitignore#Hide"](),

  -- Show hidden files
  -- 0 : show all files
  -- 1 : show not-hidden files
  -- 2 : show hidden files only
  netrw_hide = 0,

  -- Preview files in a vertical split window
  netrw_preview = 1,

  -- Open files in split
  -- 0 : re-use the same window (default)
  -- 1 : horizontally splitting the window first
  -- 2 : vertically   splitting the window first
  -- 3 : open file in new tab
  -- 4 : act like "P" (ie. open previous window)
  netrw_browse_split = 0,

  -- Enable recursive copy of directories in *nix systems
  netrw_localcopydircmd = is_nix_system and "cp -r" or vim.g.netrw_localcopydircmd,

  -- Enable recursive creation of directories in *nix systems
  netrw_localmkdir = is_nix_system and "mkdir -p" or vim.g.netrw_localmkdir,

  -- Enable recursive removal of directories in *nix systems
  -- NOTE: we use 'rm' instead of 'rmdir' (default) to be able to remove non-empty directories
  netrw_localrmdir = is_nix_system and "rm -r" or vim.g.netrw_localrmdir,
}

M.options = {}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})

  vim.g.netrw_winsize = M.options.netrw_winsize
  vim.g.netrw_banner = M.options.netrw_banner
  vim.g.netrw_keepdir = M.options.netrw_keepdir
  vim.g.netrw_sort_sequence = M.options.netrw_sort_sequence
  vim.g.netrw_sizestyle = M.options.netrw_sizestyle
  vim.g.netrw_liststyle = M.options.netrw_liststyle
  vim.g.netrw_list_hide = M.options.netrw_list_hide
  vim.g.netrw_hide = M.options.netrw_hide
  vim.g.netrw_preview = M.options.netrw_preview
  vim.g.netrw_browse_split = M.options.netrw_browse_split
  vim.g.netrw_localcopydircmd = M.options.netrw_localcopydircmd
  vim.g.netrw_localmkdir = M.options.netrw_localmkdir
  vim.g.netrw_localrmdir = M.options.netrw_localrmdir
end

-- Highlight marked files in the same way search matches are
vim.cmd("hi! link netrwMarkFile Search")

local function netrw_maps()
  if vim.bo.filetype ~= "netrw" then
    return
  end

  local opts = { silent = false }

  -- Refresh netrw
  vim.api.nvim_buf_set_keymap(0, "n", "<C-r>", ":e .<CR>", opts)

  -- Go to right window
  vim.api.nvim_buf_set_keymap(0, "n", "<C-l>", "<C-w>l", opts)

  -- Toggle dotfiles
  vim.api.nvim_buf_set_keymap(0, "n", ".", "gh", opts)

  -- Open file and close netrw
  vim.api.nvim_buf_set_keymap(0, "n", "o", "<CR>:Lexplore<CR>", opts)

  -- Go up one directory
  vim.api.nvim_buf_set_keymap(0, "n", "h", "-", opts)

  -- Open file or directory
  vim.api.nvim_buf_set_keymap(0, "n", "l", "<CR>", opts)

  -- Close netrw
  vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", opts)

  -- Create a new file and save it
  vim.api.nvim_buf_set_keymap(0, "n", "ff", "%:w<CR>:buffer #<CR>", opts)

  -- Create a new directory
  vim.api.nvim_buf_set_keymap(0, "n", "fa", "d", opts)

  -- Rename file
  vim.api.nvim_buf_set_keymap(0, "n", "fr", "R", opts)

  -- Remove file or directory
  vim.api.nvim_buf_set_keymap(0, "n", "fd", "D", opts)

  -- Copy marked file
  vim.api.nvim_buf_set_keymap(0, "n", "fc", "mc", opts)

  -- Copy marked file in one step, with this we can put the cursor in a directory
  -- after marking the file to assign target directory and copy file
  vim.api.nvim_buf_set_keymap(0, "n", "fC", "mtmc", opts)

  -- Move marked file
  vim.api.nvim_buf_set_keymap(0, "n", "fx", "mm", opts)

  -- Move marked file in one step, same as fC but for moving files
  vim.api.nvim_buf_set_keymap(0, "n", "fX", "mtmm", opts)

  -- Execute commands in marked file or directory
  vim.api.nvim_buf_set_keymap(0, "n", "fe", "mx", opts)

  -- Show a list of marked files and directories
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "fm",
    ':echo "Marked files:\n" . join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>',
    opts
  )

  -- Show target directory
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "ft",
    ':echo "Target: " . netrw#Expose("netrwmftgt")<CR>',
    opts
  )

  -- Toggle the mark on a file or directory
  vim.api.nvim_buf_set_keymap(0, "n", "<TAB>", "mf", opts)

  -- Unmark all the files in the current buffer
  vim.api.nvim_buf_set_keymap(0, "n", "<S-TAB>", "mF", opts)

  -- Remove all the marks on all files
  vim.api.nvim_buf_set_keymap(0, "n", "<Leader><TAB>", "mu", opts)

  -- Create a bookmark
  vim.api.nvim_buf_set_keymap(0, "n", "bc", "mb", opts)

  -- Remove the most recent bookmark
  vim.api.nvim_buf_set_keymap(0, "n", "bd", "mB", opts)

  -- Jumo to the most recent bookmark
  vim.api.nvim_buf_set_keymap(0, "n", "bj", "gb", opts)
end

local function draw_icons()
  if vim.bo.filetype ~= "netrw" then
    return
  end

  local is_devicons_available, devicons = xpcall(require, debug.traceback, "nvim-web-devicons")
  if not is_devicons_available then
    return
  end
  local default_signs = {
    netrw_dir = {
      text = "",
      texthl = "netrwDir",
    },
    netrw_file = {
      text = "",
      texthl = "netrwPlain",
    },
    netrw_exec = {
      text = "",
      texthl = "netrwExe",
    },
    netrw_link = {
      text = "",
      texthl = "netrwSymlink",
    },
  }

  local bufnr = vim.api.nvim_win_get_buf(0)

  -- Unplace all signs
  vim.fn.sign_unplace("*", { buffer = bufnr })

  -- Define default signs
  for sign_name, sign_opts in pairs(default_signs) do
    vim.fn.sign_define(sign_name, sign_opts)
  end

  local cur_line_nr = 1
  local total_lines = vim.fn.line("$")
  while cur_line_nr <= total_lines do
    -- Set default sign
    local sign_name = "netrw_file"

    -- Get line contents
    local line = vim.fn.getline(cur_line_nr)

    if line == "" or line == nil then
      -- If current line is an empty line (newline) then increase current line count
      -- without doing nothing more
      cur_line_nr = cur_line_nr + 1
    else
      if line:find("/$") then
        sign_name = "netrw_dir"
      elseif line:find("@%s+-->") then
        sign_name = "netrw_link"
      elseif line:find("*$") then
        sign_name:find("netrw_exec")
      else
        local filetype = line:match("^.*%.(.*)")
        if not filetype and line:find("LICENSE") then
          filetype = "md"
        elseif line:find("rc$") then
          filetype = "conf"
        end

        -- If filetype is still nil after manually setting extensions
        -- for unknown filetypes then let's use 'default'
        if not filetype then
          filetype = "default"
        end

        local icon, icon_highlight = devicons.get_icon(line, filetype, { default = "" })
        sign_name = "netrw_" .. filetype
        vim.fn.sign_define(sign_name, {
          text = icon,
          texthl = icon_highlight,
        })
      end
      vim.fn.sign_place(cur_line_nr, sign_name, sign_name, bufnr, {
        lnum = cur_line_nr,
      })
      cur_line_nr = cur_line_nr + 1
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    draw_icons()
    netrw_maps()
  end,
})

vim.api.nvim_create_autocmd("TextChanged", {
  pattern = "*",
  callback = function()
    draw_icons()
  end,
})

function ToggleVexplore()
  local expl_buf_num = vim.api.nvim_get_var("expl_buf_num")

  -- Check if Vexplore is already open
  local is_vexplore_open = expl_buf_num ~= nil

  if is_vexplore_open then
    -- Close Vexplore
    vim.api.nvim_buf_delete(expl_buf_num, { force = true })

    -- Unset the Vexplore buffer number
    vim.api.nvim_set_var("expl_buf_num", nil)
  else
    -- Open Vexplore
    vim.cmd("Vexplore")

    -- Set the Vexplore buffer number
    vim.api.nvim_set_var("expl_buf_num", vim.api.nvim_call_function("bufnr", { "%" }))
  end
end

-- Initialize expl_buf_num to nil
vim.api.nvim_set_var("expl_buf_num", nil)

-- Declare new command: ToggleVexplore
vim.cmd('command! -nargs=0 ToggleVexplore :lua ToggleVexplore()')

return M
