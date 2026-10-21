# Configurador de carcazas con DriveWorksXpress: diseño

Este documento explica cómo se lleva la hoja **"CODIFICACION CARCAZAS"** a DriveWorksXpress (SOLIDWORKS
2022). También cubre qué se resolvió, qué es provisional y qué hay que confirmar.

Archivos relacionados:

| Archivo | Para qué |
|---|---|
| [`macros/CrearMaestrosCarcaza.bas`](../macros/CrearMaestrosCarcaza.bas) | Crea los modelos maestros `FC_*` con todos los nombres que usan las reglas |
| [`docs/reglas-carcazas.md`](reglas-carcazas.md) | Formulario, opciones de las listas y todas las reglas listas para copiar |
| [`scripts/generar_reglas.py`](../scripts/generar_reglas.py) | Genera la hoja de reglas y las tablas a partir de los datos. Si cambias un dato, se cambia aquí |
| [`datos/`](../datos) | La codificación y las tablas de ingeniería en CSV, más `presion_maxima.xlsx` |

---

## 1. La codificación

`X X X XXXX X X XX X`, 12 caracteres sin separadores. Ejemplo: **`ZAB020021084`**

| Pos. | Campo | Valores | Qué cambia en el modelo |
|---|---|---|---|
| 1 | Modelo de carcaza | 18 letras (D…Z) | Dirección de flujo (posición de las boquillas) y tipo de elemento |
| 2 | Tipo de conexión | A, E, I, O, U | Extremo de las boquillas: brida, férula clamp, unión NPT, liso para soldar, espiga |
| 3 | Tipo de cierre | 18 letras (B…W) | Variante de cierre (brida, clamp, roscado, basculante), accesorios y si va al centro o al extremo |
| 4–7 | Ø conexión | 0050…1200 (½"…12") | Diámetro del tubo de las boquillas y medidas de la brida |
| 8 | Material | 1…7 | Propiedad `Material` y sobreespesor de corrosión del acero al carbono |
| 9 | Presión | 0…5 (≤80…1200 psi) | Clase de brida ASME B16.5 (150 / 300 / 600) |
| 10–11 | Ø carcaza | 02…30 | Diámetro exterior de la virola |
| 12 | Schedule | 1…7 | Espesor de pared (sanitaria, Sch 10…80, otro) |

Las letras X, Y y Z de la tabla de cierres no tienen descripción, así que no se incluyeron.

---

## 2. Lo que DriveWorksXpress permite y cómo afecta este diseño

| Limitación de Xpress | Cómo se resolvió |
|---|---|
| No admite tablas ni bases de datos externas | Cada tabla (OD por Ø, espesor por schedule, bridas por clase) se convierte en un `IF` anidado. El script lo genera para que no haya que escribirlo a mano |
| No tiene variables intermedias | Cada regla repite la expresión completa; por eso algunas son largas (hasta ~3 000 caracteres) |
| Un proyecto trabaja con **un** ensamble maestro | Un solo ensamble genérico de carcaza: cuerpo + cierre + 2 boquillas + elemento. Las variantes son operaciones que se suprimen |
| No agrega instancias de componentes | Las variantes se modelan todas dentro de cada pieza y se activan o suprimen |
| Solo genera archivos SOLIDWORKS (sin PDF/DXF) | Los planos se generan como .SLDDRW; se exportan a PDF a mano o con DriveWorks Solo |

DriveWorksXpress sí permite:
- Funciones tipo Excel en las reglas (`IF`, `OR`, `AND`, `LEFT`, `MID`, `ROUND`…). Las listas desplegables
  llevan el código al principio ("Z - Colineal, 1 cartucho") y las reglas lo extraen con `LEFT`.
- Suprimir operaciones, cambiar cotas (incluidas las distancias de planos de referencia), escribir
  propiedades personalizadas, cambiar configuraciones y nombrar los archivos generados.

---

## 3. Arquitectura del modelo maestro

```
FC_Ensamble
├── FC_Cuerpo      virola + fondo; planos Plano_Cierre, Plano_Elemento, Plano_Entrada,
│                  Plano_Salida, Plano_Boq_Ent, Plano_Boq_Sal (sus distancias las mueve DriveWorks)
├── FC_Cierre      se relaciona con Plano_Cierre; 9 operaciones suprimibles
├── FC_Boquilla ×2 entrada y salida (la misma pieza dos veces); tubo + 4 extremos suprimibles
└── FC_Elemento    se relaciona con Plano_Elemento; provisional
```

Todas las relaciones de posición son entre **planos**, así que el ensamble se reacomoda solo al cambiar
diámetros y alturas.

### Cierres: 18 letras en 9 operaciones

En lugar de modelar 18 cierres, cada letra activa una combinación de 9 operaciones:

| Operación | Cierres que la usan |
|---|---|
| Brida_Cuerpo | B C G H L N Q R S T W |
| Tapa_Plana | B C D F G H K L N Q R S T W |
| Abrazadera_Clamp | D F K |
| Tapa_Roscada | J M P V |
| Davit | B C |
| Esparragos | B N |
| Tornillos_Pivotados | C G H L R S W |
| Tornillo_Central | Q T |
| Bisagra | L W |

Los cierres D, G y P van **al centro**: la regla mueve `Plano_Cierre` a media altura. El sello solo va como
propiedad (`Sello`), porque no cambia la geometría.

### Dirección de flujo (supuesto, confirmar)

| Dirección | Modelos | Cómo se interpretó |
|---|---|---|
| Colineal | Z X V Q N K J F | Entrada y salida en lados opuestos, a la misma altura (en línea) |
| No colineal | Y W T P G D | Entrada arriba y salida abajo, en lados opuestos |
| Direccional | S R M L | Por ahora igual que no colineal. Falta definir la geometría real |

---

## 4. Datos de ingeniería usados

- **Tubería:** OD y espesores ASME B36.10 / B36.19. Sch 10 = 10S hasta 12". Si un schedule no existe para ese
  Ø (Sch 20/60 por debajo de 8", Sch 40/60/80 en 30"), la regla usa Sch 40 o el mayor disponible.
- **Sanitaria:** OD = Ø nominal en pulgadas; espesor 1.65 mm hasta 3", 2.11 en 4", 2.77 en 6–8", 3.4 en 10–12".
  No hay 5", 14" ni mayores.
- **Bridas de conexión:** ASME B16.5 (OD, espesor, círculo de pernos, nº de pernos). Valores de catálogo, a
  revisar contra tu norma.
- **Clase de brida según presión:** ≤80 y 150 psi → clase 150; 300 y 600 psi → clase 300; 900 y 1200 psi →
  clase 600 (a temperatura ambiente, acero al carbono e inoxidable).
- **Presión máxima de la virola:** tabla en `reglas-carcazas.md` §9 y `datos/presion_maxima.xlsx`, según
  ASME VIII-1 Ap. 1-1. Ejemplo: en acero al carbono, Sch 10 no llega a 300 psi en ningún diámetro.

**Provisionales** (reemplázalos con tus estándares): la brida del cuerpo (OD×1.25+60), el espesor de la
tapa, las medidas de los accesorios del cierre, la altura (largo del elemento + 150 mm), las posiciones de
las boquillas y el elemento filtrante (un cilindro).

---

## 5. Pasos para montarlo

1. **Crear los maestros:** en SOLIDWORKS 2022, ejecuta `CrearMaestrosCarcaza.bas` (Herramientas > Macro >
   Nueva → Importar → `main`). Revisa `FC_Ensamble`: debe reconstruir sin errores y las boquillas deben
   tener la brida hacia afuera.
2. **Proyecto DriveWorksXpress:** `Herramientas > Productos Xpress > DriveWorksXpress`, crea una base de datos
   nueva (`Carcazas.mdb`) y captura los 5 modelos, sus planos y todo lo listado en `reglas-carcazas.md`.
3. **Formulario:** crea los 12 controles y pega las opciones de cada lista.
4. **Reglas:** copia cada bloque de `reglas-carcazas.md`.
5. **Probar** al menos con estos códigos:

| Código | Qué valida |
|---|---|
| `ZAB020021084` | Caso base: colineal, brida, davit, 8" Sch 40 |
| `TEF010031041` | No colineal, conexión clamp, cierre clamp, S.S. 316, 4" sanitaria |
| `KIJ005010062` | Unión NPT, tapa quick opening clamp, A.C., ≤80 psi, 6" Sch 10 |
| `WAQ060024126` | Varios cartuchos, brida clase 600 (900 psi), 12" Sch 80, tornillo central |
| `YUG030021303` | Cierre al centro (G), espiga manguera, 30" Sch 20 |

---

## 6. Qué falta y qué necesito confirmar

1. **"Direccional":** ¿qué significa en la posición de las boquillas (por ejemplo, salida por el fondo o ambas
   en el cabezal)?
2. **Elemento filtrante:** el código no incluye largo ni cantidad de cartuchos. Agregué la entrada
   `LargoElemento`. ¿Tienen largos estándar (10", 20", 30", 40") y número de cartuchos por diámetro?
3. **Formato del código:** ¿va pegado (`ZAB020021084`) o con guiones?
4. **Brida del cuerpo y tapa:** ¿tienen tabla propia por diámetro y presión? Si la tienen, la paso a reglas.
5. **Modelos especiales** (M botella, G discos, D placas): la carcaza sale bien; el interno queda pendiente.
6. Si DriveWorksXpress rechaza alguna regla por larga, la alternativa es mover esa tabla a una **tabla de
   diseño** de SOLIDWORKS con configuraciones y que Xpress solo elija la configuración.
