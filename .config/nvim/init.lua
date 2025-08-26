require("config.lazy")
-- Load every config file AFTER lazy
local config_path = vim.fn.stdpath("config") .. "/lua/config"
for _, file in ipairs(vim.fn.readdir(config_path)) do
  if file ~= "lazy.lua" and file:sub(-4) == ".lua" then
    local module = "config." .. file:sub(1, -5)
    require(module)
  end
end

vim.opt.fillchars = table.concat(
  vim.tbl_filter(function(item)
    return not vim.startswith(item, "eob:") -- Remove eob from lazy config
  end, vim.split(vim.o.fillchars, ",", { plain = true })),
  ","
)

vim.cmd("colorscheme gruber-darker")

-- List characters
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ", -- tab characters
  trail = "·", -- trailing spaces
  nbsp = "␣", -- non-breaking spaces
  extends = "›", -- when lines continue right
  precedes = "‹", -- when lines continue left
}

-- UI settings
-- vim.opt.relativenumber = true
-- vim.opt.number = true
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true
-- vim.opt.incsearch = true
-- vim.opt.modeline = true
-- vim.opt.iminsert = 0
-- vim.opt.imsearch = 0
-- vim.opt.autoindent = true
vim.opt.autochdir = not true
