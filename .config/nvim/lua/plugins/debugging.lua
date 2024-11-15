return {
  "mfussenegger/nvim-dap",

  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<Leader>dc", dap.continue, {})
    vim.keymap.set("n", "<Leader>dsi", dap.step_into, {})
    vim.keymap.set("n", "<Leader>dso", dap.step_out, {})

    local wk = require("which-key")
    wk.add({
      { "<Leader>d", group = "debug" },
      { "<Leader>dt", desc = "Toggle Breakpoint", mode = "n" },
      { "<Leader>dc", desc = "Continue", mode = "n" },
      { "<Leader>ds", group = "Step...", mode = "n" },
      { "<Leader>dsi", name = "into", mode = "n" },
      { "<Leader>dso", name = "out", mode = "n" },
    })
  end,
}
