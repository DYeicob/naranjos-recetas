#!/usr/bin/env python3
# NaranjOS · salvapantallas en la terminal: gajos y la palabra NaranjOS con los colores del tema
import os, random, select, shutil, sys, termios, time, tty
def color(nombre, defecto):
    try:
        for l in open(os.path.expanduser("~/.config/naranjos/tema/colores")):
            if l.startswith(nombre + "="): return l.split("=", 1)[1].strip()
    except OSError: pass
    return defecto
def rgb(h): return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))
AC, AC2, FO = rgb(color("COLOR_ACENTO", "ff8700")), rgb(color("COLOR_ACENTO2", "ffaf5f")), rgb(color("COLOR_FONDO", "121212"))
def esc(c, fondo=False): return "\033[%d;2;%d;%d;%dm" % (48 if fondo else 38, *c)
LOGO = ["█▄ █ ▄▀█ █▀█ ▄▀█   █ █▀█ █▀", "█ ▀█ █▀█ █▀▄ █▀█ █▄█ █▄█ ▄█"]
SIGNOS = "◐◑◒◓○●◌◍"
def main():
    fd = sys.stdin.fileno(); viejo = termios.tcgetattr(fd); tty.setcbreak(fd)
    sys.stdout.write("\033[?25l\033[?1003h" + esc(FO, True) + "\033[2J"); sys.stdout.flush()
    gotas = []; t0 = time.time()
    try:
        while True:
            w, h = shutil.get_terminal_size()
            if random.random() < 0.5: gotas.append([random.randrange(w), 0, random.choice(SIGNOS), random.random() < 0.3])
            out = [esc(FO, True)]
            for g in gotas:
                out.append("\033[%d;%dH " % (g[1] + 1, g[0] + 1)); g[1] += 1
                if g[1] < h: out.append("\033[%d;%dH%s%s" % (g[1] + 1, g[0] + 1, esc(AC2 if g[3] else AC), g[2]))
            gotas = [g for g in gotas if g[1] < h]
            y = h // 2 - 1; fase = (time.time() - t0) % 6 < 3
            for i, l in enumerate(LOGO):
                out.append("\033[%d;%dH%s%s" % (y + i + 1, max(1, (w - len(l)) // 2 + 1), esc(AC if fase else AC2), l))
            sys.stdout.write("".join(out)); sys.stdout.flush()
            if select.select([fd], [], [], 0.09)[0]: break
    finally:
        sys.stdout.write("\033[?1003l\033[0m\033[2J\033[?25h"); sys.stdout.flush()
        termios.tcsetattr(fd, termios.TCSADRAIN, viejo)
if __name__ == "__main__": main()
