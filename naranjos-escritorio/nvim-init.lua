-- NaranjOS · Neovim (~/.config/nvim/init.lua) — sencillo, rápido y con los colores del tema de NaranjOS.
-- Sin complementos que se bajen de internet: todo lo que ves viene con Neovim.
-- Para volver a esta versión: naranjos-restablece editor
local o, g, map = vim.opt, vim.g, vim.keymap.set
g.mapleader, g.maplocalleader = " ", " "

-- aspecto
o.number, o.relativenumber, o.cursorline = true, true, true
o.signcolumn, o.termguicolors, o.showmode = "yes", true, false
o.scrolloff, o.sidescrolloff = 6, 8
o.list, o.listchars = true, { tab = "» ", trail = "·", nbsp = "␣" }
o.fillchars = { eob = " " }
o.winborder = "rounded"

-- escribir
o.expandtab, o.shiftwidth, o.tabstop, o.smartindent = true, 2, 2, true
o.ignorecase, o.smartcase, o.inccommand = true, true, "split"
o.undofile, o.swapfile = true, false
o.mouse, o.clipboard = "a", "unnamedplus"      -- portapapeles del escritorio (wl-clipboard)
o.splitright, o.splitbelow = true, true
o.updatetime, o.timeoutlen = 250, 400

-- colores del tema de NaranjOS (cambian con naranjos-tema; al abrir Neovim)
local tema = vim.fn.expand("~/.config/naranjos/tema/nvim.lua")
if vim.fn.filereadable(tema) == 1 then pcall(dofile, tema) end

-- barra de estado propia: modo · fichero · posición
local modos = { n = "NORMAL", i = "INSERTAR", v = "VISUAL", V = "V-LÍNEA", ["\22"] = "V-BLOQUE",
                c = "ORDEN", R = "REEMPLAZAR", t = "TERMINAL", s = "SELECCIÓN" }
function _G.naranjos_estado()
  local m = modos[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode
  return table.concat({ "%#TabLineSel# ", m, " %#StatusLine# %f %m%r", "%=", "%y  %l:%c  %p%% " })
end
o.statusline = "%!v:lua.naranjos_estado()"

-- atajos (Espacio es la tecla «líder»)
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map({ "n", "i" }, "<C-s>", "<cmd>write<CR><Esc>", { desc = "Guardar" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Cerrar" })
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Explorador de ficheros" })
map("n", "<leader>f", ":find ", { desc = "Buscar fichero" })
map("n", "<leader>b", "<cmd>ls<CR>:buffer ", { desc = "Cambiar de fichero abierto" })
map("n", "<leader>t", "<cmd>split | terminal<CR>", { desc = "Terminal" })
map("n", "<C-h>", "<C-w>h"); map("n", "<C-j>", "<C-w>j"); map("n", "<C-k>", "<C-w>k"); map("n", "<C-l>", "<C-w>l")
map("v", "<", "<gv"); map("v", ">", ">gv")
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Salir del modo terminal" })
o.path:append("**")

-- resalta lo que copias y vuelve a la última posición del fichero
local grupo = vim.api.nvim_create_augroup("naranjos", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", { group = grupo, callback = function() vim.hl.on_yank({ timeout = 180 }) end })
vim.api.nvim_create_autocmd("BufReadPost", { group = grupo, callback = function()
  local m = vim.api.nvim_buf_get_mark(0, '"')
  if m[1] > 0 and m[1] <= vim.api.nvim_buf_line_count(0) then pcall(vim.api.nvim_win_set_cursor, 0, m) end
end })
-- resaltado con tree-sitter en los lenguajes que trae Neovim
vim.api.nvim_create_autocmd("FileType", { group = grupo, pattern = { "c", "lua", "vim", "help", "markdown", "query" },
  callback = function() pcall(vim.treesitter.start) end })

-- tu configuración extra (no se toca al actualizar NaranjOS)
local extra = vim.fn.stdpath("config") .. "/lua/mio.lua"
if vim.fn.filereadable(extra) == 1 then pcall(dofile, extra) end
