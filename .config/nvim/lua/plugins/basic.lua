local gruvbox = { "ellisonleao/gruvbox.nvim" }

local loadGruvbox = { "LazyVim/LazyVim", opts = {
  colorscheme = "gruvbox",
} }

local surround = { "tpope/vim-surround", lazy = false }

return { gruvbox, loadGruvbox, surround }
