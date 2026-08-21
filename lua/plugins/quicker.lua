-- Makes the quickfix list editable + prettier. Pairs well with :grep and Trouble.
require("quicker").setup({ keys = {
  { ">", function() require("quicker").expand({ before = 2, after = 2 }) end, desc = "Expand context" },
  { "<", function() require("quicker").collapse() end, desc = "Collapse context" },
} })
