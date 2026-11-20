-- ~/.config/hypr/hyprland.lua · tu configuración de Hyprland en NaranjOS
--
-- 1) Primero se carga la base de NaranjOS (se actualiza con el sistema).
--    Si justo se está actualizando y aún no se puede leer, quedan unos atajos mínimos
--    (Super + Enter terminal, Super + Escape menú, Super + Shift + R recargar)
--    hasta que zumo termina y recarga el escritorio él solo.
local cargada = pcall(require, "/usr/share/naranjos/hypr/naranjos")
if not cargada then
  hl.bind("SUPER + Return",    hl.dsp.exec_cmd("foot"))
  hl.bind("SUPER + Escape",    hl.dsp.exec_cmd("naranjos-sistema"))
  hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
end

-- 2) Debajo, tus cambios. Lo que pongas aquí manda sobre la base. Ejemplos:
--
-- Dos distribuciones de teclado (Alt+Shift para cambiar):
-- hl.config({ input = { kb_layout = "es,us", kb_options = "grp:alt_shift_toggle" } })
--
-- Un atajo propio:
-- hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
--
-- Manual completo: naranjos-ayuda   ·   Atajos: Super + K
