#!/usr/bin/env python3
# NaranjOS · cursores de los temas cítricos: recolorea el borde naranja del cursor NaranjOS (Bibata, GPL-3.0)
#   recolorea-cursor.py <naranjos-cursor-X.cursores> <salida.tar> <tema>…
# Crea NaranjOS-<tema>/ (mismos enlaces y nombres); solo se mueve el tono de lo anaranjado.
import sys, io, struct, tarfile, pathlib
import numpy as np
sys.path.insert(0, str(pathlib.Path(__file__).parent))
from recolorea import TEMAS, rgb_a_hsv, hsv_a_rgb

def recolorea_xcursor(datos, c):
    if datos[:4] != b"Xcur": return datos
    b = bytearray(datos)
    _, _, ntoc = struct.unpack_from("<III", b, 4)
    for i in range(ntoc):
        tipo, _, pos = struct.unpack_from("<III", b, 16 + i * 12)
        if tipo != 0xFFFD0002: continue
        _, _, _, _, w, h, _, _, _ = struct.unpack_from("<9I", b, pos)
        ini = pos + 36; n = w * h
        px = np.frombuffer(bytes(b[ini:ini + 4 * n]), dtype="<u4").astype(np.uint32)
        a = ((px >> 24) & 255).astype(np.float64)
        rgb = np.stack([(px >> 16) & 255, (px >> 8) & 255, px & 255], -1).astype(np.float64)
        al = np.maximum(a, 1)[:, None] / 255.0
        col = np.clip(rgb / 255.0 / al, 0, 1)                     # sin premultiplicar
        hh, s, v = rgb_a_hsv(col)
        croma = s * v
        dist = np.minimum(np.abs(((hh - 28) + 180) % 360 - 180), 60)
        peso = np.clip((40 - dist) / 15.0, 0, 1) * np.clip((croma - 0.04) / 0.08, 0, 1)
        nuevo = (hh + (c["tono"] - 30)) % 360
        h2 = np.where(peso > 0, (hh + peso * (((nuevo - hh) + 180) % 360 - 180)) % 360, hh)
        s2 = np.clip(s * (1 + peso * (c["sat"] - 1)), 0, 1)
        v2 = np.clip(v * (1 + peso * (c["luz"] - 1)), 0, 1)
        out = np.clip(hsv_a_rgb(h2, s2, v2), 0, 1) * al * 255.0 + 0.5   # premultiplicado otra vez
        out = out.astype(np.uint32)
        nuevo_px = (a.astype(np.uint32) << 24) | (out[:, 0] << 16) | (out[:, 1] << 8) | out[:, 2]
        b[ini:ini + 4 * n] = nuevo_px.astype("<u4").tobytes()
    return bytes(b)

def main():
    ent, sal, temas = sys.argv[1], sys.argv[2], sys.argv[3:]
    with tarfile.open(ent) as tin, tarfile.open(sal, "w", format=tarfile.GNU_FORMAT) as tout:
        miembros = tin.getmembers()
        for t in temas:
            c = TEMAS[t]; raiz = f"NaranjOS-{t}"
            for m in miembros:
                if not m.name.startswith("NaranjOS/") and m.name != "NaranjOS": continue
                nm = tarfile.TarInfo(raiz + m.name[len("NaranjOS"):])
                nm.mode, nm.mtime, nm.uid, nm.gid, nm.uname, nm.gname = m.mode, 0, 0, 0, "root", "root"
                if m.isdir():
                    nm.type = tarfile.DIRTYPE; tout.addfile(nm)
                elif m.issym():
                    nm.type = tarfile.SYMTYPE; nm.linkname = m.linkname; tout.addfile(nm)
                elif m.isfile():
                    d = tin.extractfile(m).read()
                    if m.name.endswith("index.theme"):
                        d = (f"[Icon Theme]\nName=NaranjOS-{t}\nComment=Cursor de NaranjOS, tema {t} (basado en Bibata Modern Classic, GPL-3.0)\n"
                             "Inherits=\"hicolor\"\n").encode()
                    else:
                        d = recolorea_xcursor(d, c)
                    nm.size = len(d); tout.addfile(nm, io.BytesIO(d))

if __name__ == "__main__":
    main()
