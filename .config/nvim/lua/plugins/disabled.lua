local disabled = {
  { "nvim-lualine/lualine.nvim" },
  -- { "folke/noice.nvim" },
}

for _, subtable in pairs(disabled) do
  subtable.enabled = false
end

return disabled
