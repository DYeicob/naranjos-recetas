# NaranjOS · aviso legal

NaranjOS es una distribución de Linux hecha desde cero (Linux From Scratch). Casi todo lo que trae es software
libre de otros proyectos, cada uno con su licencia; NaranjOS solo lo compila y lo empaqueta.

- **Licencias:** cada paquete guarda las suyas en `/usr/share/licenses/` (o en `naranjos-licencias`). Lista completa:
  [LICENCIAS.md](LICENCIAS.md). `zumo licencia <paquete>` las enseña.
- **Código fuente:** el de cada versión publicada está en la Release `naranjos-fuentes` de este repositorio
  (`zumo fuentes <paquete>`), como piden la GPL y licencias parecidas.
- **Arranque seguro (shim):** `naranjos-shim` es el shim de Ubuntu (Canonical) firmado por Microsoft, sin cambios
  (licencia BSD-2-Clause). NaranjOS no está respaldado por Canonical ni por Microsoft.
- **Marcas:** Firefox, Chromium, Linux, Hyprland, Ubuntu, Windows, YubiKey y el resto de nombres son marcas de sus
  dueños. NaranjOS no incluye Firefox ni Chromium: se instalan desde Flathub cuando tú lo pides.
- **Datos de terceros:** emojis de Unicode CLDR (licencia Unicode-3.0); modelo de voz de whisper.cpp (MIT); datos de
  reconocimiento de texto de Tesseract (Apache-2.0); el tiempo, de Open-Meteo (CC BY 4.0) solo si eliges una ciudad.
- **Arte de NaranjOS** (logotipo, fondos, cursores y temas): CC BY-SA 4.0.
- **Sin garantía:** NaranjOS se ofrece tal cual, sin garantía de ningún tipo.
