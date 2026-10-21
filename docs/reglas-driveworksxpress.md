# Hoja de reglas para DriveWorksXpress (filtro de bolsa)

Esta hoja corresponde **exactamente** a los nombres que crea la macro
[`macros/CrearMaestrosFiltroBolsa.bas`](../macros/CrearMaestrosFiltroBolsa.bas). Sigue el orden de las
pestañas de DriveWorksXpress (SOLIDWORKS 2022: `Herramientas > Productos Xpress > DriveWorksXpress`).

> **Sintaxis.** En las reglas, `[TamanoBolsa]` significa "inserta la entrada TamanoBolsa" con el generador
> de reglas. Si tu Windows usa coma decimal, escribe los decimales como el generador te lo pida (por
> ejemplo `109,55` y `;` como separador). Pruébalo con la primera regla antes de pegar el resto.

## 0. Ejecutar la macro

1. Abre SOLIDWORKS 2022 sin ningún documento abierto.
2. `Herramientas > Macro > Nueva`, guarda como `CrearMaestros.swp`.
3. En el editor VBA: `Archivo > Importar archivo...` → `CrearMaestrosFiltroBolsa.bas`. Borra el
   módulo vacío que se creó (`Module1`).
4. Pon el cursor dentro de `Sub main()` y pulsa **F5**. Acepta o cambia la carpeta propuesta.
5. Al terminar verás 5 modelos y 5 planos en la carpeta. Abre `FB_Ensamble.SLDASM` y revisa:
   - Que reconstruya sin errores.
   - Que las dos boquillas apunten hacia afuera con la brida por fuera. Si alguna está al revés, edita la
     relación `Boquilla .../exterior` y cambia la alineación.
   - Los planos se crean con tu plantilla por defecto; ordena vistas y cotas a tu gusto.

La macro no se pudo probar fuera de tu SOLIDWORKS. Si se detiene con un error, envíame el mensaje exacto
y lo corrijo.

## 1. Pestaña Modelos: qué capturar

Con `FB_Ensamble.SLDASM` abierto, captura los 5 modelos y, en cada uno:

### FB_Cuerpo
| Tipo | Nombre en SOLIDWORKS |
|---|---|
| Cota | `RadioExt@Croquis_Cuerpo` |
| Cota | `Espesor@Croquis_Cuerpo` |
| Cota | `EspesorFondo@Croquis_Cuerpo` |
| Cota | `Altura@Croquis_Cuerpo` |
| Cota | `RadioPatas@Croquis_Patas` |
| Cota | `Distancia@Plano_Tapa` |
| Cota | `Distancia@Plano_Entrada` |
| Cota | `Distancia@Plano_Salida` |
| Cota | `Distancia@Plano_Boq_Ent` |
| Cota | `Distancia@Plano_Boq_Sal` |
| Operación | `Patas` |

### FB_Tapa
| Tipo | Nombre |
|---|---|
| Cota | `DiamTapa@Croquis_Tapa` |
| Cota | `Espesor@Extruir_Tapa` |
| Operación | `Toma_Manometro` |

### FB_Boquilla
| Tipo | Nombre |
|---|---|
| Cota | `DiamTubo@Croquis_Tubo` |
| Cota | `DiamInt@Croquis_Tubo` |
| Cota | `Largo@Tubo` |
| Cota | `DiamBrida@Croquis_Brida` |
| Cota | `DiamInt@Croquis_Brida` |
| Cota | `DiamExt@Croquis_Manguito` |
| Cota | `DiamInt@Croquis_Manguito` |
| Operación | `Brida` |
| Operación | `Manguito_Roscado` |

### FB_Canasta
| Tipo | Nombre |
|---|---|
| Cota | `DiamExt@Croquis_Canasta` |
| Cota | `DiamInt@Croquis_Canasta` |
| Cota | `Altura@Extruir_Canasta` |

### Todos los modelos
Propiedades personalizadas: `Codigo`, `Descripcion`, `Material`, `PresionDiseno`, `Espesor`.

## 2. Pestaña Formulario

| Nombre | Control | Valores |
|---|---|---|
| `Referencia` | Cuadro de texto, obligatorio | — |
| `TamanoBolsa` | Lista desplegable | `1` `2` `3` `4` |
| `DN` | Lista desplegable | `25` `40` `50` `80` |
| `TipoConexion` | Lista desplegable | `Bridada` `Roscada` |
| `Material` | Lista desplegable | `AISI 304` `AISI 316L` `Acero al carbono` |
| `PresionBar` | Cuadro numérico | mín. 1, máx. 16 |
| `ConPatas` | Casilla de verificación | — |
| `ConManometro` | Casilla de verificación | — |

## 3. Pestaña Reglas

DriveWorksXpress no tiene variables, así que tres expresiones se repiten. Cópialas tal cual donde aparezcan:

- **R** (radio exterior, mm):
  `IF(OR([TamanoBolsa]="1",[TamanoBolsa]="2"),109.55,70.65)`
- **H** (altura del cuerpo, mm):
  `IF([TamanoBolsa]="1",560,IF([TamanoBolsa]="2",950,IF([TamanoBolsa]="3",340,490)))`
- **T** (espesor de pared, mm; ASME VIII Ap. 1-1, E = 0.7, mínimo 3 mm):
  `IF(ROUNDUP(([PresionBar]/10)*IF(OR([TamanoBolsa]="1",[TamanoBolsa]="2"),109.55,70.65)/(IF([Material]="AISI 316L",115,138)*0.7+0.4*([PresionBar]/10))+IF([Material]="Acero al carbono",1.5,0),0)<3,3,ROUNDUP(([PresionBar]/10)*IF(OR([TamanoBolsa]="1",[TamanoBolsa]="2"),109.55,70.65)/(IF([Material]="AISI 316L",115,138)*0.7+0.4*([PresionBar]/10))+IF([Material]="Acero al carbono",1.5,0),0))`
- **D** (Ø exterior del tubo según DN, mm):
  `IF([DN]="25",33.4,IF([DN]="40",48.3,IF([DN]="50",60.3,88.9)))`

### 3a. Nombres de archivo

| Modelo | Regla |
|---|---|
| FB_Ensamble | `"FB-" & [Referencia] & "-B" & [TamanoBolsa] & "-DN" & [DN]` |
| FB_Cuerpo | `"FB-" & [Referencia] & "-CUERPO"` |
| FB_Tapa | `"FB-" & [Referencia] & "-TAPA"` |
| FB_Boquilla | `"FB-" & [Referencia] & "-BOQ-DN" & [DN]` |
| FB_Canasta | `"FB-" & [Referencia] & "-CANASTA"` |

### 3b. Cotas

| Cota | Regla |
|---|---|
| `RadioExt@Croquis_Cuerpo` | **R** |
| `Altura@Croquis_Cuerpo` | **H** |
| `Espesor@Croquis_Cuerpo` | **T** |
| `EspesorFondo@Croquis_Cuerpo` | **T** |
| `RadioPatas@Croquis_Patas` | **R** `- 25` |
| `Distancia@Plano_Tapa` | **H** |
| `Distancia@Plano_Entrada` | `ROUND(`**H**`*0.75,0)` |
| `Distancia@Plano_Salida` | `ROUND(`**H**`*0.25,0)` |
| `Distancia@Plano_Boq_Ent` | **R** `+ 100` |
| `Distancia@Plano_Boq_Sal` | **R** `+ 100` |
| `DiamTapa@Croquis_Tapa` | `2*`**R**`+40` |
| `Espesor@Extruir_Tapa` | **T** |
| `DiamTubo@Croquis_Tubo` | **D** |
| `DiamInt@Croquis_Tubo` | **D** `- 6` |
| `Largo@Tubo` | `100 + `**T** |
| `DiamBrida@Croquis_Brida` | `IF([DN]="25",115,IF([DN]="40",150,IF([DN]="50",165,200)))` |
| `DiamInt@Croquis_Brida` | **D** `- 6` |
| `DiamExt@Croquis_Manguito` | **D** `+ 12` |
| `DiamInt@Croquis_Manguito` | **D** `- 6` |
| `DiamExt@Croquis_Canasta` | `2*(`**R**`-`**T**`)-10` |
| `DiamInt@Croquis_Canasta` | `2*(`**R**`-`**T**`)-14` |
| `Altura@Extruir_Canasta` | **H** `- 60` |

Diámetros de brida aproximados a EN 1092-1 PN16; ajústalos a tu norma.

### 3c. Operaciones

| Operación | Activa cuando |
|---|---|
| `Patas` | `[ConPatas]` está marcada |
| `Toma_Manometro` | `[ConManometro]` está marcada |
| `Brida` | `[TipoConexion]="Bridada"` |
| `Manguito_Roscado` | `[TipoConexion]="Roscada"` |

En el generador: `IF(<condición>, <Activa>, <Suprimida>)`, eligiendo los dos estados de la lista que te ofrece.

### 3d. Propiedades personalizadas (en todos los modelos)

| Propiedad | Regla |
|---|---|
| `Codigo` | `"FB-" & [Referencia] & "-B" & [TamanoBolsa] & "-DN" & [DN]` |
| `Descripcion` | `"Filtro de bolsa #" & [TamanoBolsa] & ", DN" & [DN] & " " & [TipoConexion] & ", " & [Material] & ", " & [PresionBar] & " bar"` |
| `Material` | `[Material]` |
| `PresionDiseno` | `[PresionBar] & " bar"` |
| `Espesor` | **T** `& " mm"` |

## 4. Prueba rápida

En la pestaña Ejecutar, genera `Referencia = PRUEBA1`, bolsa 2, DN80, Bridada, Acero al carbono, 16 bar,
con patas y manómetro. Debes obtener un cuerpo de 950 mm de alto y pared de **4 mm**. Luego prueba bolsa
3, DN25, Roscada, sin patas: el manguito aparece y la brida y las patas desaparecen.
