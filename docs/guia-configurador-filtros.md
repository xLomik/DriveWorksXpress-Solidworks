# Guía: configurador guiado de filtros industriales con DriveWorksXpress

Esta guía explica, de principio a fin, cómo construir un configurador de producto para una familia de
filtros industriales usando **DriveWorksXpress** (la versión gratuita incluida en SOLIDWORKS). Usa como
ejemplo una **carcasa de filtro de bolsa (bag filter) de una sola bolsa**, pero el método sirve igual para
filtros de cartucho, filtros canasta o filtros en Y.

> Los valores numéricos de ingeniería (diámetros, esfuerzos admisibles, espesores) son **de ejemplo** para
> ilustrar las reglas. Antes de fabricar, valídalos con tus normas (ASME VIII, EN 13445, etc.), tus
> proveedores de bolsas y tu responsable de diseño de recipientes a presión.

---

## 1. Qué es DriveWorksXpress y qué puede (y no puede) hacer

DriveWorksXpress es un asistente dentro de SOLIDWORKS que toma un modelo "maestro" (ensamble, piezas y
planos), te deja definir un **formulario** de entradas y unas **reglas**, y con cada especificación genera
**copias nuevas** de los archivos con las cotas, operaciones y propiedades cambiadas.

| Puede | No puede |
|---|---|
| Capturar piezas, ensambles y sus planos (un plano por pieza/ensamble) | Agregar o quitar instancias de componentes en el ensamble |
| Controlar **cotas** (incluye número de instancias de una matriz) | Usar tablas, Excel o bases de datos externas como origen de datos |
| Suprimir / activar **operaciones** | Tener variables intermedias o constantes reutilizables (cada regla es una fórmula completa) |
| Escribir **propiedades personalizadas** (título, material, descripción, etc.) | Generar PDF, STEP, DXF, Excel o Word (solo archivos SOLIDWORKS) |
| Definir el **nombre de los archivos** generados | Vista previa 3D en vivo, varios formularios, controles dinámicos |
| Formulario con 5 tipos de control: cuadro de texto, cuadro numérico (con mín./máx.), lista desplegable, botón de giro y casilla de verificación | Ejecutarse desatendido, en la web o integrado con ERP/PDM |

Los datos del proyecto se guardan en una base de datos Access (`.mdb`) que tú eliges al crear el proyecto.

**Cuándo pasar a DriveWorks Solo/Pro:** si necesitas tablas de datos (por ejemplo, un catálogo de bridas),
exportar PDF/STEP/DXF automáticamente, varios formularios con navegación, vista previa en vivo, o un
configurador web para clientes. Todo lo que construyas en Xpress (modelos bien nombrados y reglas) se
aprovecha al migrar.

---

## 2. Requisitos previos

1. **SOLIDWORKS** (cualquier licencia: Standard, Professional o Premium) en Windows.
2. **Activar DriveWorksXpress**: `Herramientas > Productos Xpress > DriveWorksXpress` (en versiones
   anteriores a 2017 está en `Herramientas > DriveWorksXpress`). La primera vez pide un código de
   activación gratuito que se solicita desde el mismo diálogo.
3. Una **carpeta de trabajo limpia**, por ejemplo:

```
C:\Configurador_Filtros\
├── Maestro\        ← modelos maestros (NO se tocan al generar)
│   ├── FB_Ensamble.SLDASM
│   ├── FB_Cuerpo.SLDPRT
│   ├── FB_Tapa.SLDPRT
│   ├── FB_Boquilla.SLDPRT
│   ├── FB_Canasta.SLDPRT
│   └── *.SLDDRW   ← un plano por modelo, mismo nombre que el modelo
├── Proyecto\FiltrosBolsa.mdb   ← base de datos de DriveWorksXpress
└── Salida\         ← aquí caen los filtros generados
```

> **Importante:** todos los archivos maestros deben estar en la misma carpeta (o subcarpetas) y los planos
> deben tener **el mismo nombre que su modelo** para que DriveWorksXpress los encuentre. No captures
> componentes de Toolbox; déjalos como referencias fijas.

---

## 3. La familia de producto de ejemplo: filtro de bolsa simple

### 3.1 Estructura del ensamble

| Archivo | Contenido | Qué cambia |
|---|---|---|
| `FB_Ensamble` | Ensamble principal | Nada directo; recibe propiedades (código, descripción) |
| `FB_Cuerpo` | Virola cilíndrica + fondo + patas + toma de manómetro | Diámetro, altura, espesor, patas sí/no, manómetro sí/no |
| `FB_Tapa` | Tapa abatible con junta | Diámetro y espesor |
| `FB_Boquilla` | Tubo de entrada/salida con brida **y** extremo roscado (uno se suprime) | Diámetro nominal, tipo de conexión |
| `FB_Canasta` | Canasta perforada que soporta la bolsa | Diámetro y altura |

La entrada y la salida usan la **misma** pieza `FB_Boquilla` insertada dos veces (ambas cambian igual).

### 3.2 Entradas del formulario

| Control | Nombre | Tipo | Valores / límites |
|---|---|---|---|
| Referencia de pedido | `Referencia` | Cuadro de texto (obligatorio) | p. ej. `OT-2026-015` |
| Tamaño de bolsa | `TamanoBolsa` | Lista desplegable | `1`, `2`, `3`, `4` |
| Diámetro nominal de conexión | `DN` | Lista desplegable | `25`, `40`, `50`, `80` |
| Tipo de conexión | `TipoConexion` | Lista desplegable | `Bridada`, `Roscada` |
| Material | `Material` | Lista desplegable | `AISI 304`, `AISI 316L`, `Acero al carbono` |
| Presión de diseño (bar) | `PresionBar` | Cuadro numérico | mín. 1, máx. 16 |
| Con patas | `ConPatas` | Casilla | Sí / No |
| Toma de manómetro | `ConManometro` | Casilla | Sí / No |

Usa listas desplegables siempre que las opciones sean "lo que tu taller sabe fabricar"; evitan errores.

### 3.3 Tabla de datos de ingeniería (referencia para las reglas)

Como Xpress no admite tablas, estos datos se escriben **dentro de las reglas** con `IF` anidados.

| Bolsa | Ø bolsa (mm) | Largo bolsa (mm) | Ø ext. carcasa (mm) | Altura cuerpo (mm) |
|---|---|---|---|---|
| 1 | 180 | 420 | 219.1 | 560 |
| 2 | 180 | 810 | 219.1 | 950 |
| 3 | 105 | 230 | 141.3 | 340 |
| 4 | 105 | 380 | 141.3 | 490 |

| DN | Ø ext. tubo (mm) |
|---|---|
| 25 | 33.4 |
| 40 | 48.3 |
| 50 | 60.3 |
| 80 | 88.9 |

| Material | Esfuerzo admisible S (MPa, aprox. a temp. ambiente) | Sobreespesor de corrosión (mm) |
|---|---|---|
| AISI 304 | 138 | 0 |
| AISI 316L | 115 | 0 |
| Acero al carbono | 138 | 1.5 |

---

## 4. Preparar los modelos maestros en SOLIDWORKS

Esta es la etapa más importante: **un configurador es tan bueno como su modelo maestro**.

### 4.1 Reglas de oro del modelado

1. **Diseña con intención**: todo debe depender de pocas cotas "maestras". Ejemplo: la altura de la canasta
   se relaciona con la altura del cuerpo; las patas se ubican con relaciones al diámetro.
2. **Nombra cotas y operaciones** con nombres claros (clic en la cota → `Propiedades` → `Nombre`). En
   DriveWorksXpress verás `DiamExt@Croquis_Virola`, mucho más fácil que `D1@Croquis3`.
3. **Relaciones de posición a planos**, no a caras ni aristas, para que no se rompan cuando cambian las
   dimensiones.
4. **Incluye todas las variantes y suprime**: modela las patas, la toma de manómetro, la brida y la rosca.
   El configurador decide qué queda activo.
5. **Prueba los extremos a mano**: pon el modelo en bolsa 4 + DN 80, y en bolsa 2 + DN 25. Si reconstruye
   sin errores con los valores extremos, funcionará en el configurador.
6. **Propiedades personalizadas** vacías ya creadas en cada archivo (`Archivo > Propiedades >
   Personalizado`): `Descripcion`, `Codigo`, `Material`, `PresionDiseno`, `Espesor`. Vincúlalas al
   cuadro de rotulación de los planos.

### 4.2 Cotas y operaciones a nombrar

> **Atajo:** la macro [`macros/CrearMaestrosFiltroBolsa.bas`](../macros/CrearMaestrosFiltroBolsa.bas) crea estos
> modelos por ti. Usa nombres algo distintos a los de esta sección (radio en vez de diámetro, toma de
> manómetro en la tapa, manguito en vez de rosca cosmética); sus nombres exactos y las reglas listas para
> copiar están en [`reglas-driveworksxpress.md`](reglas-driveworksxpress.md).

**FB_Cuerpo**

| Nombre sugerido | Qué controla |
|---|---|
| `DiamExt@Croquis_Virola` | Diámetro exterior de la carcasa |
| `Altura@Extruir_Virola` | Altura del cuerpo |
| `Espesor@Extruir_Virola` | Espesor de pared (operación de pared delgada) |
| `AlturaBoquillas@Croquis_Boquillas` | Altura del eje de entrada/salida |
| Operación `Patas` (y su matriz `Matriz_Patas`) | Se suprime si `ConPatas` = No |
| Operación `Toma_Manometro` | Se suprime si `ConManometro` = No |

**FB_Boquilla**

| Nombre sugerido | Qué controla |
|---|---|
| `DiamTubo@Croquis_Tubo` | Ø exterior del tubo |
| Operación `Brida` | Activa si `TipoConexion` = Bridada |
| Operación `Rosca_Cosmetica` (o `Rosca`) | Activa si `TipoConexion` = Roscada |

**FB_Tapa** y **FB_Canasta**: `DiamExt@Croquis_Tapa`, `Espesor@Extruir_Tapa`, `Diam@Croquis_Canasta`,
`Altura@Extruir_Canasta`.

### 4.3 Planos

- Crea un plano por pieza y uno del ensamble, con el **mismo nombre** que el modelo.
- Acota usando **cotas del modelo** (insertar elementos del modelo) u ordenadas, para que se actualicen
  solas. Evita cotas "colgantes" que dependan de aristas que desaparecen al suprimir operaciones.
- Usa notas vinculadas a propiedades (`$PRPSHEET:"Descripcion"`) en el cuadro de rotulación.

---

## 5. Crear el proyecto en DriveWorksXpress paso a paso

Abre `FB_Ensamble.SLDASM` (el ensamble de nivel superior) y lanza DriveWorksXpress.

### Paso 1 — Base de datos

Crea una nueva base de datos `Proyecto\FiltrosBolsa.mdb`. Ahí se guardan formulario, reglas y el
historial de especificaciones.

### Paso 2 — Capturar modelos (pestaña *Modelos*)

1. **Capturar modelos**: DriveWorksXpress lista el ensamble y sus componentes. Marca `FB_Ensamble`,
   `FB_Cuerpo`, `FB_Tapa`, `FB_Boquilla` y `FB_Canasta`. Deja fuera tornillería y Toolbox.
2. **Cotas**: para cada modelo, selecciona las cotas de la sección 4.2 y asígnales un nombre corto
   (`DiamExt`, `Altura`, `Espesor`...).
3. **Operaciones**: captura `Patas`, `Matriz_Patas`, `Toma_Manometro`, `Brida`, `Rosca_Cosmetica`.
4. **Propiedades personalizadas**: captura `Descripcion`, `Codigo`, `Material`, `PresionDiseno`,
   `Espesor` en cada modelo donde se necesiten.
5. **Planos**: marca los planos que quieres que se generen junto con cada modelo.

### Paso 3 — Formulario (pestaña *Formulario*)

Crea los 8 controles de la tabla 3.2. Para cada lista desplegable escribe las opciones (una por línea).
En el cuadro numérico `PresionBar` fija mínimo 1 y máximo 16. Marca `Referencia` como obligatorio.

### Paso 4 — Reglas (pestaña *Reglas*)

Cada regla se escribe en el generador de reglas, que te deja insertar entradas del formulario y funciones
(`IF`, `AND`, `OR`, `ROUNDUP`, `MAX`, `MIN`, operadores `+ - * /` y `&` para unir texto). Los nombres
exactos de las entradas los inserta el generador: aquí se escriben como `[Entrada]` por claridad.

#### 4a. Reglas de nombre de archivo (obligatorias)

Cada especificación debe producir nombres **únicos**, o sobrescribirá un filtro anterior.

| Modelo | Regla |
|---|---|
| FB_Ensamble | `"FB-" & [Referencia] & "-B" & [TamanoBolsa] & "-DN" & [DN]` |
| FB_Cuerpo | `"FB-" & [Referencia] & "-CUERPO"` |
| FB_Tapa | `"FB-" & [Referencia] & "-TAPA"` |
| FB_Boquilla | `"FB-" & [Referencia] & "-BOQ-DN" & [DN]` |
| FB_Canasta | `"FB-" & [Referencia] & "-CANASTA"` |

#### 4b. Reglas de cotas

**Diámetro exterior del cuerpo** (`FB_Cuerpo > DiamExt`), y la misma lógica para la tapa:

```
IF(OR([TamanoBolsa]="1", [TamanoBolsa]="2"), 219.1, 141.3)
```

**Altura del cuerpo** (`FB_Cuerpo > Altura`):

```
IF([TamanoBolsa]="1", 560,
 IF([TamanoBolsa]="2", 950,
  IF([TamanoBolsa]="3", 340, 490)))
```

**Altura de la canasta** = altura del cuerpo − 60 mm (repite el IF anidado con los valores 500, 890, 280, 430).

**Diámetro del tubo de la boquilla** (`FB_Boquilla > DiamTubo`):

```
IF([DN]="25", 33.4, IF([DN]="40", 48.3, IF([DN]="50", 60.3, 88.9)))
```

**Altura de boquillas** = 75 % de la altura del cuerpo, redondeada a 5 mm:

```
ROUNDUP(IF([TamanoBolsa]="1",560,IF([TamanoBolsa]="2",950,IF([TamanoBolsa]="3",340,490))) * 0.75 / 5, 0) * 5
```

**Espesor de pared** (`FB_Cuerpo > Espesor`). Fórmula de cilindro a presión interna por radio exterior
(ASME VIII Div. 1, Apéndice 1-1): `t = P·Ro / (S·E + 0.4·P) + CA`, con `P` en MPa (`bar / 10`),
`E = 0.7` (eficiencia de junta sin radiografía), y mínimo constructivo de 3 mm, redondeado hacia arriba al
milímetro. En una sola regla:

```
MAX(3, ROUNDUP(
   ([PresionBar]/10) * (IF(OR([TamanoBolsa]="1",[TamanoBolsa]="2"),219.1,141.3)/2)
   / ( IF([Material]="AISI 316L",115,138) * 0.7 + 0.4*([PresionBar]/10) )
   + IF([Material]="Acero al carbono",1.5,0)
, 0))
```

Ejemplo: bolsa 2, 16 bar, acero al carbono → t ≈ 1.6·109.55/(96.6+0.64) + 1.5 ≈ 3.3 → **4 mm**.

#### 4c. Reglas de operaciones (suprimir / activar)

El generador te ofrece los dos estados posibles (suprimida o activa); la regla devuelve uno u otro con un `IF`.

| Operación | Regla |
|---|---|
| `Patas`, `Matriz_Patas` | `IF([ConPatas]=TRUE, <activa>, <suprimida>)` |
| `Toma_Manometro` | `IF([ConManometro]=TRUE, <activa>, <suprimida>)` |
| `Brida` | `IF([TipoConexion]="Bridada", <activa>, <suprimida>)` |
| `Rosca_Cosmetica` | `IF([TipoConexion]="Roscada", <activa>, <suprimida>)` |

#### 4d. Reglas de propiedades personalizadas

| Propiedad | Regla |
|---|---|
| `Codigo` | `"FB-" & [Referencia] & "-B" & [TamanoBolsa] & "-DN" & [DN]` |
| `Descripcion` | `"Filtro de bolsa #" & [TamanoBolsa] & ", DN" & [DN] & " " & [TipoConexion] & ", " & [Material] & ", " & [PresionBar] & " bar"` |
| `Material` | `[Material]` |
| `PresionDiseno` | `[PresionBar] & " bar"` |
| `Espesor` | La misma fórmula de 4b, unida a `" mm"` |

> **Material de SOLIDWORKS:** la propiedad `Material` alimenta el rótulo y la lista de materiales. Si
> además necesitas que cambie el material asignado a la pieza (para masa y densidad), comprueba en tu
> versión si se puede capturar la configuración; si no, crea una configuración por material en el maestro
> o ajústalo después de generar.

### Paso 5 — Ejecutar (pestaña *Ejecutar*)

1. Elige la carpeta de salida (`Salida\`).
2. Rellena el formulario y pulsa **Crear**. DriveWorksXpress copia los maestros, aplica las reglas,
   reconstruye y guarda con los nombres nuevos, incluidos los planos.
3. Abre el ensamble generado y revisa: reconstrucción sin errores, interferencias, planos actualizados.

---

## 6. Plan de pruebas recomendado

Antes de entregar el configurador a otros, genera al menos estas combinaciones:

| # | Bolsa | DN | Conexión | Material | Presión | Patas | Manómetro | Qué valida |
|---|---|---|---|---|---|---|---|---|
| 1 | 1 | 50 | Bridada | AISI 304 | 6 | Sí | Sí | Caso típico |
| 2 | 2 | 80 | Bridada | Acero al carbono | 16 | Sí | No | Máximos y sobreespesor |
| 3 | 3 | 25 | Roscada | AISI 316L | 1 | No | No | Mínimos y supresiones |
| 4 | 4 | 80 | Roscada | AISI 304 | 10 | No | Sí | Boquilla grande en cuerpo pequeño |

La prueba 4 es intencionadamente incómoda: si una brida DN80 choca con un cuerpo de Ø141, decide si la
combinación es válida. Como Xpress no filtra listas dinámicamente, la protección se hace con una regla
(por ejemplo, limitar el DN efectivo con `IF(OR([TamanoBolsa]="3",[TamanoBolsa]="4"), ...)`) o dejando escrita la restricción
en la etiqueta del control.

---

## 7. Errores frecuentes

| Síntoma | Causa probable | Solución |
|---|---|---|
| El ensamble generado apunta a piezas maestras | Una pieza no fue capturada | Captura todas las piezas que cambian (o que deben copiarse) |
| Se sobrescribe un filtro anterior | Reglas de nombre no únicas | Incluye `Referencia` en todas las reglas de nombre |
| Errores de reconstrucción en ciertos tamaños | Relaciones a caras/aristas o croquis sobredefinidos | Relaciona a planos y prueba extremos a mano |
| El plano no se genera | Nombre distinto al del modelo o en otra carpeta | Mismo nombre y misma carpeta |
| Cotas del plano desaparecen | Acotaste aristas de operaciones suprimidas | Acota con cotas del modelo y referencias estables |

---

## 8. Siguientes pasos

1. Modela el maestro con la estructura de la sección 3 y nombra cotas/operaciones (sección 4).
2. Crea el proyecto en DriveWorksXpress siguiendo la sección 5.
3. Ejecuta el plan de pruebas de la sección 6.
4. Cuando el catálogo crezca (más tamaños, bridas por norma, exportar PDF/DXF para taller), evalúa
   DriveWorks Solo.

## Fuentes

- [Compare DriveWorks Packages: Xpress, Solo & Pro — GoEngineer](https://www.goengineer.com/blog/compare-driveworks-packages)
- [DriveWorksXpress: choosing the best form controls — Javelin](https://www.javelin-tech.com/blog/fr/2025/01/driveworksxpress-choosing-the-best-form-controls/)
- [How to: Set up a DriveWorks Xpress Project — Visiativ](https://visiativ.co.uk/news-resources/setup-driveworks-xpress-project/)
- [Getting started with DriveWorksXpress — Engineers Rule](https://www.engineersrule.com/getting-started-with-driveworksxpress/)
- [DriveWorksXpress — DriveWorks](https://www.driveworks.co.uk/products/driveworksxpress/)
