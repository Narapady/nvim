return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    keys = { "<leader>T", "<cmd>TransparentToggle<CR>", desc = "Toggle Transparent" },
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "BufRead",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
      })
    end,
  },
  {
    "DreamMaoMao/yazi.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },

    keys = {
      { ";e", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    dependencies = { "nvim-tree/nvim-web-devicons", "AndreM222/copilot-lualine", "nvimdev/lspsaga.nvim" },
    opts = {},
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = {
            normal = { c = { fg = "#00000000", bg = "#00000000" } },
          },
          component_separators = { left = " ", right = "" },
          section_separators = { left = " ", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        inactive_section = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        sections = {},
        tabline = {},
        winbar = {
          lualine_a = {
            -- {
            --   function()
            --     local msg = "No Active Lsp"
            --     local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            --     local clients = vim.lsp.get_active_clients()
            --     if next(clients) == nil then
            --       return msg
            --     end
            --     for _, client in ipairs(clients) do
            --       local filetypes = client.config.filetypes
            --       if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            --         return client.name
            --       end
            --     end
            --     return msg
            --   end,
            --   icon = "",
            --   color = { fg = "#849b04", gui = "bold" },
            -- },
            { "filetype", icon_only = false, colored = true },
            { "filename", colored = true },
            {
              function()
                local breadcrum = require("lspsaga.symbol.winbar").get_bar()
                if breadcrum ~= nil then
                  return breadcrum
                else
                  return ""
                end
              end,
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            { "branch", color = { fg = "#D33682" }, icon = "󰘬" },
            {
              "diff",
              colored = true, -- Displays a colored diff status if set to true
              symbols = { added = " ", modified = " ", removed = " " }, -- Changes the symbols used by the diff.
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " " },
            },
            -- { "mode", color = { fg = "#8dc07c" } },
            -- { "location", color = { fg = "#d3859b" } },
            -- { "progress", color = { fg = "#e78a4e" } },
          },
        },
        inactive_winbar = {
          lualine_x = {
            { "filetype", icon_only = true, colored = true },
            { "filename" },
          },
        },
        extensions = {},
      })
    end,
  },
}
