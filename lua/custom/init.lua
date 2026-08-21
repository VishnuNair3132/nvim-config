-- Everything personal goes here. This module is required last, so anything you
-- set will win over the defaults above. Add files next to this one and require
-- them below.

-- require("custom.snippets")
-- require("custom.projects")

local ok, _ = pcall(require, "custom.local")  -- gitignored machine-specific tweaks
if not ok then return end
