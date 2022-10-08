# cmp-latex-symbol

Latex symbol source for [nvim-cmp](https://github.com/hrsh7th/nvim-cmp), fast, all written in Lua, with documentation.
Use [unimathsymbols.txt](https://milde.users.sourceforge.net/LUCR/Math/data/unimathsymbols.txt).

![image](https://user-images.githubusercontent.com/82267684/194706546-3d1e9b0f-2e83-41c8-9f95-06051eff8d74.png)

# Usage

```lua
require("cmp").setup({
    sources = {
        { name = "latex_symbol" },
    },
})
```

# Related projects

[kdheepak/cmp-latex-symbols](https://github.com/kdheepak/cmp-latex-symbols)
