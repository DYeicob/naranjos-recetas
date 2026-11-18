-- ~/.config/hypr/hyprland.lua · tu configuración de Hyprland en NaranjOS
--
-- 1) Primero se carga la base de NaranjOS (se actualiza con el sistema):
require("/usr/share/naranjos/hypr/naranjos")

-- 2) Debajo, tus cambios. Lo que pongas aquí manda sobre la base. Ejemplos:
--
-- Dos distribuciones de teclado (Alt+Shift para cambiar):
-- hl.config({ input = { kb_layout = "es,us", kb_options = "grp:alt_shift_toggle" } })
--
-- Un atajo propio:
-- hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
--
-- Manual completo: naranjos-ayuda   ·   Atajos: Super + K
