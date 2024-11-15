local gruvbox = { "ellisonleao/gruvbox.nvim" }

local loadGruvbox = { "LazyVim/LazyVim", opts = {
  colorscheme = "gruvbox",
} }

local lualine_opts = function()
  return {
    --[[add your custom lualine config here]]
    icons_enabled = false,
  }
end

local lualine = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = lualine_opts,
  -- enabled = false,
  options = {
    icons_enabled = false,
  },
}

local surround = { "tpope/vim-surround" }

return { gruvbox, loadGruvbox, lualine, surround }
