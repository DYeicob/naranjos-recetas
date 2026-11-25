#!/usr/bin/env python3
# NaranjOS · generador de temas (lo usa «naranjos-tema crea»): crea un tema cítrico a partir de un color
#   tema-generador.py <carpeta-destino> <id> "<Nombre>" <color-hex> [claro]
import sys, re, pathlib, hashlib, shutil
# --- paletas (hex sin #) --------------------------------------------------------------------------
P = {
  "naranja":  dict(nombre="Naranja",  fondo="121212", sup="1e1e1e", texto="e6e6e6", apagado="8a8a8a", acento="ff8700", acento2="ffaf5f", inactivo="2a2a2a"),
  "sanguina": dict(nombre="Sanguina", fondo="140c0c", sup="1f1414", texto="eadede", apagado="8f7f7f", acento="e0393e", acento2="ff7a6b", inactivo="2e1c1c"),
  "lima":     dict(nombre="Lima",     fondo="0f130d", sup="182014", texto="e2eadb", apagado="808a78", acento="9ccc2c", acento2="c6e66b", inactivo="24301d"),
  "pomelo":   dict(nombre="Pomelo",   fondo="151012", sup="21181b", texto="ecdfe3", apagado="8f8086", acento="ff6f91", acento2="ffa3b8", inactivo="32242a"),
  "limon":    dict(nombre="Limón",    fondo="12110a", sup="1d1b10", texto="ecebd9", apagado="8a8770", acento="f2d200", acento2="fff07a", inactivo="2e2b18"),
  "brisa":    dict(nombre="Brisa",    fondo="0b1016", sup="131b25", texto="dfe7ef", apagado="7a8796", acento="3d9bff", acento2="8cc4ff", inactivo="1f2a38"),
  "azahar":   dict(nombre="Azahar",   fondo="faf6ef", sup="ffffff", texto="2b2522", apagado="8a8076", acento="e07000", acento2="f2a541", inactivo="e4dccf", claro=1),
  # (6o) versión clara de cada cítrico; la de Naranja es Azahar
  "sanguina-claro": dict(nombre="Sanguina clara", fondo="fbf4f4", sup="ffffff", texto="2a2122", apagado="8a7878", acento="c62a30", acento2="e8676b", inactivo="ecdcdc", claro=1),
  "lima-claro":     dict(nombre="Lima clara",     fondo="f5f8f0", sup="ffffff", texto="222a1d", apagado="7a8570", acento="5e8f12", acento2="8cbf3a", inactivo="dfe8d2", claro=1),
  "pomelo-claro":   dict(nombre="Pomelo claro",   fondo="fbf3f5", sup="ffffff", texto="2b2226", apagado="8a7a80", acento="d63e66", acento2="f2809d", inactivo="eedae0", claro=1),
  "limon-claro":    dict(nombre="Limón claro",    fondo="fbf9ec", sup="ffffff", texto="2b2a1f", apagado="88846c", acento="a68a00", acento2="d9b800", inactivo="ece7cc", claro=1),
  "brisa-claro":    dict(nombre="Brisa clara",    fondo="f2f6fb", sup="ffffff", texto="1f2630", apagado="727f8f", acento="1f6fd1", acento2="5c9ae6", inactivo="d9e3ef", claro=1),
}
def base(t): return t[:-6] if t.endswith("-claro") else t
MAL, BIEN, AVISO = "ff5f5f", "87d787", "ffd75f"
MAL_C, BIEN_C, AVISO_C = "c8323a", "3f8f3a", "b07d00"   # en el tema claro
ANSI_OSCURO = dict(regular0="1e1e1e", regular1="ff5f5f", regular2="87d787", regular3="ffaf5f", regular4="5fafff",
                   regular5="d787ff", regular6="5fd7d7", regular7="d0d0d0", bright0="5a5a5a", bright1="ff8787",
                   bright2="afffaf", bright3="ffd787", bright4="87d7ff", bright5="ffafff", bright6="87ffff", bright7="ffffff")
ANSI_CLARO = dict(regular0="2b2522", regular1="c8323a", regular2="3f8f3a", regular3="b06a00", regular4="2f6fb5",
                  regular5="8e44ad", regular6="1f8a8a", regular7="d8d0c4", bright0="6e655c", bright1="e0484f",
                  bright2="52a84c", bright3="d08a10", bright4="4a8ad4", bright5="a95fc4", bright6="2fa5a5", bright7="ffffff")

def rgb(h): return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def cursor_de(t):
    t = base(t)
    return "NaranjOS" if t in ("naranja", "azahar") else f"NaranjOS-{t}"
def fondo_de(t):
    t = base(t)
    return "/usr/share/backgrounds/naranjos/naranjos-01.jpg" if t == "naranja" else f"/usr/share/backgrounds/naranjos/temas/{t}/naranjos-01.jpg"
def bloqueo_de(t):
    t = base(t)
    return "/usr/share/backgrounds/naranjos/naranjos-bloqueo.jpg" if t == "naranja" else f"/usr/share/backgrounds/naranjos/temas/{t}/naranjos-bloqueo.jpg"

def apps_tema(t, p, claro, mal, bien, aviso):
    """(6o) los 24 colores del tema también en btop, Neovim y VS Code"""
    a = list((ANSI_CLARO if claro else ANSI_OSCURO).values())
    c = dict(p); c.update(mal=mal, bien=bien, aviso=aviso)
    cab = f"NaranjOS · tema {p['nombre']} (paquete naranjos-temas)"
    f = {}
    bt = dict(main_bg=c["fondo"], main_fg=c["texto"], title=c["texto"], hi_fg=c["acento"], selected_bg=c["inactivo"],
              selected_fg=c["acento"], inactive_fg=c["apagado"], graph_text=c["apagado"], meter_bg=c["inactivo"],
              proc_misc=c["acento2"], cpu_box=c["acento"], mem_box=c["acento"], net_box=c["acento"], proc_box=c["acento"],
              div_line=c["inactivo"], temp_start=c["bien"], temp_mid=c["aviso"], temp_end=c["mal"],
              cpu_start=c["acento2"], cpu_mid=c["acento"], cpu_end=c["mal"], free_start=c["bien"], free_mid=c["bien"], free_end=c["bien"],
              cached_start=c["acento2"], cached_mid=c["acento2"], cached_end=c["acento2"], available_start=c["aviso"],
              available_mid=c["aviso"], available_end=c["aviso"], used_start=c["acento"], used_mid=c["acento"], used_end=c["mal"],
              download_start=c["acento2"], download_mid=c["acento"], download_end=c["mal"], upload_start=c["acento2"],
              upload_mid=c["acento"], upload_end=c["mal"], process_start=c["acento2"], process_mid=c["acento"], process_end=c["mal"])
    f["btop.theme"] = f"# {cab}\n" + "".join(f'theme[{k}]="#{v}"\n' for k, v in bt.items())
    hl = {"Normal": (c["texto"], c["fondo"]), "NormalFloat": (c["texto"], c["sup"]), "FloatBorder": (c["acento"], c["sup"]),
          "CursorLine": (None, c["sup"]), "CursorLineNr": (c["acento"], None), "LineNr": (c["apagado"], None),
          "Visual": (None, c["inactivo"]), "Search": (c["fondo"], c["acento2"]), "IncSearch": (c["fondo"], c["acento"]),
          "CurSearch": (c["fondo"], c["acento"]), "MatchParen": (c["acento"], c["inactivo"]), "Comment": (c["apagado"], None),
          "String": (a[2], None), "Character": (a[2], None), "Number": (a[3], None), "Boolean": (a[3], None),
          "Constant": (a[3], None), "Function": (c["acento"], None), "Identifier": (c["texto"], None),
          "Keyword": (a[5], None), "Statement": (a[5], None), "Conditional": (a[5], None), "Repeat": (a[5], None),
          "Operator": (c["acento2"], None), "Type": (a[4], None), "Special": (a[6], None), "PreProc": (a[6], None),
          "Title": (c["acento"], None), "Directory": (c["acento"], None), "Pmenu": (c["texto"], c["sup"]),
          "PmenuSel": (c["fondo"], c["acento"]), "StatusLine": (c["texto"], c["sup"]), "StatusLineNC": (c["apagado"], c["sup"]),
          "WinSeparator": (c["inactivo"], None), "SignColumn": (None, c["fondo"]), "Folded": (c["apagado"], c["sup"]),
          "DiagnosticError": (c["mal"], None), "DiagnosticWarn": (c["aviso"], None), "DiagnosticInfo": (a[4], None),
          "DiagnosticHint": (a[6], None), "DiagnosticOk": (c["bien"], None), "DiffAdd": (c["bien"], None),
          "DiffDelete": (c["mal"], None), "DiffChange": (c["aviso"], None), "ErrorMsg": (c["mal"], None),
          "WarningMsg": (c["aviso"], None), "TabLine": (c["apagado"], c["sup"]), "TabLineSel": (c["fondo"], c["acento"]),
          "TabLineFill": (None, c["fondo"])}
    l = [f"-- {cab}", "vim.cmd('highlight clear')", f"vim.o.background = '{'light' if claro else 'dark'}'",
         "vim.g.colors_name = 'naranjos'", "local h = vim.api.nvim_set_hl"]
    for g, (fg, bg) in hl.items():
        partes = []
        if fg: partes.append("fg = '#%s'" % fg)
        if bg: partes.append("bg = '#%s'" % bg)
        l.append("h(0, '%s', { %s })" % (g, ", ".join(partes)))
    l += [f"vim.g.terminal_color_{i} = '#{v}'" for i, v in enumerate(a)]
    f["nvim.lua"] = "\n".join(l) + "\n"
    import json as _j
    vs = {"name": f"NaranjOS {p['nombre']}", "type": "light" if claro else "dark",
          "colors": {"editor.background": "#" + c["fondo"], "editor.foreground": "#" + c["texto"],
                     "editorLineNumber.foreground": "#" + c["apagado"], "editorLineNumber.activeForeground": "#" + c["acento"],
                     "editorCursor.foreground": "#" + c["acento"], "editor.selectionBackground": "#" + c["inactivo"],
                     "editor.lineHighlightBackground": "#" + c["sup"], "sideBar.background": "#" + c["sup"],
                     "activityBar.background": "#" + c["fondo"], "activityBarBadge.background": "#" + c["acento"],
                     "statusBar.background": "#" + c["sup"], "statusBar.foreground": "#" + c["texto"],
                     "titleBar.activeBackground": "#" + c["fondo"], "tab.activeBorder": "#" + c["acento"],
                     "focusBorder": "#" + c["acento"], "button.background": "#" + c["acento"], "button.foreground": "#" + c["fondo"],
                     "terminal.background": "#" + c["fondo"], "terminal.foreground": "#" + c["texto"],
                     **{f"terminal.ansi{n}": "#" + a[i] for i, n in enumerate(("Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White",
                        "BrightBlack", "BrightRed", "BrightGreen", "BrightYellow", "BrightBlue", "BrightMagenta", "BrightCyan", "BrightWhite"))}},
          "tokenColors": [{"scope": s, "settings": {"foreground": "#" + col}} for s, col in (
              ("comment", c["apagado"]), ("string", a[2]), ("constant.numeric", a[3]), ("constant", a[3]), ("keyword", a[5]),
              ("storage", a[5]), ("entity.name.function", c["acento"]), ("support.function", c["acento"]),
              ("entity.name.type", a[4]), ("support.type", a[4]), ("variable", c["texto"]), ("keyword.operator", c["acento2"]),
              ("entity.name.tag", c["acento"]), ("entity.other.attribute-name", a[6]))]}
    f["vscode.json"] = _j.dumps(vs, indent=1, ensure_ascii=False) + "\n"
    return f

def ficheros_tema(t, p):
    claro = p.get("claro", 0)
    mal, bien, aviso = (MAL_C, BIEN_C, AVISO_C) if claro else (MAL, BIEN, AVISO)
    f = {}
    cab = f"NaranjOS · tema {p['nombre']} (paquete naranjos-temas; NO lo edites: cambia de tema con naranjos-tema)"
    f["colores"] = "\n".join([f"# {cab}", f'NOMBRE="{p["nombre"]}"', f"CLARO={claro}",
        f"FONDO={fondo_de(t)}", f"BLOQUEO={bloqueo_de(t)}", f"CURSOR={cursor_de(t)}", f"ICONOS=NaranjOS-iconos-{t}",
        *[f"COLOR_{k.upper()}={v}" for k, v in p.items() if k not in ("nombre", "claro")],
        f"COLOR_MAL={mal}", f"COLOR_BIEN={bien}", f"COLOR_AVISO={aviso}",
        *[f"COLOR_ANSI{i}={v}" for i, v in enumerate((ANSI_CLARO if claro else ANSI_OSCURO).values())], ""])
    f.update(apps_tema(t, p, claro, mal, bien, aviso))
    f["hyprland.lua"] = (f"-- {cab}\nreturn {{\n  fondo = \"{p['fondo']}\", acento = \"{p['acento']}\", acento2 = \"{p['acento2']}\",\n"
                         f"  inactivo = \"{p['inactivo']}\", sombra = \"{'33000000' if claro else 'ee0a0a0a'}\", cursor = \"{cursor_de(t)}\",\n}}\n")
    r, g, b = rgb(p["fondo"]); ar, ag, ab = rgb(p["acento"])
    f["waybar.css"] = (f"/* {cab} */\n"
        f"@define-color fondo #{p['fondo']};\n@define-color superficie #{p['sup']};\n@define-color texto #{p['texto']};\n"
        f"@define-color apagado #{p['apagado']};\n@define-color acento #{p['acento']};\n@define-color acento2 #{p['acento2']};\n"
        f"@define-color inactivo #{p['inactivo']};\n@define-color mal #{mal};\n@define-color bien #{bien};\n@define-color aviso #{aviso};\n"
        f"@define-color fondo_barra rgba({r}, {g}, {b}, 0.90);\n@define-color borde_barra rgba({ar}, {ag}, {ab}, 0.55);\n")
    f["fuzzel.ini"] = (f"# {cab}\n[colors]\nbackground={p['fondo']}f2\ntext={p['texto']}ff\nprompt={p['acento']}ff\n"
        f"input={p['texto']}ff\nplaceholder={p['apagado']}ff\nmatch={p['acento']}ff\nselection={p['inactivo']}ff\n"
        f"selection-text={'000000' if claro else 'ffffff'}ff\nselection-match={p['acento2'] if not claro else p['acento']}ff\nborder={p['acento']}ff\n")
    f["mako.conf"] = (f"# {cab}\nbackground-color=#{p['fondo']}f0\ntext-color=#{p['texto']}\nborder-color=#{p['acento']}\n"
        f"progress-color=over #{p['acento']}\n")
    ansi = ANSI_CLARO if claro else ANSI_OSCURO
    f["foot.ini"] = (f"# {cab}\n[colors-dark]\nalpha=0.96\nbackground={p['fondo']}\nforeground={p['texto']}\n"
        f"selection-background={p['acento']}\nselection-foreground={p['sup'] if claro else p['fondo']}\ncursor={p['fondo']} {p['acento']}\n"
        + "".join(f"{k}={v}\n" for k, v in ansi.items()))
    f["hyprlock.conf"] = (f"# {cab}\n$acento = rgba({p['acento']}ff)\n$acento2 = rgba({p['acento2']}ee)\n$acento_borde = rgba({p['acento']}ee)\n"
        f"$texto = rgba({p['texto']}ff)\n$apagado = rgba({p['apagado']}ff)\n$campo = rgba({r}, {g}, {b}, 0.85)\n"
        f"$mal = rgba({mal}ee)\n$bloqueo = {bloqueo_de(t)}\n")
    acf = p['sup'] if claro else p['fondo']
    f["gtk.css"] = (f"/* {cab} */\n"
        f"@define-color accent_color #{p['acento']};\n@define-color accent_bg_color #{p['acento']};\n"
        f"@define-color accent_fg_color #{acf};\n@define-color theme_selected_bg_color #{p['acento']};\n"
        f"@define-color theme_selected_fg_color #{acf};\n"
        f"@define-color naranjos_fondo #{p['fondo']};\n@define-color naranjos_superficie #{p['sup']};\n"
        f"@define-color naranjos_texto #{p['texto']};\n@define-color naranjos_apagado #{p['apagado']};\n"
        f"@define-color naranjos_acento #{p['acento']};\n@define-color naranjos_acento2 #{p['acento2']};\n"
        f"@define-color naranjos_inactivo #{p['inactivo']};\n"
        "\n"
        "/* Aspecto NaranjOS para las aplicaciones GTK 3 (Thunar…): oscuro y limpio, el acento solo donde importa */\n"
        "window, .background, dialog { background-color: @naranjos_fondo; color: @naranjos_texto; }\n"
        ".view, iconview, treeview.view, textview text { background-color: @naranjos_fondo; color: @naranjos_texto; }\n"
        "*:selected, *:selected:focus, row:selected { background-color: @naranjos_acento; color: @accent_fg_color; }\n"
        "\n"
        "/* barra de herramientas y ruta */\n"
        "menubar, .menubar, toolbar, .primary-toolbar, headerbar, .titlebar {\n"
        "  background-color: @naranjos_fondo; border: none; box-shadow: none; padding: 6px 8px; }\n"
        "toolbar button, .primary-toolbar button, headerbar button {\n"
        "  background: none; border: none; box-shadow: none; border-radius: 10px; padding: 6px; color: @naranjos_apagado; }\n"
        "toolbar button:hover, .primary-toolbar button:hover, headerbar button:hover {\n"
        "  background-color: alpha(@naranjos_acento, 0.14); color: @naranjos_texto; }\n"
        "toolbar button:disabled { color: alpha(@naranjos_apagado, 0.35); }\n"
        ".path-bar, .location-button-box { background-color: @naranjos_superficie; border-radius: 12px; padding: 2px; }\n"
        ".path-bar button, .location-button-box button, .linked > button.toggle {\n"
        "  background: none; border: none; box-shadow: none; border-radius: 10px; padding: 4px 12px; color: @naranjos_apagado; }\n"
        ".path-bar button:hover, .location-button-box button:hover, .linked > button.toggle:hover {\n"
        "  background-color: alpha(@naranjos_acento, 0.12); color: @naranjos_texto; }\n"
        ".path-bar button:checked, .location-button-box button:checked, .linked > button.toggle:checked {\n"
        "  background-color: alpha(@naranjos_acento, 0.18); color: @naranjos_acento; font-weight: bold; }\n"
        "entry { background-color: @naranjos_superficie; color: @naranjos_texto; border-radius: 10px;\n"
        "  border: 1px solid @naranjos_inactivo; box-shadow: none; padding: 4px 10px; }\n"
        "entry:focus { border-color: @naranjos_acento; }\n"
        "\n"
        "/* barra lateral: un poco más clara, filas amplias y la selección como un toque de color */\n"
        "placessidebar, placessidebar list, .sidebar, .sidebar list, .sidebar .view, .sidebar treeview, .shortcuts-pane {\n"
        "  background-color: @naranjos_superficie; border: none; }\n"
        "placessidebar row, .sidebar row { border-radius: 10px; margin: 1px 8px; padding: 6px 8px; }\n"
        ".sidebar treeview.view { padding: 5px 8px; }\n"
        "placessidebar row:hover, .sidebar row:hover, .sidebar treeview.view:hover { background-color: alpha(@naranjos_acento, 0.10); }\n"
        "placessidebar row:selected, .sidebar row:selected, .sidebar .view:selected, .sidebar treeview.view:selected {\n"
        "  background-color: alpha(@naranjos_acento, 0.20); color: @naranjos_acento; border-radius: 10px; }\n"
        "paned > separator { background-color: @naranjos_fondo; min-width: 1px; background-image: none; }\n"
        "\n"
        "/* iconos de ficheros: selección suave y redondeada, recuadro de selección del acento */\n"
        "iconview, .view.iconview { padding: 6px; }\n"
        "iconview:selected, .view:selected, treeview.view:selected, flowboxchild:selected {\n"
        "  background-color: alpha(@naranjos_acento, 0.22); color: @naranjos_texto; border-radius: 12px; }\n"
        "iconview:selected:focus, .view:selected:focus { background-color: alpha(@naranjos_acento, 0.32); }\n"
        ".rubberband, rubberband { border: 1px solid @naranjos_acento; background-color: alpha(@naranjos_acento, 0.15); border-radius: 6px; }\n"
        "\n"
        "/* menús, ventanas emergentes y avisos */\n"
        "menu, .menu, .context-menu, popover, popover.background {\n"
        "  background-color: @naranjos_superficie; color: @naranjos_texto; border: 1px solid @naranjos_inactivo; border-radius: 12px; padding: 6px; }\n"
        "menuitem, modelbutton { border-radius: 8px; padding: 6px 10px; }\n"
        "menuitem:hover, modelbutton:hover { background-color: alpha(@naranjos_acento, 0.18); color: @naranjos_texto; }\n"
        "separator { background-color: @naranjos_inactivo; }\n"
        "tooltip, tooltip.background { background-color: @naranjos_superficie; color: @naranjos_texto;\n"
        "  border: 1px solid @naranjos_acento; border-radius: 8px; }\n"
        "statusbar, .statusbar { color: @naranjos_apagado; }\n"
        "scrollbar, scrollbar trough { background: none; border: none; }\n"
        "scrollbar slider { background-color: @naranjos_inactivo; border: none; border-radius: 6px; min-width: 6px; min-height: 6px; }\n"
        "scrollbar slider:hover { background-color: @naranjos_acento; }\n")
    return f


def mezcla(a, b, t):
    ra, rb = rgb(a), rgb(b)
    return "".join("%02x" % round(x + (y - x) * t) for x, y in zip(ra, rb))

def paleta(nombre, ac, claro):
    if claro:
        acc = mezcla(ac, "000000", 0.18)
        return dict(nombre=nombre, fondo=mezcla("fbfaf8", ac, 0.04), sup="ffffff", texto=mezcla("26221f", ac, 0.08),
                    apagado=mezcla("857d76", ac, 0.10), acento=acc, acento2=mezcla(ac, "ffffff", 0.25),
                    inactivo=mezcla("e6e1da", ac, 0.12), claro=1)
    return dict(nombre=nombre, fondo=mezcla("121212", ac, 0.035), sup=mezcla("1c1c1c", ac, 0.06), texto=mezcla("e6e6e6", ac, 0.04),
                apagado=mezcla("8a8a8a", ac, 0.08), acento=ac, acento2=mezcla(ac, "ffffff", 0.35), inactivo=mezcla("2a2a2a", ac, 0.12))

if __name__ == "__main__":
    dest, tid, nombre, ac = pathlib.Path(sys.argv[1]), sys.argv[2], sys.argv[3], sys.argv[4].lstrip("#").lower()
    claro = len(sys.argv) > 5 and sys.argv[5] == "claro"
    assert re.fullmatch(r"[0-9a-f]{6}", ac), "color: 6 cifras hexadecimales, p. ej. ff8700"
    p = paleta(nombre, ac, claro)
    dest.mkdir(parents=True, exist_ok=True)
    for n, txt in ficheros_tema(tid, p).items():
        if n == "colores":   # los temas tuyos usan el fondo, el cursor y los iconos de Naranja / Azahar
            txt = re.sub(r"^FONDO=.*$", "FONDO=/usr/share/backgrounds/naranjos/naranjos-01.jpg", txt, flags=re.M)
            txt = re.sub(r"^BLOQUEO=.*$", "BLOQUEO=/usr/share/backgrounds/naranjos/naranjos-bloqueo.jpg", txt, flags=re.M)
            txt = re.sub(r"^CURSOR=.*$", "CURSOR=NaranjOS", txt, flags=re.M)
            txt = re.sub(r"^ICONOS=.*$", "ICONOS=NaranjOS-iconos-" + ("azahar" if claro else "naranja"), txt, flags=re.M)
        txt = txt.replace("/usr/share/backgrounds/naranjos/temas/%s/" % tid, "/usr/share/backgrounds/naranjos/")
        if n == "hyprland.lua": txt = txt.replace('cursor = "NaranjOS-%s"' % tid, 'cursor = "NaranjOS"')
        (dest / n).write_text(txt)
    print(dest)
