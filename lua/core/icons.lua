-- One place for every glyph in the config.
--
-- These are deliberately plain Unicode (BMP, no Private Use Area), so they
-- render correctly even if your terminal font isn't a Nerd Font. File-type
-- icons in nvim-tree/telescope come from nvim-web-devicons and DO need a Nerd
-- Font, but nothing here does.
--
-- Want the Nerd Font look instead? Replace the strings below; that's the only
-- file you need to touch.

return {
  diagnostics = {
    ERROR = "\u{2718}", -- ✘
    WARN  = "\u{25B2}", -- ▲
    INFO  = "\u{25CF}", -- ●
    HINT  = "\u{25C6}", -- ◆
  },

  git = {
    add          = "\u{258E}", -- ▎
    change       = "\u{258E}", -- ▎
    delete       = "\u{2581}", -- ▁
    topdelete    = "\u{2594}", -- ▔
    changedelete = "\u{258E}", -- ▎
    untracked    = "\u{258E}", -- ▎
    added        = "+",
    modified     = "~",
    removed      = "-",
  },

  dap = {
    breakpoint          = "\u{25CF}", -- ●
    breakpoint_cond     = "\u{25C6}", -- ◆
    logpoint            = "\u{25C7}", -- ◇
    stopped             = "\u{25B6}", -- ▶
    breakpoint_rejected = "\u{2718}", -- ✘
  },

  fold = {
    open   = "\u{25BE}", -- ▾
    closed = "\u{25B8}", -- ▸
  },

  ui = {
    prompt      = "\u{276F} ", -- ❯
    caret       = "\u{25B8} ", -- ▸
    modified    = "\u{25CF}",  -- ●
    readonly    = "RO",
    separator   = "\u{2502}",  -- │
    indent      = "\u{2502}",  -- │
    tab         = "\u{00BB} ", -- »
    trail       = "\u{00B7}",  -- ·
    nbsp        = "\u{2423}",  -- ␣
    check       = "\u{2713}",  -- ✓
    cross       = "\u{2717}",  -- ✗
    arrow       = "\u{279C}",  -- ➜
  },
}
