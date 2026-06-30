# Quiz interactivo SCE

Aplicación estática tipo Kahoot para capacitaciones presenciales de la Superintendencia de Competencia Económica del Ecuador.

La app usa:

- **Frontend**: `host.html` y `player.html` con HTML, CSS y JavaScript vanilla.
- **Realtime**: Firebase Realtime Database.
- **Hosting**: GitHub Pages o cualquier hosting estático.

## Prerrequisitos

- Un proyecto de Firebase.
- Realtime Database activado.
- Una app web registrada en Firebase para copiar el objeto `firebaseConfig`.
- El repositorio publicado en GitHub Pages.

## Paso 1: Registrar una app web en Firebase

1. Entra a Firebase Console.
2. Abre tu proyecto.
3. En la pantalla principal, haz clic en **Agregar app**.
4. Selecciona el ícono web `</>`.
5. Pon un nombre, por ejemplo `quiz-sce-web`.
6. No es necesario activar Firebase Hosting.
7. Copia el objeto `firebaseConfig` que te muestra Firebase.

Se verá parecido a esto:

```javascript
const firebaseConfig = {
  apiKey: "...",
  authDomain: "...",
  databaseURL: "...",
  projectId: "...",
  storageBucket: "...",
  messagingSenderId: "...",
  appId: "..."
};
```

## Paso 2: Activar Realtime Database

1. En Firebase Console, abre **Compilación** o **Build**.
2. Entra a **Realtime Database**.
3. Haz clic en **Crear base de datos**.
4. Elige una región.
5. Para una capacitación controlada, puedes iniciar en modo de prueba.

Luego entra a la pestaña **Reglas** y reemplaza el contenido por el de `database.rules.json`:

```json
{
  "rules": {
    "salas": {
      "$sala": {
        ".read": true,
        ".write": true
      }
    }
  }
}
```

Estas reglas son abiertas para simplificar el demo. Úsalas solo en capacitaciones controladas y no como enlace público permanente.

## Paso 3: Reemplazar la configuración Firebase

Abre `host.html` y `player.html`.

En la parte superior de cada archivo busca:

```javascript
const FIREBASE_CONFIG = { // REEMPLAZAR
  apiKey: "",
  authDomain: "",
  databaseURL: "",
  projectId: "",
  storageBucket: "",
  messagingSenderId: "",
  appId: ""
};
```

Reemplaza los valores vacíos por los valores de tu `firebaseConfig`.

No copies las líneas `import`, `initializeApp` ni `getAnalytics` que muestra Firebase. Esta app ya carga Firebase desde CDN y solo necesita el objeto de configuración.

Si Firebase no muestra `databaseURL`, primero crea Realtime Database y copia la URL de la base. Para este proyecto debería verse parecida a:

```javascript
databaseURL: "https://replica-kahoot-default-rtdb.firebaseio.com"
```

## Paso 4: Subir los cambios a GitHub

Desde PowerShell:

```powershell
cd "C:\Users\Admin\Documents\sce 26\simulador kahoot\kahoot-sce"
git add .
git commit -m "Migrar quiz a Firebase Realtime Database"
git push
```

GitHub Pages actualizará el sitio después de unos minutos.

## Paso 5: Abrir las pantallas

La pantalla del host estará en:

```text
https://joselmatias.github.io/quiz-sce/host.html
```

La pantalla de participantes estará en:

```text
https://joselmatias.github.io/quiz-sce/player.html
```

El host muestra automáticamente un código QR hacia `player.html` en el lobby. También puedes abrirlo en cualquier momento con el botón **Mostrar QR** del encabezado. Proyecta ese QR para que los estudiantes abran la pantalla de participante y registren su nombre.

## Paso 6: Jugar

1. Los participantes ingresan su nombre desde `player.html`.
2. El host presiona **Iniciar juego**.
3. Los participantes responden desde el celular.
4. El host revela la respuesta o espera a que termine el timer.
5. Al final se muestra el ranking.

Al iniciar una nueva partida se eliminan las respuestas anteriores de `sala1`.

Si la sala queda en una pregunta anterior o aparece un participante colgado, usa **Reiniciar sala** desde el encabezado del host. Ese botón borra respuestas, limpia presencia y vuelve al lobby con el QR listo.

## Estructura en Firebase

La app escribe datos en estas rutas:

```text
salas/sala1/estado
salas/sala1/respuestas
salas/sala1/presencia
```

- `estado`: pregunta activa, si está revelada y hora de inicio.
- `respuestas`: respuestas enviadas por cada jugador.
- `presencia`: participantes conectados en tiempo real.

## Agregar o editar preguntas

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
