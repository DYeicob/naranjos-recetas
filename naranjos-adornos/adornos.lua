---- NaranjOS · adornos (paquete naranjos-adornos): barras de título, fondo en movimiento y escritura CJK ----
-- Lo carga naranjos.lua. Cada cosa se activa con su orden: naranjos-barras · naranjos-fondo-video · naranjos-escritura
local C = ((os and os.getenv and os.getenv("HOME")) or "") .. "/.config/naranjos/"
local function hay(n)
    if not io then return false end
    local f = io.open(C .. n, "r")
    if f then f:close(); return true end
    return false
end
local t = { fondo = "121212", acento = "ff8700", inactivo = "2a2a2a" }
do
    local ok, x = pcall(dofile, C .. "tema/hyprland.lua")
    if ok and type(x) == "table" then for k, v in pairs(x) do t[k] = v end end
end

-- Barras de título, solo en las ventanas flotantes (el complemento lo carga «naranjos-barras arranca»)
if hay("barras-activas") and hl.plugin and hl.plugin.hyprbars then
    hl.config({
        plugin = {
            hyprbars = {
                bar_height = 28,
                bar_color = "rgb(" .. t.fondo .. ")",
                ["col.text"] = "rgb(e6e6e6)",
                bar_text_font = "JetBrainsMono Nerd Font",
                bar_text_size = 11,
                bar_text_align = "left",
                bar_padding = 10,
                bar_button_padding = 8,
                bar_part_of_window = true,
                bar_precedence_over_border = true,
                inactive_button_color = "rgb(" .. t.inactivo .. ")",
                on_double_click = [[hyprctl dispatch 'hl.dsp.window.float({ action = "toggle" })']],
            },
        },
    })
    -- botones (de derecha a izquierda): cerrar · maximizar · minimizar
    hl.plugin.hyprbars.add_button({ bg_color = "rgb(ff5f5f)", fg_color = "rgb(" .. t.fondo .. ")", size = 14, icon = "",
        action = [[hyprctl dispatch 'hl.dsp.window.close()']] })
    hl.plugin.hyprbars.add_button({ bg_color = "rgb(" .. t.acento .. ")", fg_color = "rgb(" .. t.fondo .. ")", size = 14, icon = "",
        action = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']] })
    hl.plugin.hyprbars.add_button({ bg_color = "rgb(" .. t.inactivo .. ")", fg_color = "rgb(e6e6e6)", size = 14, icon = "",
        action = [[hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:minimizadas" })']] })
    hl.window_rule({ name = "barras-solo-flotantes", match = { float = false }, ["hyprbars:no_bar"] = true })
end

-- La animación al cambiar de tema (naranjos-fondo-video intro): encima de todo y a pantalla completa
hl.window_rule({ name = "intro-tema", match = { class = "^naranjos-intro$" }, fullscreen = true, pin = true, no_initial_focus = true })

-- Escritura en chino, japonés y coreano (fcitx5 por el protocolo de Wayland; Qt y SDL por su módulo)
if hay("escritura-activa") then
    hl.env("XMODIFIERS", "@im=fcitx")
    hl.env("QT_IM_MODULE", "fcitx")
    hl.env("SDL_IM_MODULE", "fcitx")
    hl.env("GLFW_IM_MODULE", "ibus")
end

hl.on("hyprland.start", function()
    hl.exec_cmd("naranjos-barras arranca")
    hl.exec_cmd("naranjos-fondo-video arranca")
    hl.exec_cmd("naranjos-escritura arranca")
end)
