# naranjos-recetas

Recetas (PKGBUILD) de los paquetes de **NaranjOS**, una distribución Linux
construida desde cero a partir de Linux From Scratch 13.1 (systemd).

Los paquetes se instalan con **zumo**, el gestor de paquetes de NaranjOS
(por dentro usa el motor de pacman).

| Receta | Qué es |
|---|---|
| `naranjos-base` | Registra en zumo el sistema base construido con LFS/BLFS 13.1 |
| `pacman` | Motor de paquetes (pacman 7.1.0) con la configuración de NaranjOS |
| `zumo` | El comando `zumo`: `instala`, `quita`, `actualiza`, `busca`… |

## Paquetes firmados

Los paquetes compilados y la base de datos del repositorio están en la
[Release `naranjos-core`](https://github.com/DYeicob/naranjos-recetas/releases/tag/naranjos-core).
Junto a ellos se publica el código fuente original que se usó (GPL).

Todos van firmados con la clave de NaranjOS:

```
NaranjOS Packager (Yeicob)
24D20F18D4A51E6B5222A5A2FCCC1B88ED9963AD
```

La clave pública está en [`claves/naranjos-packager.asc`](claves/naranjos-packager.asc).

## Construir una receta

```
cd zumo
makepkg -f
```

## Licencia

Las recetas y `zumo` se publican bajo GPL-3.0-or-later (ver `LICENSE`).
Cada paquete conserva la licencia de su proyecto original.

## Flujo de trabajo

1. Las recetas se escriben y se suben a este repositorio.
2. En NaranjOS: `git pull` y `zumo exprime <receta>` (compila, firma y añade al repositorio local).
3. Los paquetes firmados se publican en la Release `naranjos-core`.

Para usar el repositorio desde cualquier NaranjOS, `/etc/pacman.conf` incluye:

```
[naranjos-core]
Server = https://github.com/DYeicob/naranjos-recetas/releases/download/naranjos-core
```
