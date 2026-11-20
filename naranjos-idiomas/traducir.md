# Traducir NaranjOS · Translating NaranjOS

## Español

NaranjOS está escrito en español y se puede traducir a cualquier idioma. Todo es gratis y no
hace falta saber programar: solo un editor de texto (o Poedit, que es gratuito) y una cuenta de GitHub.

1. Los textos están en el repositorio de recetas, carpeta `naranjos-idiomas/`:
   - `naranjos.pot`: la plantilla con todos los textos de NaranjOS (en español).
   - `en.po`: la traducción al inglés; sírvete de ella si no sabes español.
2. Copia `naranjos.pot` como `<código>.po` (por ejemplo `pt.po`, `fr.po`, `gl.po`) y rellena cada
   `msgstr ""` con la traducción del `msgid` de encima. Respeta los `%s`: ahí va un dato.
3. Traduce también, si quieres, el manual (`manual.md`), los atajos (`atajos.txt`) y la guía de
   seguridad (`peel.md`) a una carpeta con el código de tu idioma.
4. Abre un *pull request* en GitHub. Al publicarse la siguiente versión, tu idioma aparecerá con ★
   en `naranjos-idioma`.

Comprueba tu fichero antes de enviarlo: `msgfmt --check -o /dev/null pt.po`

## English

NaranjOS is written in Spanish and can be translated into any language. It is free and you don't
need to know how to program: just a text editor (or the free Poedit) and a GitHub account.

1. The texts are in the recipes repository, folder `naranjos-idiomas/`:
   - `naranjos.pot`: the template with every NaranjOS text (in Spanish).
   - `en.po`: the English translation; use it as a reference if you don't speak Spanish.
2. Copy `naranjos.pot` to `<code>.po` (e.g. `pt.po`, `fr.po`, `de.po`) and fill in each
   `msgstr ""` with the translation of the `msgid` above it. Keep every `%s`: a value goes there.
3. Optionally also translate the manual (`manual.md`), the shortcuts (`atajos.txt`) and the security
   guide (`peel.md`) into a folder named after your language code.
4. Open a pull request on GitHub. With the next release your language will show a ★
   in `naranjos-idioma`.

Check your file before sending it: `msgfmt --check -o /dev/null pt.po`
