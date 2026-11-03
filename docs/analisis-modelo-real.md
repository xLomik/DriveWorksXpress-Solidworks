# Análisis de los archivos de referencia "NUEVO 2"

Revisión de la carpeta `NUEVO 2` (53 archivos, SOLIDWORKS 2025 SP2) y qué cambia en el configurador.
El árbol de operaciones, las cotas y las propiedades se extrajeron directamente de los `.SLDPRT/.SLDASM`, sin
abrir SOLIDWORKS. Las cotas se leyeron de los planos PDF.

---

## 1. Qué hay en la carpeta

Es el filtro **multicartucho de 8"** (cliente Watercol), en dos versiones:

| | PAH 0.200 (19/10/2026) | WAT, plano general (26/10/2026) |
|---|---|---|
| Ensamble | `ENSAMBLE 444` | `ENDABLE 2 WT` (ensamble general) → `ENSANBLE 2 SART WT` (cartuchos) |
| Cuerpo | tubería 8" | tubería 8" "clase 40" |
| Entrada / salida | brida 3" / brida 3" | brida 2" 150 psi / brida 2" 150 psi |
| Altura entrada / salida (eje, desde el fondo del tubo) | 800 / 46 (754 entre boquillas) | 434 / 46 (388 entre boquillas) |
| Soporte de cartuchos | a 83 mm del fondo del tubo | a 83 mm del fondo del tubo |
| Cartuchos | 5 alrededor en Ø130 | 6 alrededor en Ø140 (la placa guía tiene además un paso central de Ø65) |
| Cartucho | 2.5" × 40" (`FILTRO 2.5X40`) | 2.5" × 40" |
| Cierre | anillo superior + anillo inferior con ranura de O'ring, tornillos pivotados, brazo y bisagra, cáncamos | igual |
| Otros | — | 3 coupling 1/4" NPT, drenaje 1/2" NPT, 3 patas |

Cotas principales del plano WAT: altura 1200, anillos Ø256 × 22 con paso interior Ø211.58 y ranura de
O'ring Ø227.97–241.95 (6.99 × 4). Soporte de cartuchos Ø211.6 × 9, tapa soporte Ø207 × 4.5, separador
guía Ø214 × 6, tornillo central Ø19 × 1100 (rosca 5/8" NC en 75 mm).

## 2. Encaja con tu codificación: `PAH-0200-21-082`

La carpeta original se llama `...\WATERCOL\PAH-0200-21-082\CARCASA\...`. Ese nombre es exactamente tu código
de 12 caracteres, **agrupado con guiones**:

| P | A | H | 0200 | 2 | 1 | 08 | 2 |
|---|---|---|---|---|---|---|---|
| No colineal, varios cartuchos concéntricos | Brida | Brida especial, extremo, tornillo pivotado, O'ring | 2" | S.S. 304 | 150 psi | 8" | Sch 10 |

Coincide con el diseño: entrada y salida a distinta altura en lados opuestos (no colineal), anillos con
O'ring y tornillos pivotados (H), bridas de 2" a 150 psi y 8" de cuerpo. Por eso el configurador ahora
arma el código **con guiones** (`PAH-0200-21-082`).

## 3. Inconsistencias que conviene revisar

1. **Schedule.** El código dice Sch 10 (2) y el plano WAT dice "8" clase 40". Los internos están hechos para
   Sch 10: el diámetro interior de 8" Sch 10 es 219.1 − 2×3.76 = **211.58**, justo el paso de los anillos y
   el Ø211.6 del soporte. En Sch 40 el interior es 202.7, y esas placas no entrarían.
2. **Separador guía Ø214 y soporte Ø213** (plano WAT y carpeta `LASER/LACER ACTUAL`). Son más grandes que el
   interior de 211.58, así que no pasan por la boca del anillo. En PAH son Ø211.6. Si el soporte apoya sobre
   el paso del anillo, el separador (que va dentro del tubo) igual debería ser menor que 211.58.
3. **Brida de conexión.** PAH lleva brida de 3" y el código 0200 dice 2". WAT sí usa 2".
4. **Dos piezas con el mismo nombre en carpetas distintas:** `SOPORTE 2 CANAS WT` (Ø211.6 en la raíz, Ø213 en
   `LASER/LACER ACTUAL`) y `pata 222 wt`. DriveWorksXpress toma la que esté referenciada en el ensamble.
   Conviene dejar una sola.
5. **Ningún modelo tiene material asignado** ("Material <sin especificar>") **ni propiedades
   personalizadas**. El peso y la lista de materiales salen vacíos.
6. Las cotas tienen nombres automáticos (`D1@Croquis1`) y hay una llamada `193@Croquis1` en `TAPA SOPORTE WT`
   que vale 207. Para DriveWorksXpress conviene renombrarlas (sección 5).

## 4. Faltan 17 archivos y cómo se reemplazan

Los ensambles referencian piezas que no venían en la carpeta. Estaban en el Google Drive de la PC donde se
modeló el filtro (`G:\Mi unidad\...\PLANOTECA\CLIENTES NACIONALES-\WATERCOL\PAH-0200-21-082\CARCASA\ENSAMBLE NUEVO`;
`pata wt` estaba en `...\WATERCOL\YIC-0200-21-082\BF2`):

```
CUERPO FILTRO PAH WT                CAP PAH WT                        CAP SUPERIOR Ø8 PULGADAS PAH WT
Anillo de cierre inferior 8 PULGADAS  WT                              Anillo de cierre superior para 8 PULGADAS PAH WT
brida 2 pulgadas slip on carcasa 8 pulgadas PAH WT                    OREJA SUPERIOR ESP  PAH WT
OREJA INFERIOR ESP PAH WT           BRAZO PAH WT                      Soporte de bisagra 8 PULGADAS
TORNILLO PAH WT                     TUERCA ROSCA PAH WT               pata wt
MIPLE media pulgada wt              filtrante polinero wt             ensamble soporte cartucho (soporte cartucho wt + guia sartucho wt)
SOP. TAPA CART WT (solo en la versión PAH)
```

**Si alguien tiene esa planoteca:** que abra `ENDABLE 2 WT.SLDASM`, vaya a `Archivo > Pack and Go`, marque
"Incluir planos" y "Guardar en archivo Zip". Así salen los originales.

**Si nadie la tiene:** la macro [`macros/CrearPiezasFaltantes.bas`](../macros/CrearPiezasFaltantes.bas) las
reconstruye con el mismo nombre de archivo, con las medidas de las hojas 1 a 4 del plano WAT:

| Pieza | Cómo queda |
|---|---|
| Cuerpo | Tubo 219.1 × 3.76 × 1200 (Sch 10, como el código) |
| Caps fondo y tapa | Bombeados: falda de 10 y altura total de 45, mismo espesor que el tubo |
| Anillos de cierre | Ø256 × 22, paso Ø211.58, asiento del tubo Ø219.1 × 8; el inferior con la ranura de O'ring Ø227.97–241.95 × 4 |
| Brida 2" slip-on | ASME B16.5 clase 150: Ø152.4 × 19.05, 4 agujeros de 19.05 en Ø120.65, con su tubo de 2" Sch 40 |
| Tornillo pivotado | Ojo Ø25.4 con agujero de 14.5, vástago 3/4" × 82.8 |
| Cartucho | 2.5" × 40": Ø63.5 / 28 × 1016 |
| Soporte y guía de cartucho | Vaso Ø28 / 22 × 25 y guía cónica (las 3 aletas, simplificadas) |
| Pata | Base Ø90 × 9 y ángulo de 30 × 30 × 3, alto 196.82 |
| Orejas, brazo, soporte de bisagra, tuerca | **Simplificadas**: el plano no las acota |

Pasos: copia la carpeta NUEVO 2 a una carpeta de trabajo, ejecuta la macro sobre esa carpeta y abre
`ENDABLE 2 WT.SLDASM` desde ahí. SOLIDWORKS encuentra las piezas por su nombre, pero son piezas nuevas: las
relaciones de posición que tocaban esas piezas salen con error y hay que rehacerlas. La macro no reemplaza
ningún archivo que ya exista. `SOP. TAPA CART WT` no se reconstruye porque no hay plano de la versión PAH.

## 5. Cómo cambia el configurador

**Recomendación:** para la familia multicartucho (modelos P, W, Q, F) usar **tu propio ensamble**
`ENDABLE 2 WT` como modelo maestro de DriveWorksXpress, en lugar de las piezas genéricas `FC_*`. Tu modelo
ya tiene el detalle real (anillos con O'ring, pivotados, bisagra, internos). Solo hay que:

1. Hacer una **copia con Pack and Go** en una carpeta nueva (por ejemplo `C:\Configurador_Carcazas\Maestro_PAH`).
   DriveWorksXpress nunca debe trabajar sobre la carpeta de la planoteca.
2. Ejecutar sobre la copia la macro [`macros/PrepararModeloReal.bas`](../macros/PrepararModeloReal.bas). La
   macro renombra las cotas de las piezas que ya tengo, nombra las matrices de los ensambles y agrega las
   propiedades personalizadas.
3. Capturar en DriveWorksXpress los modelos y las cotas renombradas, y pegar las reglas de
   [`reglas-carcazas.md`](reglas-carcazas.md) §10 (el resumen está en la sección 6 de este documento).

Las piezas genéricas `FC_*` (macro `CrearMaestrosCarcaza.bas`) quedan para las familias que todavía no
tienen modelo real: canastilla, cartucho único y especiales.

### Cotas que renombra la macro

| Pieza | Cota actual | Nombre nuevo | Valor | Qué es |
|---|---|---|---|---|
| SOPORTE 2 CANAS WT | D1@Croquis1 | DiamExt | 211.6 | Ø exterior de la placa |
| | D3@Croquis1 | DiamPCD | 140 | círculo de los cartuchos |
| | D4@Croquis1 | DiamAgujero | 28 | agujero de cada cartucho |
| | D2@Croquis1 | DiamCentro | 19 | paso del tornillo central |
| | D1@Saliente-Extruir1 | Espesor | 9 | |
| TAPA SOPORTE WT | 193@Croquis1 | DiamExt | 207 | |
| | D2@Croquis1 | DiamPCD | 140 | |
| | D3@Croquis1 | DiamAgujero | 28 | |
| | D7@Croquis1 | DiamCentro | 19 | |
| | D1@Saliente-Extruir1 | Espesor | 4.5 | |
| plato guia centro | D1@Croquis1 | DiamExt | 213 | separador guía |
| | D2@Croquis1 | DiamPCD | 140 | |
| | D3@Croquis1 | DiamAgujero | 65 | paso de cada cartucho |
| | D5@Croquis1 | DiamCentro | 65 | |
| | D1@Saliente-Extruir1 | Espesor | 6 | |
| TORNILLO WT | D1@Saliente-Extruir1 | Largo | 1100 | tornillo central |
| | D1@Croquis1 | Diam | 19 | |
| tapa pata wt | D4@Croquis1 | DiamCuerpo | 219 | copia el Ø exterior del tubo |
| SOPORTE BISAGRA WT | D1@Croquis1 | DiamAnillo | 256 | copia el Ø exterior del anillo |
| couplin un cuarto wt | D1@Croquis6 | DiamInterior | 211.6 | referencia de posición |
| ENSANBLE 2 SART WT | D1@MatrizC local1 y D1@MatrizC local2 | NumCartuchos | 6 | una matriz repite los cartuchos y la otra sus soportes |
| ENSAMBLE 444 | D1@MatrizC local1 y D1@MatrizC local2 | NumCartuchos | 5 | |
| ENDABLE 2 WT | D1@MatrizC local1 | NumPivotados | 4 | tornillos pivotados |
| | D1@MatrizC local2 | NumPatas | 3 | matriz de las patas |

La tornillería (pasador, arandela, resorte, tuerca, férula, codo, soporte y tope de resorte) no cambia con
el diámetro, así que no se toca.

**Agujeros de las placas.** En las placas los agujeros están dibujados en el croquis, así que su cantidad
no es una cota y DriveWorksXpress no puede cambiarla. Para variar el número de cartuchos, deja un solo
agujero en el croquis y repítelo con una **matriz circular** (Insertar > Matriz/Simetría > Matriz circular).
El número de instancias de esa matriz sí se puede capturar.

## 6. Reglas propuestas para la familia multicartucho

Las relaciones salen de tus propias medidas (8" Sch 10, OD 219.1, ID 211.58):

| Cota | Regla propuesta | Comprobación con tu modelo |
|---|---|---|
| Anillos: Ø exterior | OD + 37 | 219.1 + 37 = 256 ✓ |
| Anillos: paso interior | ID | 211.58 ✓ |
| Anillos: ranura O'ring | centro en OD + 15.9, ancho 6.99, profundidad 4 | 234.96 ✓ |
| Soporte cartuchos: Ø | ID (apoya en el paso del anillo) | 211.6 ✓ |
| Tapa soporte: Ø | ID − 4.6 | 207 ✓ |
| Separador guía: Ø | ID − 2 (**hoy 213–214, ver §3.2**) | — |
| Círculo de cartuchos (PCD) | 140 con 6 alrededor, 130 con 5 | ✓ |
| Nº de cartuchos (matriz) | entrada `CartuchosAlrededor` | 6 / 5 ✓ |
| Tornillo central: largo | largo cartucho + 84 | 1016 + 84 = 1100 ✓ |
| Cuerpo: altura | largo cartucho + 184 | 1016 + 184 = 1200 ✓ |
| Altura salida | radio del tubo de conexión + 16 | 30.15 + 16 = 46 ✓ (ambas versiones) |
| Altura entrada | entrada `AlturaEntrada` (800 en PAH, 434 en WAT) | — |
| Elemento: parte superior | largo cartucho + 92 (soporte a 83 + 9 de espesor) | 1108 |
| Cara de las bridas | radio del cuerpo + 105.45 | 430 de cara a cara ✓ |
| Tapa pata / soporte bisagra | OD / Ø anillo | 219 / 256 ✓ |

El OD y el espesor salen de las mismas reglas de `reglas-carcazas.md` §4 (según Ø carcaza y schedule).
`ID = OD − 2 × espesor`. La regla de cada cota se arma igual que en ese documento.

Las reglas de las piezas reconstruidas (cuerpo, caps, anillos, brida y cartucho) están en
[`reglas-carcazas.md`](reglas-carcazas.md) §10.
