-- =====================================================================
--  NaranjOS · configuración base de Hyprland
--  /usr/share/naranjos/hypr/naranjos.lua  (paquete naranjos-escritorio)
--
--  NO edites este fichero: se actualiza con el sistema.
--  Tus cambios van en ~/.config/hypr/hyprland.lua, DEBAJO del require.
--  Manual: naranjos-ayuda   ·   Atajos en pantalla: Super + K
-- =====================================================================

local terminal = "foot"
local menu     = "naranjos-menu"   -- el menú de NaranjOS (apps, ajustes, temas…)
local mainMod  = "SUPER"   -- la tecla de Windows

---- Aspecto: los colores del tema (naranjos-tema · Super + Ctrl + T) -----
local tema = { fondo = "121212", acento = "ff8700", acento2 = "ffaf5f", inactivo = "2a2a2a", sombra = "ee0a0a0a", cursor = "NaranjOS" }
do
    local base = (os and os.getenv and os.getenv("HOME") or "") .. "/.config/naranjos/tema/hyprland"
    local ok, t = pcall(dofile, base .. ".lua")
    if not ok and package and package.loaded then   -- sin dofile: require (sin caché, por si cambió de tema)
        package.loaded[base] = nil
        ok, t = pcall(require, base)
    end
    if ok and type(t) == "table" then for c, v in pairs(t) do tema[c] = v end end
end

---- Pantallas ---------------------------------------------------------
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

---- Entorno -----------------------------------------------------------
hl.env("XCURSOR_THEME", tema.cursor)
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

---- Al arrancar -------------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl setcursor " .. tema.cursor .. " 24")  -- cursor del tema
    hl.exec_cmd("hyprpaper")                                   -- fondo
    hl.exec_cmd("mako")                                        -- avisos
    hl.exec_cmd("hypridle")                                    -- bloqueo por inactividad
    hl.exec_cmd("naranjos-noche arranca")                      -- luz nocturna (hyprsunset)
    hl.exec_cmd("thunar --daemon")                             -- archivos al instante y USB al enchufarlos
    hl.exec_cmd("command -v waybar >/dev/null && waybar")      -- barra (llega en la tanda 5c2)
end)

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(" .. tema.acento .. "ff)", "rgba(" .. tema.acento2 .. "ff)"}, angle = 45 },
            inactive_border = "rgba(" .. tema.inactivo .. "ff)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.96,
        shadow = {
            enabled      = true,
            range        = 8,
            render_power = 3,
            color        = tonumber("0x" .. tema.sombra),
        },
        blur = {
            enabled  = true,
            size     = 4,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },

    animations = { enabled = true },

    misc = {
        force_default_wallpaper  = 0,       -- sin fondos de Hyprland
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        background_color         = tonumber("0xff" .. tema.fondo),
    },

    ecosystem = {
        no_update_news   = true,
        no_donation_nag  = true,
    },

    dwindle = { preserve_split = true },

    input = {
        kb_layout  = "es",
        follow_mouse = 1,
        numlock_by_default = true,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
        },
    },
})

---- Animaciones (las de Hyprland) ----------------------------------------
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, damping = 24.21279333 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

---- Gestos del touchpad: 3 dedos a los lados = cambiar de escritorio -----
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

---- ATAJOS (resumen en pantalla: Super + K) ----------------------------
-- Aplicaciones
hl.bind(mainMod .. " + Return",        hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + space",         hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + ALT + space",   hl.dsp.exec_cmd("fuzzel"))                         -- solo aplicaciones
hl.bind(mainMod .. " + CTRL + space",  hl.dsp.exec_cmd("naranjos-tema fondo siguiente"))  -- otro fondo
hl.bind(mainMod .. " + CTRL + N",      hl.dsp.exec_cmd("naranjos-noche menu"))            -- luz nocturna
hl.bind(mainMod .. " + B",             hl.dsp.exec_cmd("naranjos-navegador"))
hl.bind(mainMod .. " + E",             hl.dsp.exec_cmd("thunar"))                          -- archivos
hl.bind(mainMod .. " + K",             hl.dsp.exec_cmd("naranjos-atajos"))
hl.bind(mainMod .. " + H",             hl.dsp.exec_cmd("naranjos-ayuda"))
hl.bind(mainMod .. " + SHIFT + B",     hl.dsp.exec_cmd("pkill -SIGUSR1 waybar || waybar"))
hl.bind(mainMod .. " + CTRL + W",      hl.dsp.exec_cmd("naranjos-tui wifi"))
hl.bind(mainMod .. " + CTRL + B",      hl.dsp.exec_cmd("naranjos-tui bluetooth"))
hl.bind(mainMod .. " + CTRL + A",      hl.dsp.exec_cmd("naranjos-tui sonido"))
hl.bind(mainMod .. " + CTRL + S",      hl.dsp.exec_cmd("naranjos-tui seguridad"))
hl.bind(mainMod .. " + CTRL + V",      hl.dsp.exec_cmd("naranjos-tui vpn"))
hl.bind(mainMod .. " + CTRL + U",      hl.dsp.exec_cmd("naranjos-tui usb"))
hl.bind(mainMod .. " + CTRL + I",      hl.dsp.exec_cmd("naranjos-idioma menu"))
hl.bind(mainMod .. " + CTRL + T",      hl.dsp.exec_cmd("naranjos-tema menu"))
-- Ventanas
hl.bind(mainMod .. " + W",             hl.dsp.window.close())
hl.bind(mainMod .. " + F",             hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F",     hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + T",             hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",             hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",             hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + left",          hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",         hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",            hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",          hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + mouse:272",     hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",     hl.dsp.window.resize(), { mouse = true })
-- Escritorios 1-10 (la tecla 0 es el 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + mouse_down",    hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",      hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + S",             hl.dsp.workspace.toggle_special("cajon"))
hl.bind(mainMod .. " + ALT + S",       hl.dsp.window.move({ workspace = "special:cajon" }))
-- Capturas (como en Windows: Super + Shift + S)
hl.bind(mainMod .. " + SHIFT + S",     hl.dsp.exec_cmd("naranjos-captura region"))
hl.bind("Print",                       hl.dsp.exec_cmd("naranjos-captura region"))
hl.bind("SHIFT + Print",               hl.dsp.exec_cmd("naranjos-captura pantalla"))
-- Sistema
hl.bind(mainMod .. " + L",             hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
hl.bind(mainMod .. " + Escape",        hl.dsp.exec_cmd("naranjos-sistema"))
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + R",     hl.dsp.exec_cmd("hyprctl reload"))
-- Teclas multimedia del portátil (el volumen funcionará con PipeWire, tanda 5c3)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("naranjos-osd volumen +5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("naranjos-osd volumen -5"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("naranjos-osd volumen silencio"),     { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("naranjos-osd micro"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("naranjos-osd brillo +5"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("naranjos-osd brillo -5"),                  { locked = true, repeating = true })

---- Reglas de ventanas -------------------------------------------------
hl.window_rule({
    name  = "menus-naranjos",
    match = { class = "^naranjos-tui$" },
    float  = true,
    size   = "960 620",
    center = true,
})
hl.window_rule({
    name  = "ignorar-maximizar",
    match = { class = ".*" },
    suppress_event = "maximize",
})
hl.window_rule({
    name  = "arreglo-arrastre-xwayland",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})
