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
-- los ficheros de ~/.config/naranjos que escriben las órdenes de NaranjOS (monitores, ventanas, complementos)
local function naranjos_carga(n)
    local f = (os and os.getenv and os.getenv("HOME") or "") .. "/.config/naranjos/" .. n
    local ok = pcall(dofile, f .. ".lua")
    if not ok and package and package.loaded then package.loaded[f] = nil; pcall(require, f) end
end
naranjos_carga("monitores")      -- naranjos-pantalla escala …

---- Entorno -----------------------------------------------------------
hl.env("XCURSOR_THEME", tema.cursor)
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

---- Al arrancar -------------------------------------------------------
hl.on("hyprland.start", function()
    -- con el inicio bonito (naranjos-inicio), la sesión nace bloqueada: lo primero, la pantalla de bloqueo
    if os and os.getenv and os.getenv("NARANJOS_BLOQUEO_INICIAL") then hl.exec_cmd("naranjos-bloqueo-inicial") end
    hl.exec_cmd("hyprctl setcursor " .. tema.cursor .. " 24")  -- cursor del tema
    hl.exec_cmd("hyprpaper")                                   -- fondo
    hl.exec_cmd("mako")                                        -- avisos
    hl.exec_cmd("hypridle")                                    -- bloqueo por inactividad
    hl.exec_cmd("naranjos-noche arranca")                      -- luz nocturna (hyprsunset)
    hl.exec_cmd("thunar --daemon")                             -- archivos al instante y USB al enchufarlos
    hl.exec_cmd("naranjos-pantalla prepara; command -v waybar >/dev/null && waybar")   -- barra
    hl.exec_cmd("naranjos-portapapeles vigila")               -- historial del portapapeles (Super + V)
    hl.exec_cmd("naranjos-ventanas vigila")                   -- cada aplicación vuelve a su escritorio
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
        kb_options = "shift:both_capslock",   -- las dos Mayús a la vez: Bloq Mayús
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
hl.bind(mainMod .. " + CTRL + SHIFT + T", hl.dsp.exec_cmd("naranjos-tema modo"))           -- claro / oscuro
hl.bind(mainMod .. " + V",             hl.dsp.exec_cmd("naranjos-portapapeles menu"))   -- portapapeles
hl.bind(mainMod .. " + period",        hl.dsp.exec_cmd("naranjos-emoji"))               -- emojis
hl.bind(mainMod .. " + CTRL + O",      hl.dsp.exec_cmd("naranjos-captura texto"))       -- copiar texto de la pantalla
hl.bind(mainMod .. " + CTRL + D",      hl.dsp.exec_cmd("naranjos-dictado"))             -- dictar
hl.bind(mainMod .. " + CTRL + R",      hl.dsp.exec_cmd("naranjos-recuerda menu"))       -- recordatorio
hl.bind(mainMod .. " + CTRL + P",      hl.dsp.exec_cmd("naranjos-pantalla menu"))       -- pantalla y barra
hl.bind(mainMod .. " + CTRL + C",      hl.dsp.exec_cmd("naranjos-despierto"))           -- mantener despierto
hl.bind(mainMod .. " + SHIFT + A",     hl.dsp.exec_cmd("naranjos-apps"))                -- apps recomendadas
hl.bind("ALT + Print",                 hl.dsp.exec_cmd("naranjos-captura video region"))   -- grabar una zona
hl.bind("ALT + SHIFT + Print",         hl.dsp.exec_cmd("naranjos-captura video pantalla")) -- grabar la pantalla
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
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i, on_current_monitor = true }))
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
    name  = "salvapantallas",
    match = { class = "^naranjos-salvapantallas$" },
    fullscreen = true,
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


---- Fase 6q: lo que trae Omarchy 4.5, a la manera de NaranjOS ----------
-- Disposición de cada escritorio: mosaico → desplazable → flotante (Super + Ctrl + L; Super + Alt + L al revés)
local disposiciones = { "dwindle", "scrolling", "flotante" }
local disp_de, flotantes = {}, {}
local escritorio = false
do
    local f = (os and os.getenv and os.getenv("HOME") or "") .. "/.config/naranjos/disposicion.lua"
    local ok, t = pcall(dofile, f)
    if ok and type(t) == "table" and t.escritorio then escritorio = true end
end
local function flota(w, si)
    if w and w.address then
        pcall(hl.dispatch, hl.dsp.window.float({ action = si and "enable" or "disable", window = "address:" .. w.address }))
    end
end
local function pon_disposicion(ws, i)
    local n = disposiciones[i]
    disp_de[ws.name] = i
    if n == "flotante" then
        flotantes[ws.name] = true
        for _, w in ipairs(hl.get_workspace_windows(ws) or {}) do flota(w, true) end
    else
        if flotantes[ws.name] then
            flotantes[ws.name] = nil
            for _, w in ipairs(hl.get_workspace_windows(ws) or {}) do flota(w, false) end
        end
        hl.workspace_rule({ workspace = tostring(ws.name), layout = n })
    end
    hl.exec_cmd("naranjos-disposicion avisa " .. n)
end
local function cambia(paso)
    return function()
        local ok, ws = pcall(hl.get_active_workspace)
        if not ok or not ws then return end
        local i = ((disp_de[ws.name] or 1) - 1 + paso) % #disposiciones + 1
        pcall(pon_disposicion, ws, i)
    end
end
hl.bind(mainMod .. " + CTRL + L", cambia(1))
hl.bind(mainMod .. " + ALT + L",  cambia(-1))
hl.on("window.open", function(w)
    local ok, ws = pcall(hl.get_active_workspace)
    if escritorio or (ok and ws and flotantes[ws.name]) then flota(w, true) end
end)

-- Minimizar al dock (Super + M) y traer de vuelta (Super + Shift + M)
hl.bind(mainMod .. " + M", function()
    local w = hl.get_active_window()
    if w and w.address then
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimizadas", window = "address:" .. w.address, follow = false }))
    end
end)
hl.bind(mainMod .. " + SHIFT + M",  hl.dsp.exec_cmd("naranjos-dock minimizadas"))
hl.bind(mainMod .. " + ALT + D",    hl.dsp.exec_cmd("naranjos-dock alterna"))
hl.bind(mainMod .. " + ALT + A",    hl.dsp.exec_cmd("naranjos-apariencia menu"))

-- Mover la ventana a otra pantalla
hl.bind(mainMod .. " + SHIFT + CTRL + left",  hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + SHIFT + CTRL + right", hl.dsp.window.move({ monitor = "r" }))
hl.bind(mainMod .. " + SHIFT + CTRL + up",    hl.dsp.window.move({ monitor = "u" }))
hl.bind(mainMod .. " + SHIFT + CTRL + down",  hl.dsp.window.move({ monitor = "d" }))

-- Notificaciones
hl.bind(mainMod .. " + comma",                 hl.dsp.exec_cmd("naranjos-notificaciones ultima"))
hl.bind(mainMod .. " + CTRL + comma",          hl.dsp.exec_cmd("naranjos-notificaciones menu"))
hl.bind(mainMod .. " + ALT + comma",           hl.dsp.exec_cmd("naranjos-notificaciones descarta"))
hl.bind(mainMod .. " + CTRL + ALT + comma",    hl.dsp.exec_cmd("naranjos-notificaciones nomolestar"))
hl.bind(mainMod .. " + SHIFT + ALT + comma",   hl.dsp.exec_cmd("naranjos-notificaciones historial"))

-- Paneles rápidos (Super + Ctrl + 1…5) y más
hl.bind(mainMod .. " + CTRL + 1", hl.dsp.exec_cmd("naranjos-red-panel"))
hl.bind(mainMod .. " + CTRL + 2", hl.dsp.exec_cmd("naranjos-tui bluetooth"))
hl.bind(mainMod .. " + CTRL + 3", hl.dsp.exec_cmd("naranjos-tui sonido"))
hl.bind(mainMod .. " + CTRL + 4", hl.dsp.exec_cmd("naranjos-energia menu"))
hl.bind(mainMod .. " + CTRL + 5", hl.dsp.exec_cmd("naranjos-notificaciones menu"))
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd("naranjos-energia menu"))
hl.bind(mainMod .. " + CTRL + ALT + E", hl.dsp.exec_cmd("naranjos-reloj ver"))
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd("naranjos-qr lee"))
hl.bind(mainMod .. " + CTRL + M", hl.dsp.exec_cmd("naranjos-camara graba"))
hl.bind(mainMod .. " + CTRL + ALT + M", hl.dsp.exec_cmd("naranjos-camara encima"))
hl.bind(mainMod .. " + ALT + K", hl.dsp.exec_cmd("naranjos-atajos tmux"))
hl.bind(mainMod .. " + ALT + Home", hl.dsp.exec_cmd("naranjos-anchos guarda"))
hl.bind(mainMod .. " + Home",       hl.dsp.exec_cmd("naranjos-anchos restaura"))

-- Música (MPRIS) — también para teclados que solo tienen «play»
hl.bind("XF86AudioPlay",          hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",         hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",          hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",          hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("SHIFT + XF86AudioPlay",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("CTRL + XF86AudioPlay",   hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
-- Luz del teclado: Ctrl + teclas de brillo
hl.bind("CTRL + XF86MonBrightnessUp",   hl.dsp.exec_cmd("naranjos-osd teclado +"), { locked = true })
hl.bind("CTRL + XF86MonBrightnessDown", hl.dsp.exec_cmd("naranjos-osd teclado -"), { locked = true })

-- Al entrar: el dock (si lo activaste), los avisos de programas colgados y el aviso de atajos la primera vez
hl.on("hyprland.start", function()
    hl.exec_cmd("naranjos-dock arranca")
    hl.exec_cmd("naranjos-cuelgues vigila")
    hl.exec_cmd("naranjos-notificaciones bienvenida")
end)
naranjos_carga("apariencia")     -- naranjos-apariencia (transparencia, esquinas, animaciones)
hl.window_rule({
    name  = "camara-encima",
    match = { class = "^org.gnome.Snapshot$" },
    float = true, pin = true, size = "360 270", move = "100%-380 100%-300", no_initial_focus = true,
})
naranjos_carga("espejo")         -- naranjos-pantalla espejo

---- Lo tuyo hecho con las órdenes de NaranjOS -------------------------
naranjos_carga("ventanas")       -- naranjos-ventanas
naranjos_carga("complementos")   -- naranjos-complementos
