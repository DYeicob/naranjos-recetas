-- NaranjOS · tema Lima clara (paquete naranjos-temas)
vim.cmd('highlight clear')
vim.o.background = 'light'
vim.g.colors_name = 'naranjos'
local h = vim.api.nvim_set_hl
h(0, 'Normal', { fg = '#222a1d', bg = '#f5f8f0' })
h(0, 'NormalFloat', { fg = '#222a1d', bg = '#ffffff' })
h(0, 'FloatBorder', { fg = '#5e8f12', bg = '#ffffff' })
h(0, 'CursorLine', { bg = '#ffffff' })
h(0, 'CursorLineNr', { fg = '#5e8f12' })
h(0, 'LineNr', { fg = '#7a8570' })
h(0, 'Visual', { bg = '#dfe8d2' })
h(0, 'Search', { fg = '#f5f8f0', bg = '#8cbf3a' })
h(0, 'IncSearch', { fg = '#f5f8f0', bg = '#5e8f12' })
h(0, 'CurSearch', { fg = '#f5f8f0', bg = '#5e8f12' })
h(0, 'MatchParen', { fg = '#5e8f12', bg = '#dfe8d2' })
h(0, 'Comment', { fg = '#7a8570' })
h(0, 'String', { fg = '#3f8f3a' })
h(0, 'Character', { fg = '#3f8f3a' })
h(0, 'Number', { fg = '#b06a00' })
h(0, 'Boolean', { fg = '#b06a00' })
h(0, 'Constant', { fg = '#b06a00' })
h(0, 'Function', { fg = '#5e8f12' })
h(0, 'Identifier', { fg = '#222a1d' })
h(0, 'Keyword', { fg = '#8e44ad' })
h(0, 'Statement', { fg = '#8e44ad' })
h(0, 'Conditional', { fg = '#8e44ad' })
h(0, 'Repeat', { fg = '#8e44ad' })
h(0, 'Operator', { fg = '#8cbf3a' })
h(0, 'Type', { fg = '#2f6fb5' })
h(0, 'Special', { fg = '#1f8a8a' })
h(0, 'PreProc', { fg = '#1f8a8a' })
h(0, 'Title', { fg = '#5e8f12' })
h(0, 'Directory', { fg = '#5e8f12' })
h(0, 'Pmenu', { fg = '#222a1d', bg = '#ffffff' })
h(0, 'PmenuSel', { fg = '#f5f8f0', bg = '#5e8f12' })
h(0, 'StatusLine', { fg = '#222a1d', bg = '#ffffff' })
h(0, 'StatusLineNC', { fg = '#7a8570', bg = '#ffffff' })
h(0, 'WinSeparator', { fg = '#dfe8d2' })
h(0, 'SignColumn', { bg = '#f5f8f0' })
h(0, 'Folded', { fg = '#7a8570', bg = '#ffffff' })
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
h(0, 'TabLine', { fg = '#7a8570', bg = '#ffffff' })
h(0, 'TabLineSel', { fg = '#f5f8f0', bg = '#5e8f12' })
h(0, 'TabLineFill', { bg = '#f5f8f0' })
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
