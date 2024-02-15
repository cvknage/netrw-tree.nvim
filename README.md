# Netrw Tree
**netrw-tree** is a lua plugin for Neovim that configures the default **[netrw](https://neovim.io/doc/user/pi_netrw.html)** so that it can functions like a tree style file browser.

<img width="1133" alt="netrw-tree" src="https://github.com/cvknage/netrw-tree.nvim/assets/609099/b2cde8c7-af80-42c4-8278-2129103ac4dc">

## Installation
Install the plugin with your preferred package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
  {
    'cvknage/netrw-tree.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons' -- optional
    },
    opts = { },
    lazy = false,
    keys = {
      { "<leader>pv", "<cmd>Explore<cr>",  desc = "Project Volumes" },
      { "<leader>pe", "<cmd>Lexplore<cr>", desc = "Project Explorer" },
    },
  }
```
# Attributions

[netrw-tree.nvim](https://github.com/cvknage/netrw-tree.nvim) is based on the [netrw](https://github.com/doom-neovim/doom-nvim/blob/e62053c9ed919ae4576eb4c3e2dd5f80d7a6c0bd/lua/doom/modules/features/netrw/init.lua) module from [doom-nvim](https://github.com/doom-neovim/doom-nvim)
