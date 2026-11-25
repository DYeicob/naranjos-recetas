-- NaranjOS · tema Pomelo (paquete naranjos-temas)
vim.cmd('highlight clear')
vim.o.background = 'dark'
vim.g.colors_name = 'naranjos'
local h = vim.api.nvim_set_hl
h(0, 'Normal', { fg = '#ecdfe3', bg = '#151012' })
h(0, 'NormalFloat', { fg = '#ecdfe3', bg = '#21181b' })
h(0, 'FloatBorder', { fg = '#ff6f91', bg = '#21181b' })
h(0, 'CursorLine', { bg = '#21181b' })
h(0, 'CursorLineNr', { fg = '#ff6f91' })
h(0, 'LineNr', { fg = '#8f8086' })
h(0, 'Visual', { bg = '#32242a' })
h(0, 'Search', { fg = '#151012', bg = '#ffa3b8' })
h(0, 'IncSearch', { fg = '#151012', bg = '#ff6f91' })
h(0, 'CurSearch', { fg = '#151012', bg = '#ff6f91' })
h(0, 'MatchParen', { fg = '#ff6f91', bg = '#32242a' })
h(0, 'Comment', { fg = '#8f8086' })
h(0, 'String', { fg = '#87d787' })
h(0, 'Character', { fg = '#87d787' })
h(0, 'Number', { fg = '#ffaf5f' })
h(0, 'Boolean', { fg = '#ffaf5f' })
h(0, 'Constant', { fg = '#ffaf5f' })
h(0, 'Function', { fg = '#ff6f91' })
h(0, 'Identifier', { fg = '#ecdfe3' })
h(0, 'Keyword', { fg = '#d787ff' })
h(0, 'Statement', { fg = '#d787ff' })
h(0, 'Conditional', { fg = '#d787ff' })
h(0, 'Repeat', { fg = '#d787ff' })
h(0, 'Operator', { fg = '#ffa3b8' })
h(0, 'Type', { fg = '#5fafff' })
h(0, 'Special', { fg = '#5fd7d7' })
h(0, 'PreProc', { fg = '#5fd7d7' })
h(0, 'Title', { fg = '#ff6f91' })
h(0, 'Directory', { fg = '#ff6f91' })
h(0, 'Pmenu', { fg = '#ecdfe3', bg = '#21181b' })
h(0, 'PmenuSel', { fg = '#151012', bg = '#ff6f91' })
h(0, 'StatusLine', { fg = '#ecdfe3', bg = '#21181b' })
h(0, 'StatusLineNC', { fg = '#8f8086', bg = '#21181b' })
h(0, 'WinSeparator', { fg = '#32242a' })
h(0, 'SignColumn', { bg = '#151012' })
h(0, 'Folded', { fg = '#8f8086', bg = '#21181b' })
h(0, 'DiagnosticError', { fg = '#ff5f5f' })
h(0, 'DiagnosticWarn', { fg = '#ffd75f' })
h(0, 'DiagnosticInfo', { fg = '#5fafff' })
h(0, 'DiagnosticHint', { fg = '#5fd7d7' })
h(0, 'DiagnosticOk', { fg = '#87d787' })
h(0, 'DiffAdd', { fg = '#87d787' })
h(0, 'DiffDelete', { fg = '#ff5f5f' })
h(0, 'DiffChange', { fg = '#ffd75f' })
h(0, 'ErrorMsg', { fg = '#ff5f5f' })
h(0, 'WarningMsg', { fg = '#ffd75f' })
h(0, 'TabLine', { fg = '#8f8086', bg = '#21181b' })
h(0, 'TabLineSel', { fg = '#151012', bg = '#ff6f91' })
h(0, 'TabLineFill', { bg = '#151012' })
vim.g.terminal_color_0 = '#1e1e1e'
vim.g.terminal_color_1 = '#ff5f5f'
vim.g.terminal_color_2 = '#87d787'
vim.g.terminal_color_3 = '#ffaf5f'
vim.g.terminal_color_4 = '#5fafff'
vim.g.terminal_color_5 = '#d787ff'
vim.g.terminal_color_6 = '#5fd7d7'
vim.g.terminal_color_7 = '#d0d0d0'
vim.g.terminal_color_8 = '#5a5a5a'
vim.g.terminal_color_9 = '#ff8787'
vim.g.terminal_color_10 = '#afffaf'
vim.g.terminal_color_11 = '#ffd787'
vim.g.terminal_color_12 = '#87d7ff'
vim.g.terminal_color_13 = '#ffafff'
vim.g.terminal_color_14 = '#87ffff'
vim.g.terminal_color_15 = '#ffffff'
