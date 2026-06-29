# Quiz interactivo SCE

Aplicación estática tipo Kahoot para capacitaciones presenciales de la Superintendencia de Competencia Económica del Ecuador.

## Prerrequisitos

- Un proyecto de Supabase.
- La URL del proyecto.
- La anon key del proyecto.
- Un navegador moderno en el laptop del facilitador y en los celulares de los participantes.

No necesitas Netlify, Vercel ni otro hosting público si todos están en la misma red Wi-Fi o conectados al mismo hotspot. La aplicación puede abrirse como archivos HTML locales; si los participantes van a entrar desde sus celulares, basta con servir la carpeta desde el laptop del facilitador en esa red.

Si los participantes usarán sus propios datos móviles y no estarán en la misma red que el laptop, necesitas publicar estos archivos en una URL pública, por ejemplo con GitHub Pages, Netlify o Vercel. Supabase seguirá siendo el backend en tiempo real.

## Paso 1: Crear las tablas

1. Abre tu proyecto en Supabase.
2. Ve a **SQL Editor**.
3. Copia y ejecuta el contenido de `setup.sql`.

El script crea las tablas `game_state` y `respuestas`, desactiva RLS para uso interno, habilita permisos para `anon` y `authenticated`, y agrega ambas tablas a Supabase Realtime.

## Paso 2: Reemplazar credenciales

Abre `host.html` y `player.html`.

En la parte superior de cada archivo reemplaza:

```javascript
const SUPABASE_URL = ""; // REEMPLAZAR
const SUPABASE_ANON_KEY = ""; // REEMPLAZAR
```

por los valores de tu proyecto Supabase.

## Paso 3: Abrir la pantalla del host

Para una prueba rápida en el mismo laptop, abre `host.html` en el navegador.

Para usar celulares en la misma red Wi-Fi, sirve la carpeta desde el laptop del facilitador. Esto no publica la app en internet; solo crea una URL local para la sala. Una opción simple es:

```bash
npx serve kahoot-sce
```

Luego abre la URL de `host.html` en el laptop del facilitador.

## Paso 4: Compartir la pantalla de participantes

El host muestra la URL de `player.html` en el lobby y permite copiarla.

Si usas `npx serve`, comparte una URL parecida a:

```text
http://IP-DEL-LAPTOP:3000/player.html
```

Puedes generar un QR con esa URL y proyectarlo antes de iniciar la partida.

## Opción con estudiantes usando datos móviles

Si los estudiantes no estarán en la misma red que tu PC, sube estos archivos a GitHub y publícalos con GitHub Pages.

Flujo recomendado:

```bash
cd "C:\Users\Admin\Documents\sce 26\simulador kahoot\kahoot-sce"
git init
git add .
git commit -m "Crear quiz interactivo SCE"
gh auth login -h github.com
gh repo create quiz-sce --public --source=. --remote=origin --push
```

Si PowerShell abre en `C:\Users\Admin`, no uses `cd kahoot-sce` porque esa carpeta no existe ahí. Usa la ruta completa con comillas, como en el comando anterior.

Luego activa GitHub Pages:

1. Entra al repositorio en GitHub.
2. Ve a **Settings**.
3. Abre **Pages**.
4. En **Build and deployment**, selecciona **Deploy from a branch**.
5. Elige la rama `main` y la carpeta `/root`.
6. Guarda los cambios.

Después de unos minutos tendrás una URL pública similar a:

```text
https://TU-USUARIO.github.io/quiz-sce/player.html
```

Usa esa URL para generar el QR de participantes. El host también puede abrirse desde:

```text
https://TU-USUARIO.github.io/quiz-sce/host.html
```

Importante: al publicar los HTML, la anon key de Supabase queda visible en el navegador. Esto es normal en apps frontend, pero como este proyecto usa RLS desactivado para simplificar el demo, conviene usarlo para capacitaciones controladas y no dejarlo como enlace abierto permanente.

## Paso 5: Jugar

1. Los participantes ingresan su nombre desde `player.html`.
2. El host presiona **Iniciar juego**.
3. Los participantes responden desde el celular.
4. El host revela la respuesta o espera a que termine el timer.
5. Al final se muestra el ranking.

Al iniciar una nueva partida se eliminan las respuestas anteriores de `sala1`.

## Paso 6: Agregar o editar preguntas

Edita el array `PREGUNTAS` en `host.html` y en `player.html`.

Cada pregunta usa esta estructura:

```javascript
{
  pregunta: "Texto de la pregunta",
  opciones: [
    "Opción A",
    "Opción B",
    "Opción C",
    "Opción D"
  ],
  correcta: 1,
  tiempo: 20
}
```

- `correcta` es el índice de la respuesta correcta: `0`, `1`, `2` o `3`.
- `tiempo` es la duración de la pregunta en segundos.

Mantén el mismo array en ambos archivos para que host y participantes usen las mismas opciones y respuestas.
