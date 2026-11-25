#!/usr/bin/env python3
# NaranjOS · recolorea los fondos naranjas para cada tema cítrico (CC BY-SA 4.0, derivados de los originales)
#   recolorea.py <entrada.jpg> <salida.jpg> <tema>
# Solo se mueve el tono de los píxeles anaranjados (de rojo-anaranjado a ámbar); el resto (hojas verdes,
# negros, grises) se queda igual. Azahar (claro): además se aclara el fondo oscuro.
import sys
import numpy as np
from PIL import Image

TEMAS = {  # tono de destino (grados) del naranja de referencia (~30°), y ajustes
    "sanguina": dict(tono=356, sat=1.05, luz=0.95),
    "lima":     dict(tono=80,  sat=0.82, luz=0.94),
    "pomelo":   dict(tono=342, sat=0.80, luz=1.08),
    "limon":    dict(tono=52,  sat=1.0,  luz=1.08),
    "brisa":    dict(tono=212, sat=0.95, luz=1.0),
    "azahar":   dict(tono=28,  sat=0.9,  luz=1.0, claro=True),
}

def rgb_a_hsv(a):
    r, g, b = a[..., 0], a[..., 1], a[..., 2]
    mx = a.max(-1); mn = a.min(-1); d = mx - mn
    h = np.zeros_like(mx)
    m = d > 1e-6
    rr = m & (mx == r); gg = m & (mx == g) & ~rr; bb = m & ~rr & ~gg
    h[rr] = ((g - b)[rr] / d[rr]) % 6
    h[gg] = (b - r)[gg] / d[gg] + 2
    h[bb] = (r - g)[bb] / d[bb] + 4
    h = h * 60.0
    s = np.where(mx > 1e-6, d / np.maximum(mx, 1e-6), 0)
    return h, s, mx

def hsv_a_rgb(h, s, v):
    h = (h % 360) / 60.0
    i = np.floor(h).astype(int) % 6; f = h - np.floor(h)
    p = v * (1 - s); q = v * (1 - s * f); t = v * (1 - s * (1 - f))
    sel = [np.stack(x, -1) for x in ((v, t, p), (q, v, p), (p, v, t), (p, q, v), (t, p, v), (v, p, q))]
    out = np.zeros(h.shape + (3,))
    for k in range(6):
        out[i == k] = sel[k][i == k]
    return out

def main():
    ent, sal, tema = sys.argv[1], sys.argv[2], sys.argv[3]
    c = TEMAS[tema]
    a = np.asarray(Image.open(ent).convert("RGB"), dtype=np.float64) / 255.0
    h, s, v = rgb_a_hsv(a)
    # peso del «naranja»: tonos de ~0° a ~55° (con bordes suaves), y con algo de color
    dist = np.minimum(np.abs(((h - 28) + 180) % 360 - 180), 60)
    croma = s * v          # (máx - mín): en lo oscuro la saturación es puro ruido de JPEG; la croma no
    peso = np.clip((40 - dist) / 15.0, 0, 1) * np.clip((croma - 0.04) / 0.08, 0, 1)
    nuevo_h = (h + (c["tono"] - 30)) % 360
    h2 = np.where(peso > 0, (h + peso * (((nuevo_h - h) + 180) % 360 - 180)) % 360, h)
    s2 = np.clip(s * (1 + peso * (c["sat"] - 1)), 0, 1)
    v2 = np.clip(v * (1 + peso * (c["luz"] - 1)), 0, 1)
    if c.get("claro"):
        # tema claro: lo neutro (fondo oscuro, sin color) se invierte a un crema suave; lo de color se conserva
        neutro = (1 - peso) * np.clip((0.16 - croma) / 0.10, 0, 1)
        v_claro = 0.975 - 0.55 * v2
        v2 = v2 + neutro * (v_claro - v2)
        s2 = s2 * (1 - neutro) + neutro * 0.07
        h2 = np.where(neutro > 0.01, (h2 * (1 - neutro) + 38 * neutro), h2)
    out = (np.clip(hsv_a_rgb(h2, s2, v2), 0, 1) * 255 + 0.5).astype(np.uint8)
    Image.fromarray(out).save(sal, quality=90, optimize=True, progressive=True)

if __name__ == "__main__":
    main()
