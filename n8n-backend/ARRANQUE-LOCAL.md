# Arranque local — n8n + PostgreSQL

Guía para levantar el backend completo en local y conectarlo con la aplicación
Ionic/Angular YaviBot.

> Este entorno utiliza PostgreSQL y datos de prueba temporales.
> La integración con la base institucional y Google Workspace se realizará
> cuando el instituto proporcione los accesos correspondientes.

---

## Requisitos

- Docker Desktop instalado y ejecutándose.
- Node.js y npm instalados.
- La aplicación Ionic/Angular ubicada en `certi-matricula-app/`.
- Archivo `n8n-backend/.env` configurado localmente.
- Credenciales de prueba configuradas manualmente dentro de n8n.

---

## 1. Configurar variables locales

El archivo:

```text
n8n-backend/.env
```

NO debe subirse a GitHub.

Debe contener las variables necesarias para PostgreSQL y n8n.

Ejemplo:

```env
POSTGRES_USER=yavirac
POSTGRES_PASSWORD=CAMBIAR_POR_PASSWORD_LOCAL
POSTGRES_DB=yavirac

DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=yavirac
DB_POSTGRESDB_USER=yavirac
DB_POSTGRESDB_PASSWORD=CAMBIAR_POR_PASSWORD_LOCAL
DB_POSTGRESDB_SCHEMA=n8n

GENERIC_TIMEZONE=America/Guayaquil
TZ=America/Guayaquil
```

La contraseña debe configurarse únicamente en el `.env` local.

> Para producción se debe utilizar una contraseña nueva y fuerte.
> No reutilizar contraseñas locales o de pruebas.

---

## 2. Levantar PostgreSQL y n8n

Desde la carpeta:

```text
n8n-backend/
```

ejecutar:

```bash
docker compose up -d
```

Esperar unos segundos y comprobar:

```bash
docker compose ps
```

Los servicios deben aparecer aproximadamente así:

```text
yavirac-db    Up (healthy)
yavirac-n8n   Up
```

Servicios locales:

```text
PostgreSQL → localhost:5432
n8n        → http://localhost:5678
```

---

## 3. Base de datos

La base utilizada actualmente es una base temporal de pruebas en PostgreSQL.

El entorno de demostración contiene datos ficticios necesarios para probar las
funcionalidades del sistema, incluyendo:

- estudiantes;
- docentes;
- carreras;
- períodos académicos;
- laboratorios;
- roles;
- tipos de solicitud;
- responsables;
- tickets;
- certificados;
- OTP;
- incidencias.

El archivo:

```text
n8n-backend/init.sql
```

se conserva como referencia del esquema original.

Actualmente `init.sql` NO se ejecuta automáticamente desde
`docker-compose.yml`.

Esto evita que una instalación nueva vuelva a cargar automáticamente datos
antiguos que ya no representan el estado actual de la base de pruebas.

Para desplegar el estado actual de PostgreSQL en un servidor se debe utilizar
un respaldo generado desde la base local previamente probada.

Los respaldos SQL son locales y NO deben subirse al repositorio.

Ejemplos de archivos locales ignorados por Git:

```text
n8n-backend/yavirac_base_limpia.sql
n8n-backend/yavirac_antes_limpieza.sql
```

---

## 4. Configurar n8n

Abrir:

```text
http://localhost:5678
```

La primera vez, n8n solicitará crear una cuenta local de administración.

---

## 5. Crear credencial PostgreSQL

En n8n ir a:

```text
Settings → Credentials → New → Postgres
```

Configurar:

| Campo | Valor |
|---|---|
| Host | `postgres` |
| Port | `5432` |
| Database | `yavirac` |
| User | `yavirac` |
| Password | La contraseña configurada en `.env` |
| Schema | `public` |

Guardar la credencial con el nombre:

```text
Yavirac DB
```

La contraseña real NO debe escribirse en este documento ni subirse al
repositorio.

---

## 6. Crear credencial SMTP de pruebas

Durante el desarrollo se puede utilizar Mailtrap para recibir correos de prueba.

Mailtrap funciona como una bandeja de correo de desarrollo: los mensajes pueden
ser probados sin enviarlos a usuarios reales.

En n8n ir a:

```text
Settings → Credentials → New → SMTP
```

Configurar utilizando los datos proporcionados por la cuenta de Mailtrap:

| Campo | Valor |
|---|---|
| Host | `sandbox.smtp.mailtrap.io` |
| Port | `2525` |
| User | Proporcionado por Mailtrap |
| Password | Proporcionado por Mailtrap |

Guardar con el nombre:

```text
SMTP Pruebas
```

Las credenciales reales de Mailtrap NO deben escribirse en:

- documentación;
- workflows exportados;
- código fuente;
- archivos versionados por Git.

---

## 7. Crear credencial Header Auth

Los webhooks protegidos utilizan el header:

```text
X-Api-Key
```

En n8n ir a:

```text
Settings → Credentials → New → Header Auth
```

Configurar:

| Campo | Valor |
|---|---|
| Name | `X-Api-Key` |
| Value | Clave de prueba configurada únicamente en el entorno local |

Guardar con el nombre:

```text
API Key App Certificado
```

La misma clave debe utilizarse en la configuración local de la aplicación.

IMPORTANTE:

La API Key real NO debe escribirse directamente en el repositorio.

Los archivos locales:

```text
certi-matricula-app/src/environments/environment.ts
certi-matricula-app/src/environments/environment.prod.ts
```

están ignorados por Git.

El repositorio contiene únicamente plantillas:

```text
certi-matricula-app/src/environments/environment.example.ts
certi-matricula-app/src/environments/environment.prod.example.ts
```

---

## 8. Configuración de reCAPTCHA

La aplicación utiliza Google reCAPTCHA para validar determinadas solicitudes
antes de consultar información del estudiante.

Existen dos conceptos diferentes:

### Site Key

La Site Key es utilizada por el frontend para mostrar y ejecutar reCAPTCHA.

Puede existir dentro de la configuración del frontend.

### Secret Key

La Secret Key sirve para validar el token contra Google desde el backend.

La Secret Key:

- NO debe incluirse en Angular;
- NO debe incluirse en el APK;
- NO debe escribirse en documentación pública;
- NO debe subirse a GitHub;
- debe mantenerse del lado del backend o servicio encargado de la validación.

Para producción también se deberá configurar el dominio definitivo autorizado
en la consola de reCAPTCHA.

---

## 9. Workflows de n8n

Los workflows exportados del proyecto se encuentran en:

```text
n8n-backend/workflows/
```

Actualmente el repositorio contiene:

1. `workflow-consultar-estudiante.json`
2. `workflow-consultar-laboratorios.json`
3. `workflow-crear-ticket-solicitud.json`
4. `workflow-enviar-certificado-pdf.json`
5. `workflow-enviar-ticket-verificacion.json`
6. `workflow-generar-certificado.json`
7. `workflow-reportar-incidencia-laboratorio.json`
8. `workflow-resetear-contrasena-correo.json`
9. `workflow-verificar-certificado.json`
10. `workflow-verificar-ticket.json`

Para importar un workflow:

```text
Workflows → Import from File
```

Después de importar los workflows:

- configurar `Yavirac DB` en los nodos PostgreSQL;
- configurar `SMTP Pruebas` en los nodos de correo;
- configurar `API Key App Certificado` en los webhooks protegidos;
- revisar los nodos que dependan de servicios externos;
- publicar los workflows que deban recibir solicitudes desde la aplicación.

Si existen versiones antiguas de los workflows, se recomienda revisar y
reemplazarlas por las versiones actuales antes de realizar las pruebas.

---

## 10. Integración de reseteo de contraseña

El workflow:

```text
workflow-resetear-contrasena-correo.json
```

está implementado para manejar el proceso de solicitud de reseteo de
contraseña.

Sin embargo, el cambio real de contraseña institucional depende de Google
Workspace y de permisos administrativos proporcionados por la institución.

Actualmente:

```text
Validación del usuario         → implementada
Flujo de solicitud             → implementado
Generación de contraseña       → implementada
Interfaz de confirmación       → implementada
Google Workspace institucional → pendiente de credenciales
```

Las credenciales administrativas de Google Workspace NO deben almacenarse en
GitHub.

Cuando el instituto proporcione las credenciales correspondientes se deberá
configurar la integración con los permisos mínimos necesarios.

---

## 11. Configuración del frontend

Los archivos locales de configuración son:

```text
certi-matricula-app/src/environments/environment.ts
certi-matricula-app/src/environments/environment.prod.ts
```

Estos archivos están ignorados por Git debido a que pueden contener
configuración específica del entorno.

Para desarrollo local, `environment.ts` puede tener una configuración similar
a:

```typescript
export const environment = {
  production: false,
  usarMock: false,
  n8nBaseUrl: 'http://localhost:5678/webhook',
  apiKey: 'CLAVE_LOCAL',
  recaptchaSiteKey: 'SITE_KEY_RECAPTCHA'
};
```

Para producción, `environment.prod.ts` deberá apuntar al servidor real:

```typescript
export const environment = {
  production: true,
  usarMock: false,
  n8nBaseUrl: 'https://DOMINIO_BACKEND/webhook',
  apiKey: 'CONFIGURAR_EN_ENTORNO_DE_DESPLIEGUE',
  recaptchaSiteKey: 'SITE_KEY_RECAPTCHA'
};
```

IMPORTANTE:

Una API Key incluida dentro de una aplicación web o móvil no debe considerarse
un secreto fuerte, ya que el valor puede terminar incluido dentro de los
archivos compilados.

Por esta razón, en producción la seguridad debe complementarse con controles
del lado servidor.

---

## 12. Levantar la aplicación web local

Desde la raíz del proyecto:

```bash
cd certi-matricula-app
```

Instalar dependencias si es necesario:

```bash
npm install
```

Después ejecutar:

```bash
npx ng serve
```

La aplicación estará disponible normalmente en:

```text
http://localhost:4200
```

La pantalla principal del chatbot puede consultarse en:

```text
http://localhost:4200/chat
```

---

## 13. Datos de prueba

La base PostgreSQL utilizada para desarrollo contiene datos ficticios.

Para comprobar los estudiantes cargados directamente desde PostgreSQL se puede
ejecutar:

```bash
docker compose exec postgres psql -U yavirac -d yavirac -c "SELECT id, cedula, nombres, carrera_id, nivel, paralelo, estado_matricula FROM estudiantes ORDER BY id;"
```

Para contar los estudiantes:

```bash
docker compose exec postgres psql -U yavirac -d yavirac -c "SELECT COUNT(*) AS estudiantes FROM estudiantes;"
```

El entorno actual utilizado para las pruebas contiene:

```text
10 estudiantes
```

Los datos utilizados en desarrollo son ficticios y sirven únicamente para
demostración y pruebas funcionales.

---

## 14. Carreras

Para comprobar las carreras:

```bash
docker compose exec postgres psql -U yavirac -d yavirac -c "SELECT id, codigo, nombre FROM carreras ORDER BY id;"
```

Actualmente se encuentran configuradas:

| Código | Carrera |
|---|---|
| `ACE` | Arte Culinario Ecuatoriano |
| `DSW` | Desarrollo de Software |
| `DMO` | Diseño de Modas |
| `GNT` | Guía Nacional de Turismo |
| `MKD` | Marketing Digital |

---

## 15. Períodos académicos

Para consultar los períodos:

```bash
docker compose exec postgres psql -U yavirac -d yavirac -c "SELECT id, codigo, nombre, fecha_inicio, fecha_fin, vigente FROM periodos_academicos ORDER BY id;"
```

El período vigente de pruebas debe mantenerse de acuerdo con la configuración
actual de la base.

---

## 16. Responsables de solicitudes

Las asignaciones de responsables pueden comprobarse con:

```bash
docker compose exec postgres psql -U yavirac -d yavirac -c "SELECT ar.id, ts.codigo, c.codigo AS carrera, up.nombres AS responsable, ar.vigente, ar.semestre FROM asignaciones_responsables ar JOIN tipos_solicitud ts ON ts.id=ar.tipo_solicitud_id LEFT JOIN carreras c ON c.id=ar.carrera_id JOIN usuarios_panel up ON up.id=ar.usuario_id ORDER BY ar.id;"
```

Las asignaciones permiten determinar qué responsable debe recibir o procesar
cada tipo de solicitud.

Algunas solicitudes pueden estar asignadas por carrera y otras utilizar un
responsable general.

---

## 17. Laboratorios

La base de pruebas contiene laboratorios utilizados por los flujos relacionados
con docentes e incidencias.

Para consultar los laboratorios:

```bash
docker compose exec postgres psql -U yavirac -d yavirac -c "SELECT id, codigo, nombre, cantidad_equipos FROM laboratorios ORDER BY id;"
```

---

## 18. Funcionalidades del proyecto

El proyecto contempla actualmente funcionalidades como:

```text
Consulta de estudiante
Validación de cédula
reCAPTCHA
OTP por correo
Verificación de identidad
Certificado de matrícula
Generación de PDF
Código QR
Verificación de certificado
Creación de tickets
Solicitudes académicas
Asignación de responsables
Correos de confirmación
Consulta de laboratorios
Reporte de incidencias de laboratorio
Solicitud de reseteo de contraseña
```

Algunas integraciones dependen de accesos institucionales que todavía deben ser
proporcionados.

Pendientes externos principales:

```text
Base/fuente institucional definitiva → pendiente de acceso institucional
Google Workspace                     → pendiente de credenciales institucionales
```

---

## 19. Aplicación Android

La aplicación utiliza Ionic/Angular con Capacitor para Android.

Primero generar el frontend:

```bash
npm run build
```

Después sincronizar Capacitor:

```bash
npx cap sync android
```

Entrar al proyecto Android:

```bash
cd android
```

Para generar un APK de prueba en Windows:

```powershell
.\gradlew assembleDebug
```

El APK normalmente se genera en:

```text
android/app/build/outputs/apk/debug/app-debug.apk
```

Para compilar Android con la configuración actual del proyecto se debe disponer
del JDK compatible con la versión de Gradle/Capacitor utilizada.

---

## 20. Comandos útiles de Docker

### Levantar servicios

```bash
docker compose up -d
```

### Ver estado

```bash
docker compose ps
```

### Logs de n8n

```bash
docker compose logs -f n8n
```

### Logs de PostgreSQL

```bash
docker compose logs -f postgres
```

### Reiniciar n8n

```bash
docker compose restart n8n
```

### Reiniciar PostgreSQL

```bash
docker compose restart postgres
```

### Detener los servicios

```bash
docker compose down
```

IMPORTANTE:

No ejecutar:

```bash
docker compose down -v
```

salvo que realmente se quiera eliminar los volúmenes y reconstruir
completamente el entorno.

La opción `-v` elimina los volúmenes asociados y puede provocar la pérdida de
los datos locales almacenados.

---

## 21. Comandos útiles de PostgreSQL

Entrar directamente a PostgreSQL:

```bash
docker compose exec postgres psql -U yavirac -d yavirac
```

Listar tablas:

```sql
\dt
```

Salir:

```sql
\q
```

Consultar estudiantes:

```bash
docker compose exec postgres psql -U yavirac -d yavirac -c "SELECT id, cedula, nombres, estado_matricula FROM estudiantes ORDER BY id;"
```

Consultar carreras:

```bash
docker compose exec postgres psql -U yavirac -d yavirac -c "SELECT id, codigo, nombre FROM carreras ORDER BY id;"
```

---

## 22. Seguridad y archivos que NO deben subirse

No subir al repositorio:

```text
.env
environment.ts
environment.prod.ts
respaldos SQL
credenciales SMTP
contraseñas PostgreSQL
API Keys reales
Secret Keys de reCAPTCHA
credenciales Google Workspace
tokens
archivos privados de producción
```

Los archivos públicos de ejemplo pueden contener valores como:

```text
CAMBIAR_POR_PASSWORD_LOCAL
REEMPLAZAR_EN_ENTORNO_LOCAL
REEMPLAZAR_EN_CI_CD
SITE_KEY_RECAPTCHA
DOMINIO_BACKEND
```

pero nunca las credenciales reales.

---

## 23. Docker Compose

El archivo:

```text
n8n-backend/docker-compose.yml
```

utiliza variables del `.env`.

El volumen de PostgreSQL permite mantener los datos aunque el contenedor sea
reiniciado.

El volumen de n8n conserva:

- configuración;
- workflows;
- credenciales internas;
- información propia de n8n.

El volumen de uploads permite almacenar archivos utilizados por los workflows.

Actualmente `init.sql` NO se monta automáticamente en:

```text
/docker-entrypoint-initdb.d/
```

Esto es intencional para evitar reconstruir la base utilizando datos antiguos.

---

## 24. Despliegue en servidor

El objetivo del entorno de servidor será:

```text
Aplicación móvil
        ↓
      HTTPS
        ↓
Servidor / VPS
        ↓
       n8n
        ↓
PostgreSQL temporal
```

La base PostgreSQL temporal se utilizará hasta que el instituto proporcione
acceso a la fuente de datos institucional definitiva.

Para el despliegue:

1. Preparar el servidor.
2. Instalar Docker.
3. Instalar Docker Compose.
4. Clonar el repositorio.
5. Crear `.env` directamente en el servidor.
6. Configurar credenciales seguras.
7. Crear/levantar PostgreSQL.
8. Restaurar el respaldo de la base temporal.
9. Levantar n8n.
10. Configurar las credenciales de PostgreSQL en n8n.
11. Configurar SMTP.
12. Configurar Header Auth.
13. Importar o restaurar los workflows.
14. Configurar dominio.
15. Configurar HTTPS.
16. Actualizar `WEBHOOK_URL`.
17. Actualizar `N8N_HOST`.
18. Configurar CORS para el entorno definitivo.
19. Preparar `environment.prod.ts`.
20. Compilar la aplicación.
21. Generar el APK.
22. Probar desde una red externa.
23. Probar desde datos móviles.
24. Revisar logs y ejecuciones de n8n.

---

## 25. CI/CD

El repositorio está preparado para incorporar posteriormente CI/CD mediante
GitHub Actions.

El objetivo será separar:

```text
CI
↓
Instalar dependencias
Validar código
Compilar Angular/Ionic
Verificar que el proyecto construya correctamente
```

y posteriormente:

```text
CD
↓
Conectarse al servidor
Actualizar código
Actualizar contenedores
Aplicar configuración del entorno
Levantar servicios
Verificar el despliegue
```

Los secretos utilizados por los workflows de CI/CD deberán almacenarse en los
Secrets del repositorio y NO escribirse directamente en los archivos
versionados.

---

## 26. Cuando lleguen los accesos institucionales

La transición final consistirá principalmente en reemplazar las fuentes
temporales por las institucionales.

Actualmente:

```text
Aplicación
    ↓
n8n
    ↓
PostgreSQL temporal
```

Posteriormente:

```text
Aplicación
    ↓
n8n
    ↓
Base / fuente institucional
```

Para Google Workspace:

```text
Integración de desarrollo
        ↓
Google Workspace institucional
```

Cuando se reciban los accesos:

1. configurar las credenciales institucionales;
2. revisar los permisos mínimos necesarios;
3. actualizar los workflows correspondientes;
4. realizar pruebas funcionales;
5. revisar seguridad;
6. validar correos;
7. validar certificados;
8. validar tickets;
9. validar reseteo de contraseña;
10. realizar pruebas desde la aplicación móvil;
11. pasar a producción únicamente después de comprobar todos los flujos.

---

## 27. Resumen de arranque rápido

### Backend

```bash
cd n8n-backend
docker compose up -d
docker compose ps
```

Abrir:

```text
http://localhost:5678
```

### Frontend

En otra terminal:

```bash
cd certi-matricula-app
npm install
npx ng serve
```

Abrir:

```text
http://localhost:4200/chat
```

### Detener backend

```bash
cd n8n-backend
docker compose down
```

---

## IMPORTANTE

Este repositorio contiene código y configuración de desarrollo.

No deben almacenarse credenciales reales dentro del código fuente.

Las configuraciones sensibles deben mantenerse fuera del repositorio mediante
archivos locales ignorados por Git y, cuando corresponda, mediante variables y
Secrets del entorno de CI/CD o del servidor.