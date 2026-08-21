local flash = require("flash")
flash.setup({ modes = { char = { jump_labels = true } } })
vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash jump" })
vim.keymap.set({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash treesitter" })
