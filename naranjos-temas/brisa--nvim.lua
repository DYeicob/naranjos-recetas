-- NaranjOS · tema Brisa (paquete naranjos-temas)
vim.cmd('highlight clear')
vim.o.background = 'dark'
vim.g.colors_name = 'naranjos'
local h = vim.api.nvim_set_hl
h(0, 'Normal', { fg = '#dfe7ef', bg = '#0b1016' })
h(0, 'NormalFloat', { fg = '#dfe7ef', bg = '#131b25' })
h(0, 'FloatBorder', { fg = '#3d9bff', bg = '#131b25' })
h(0, 'CursorLine', { bg = '#131b25' })
h(0, 'CursorLineNr', { fg = '#3d9bff' })
h(0, 'LineNr', { fg = '#7a8796' })
h(0, 'Visual', { bg = '#1f2a38' })
h(0, 'Search', { fg = '#0b1016', bg = '#8cc4ff' })
h(0, 'IncSearch', { fg = '#0b1016', bg = '#3d9bff' })
h(0, 'CurSearch', { fg = '#0b1016', bg = '#3d9bff' })
h(0, 'MatchParen', { fg = '#3d9bff', bg = '#1f2a38' })
h(0, 'Comment', { fg = '#7a8796' })
h(0, 'String', { fg = '#87d787' })
h(0, 'Character', { fg = '#87d787' })
h(0, 'Number', { fg = '#ffaf5f' })
h(0, 'Boolean', { fg = '#ffaf5f' })
h(0, 'Constant', { fg = '#ffaf5f' })
h(0, 'Function', { fg = '#3d9bff' })
h(0, 'Identifier', { fg = '#dfe7ef' })
h(0, 'Keyword', { fg = '#d787ff' })
h(0, 'Statement', { fg = '#d787ff' })
h(0, 'Conditional', { fg = '#d787ff' })
h(0, 'Repeat', { fg = '#d787ff' })
h(0, 'Operator', { fg = '#8cc4ff' })
h(0, 'Type', { fg = '#5fafff' })
h(0, 'Special', { fg = '#5fd7d7' })
h(0, 'PreProc', { fg = '#5fd7d7' })
h(0, 'Title', { fg = '#3d9bff' })
h(0, 'Directory', { fg = '#3d9bff' })
h(0, 'Pmenu', { fg = '#dfe7ef', bg = '#131b25' })
h(0, 'PmenuSel', { fg = '#0b1016', bg = '#3d9bff' })
h(0, 'StatusLine', { fg = '#dfe7ef', bg = '#131b25' })
h(0, 'StatusLineNC', { fg = '#7a8796', bg = '#131b25' })
h(0, 'WinSeparator', { fg = '#1f2a38' })
h(0, 'SignColumn', { bg = '#0b1016' })
h(0, 'Folded', { fg = '#7a8796', bg = '#131b25' })
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
h(0, 'TabLine', { fg = '#7a8796', bg = '#131b25' })
h(0, 'TabLineSel', { fg = '#0b1016', bg = '#3d9bff' })
h(0, 'TabLineFill', { bg = '#0b1016' })
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
