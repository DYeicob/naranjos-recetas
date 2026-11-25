-- NaranjOS · tema Azahar (paquete naranjos-temas)
vim.cmd('highlight clear')
vim.o.background = 'light'
vim.g.colors_name = 'naranjos'
local h = vim.api.nvim_set_hl
h(0, 'Normal', { fg = '#2b2522', bg = '#faf6ef' })
h(0, 'NormalFloat', { fg = '#2b2522', bg = '#ffffff' })
h(0, 'FloatBorder', { fg = '#e07000', bg = '#ffffff' })
h(0, 'CursorLine', { bg = '#ffffff' })
h(0, 'CursorLineNr', { fg = '#e07000' })
h(0, 'LineNr', { fg = '#8a8076' })
h(0, 'Visual', { bg = '#e4dccf' })
h(0, 'Search', { fg = '#faf6ef', bg = '#f2a541' })
h(0, 'IncSearch', { fg = '#faf6ef', bg = '#e07000' })
h(0, 'CurSearch', { fg = '#faf6ef', bg = '#e07000' })
h(0, 'MatchParen', { fg = '#e07000', bg = '#e4dccf' })
h(0, 'Comment', { fg = '#8a8076' })
h(0, 'String', { fg = '#3f8f3a' })
h(0, 'Character', { fg = '#3f8f3a' })
h(0, 'Number', { fg = '#b06a00' })
h(0, 'Boolean', { fg = '#b06a00' })
h(0, 'Constant', { fg = '#b06a00' })
h(0, 'Function', { fg = '#e07000' })
h(0, 'Identifier', { fg = '#2b2522' })
h(0, 'Keyword', { fg = '#8e44ad' })
h(0, 'Statement', { fg = '#8e44ad' })
h(0, 'Conditional', { fg = '#8e44ad' })
h(0, 'Repeat', { fg = '#8e44ad' })
h(0, 'Operator', { fg = '#f2a541' })
h(0, 'Type', { fg = '#2f6fb5' })
h(0, 'Special', { fg = '#1f8a8a' })
h(0, 'PreProc', { fg = '#1f8a8a' })
h(0, 'Title', { fg = '#e07000' })
h(0, 'Directory', { fg = '#e07000' })
h(0, 'Pmenu', { fg = '#2b2522', bg = '#ffffff' })
h(0, 'PmenuSel', { fg = '#faf6ef', bg = '#e07000' })
h(0, 'StatusLine', { fg = '#2b2522', bg = '#ffffff' })
h(0, 'StatusLineNC', { fg = '#8a8076', bg = '#ffffff' })
h(0, 'WinSeparator', { fg = '#e4dccf' })
h(0, 'SignColumn', { bg = '#faf6ef' })
h(0, 'Folded', { fg = '#8a8076', bg = '#ffffff' })
h(0, 'DiagnosticError', { fg = '#c8323a' })
h(0, 'DiagnosticWarn', { fg = '#b07d00' })
h(0, 'DiagnosticInfo', { fg = '#2f6fb5' })
h(0, 'DiagnosticHint', { fg = '#1f8a8a' })
h(0, 'DiagnosticOk', { fg = '#3f8f3a' })
h(0, 'DiffAdd', { fg = '#3f8f3a' })
h(0, 'DiffDelete', { fg = '#c8323a' })
h(0, 'DiffChange', { fg = '#b07d00' })
h(0, 'ErrorMsg', { fg = '#c8323a' })
h(0, 'WarningMsg', { fg = '#b07d00' })
h(0, 'TabLine', { fg = '#8a8076', bg = '#ffffff' })
h(0, 'TabLineSel', { fg = '#faf6ef', bg = '#e07000' })
h(0, 'TabLineFill', { bg = '#faf6ef' })
vim.g.terminal_color_0 = '#2b2522'
vim.g.terminal_color_1 = '#c8323a'
vim.g.terminal_color_2 = '#3f8f3a'
vim.g.terminal_color_3 = '#b06a00'
vim.g.terminal_color_4 = '#2f6fb5'
vim.g.terminal_color_5 = '#8e44ad'
vim.g.terminal_color_6 = '#1f8a8a'
vim.g.terminal_color_7 = '#d8d0c4'
vim.g.terminal_color_8 = '#6e655c'
vim.g.terminal_color_9 = '#e0484f'
vim.g.terminal_color_10 = '#52a84c'
vim.g.terminal_color_11 = '#d08a10'
vim.g.terminal_color_12 = '#4a8ad4'
vim.g.terminal_color_13 = '#a95fc4'
vim.g.terminal_color_14 = '#2fa5a5'
vim.g.terminal_color_15 = '#ffffff'
