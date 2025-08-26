local function create_opts(extra_opts)
  local defaults = { silent = true }

  extra_opts = extra_opts or {}
  local opts = {}
  for k, v in pairs(defaults) do
    opts[k] = extra_opts[k] or v -- Allows overwrite
  end

  return opts
end

local map = vim.keymap.set
local curr_dir = vim.fn.stdpath("config")
-- local curr_file = curr_dir .. "/init.lua"

map("n", "gf", "<Cmd>vnew <cfile><CR>", create_opts())
map("n", "gvf", "<Cmd>vnew " .. curr_dir .. "<CR>", create_opts())
-- map("n", "<Leader>so", "<Cmd>so " .. curr_file .. "<CR>", create_opts())
-- map("n", "<Leader>bd", "<Cmd>bd<CR>", create_opts())
map("n", "<Leader>bw", "<Cmd>bw<CR>", create_opts({ desc = "Buff wipe" }))
map({ "n", "i" }, "<C-s>", "<ESC><Cmd>w<CR>", create_opts())
map("n", "<Leader>st", "<Cmd>hor term<CR><C-w>x<C-w>j", create_opts())
map("n", "<Leader>vt", "<Cmd>vert term<CR>", create_opts())
map({ "n", "i", "v" }, "<Esc>", function()
  vim.cmd.nohlsearch() -- Clear search highlights
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, create_opts())
