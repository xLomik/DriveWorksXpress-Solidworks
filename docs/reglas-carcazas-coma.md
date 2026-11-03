# Reglas de DriveWorksXpress para la codificación de carcazas (coma decimal)

> Archivo generado por `scripts/generar_reglas.py`. No lo edites a mano: cambia los datos del script y vuelve a ejecutarlo.

Los nombres de cotas y operaciones corresponden a la macro [`macros/CrearMaestrosCarcaza.bas`](../macros/CrearMaestrosCarcaza.bas). Cada regla está en un bloque: cópiala completa en el generador de reglas de DriveWorksXpress. Donde dice `[Entrada]`, el texto ya es el nombre del control; si el generador no lo reconoce al pegar, vuelve a insertar ese control desde la lista de entradas.

> **Coma decimal.** Las reglas usan punto decimal y coma entre argumentos (`ROUND(1.5,0)`). Antes de pegar las largas, prueba esa regla corta en el generador. Si la marca como error (Windows con coma decimal), usa [`reglas-carcazas-coma.md`](reglas-carcazas-coma.md): es la misma hoja con `;` entre argumentos y coma decimal (`ROUND(1,5;0)`).

## 1. Formulario

| Control | Tipo | Notas |
|---|---|---|
| `Referencia` | Cuadro de texto, obligatorio | Nº de pedido u OT; hace únicos los nombres de archivo |
| `Modelo` | Lista desplegable | 18 opciones (abajo) |
| `TipoConexion` | Lista desplegable | 5 opciones (abajo) |
| `TipoCierre` | Lista desplegable | 18 opciones (abajo) |
| `DiamConexion` | Lista desplegable | 12 opciones (abajo) |
| `Material` | Lista desplegable | 7 opciones (abajo) |
| `Presion` | Lista desplegable | 6 opciones (abajo) |
| `DiamCarcaza` | Lista desplegable | 14 opciones (abajo) |
| `Schedule` | Lista desplegable | 7 opciones (abajo) |
| `LargoElemento` | Cuadro numérico (mm) | Largo del cartucho/canastilla (1016 = 40"). No forma parte del código |
| `AlturaEntrada` | Cuadro numérico (mm) | Altura del eje de entrada desde el fondo del tubo (800 en PAH, 434 en WAT) |
| `CartuchosAlrededor` | Botón de giro (3 a 12) | Solo familia multicartucho: 5 en PAH, 6 en WAT |
| `EspesorManual` | Cuadro numérico (mm) | Solo se usa con Schedule 7 - Otro |
| `MaterialOtro` | Cuadro de texto | Solo se usa con Material 7 - Otro |

Opciones de cada lista (pega una por línea; el código va siempre al principio porque las reglas lo leen con `LEFT`):

**Modelo**

```
Z - Colineal, 1 cartucho
Y - No colineal, 1 cartucho
X - Colineal, 1 cartucho (automatizado)
W - No colineal, Varios cartuchos
V - Colineal, Canastilla truncada
T - No colineal, Canastilla normal
S - Direccional, Cartucho
R - Direccional, Canastilla cónica
Q - Colineal, Varios cartuchos cilíndricos concéntricos
P - No colineal, Varios cartuchos cilíndricos concéntricos
N - Colineal, Canastilla invertida
M - Direccional, Tipo botella (filtro aceite carro)
L - Direccional, Canastilla cilíndrica
K - Colineal, Canastilla normal
J - Colineal, Cartucho inclinado tipo Y
G - No colineal, Discos tipo sparkler
F - Colineal, Varios cartuchos
D - No colineal, Placas verticales
```

**TipoConexion**

```
A - Brida
E - Clamp
I - Unión NPT
O - Para soldar
U - Acople manguera
```

**TipoCierre**

```
B - Brida con top davit (extremo, espárrago)
C - Brida especial con top davit (extremo, tornillo pivotado)
D - Clamp sanitario (centro, abrazadera)
F - Clamp sanitario (extremo, abrazadera)
G - Brida especial (centro, tornillo pivotado)
H - Brida especial (extremo, tornillo pivotado)
J - Tapa quick opening roscada (extremo, roscada)
K - Tapa quick opening clamp (extremo, abrazadera)
L - Tapa basculante tipo brazo (extremo, cierre rápido - tornillo pivotado)
M - SMS plástica (Cuno) (extremo, roscada)
N - Brida ciega (extremo, espárrago)
P - Universal SMS roscado (centro, roscado)
Q - Brida especial (extremo, tornillo central (ajuste axial) modelo b)
R - Brida especial (extremo, tornillo pivotado)
S - Brida especial (extremo, tornillos pivotados - tuerca especial)
T - Brida especial (extremo, tornillo central (ajuste axial) modelo a)
V - Roscado (extremo, roscado)
W - Tapa basculante (extremo, con ganchos pivotados)
```

**DiamConexion**

```
0050 - 1/2 pulg
0075 - 3/4 pulg
0100 - 1 pulg
0125 - 1 1/4 pulg
0150 - 1 1/2 pulg
0200 - 2 pulg
0300 - 3 pulg
0400 - 4 pulg
0600 - 6 pulg
0800 - 8 pulg
1000 - 10 pulg
1200 - 12 pulg
```

**Material**

```
1 - A.C.
2 - S.S. 304
3 - S.S. 316
4 - P.P.
5 - Nylon
6 - Aluminio
7 - Otro
```

**Presion**

```
0 - <= 80 psi
1 - 150 psi
2 - 300 psi
3 - 600 psi
4 - 900 psi
5 - 1200 psi
```

**DiamCarcaza**

```
02 - 2 pulg
03 - 3 pulg
04 - 4 pulg
05 - 5 pulg
06 - 6 pulg
08 - 8 pulg
10 - 10 pulg
12 - 12 pulg
14 - 14 pulg
16 - 16 pulg
18 - 18 pulg
20 - 20 pulg
24 - 24 pulg
30 - 30 pulg
```

**Schedule**

```
1 - Sanitaria
2 - Sch 10
3 - Sch 20
4 - Sch 40
5 - Sch 60
6 - Sch 80
7 - Otro
```

## 2. Código del producto

Se usa en el nombre de archivo y en la propiedad `Codigo`. Va con guiones, igual que el nombre de carpeta de tu planoteca: P + A + H, 0200, 2 + 1, 08 + 2 → `PAH-0200-21-082`.

```
LEFT([Modelo];1) & LEFT([TipoConexion];1) & LEFT([TipoCierre];1) & "-" & LEFT([DiamConexion];4) & "-" & LEFT([Material];1) & LEFT([Presion];1) & "-" & LEFT([DiamCarcaza];2) & LEFT([Schedule];1)
```

## 3. Nombres de archivo

| Modelo | Regla |
|---|---|
| FC_Ensamble | `LEFT([Modelo];1) & LEFT([TipoConexion];1) & LEFT([TipoCierre];1) & "-" & LEFT([DiamConexion];4) & "-" & LEFT([Material];1) & LEFT([Presion];1) & "-" & LEFT([DiamCarcaza];2) & LEFT([Schedule];1) & "-" & [Referencia]` |
| FC_Cuerpo | `LEFT([Modelo];1) & LEFT([TipoConexion];1) & LEFT([TipoCierre];1) & "-" & LEFT([DiamConexion];4) & "-" & LEFT([Material];1) & LEFT([Presion];1) & "-" & LEFT([DiamCarcaza];2) & LEFT([Schedule];1) & "-" & [Referencia] & "-CUERPO"` |
| FC_Cierre | `LEFT([Modelo];1) & LEFT([TipoConexion];1) & LEFT([TipoCierre];1) & "-" & LEFT([DiamConexion];4) & "-" & LEFT([Material];1) & LEFT([Presion];1) & "-" & LEFT([DiamCarcaza];2) & LEFT([Schedule];1) & "-" & [Referencia] & "-CIERRE"` |
| FC_Boquilla | `LEFT([Modelo];1) & LEFT([TipoConexion];1) & LEFT([TipoCierre];1) & "-" & LEFT([DiamConexion];4) & "-" & LEFT([Material];1) & LEFT([Presion];1) & "-" & LEFT([DiamCarcaza];2) & LEFT([Schedule];1) & "-" & [Referencia] & "-BOQ"` |
| FC_Elemento | `LEFT([Modelo];1) & LEFT([TipoConexion];1) & LEFT([TipoCierre];1) & "-" & LEFT([DiamConexion];4) & "-" & LEFT([Material];1) & LEFT([Presion];1) & "-" & LEFT([DiamCarcaza];2) & LEFT([Schedule];1) & "-" & [Referencia] & "-ELEM"` |

## 4. FC_Cuerpo

**RadioExt@Croquis_Cuerpo** — radio exterior según Ø carcaza y schedule (sanitaria usa OD de tubo)

```
(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))/2
```

**Espesor@Croquis_Cuerpo** — espesor nominal ASME B36.10/B36.19; si el schedule no existe para ese Ø usa el siguiente más grueso

```
IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))
```

**EspesorFondo@Croquis_Cuerpo** — mismo valor que la pared (provisional)

```
IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))
```

**Altura@Croquis_Cuerpo** — largo del elemento + 184 mm, como tu modelo WAT (1016 + 184 = 1200)

```
([LargoElemento]+184)
```

**Distancia@Plano_Cierre** — cierres D, G y P van al centro

```
IF(OR(LEFT([TipoCierre];1)="D";LEFT([TipoCierre];1)="G";LEFT([TipoCierre];1)="P");ROUND(([LargoElemento]+184)/2;0);([LargoElemento]+184))
```

**Distancia@Plano_Elemento** — parte superior del elemento: tu soporte de cartuchos va a 83 mm del fondo y mide 9 (83 + 9 + 1016 = 1108)

```
[LargoElemento]+92
```

**Distancia@Plano_Entrada**

```
[AlturaEntrada]
```

**Distancia@Plano_Salida** — colineal: misma altura que la entrada; no colineal y direccional: radio del tubo de conexión + 16 (46 mm con 2", como en PAH y WAT)

```
IF(OR(OR(LEFT([Modelo];1)="Y";LEFT([Modelo];1)="W";LEFT([Modelo];1)="T";LEFT([Modelo];1)="P";LEFT([Modelo];1)="G";LEFT([Modelo];1)="D");OR(LEFT([Modelo];1)="S";LEFT([Modelo];1)="R";LEFT([Modelo];1)="M";LEFT([Modelo];1)="L"));ROUND((IF(LEFT([TipoConexion];1)="E";IF(LEFT([DiamConexion];4)="0050";12,7;IF(LEFT([DiamConexion];4)="0075";19,05;IF(LEFT([DiamConexion];4)="0100";25,4;IF(LEFT([DiamConexion];4)="0125";31,75;IF(LEFT([DiamConexion];4)="0150";38,1;IF(LEFT([DiamConexion];4)="0200";50,8;IF(LEFT([DiamConexion];4)="0300";76,2;IF(LEFT([DiamConexion];4)="0400";101,6;IF(LEFT([DiamConexion];4)="0600";152,4;IF(LEFT([DiamConexion];4)="0800";203,2;IF(LEFT([DiamConexion];4)="1000";254;IF(LEFT([DiamConexion];4)="1200";304,8;0))))))))))));IF(LEFT([DiamConexion];4)="0050";21,3;IF(LEFT([DiamConexion];4)="0075";26,7;IF(LEFT([DiamConexion];4)="0100";33,4;IF(LEFT([DiamConexion];4)="0125";42,2;IF(LEFT([DiamConexion];4)="0150";48,3;IF(LEFT([DiamConexion];4)="0200";60,3;IF(LEFT([DiamConexion];4)="0300";88,9;IF(LEFT([DiamConexion];4)="0400";114,3;IF(LEFT([DiamConexion];4)="0600";168,3;IF(LEFT([DiamConexion];4)="0800";219,1;IF(LEFT([DiamConexion];4)="1000";273,1;IF(LEFT([DiamConexion];4)="1200";323,9;0))))))))))))))/2+16;0);[AlturaEntrada])
```

**Distancia@Plano_Boq_Ent y Distancia@Plano_Boq_Sal** — cara de la brida a 105.45 mm de la pared, como en PAH (430 mm de cara a cara en 8")

```
(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))/2+105,45
```

## 5. FC_Cierre

**DiamBrida@Croquis_Brida_Cuerpo y DiamTapa@Croquis_Tapa** — como tus anillos de cierre (219.1 + 37 = 256); con espárragos (B, N) se ensancha 80 mm para que los espárragos queden dentro de la brida (provisional)

```
ROUND(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))+IF(OR(LEFT([TipoCierre];1)="B";LEFT([TipoCierre];1)="N");117;37);0)
```

**DiamInt@Croquis_Brida_Cuerpo**

```
IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))-2*(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual])))))))
```

**DiamClamp@Croquis_Clamp y DiamTapa@Croquis_Tapa_Roscada**

```
ROUND(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))+40;0)
```

**DiamInt@Croquis_Clamp**

```
IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))
```

**Radio@Croquis_Pernos y Radio@Croquis_Pivotados** — provisional: los pivotados van por fuera del anillo, en las orejas

```
ROUND((IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))+37)/2+20;0)
```

**Radio@Croquis_Davit y Radio@Croquis_Bisagra** — por fuera de los espárragos y de los pivotados, para que no se crucen (provisional)

```
ROUND((IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))+37)/2+60;0)
```

**Operaciones** (activa si se cumple la condición, suprimida si no):

| Operación | Condición |
|---|---|
| `Brida_Cuerpo` | `OR(LEFT([TipoCierre];1)="B";LEFT([TipoCierre];1)="C";LEFT([TipoCierre];1)="G";LEFT([TipoCierre];1)="H";LEFT([TipoCierre];1)="L";LEFT([TipoCierre];1)="N";LEFT([TipoCierre];1)="Q";LEFT([TipoCierre];1)="R";LEFT([TipoCierre];1)="S";LEFT([TipoCierre];1)="T";LEFT([TipoCierre];1)="W")` |
| `Tapa_Plana` | `OR(LEFT([TipoCierre];1)="B";LEFT([TipoCierre];1)="C";LEFT([TipoCierre];1)="D";LEFT([TipoCierre];1)="F";LEFT([TipoCierre];1)="G";LEFT([TipoCierre];1)="H";LEFT([TipoCierre];1)="K";LEFT([TipoCierre];1)="L";LEFT([TipoCierre];1)="N";LEFT([TipoCierre];1)="Q";LEFT([TipoCierre];1)="R";LEFT([TipoCierre];1)="S";LEFT([TipoCierre];1)="T";LEFT([TipoCierre];1)="W")` |
| `Abrazadera_Clamp` | `OR(LEFT([TipoCierre];1)="D";LEFT([TipoCierre];1)="F";LEFT([TipoCierre];1)="K")` |
| `Tapa_Roscada` | `OR(LEFT([TipoCierre];1)="J";LEFT([TipoCierre];1)="M";LEFT([TipoCierre];1)="P";LEFT([TipoCierre];1)="V")` |
| `Davit` | `OR(LEFT([TipoCierre];1)="B";LEFT([TipoCierre];1)="C")` |
| `Esparragos` | `OR(LEFT([TipoCierre];1)="B";LEFT([TipoCierre];1)="N")` |
| `Tornillos_Pivotados` | `OR(LEFT([TipoCierre];1)="C";LEFT([TipoCierre];1)="G";LEFT([TipoCierre];1)="H";LEFT([TipoCierre];1)="L";LEFT([TipoCierre];1)="R";LEFT([TipoCierre];1)="S";LEFT([TipoCierre];1)="W")` |
| `Tornillo_Central` | `OR(LEFT([TipoCierre];1)="Q";LEFT([TipoCierre];1)="T")` |
| `Bisagra` | `OR(LEFT([TipoCierre];1)="L";LEFT([TipoCierre];1)="W")` |

## 6. FC_Boquilla

**DiamTubo@Croquis_Tubo** — clamp (E) usa OD de tubo sanitario

```
IF(LEFT([TipoConexion];1)="E";IF(LEFT([DiamConexion];4)="0050";12,7;IF(LEFT([DiamConexion];4)="0075";19,05;IF(LEFT([DiamConexion];4)="0100";25,4;IF(LEFT([DiamConexion];4)="0125";31,75;IF(LEFT([DiamConexion];4)="0150";38,1;IF(LEFT([DiamConexion];4)="0200";50,8;IF(LEFT([DiamConexion];4)="0300";76,2;IF(LEFT([DiamConexion];4)="0400";101,6;IF(LEFT([DiamConexion];4)="0600";152,4;IF(LEFT([DiamConexion];4)="0800";203,2;IF(LEFT([DiamConexion];4)="1000";254;IF(LEFT([DiamConexion];4)="1200";304,8;0))))))))))));IF(LEFT([DiamConexion];4)="0050";21,3;IF(LEFT([DiamConexion];4)="0075";26,7;IF(LEFT([DiamConexion];4)="0100";33,4;IF(LEFT([DiamConexion];4)="0125";42,2;IF(LEFT([DiamConexion];4)="0150";48,3;IF(LEFT([DiamConexion];4)="0200";60,3;IF(LEFT([DiamConexion];4)="0300";88,9;IF(LEFT([DiamConexion];4)="0400";114,3;IF(LEFT([DiamConexion];4)="0600";168,3;IF(LEFT([DiamConexion];4)="0800";219,1;IF(LEFT([DiamConexion];4)="1000";273,1;IF(LEFT([DiamConexion];4)="1200";323,9;0)))))))))))))
```

**DiamInt@Croquis_Tubo, DiamInt@Croquis_Brida, DiamInt@Croquis_Ferrula, DiamInt@Croquis_Union, DiamInt@Croquis_Espiga** — provisional

```
ROUND((IF(LEFT([TipoConexion];1)="E";IF(LEFT([DiamConexion];4)="0050";12,7;IF(LEFT([DiamConexion];4)="0075";19,05;IF(LEFT([DiamConexion];4)="0100";25,4;IF(LEFT([DiamConexion];4)="0125";31,75;IF(LEFT([DiamConexion];4)="0150";38,1;IF(LEFT([DiamConexion];4)="0200";50,8;IF(LEFT([DiamConexion];4)="0300";76,2;IF(LEFT([DiamConexion];4)="0400";101,6;IF(LEFT([DiamConexion];4)="0600";152,4;IF(LEFT([DiamConexion];4)="0800";203,2;IF(LEFT([DiamConexion];4)="1000";254;IF(LEFT([DiamConexion];4)="1200";304,8;0))))))))))));IF(LEFT([DiamConexion];4)="0050";21,3;IF(LEFT([DiamConexion];4)="0075";26,7;IF(LEFT([DiamConexion];4)="0100";33,4;IF(LEFT([DiamConexion];4)="0125";42,2;IF(LEFT([DiamConexion];4)="0150";48,3;IF(LEFT([DiamConexion];4)="0200";60,3;IF(LEFT([DiamConexion];4)="0300";88,9;IF(LEFT([DiamConexion];4)="0400";114,3;IF(LEFT([DiamConexion];4)="0600";168,3;IF(LEFT([DiamConexion];4)="0800";219,1;IF(LEFT([DiamConexion];4)="1000";273,1;IF(LEFT([DiamConexion];4)="1200";323,9;0))))))))))))))*0,85;1)
```

**Largo@Tubo**

```
100+IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))
```

**DiamBrida@Croquis_Brida** — OD ASME B16.5 según clase

```
IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=150;IF(LEFT([DiamConexion];4)="0050";88,9;IF(LEFT([DiamConexion];4)="0075";98,55;IF(LEFT([DiamConexion];4)="0100";107,95;IF(LEFT([DiamConexion];4)="0125";117,35;IF(LEFT([DiamConexion];4)="0150";127;IF(LEFT([DiamConexion];4)="0200";152,4;IF(LEFT([DiamConexion];4)="0300";190,5;IF(LEFT([DiamConexion];4)="0400";228,6;IF(LEFT([DiamConexion];4)="0600";279,4;IF(LEFT([DiamConexion];4)="0800";342,9;IF(LEFT([DiamConexion];4)="1000";406,4;IF(LEFT([DiamConexion];4)="1200";482,6;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=300;IF(LEFT([DiamConexion];4)="0050";95,25;IF(LEFT([DiamConexion];4)="0075";117,35;IF(LEFT([DiamConexion];4)="0100";123,95;IF(LEFT([DiamConexion];4)="0125";133,35;IF(LEFT([DiamConexion];4)="0150";155,45;IF(LEFT([DiamConexion];4)="0200";165,1;IF(LEFT([DiamConexion];4)="0300";209,55;IF(LEFT([DiamConexion];4)="0400";254;IF(LEFT([DiamConexion];4)="0600";317,5;IF(LEFT([DiamConexion];4)="0800";381;IF(LEFT([DiamConexion];4)="1000";444,5;IF(LEFT([DiamConexion];4)="1200";520,7;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=600;IF(LEFT([DiamConexion];4)="0050";95,25;IF(LEFT([DiamConexion];4)="0075";117,35;IF(LEFT([DiamConexion];4)="0100";123,95;IF(LEFT([DiamConexion];4)="0125";133,35;IF(LEFT([DiamConexion];4)="0150";155,45;IF(LEFT([DiamConexion];4)="0200";165,1;IF(LEFT([DiamConexion];4)="0300";209,55;IF(LEFT([DiamConexion];4)="0400";273,05;IF(LEFT([DiamConexion];4)="0600";355,6;IF(LEFT([DiamConexion];4)="0800";419,1;IF(LEFT([DiamConexion];4)="1000";508;IF(LEFT([DiamConexion];4)="1200";558,8;0))))))))))));0)))
```

**Espesor@Brida**

```
IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=150;IF(LEFT([DiamConexion];4)="0050";11,18;IF(LEFT([DiamConexion];4)="0075";12,7;IF(LEFT([DiamConexion];4)="0100";14,22;IF(LEFT([DiamConexion];4)="0125";15,75;IF(LEFT([DiamConexion];4)="0150";17,53;IF(LEFT([DiamConexion];4)="0200";19,05;IF(LEFT([DiamConexion];4)="0300";23,88;IF(LEFT([DiamConexion];4)="0400";23,88;IF(LEFT([DiamConexion];4)="0600";25,4;IF(LEFT([DiamConexion];4)="0800";28,45;IF(LEFT([DiamConexion];4)="1000";30,23;IF(LEFT([DiamConexion];4)="1200";31,75;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=300;IF(LEFT([DiamConexion];4)="0050";14,22;IF(LEFT([DiamConexion];4)="0075";15,75;IF(LEFT([DiamConexion];4)="0100";17,53;IF(LEFT([DiamConexion];4)="0125";19,05;IF(LEFT([DiamConexion];4)="0150";20,57;IF(LEFT([DiamConexion];4)="0200";22,35;IF(LEFT([DiamConexion];4)="0300";28,45;IF(LEFT([DiamConexion];4)="0400";31,75;IF(LEFT([DiamConexion];4)="0600";36,58;IF(LEFT([DiamConexion];4)="0800";41,15;IF(LEFT([DiamConexion];4)="1000";47,75;IF(LEFT([DiamConexion];4)="1200";50,8;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=600;IF(LEFT([DiamConexion];4)="0050";14,22;IF(LEFT([DiamConexion];4)="0075";15,75;IF(LEFT([DiamConexion];4)="0100";17,53;IF(LEFT([DiamConexion];4)="0125";20,57;IF(LEFT([DiamConexion];4)="0150";22,35;IF(LEFT([DiamConexion];4)="0200";25,4;IF(LEFT([DiamConexion];4)="0300";31,75;IF(LEFT([DiamConexion];4)="0400";38,1;IF(LEFT([DiamConexion];4)="0600";47,75;IF(LEFT([DiamConexion];4)="0800";55,63;IF(LEFT([DiamConexion];4)="1000";63,5;IF(LEFT([DiamConexion];4)="1200";66,55;0))))))))))));0)))
```

**Clase de brida (para la propiedad ClaseBrida)**

```
IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))
```

**DiamExt@Croquis_Ferrula**

```
IF(LEFT([DiamConexion];4)="0050";25;IF(LEFT([DiamConexion];4)="0075";25;IF(LEFT([DiamConexion];4)="0100";50,5;IF(LEFT([DiamConexion];4)="0125";50,5;IF(LEFT([DiamConexion];4)="0150";50,5;IF(LEFT([DiamConexion];4)="0200";64;IF(LEFT([DiamConexion];4)="0300";91;IF(LEFT([DiamConexion];4)="0400";119;IF(LEFT([DiamConexion];4)="0600";167;IF(LEFT([DiamConexion];4)="0800";220;IF(LEFT([DiamConexion];4)="1000";269;IF(LEFT([DiamConexion];4)="1200";319,8;0))))))))))))
```

**DiamExt@Croquis_Union**

```
ROUND((IF(LEFT([TipoConexion];1)="E";IF(LEFT([DiamConexion];4)="0050";12,7;IF(LEFT([DiamConexion];4)="0075";19,05;IF(LEFT([DiamConexion];4)="0100";25,4;IF(LEFT([DiamConexion];4)="0125";31,75;IF(LEFT([DiamConexion];4)="0150";38,1;IF(LEFT([DiamConexion];4)="0200";50,8;IF(LEFT([DiamConexion];4)="0300";76,2;IF(LEFT([DiamConexion];4)="0400";101,6;IF(LEFT([DiamConexion];4)="0600";152,4;IF(LEFT([DiamConexion];4)="0800";203,2;IF(LEFT([DiamConexion];4)="1000";254;IF(LEFT([DiamConexion];4)="1200";304,8;0))))))))))));IF(LEFT([DiamConexion];4)="0050";21,3;IF(LEFT([DiamConexion];4)="0075";26,7;IF(LEFT([DiamConexion];4)="0100";33,4;IF(LEFT([DiamConexion];4)="0125";42,2;IF(LEFT([DiamConexion];4)="0150";48,3;IF(LEFT([DiamConexion];4)="0200";60,3;IF(LEFT([DiamConexion];4)="0300";88,9;IF(LEFT([DiamConexion];4)="0400";114,3;IF(LEFT([DiamConexion];4)="0600";168,3;IF(LEFT([DiamConexion];4)="0800";219,1;IF(LEFT([DiamConexion];4)="1000";273,1;IF(LEFT([DiamConexion];4)="1200";323,9;0))))))))))))))*1,5;0)
```

**DiamExt@Croquis_Espiga**

```
ROUND((IF(LEFT([TipoConexion];1)="E";IF(LEFT([DiamConexion];4)="0050";12,7;IF(LEFT([DiamConexion];4)="0075";19,05;IF(LEFT([DiamConexion];4)="0100";25,4;IF(LEFT([DiamConexion];4)="0125";31,75;IF(LEFT([DiamConexion];4)="0150";38,1;IF(LEFT([DiamConexion];4)="0200";50,8;IF(LEFT([DiamConexion];4)="0300";76,2;IF(LEFT([DiamConexion];4)="0400";101,6;IF(LEFT([DiamConexion];4)="0600";152,4;IF(LEFT([DiamConexion];4)="0800";203,2;IF(LEFT([DiamConexion];4)="1000";254;IF(LEFT([DiamConexion];4)="1200";304,8;0))))))))))));IF(LEFT([DiamConexion];4)="0050";21,3;IF(LEFT([DiamConexion];4)="0075";26,7;IF(LEFT([DiamConexion];4)="0100";33,4;IF(LEFT([DiamConexion];4)="0125";42,2;IF(LEFT([DiamConexion];4)="0150";48,3;IF(LEFT([DiamConexion];4)="0200";60,3;IF(LEFT([DiamConexion];4)="0300";88,9;IF(LEFT([DiamConexion];4)="0400";114,3;IF(LEFT([DiamConexion];4)="0600";168,3;IF(LEFT([DiamConexion];4)="0800";219,1;IF(LEFT([DiamConexion];4)="1000";273,1;IF(LEFT([DiamConexion];4)="1200";323,9;0))))))))))))))*0,9;1)
```

Círculo de pernos y nº de pernos (para cuando agregues los agujeros con una matriz circular):

**Círculo de pernos (mm)**

```
IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=150;IF(LEFT([DiamConexion];4)="0050";60,45;IF(LEFT([DiamConexion];4)="0075";69,85;IF(LEFT([DiamConexion];4)="0100";79,25;IF(LEFT([DiamConexion];4)="0125";88,9;IF(LEFT([DiamConexion];4)="0150";98,55;IF(LEFT([DiamConexion];4)="0200";120,65;IF(LEFT([DiamConexion];4)="0300";152,4;IF(LEFT([DiamConexion];4)="0400";190,5;IF(LEFT([DiamConexion];4)="0600";241,3;IF(LEFT([DiamConexion];4)="0800";298,45;IF(LEFT([DiamConexion];4)="1000";361,95;IF(LEFT([DiamConexion];4)="1200";431,8;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=300;IF(LEFT([DiamConexion];4)="0050";66,55;IF(LEFT([DiamConexion];4)="0075";82,55;IF(LEFT([DiamConexion];4)="0100";88,9;IF(LEFT([DiamConexion];4)="0125";98,55;IF(LEFT([DiamConexion];4)="0150";114,3;IF(LEFT([DiamConexion];4)="0200";127;IF(LEFT([DiamConexion];4)="0300";168,15;IF(LEFT([DiamConexion];4)="0400";200,15;IF(LEFT([DiamConexion];4)="0600";269,75;IF(LEFT([DiamConexion];4)="0800";330,2;IF(LEFT([DiamConexion];4)="1000";387,35;IF(LEFT([DiamConexion];4)="1200";450,85;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=600;IF(LEFT([DiamConexion];4)="0050";66,55;IF(LEFT([DiamConexion];4)="0075";82,55;IF(LEFT([DiamConexion];4)="0100";88,9;IF(LEFT([DiamConexion];4)="0125";98,55;IF(LEFT([DiamConexion];4)="0150";114,3;IF(LEFT([DiamConexion];4)="0200";127;IF(LEFT([DiamConexion];4)="0300";168,15;IF(LEFT([DiamConexion];4)="0400";215,9;IF(LEFT([DiamConexion];4)="0600";292,1;IF(LEFT([DiamConexion];4)="0800";349,25;IF(LEFT([DiamConexion];4)="1000";431,8;IF(LEFT([DiamConexion];4)="1200";488,95;0))))))))))));0)))
```

**Nº de pernos**

```
IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=150;IF(LEFT([DiamConexion];4)="0050";4;IF(LEFT([DiamConexion];4)="0075";4;IF(LEFT([DiamConexion];4)="0100";4;IF(LEFT([DiamConexion];4)="0125";4;IF(LEFT([DiamConexion];4)="0150";4;IF(LEFT([DiamConexion];4)="0200";4;IF(LEFT([DiamConexion];4)="0300";4;IF(LEFT([DiamConexion];4)="0400";8;IF(LEFT([DiamConexion];4)="0600";8;IF(LEFT([DiamConexion];4)="0800";8;IF(LEFT([DiamConexion];4)="1000";12;IF(LEFT([DiamConexion];4)="1200";12;4))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=300;IF(LEFT([DiamConexion];4)="0050";4;IF(LEFT([DiamConexion];4)="0075";4;IF(LEFT([DiamConexion];4)="0100";4;IF(LEFT([DiamConexion];4)="0125";4;IF(LEFT([DiamConexion];4)="0150";4;IF(LEFT([DiamConexion];4)="0200";8;IF(LEFT([DiamConexion];4)="0300";8;IF(LEFT([DiamConexion];4)="0400";8;IF(LEFT([DiamConexion];4)="0600";12;IF(LEFT([DiamConexion];4)="0800";12;IF(LEFT([DiamConexion];4)="1000";16;IF(LEFT([DiamConexion];4)="1200";16;4))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=600;IF(LEFT([DiamConexion];4)="0050";4;IF(LEFT([DiamConexion];4)="0075";4;IF(LEFT([DiamConexion];4)="0100";4;IF(LEFT([DiamConexion];4)="0125";4;IF(LEFT([DiamConexion];4)="0150";4;IF(LEFT([DiamConexion];4)="0200";8;IF(LEFT([DiamConexion];4)="0300";8;IF(LEFT([DiamConexion];4)="0400";8;IF(LEFT([DiamConexion];4)="0600";12;IF(LEFT([DiamConexion];4)="0800";12;IF(LEFT([DiamConexion];4)="1000";16;IF(LEFT([DiamConexion];4)="1200";20;4))))))))))));4)))
```

| Operación | Condición |
|---|---|
| `Brida` | `LEFT([TipoConexion];1)="A"` |
| `Ferrula_Clamp` | `LEFT([TipoConexion];1)="E"` |
| `Union_NPT` | `LEFT([TipoConexion];1)="I"` |
| `Espiga_Manguera` | `LEFT([TipoConexion];1)="U"` |

Para la conexión O (para soldar) todas quedan suprimidas: solo el tubo.

## 7. FC_Elemento (provisional)

**Diam@Croquis_Elemento**

```
ROUND((IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))-2*(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))))*0,8;0)
```

**Largo@Elemento**

```
[LargoElemento]
```

## 8. Propiedades personalizadas (todos los modelos)

**Codigo**

```
LEFT([Modelo];1) & LEFT([TipoConexion];1) & LEFT([TipoCierre];1) & "-" & LEFT([DiamConexion];4) & "-" & LEFT([Material];1) & LEFT([Presion];1) & "-" & LEFT([DiamCarcaza];2) & LEFT([Schedule];1)
```

**Descripcion**

```
"Carcaza " & MID([Modelo];5;100) & " | Conexión " & MID([TipoConexion];5;100) & " " & MID([DiamConexion];8;20) & " | Cierre " & MID([TipoCierre];5;100) & " | " & MID([Presion];5;20) & " | Ø " & MID([DiamCarcaza];6;20) & " " & MID([Schedule];5;20)
```

**Material**

```
IF(LEFT([Material];1)="1";"A.C.";IF(LEFT([Material];1)="2";"S.S. 304";IF(LEFT([Material];1)="3";"S.S. 316";IF(LEFT([Material];1)="4";"P.P.";IF(LEFT([Material];1)="5";"Nylon";IF(LEFT([Material];1)="6";"Aluminio";[MaterialOtro]))))))
```

**Presion**

```
MID([Presion];5;20)
```

**ClaseBrida**

```
IF(LEFT([TipoConexion];1)="A";"Clase " & IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))));"N/A")
```

**Espesor**

```
IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual])))))) & " mm"
```

**Sello**

```
IF(LEFT([TipoCierre];1)="B";"O'ring";IF(LEFT([TipoCierre];1)="C";"Espirotálico";IF(LEFT([TipoCierre];1)="D";"Empaque teflón";IF(LEFT([TipoCierre];1)="F";"Empaque teflón";IF(LEFT([TipoCierre];1)="G";"O'ring";IF(LEFT([TipoCierre];1)="H";"O'ring";IF(LEFT([TipoCierre];1)="J";"O'ring";IF(LEFT([TipoCierre];1)="K";"O'ring";IF(LEFT([TipoCierre];1)="L";"O'ring";IF(LEFT([TipoCierre];1)="M";"O'ring";IF(LEFT([TipoCierre];1)="N";"Espirotálico";IF(LEFT([TipoCierre];1)="P";"Buna especial";IF(LEFT([TipoCierre];1)="Q";"O'ring";IF(LEFT([TipoCierre];1)="R";"O'ring";IF(LEFT([TipoCierre];1)="S";"O'ring";IF(LEFT([TipoCierre];1)="T";"O'ring";IF(LEFT([TipoCierre];1)="V";"O'ring";IF(LEFT([TipoCierre];1)="W";"O'ring";""))))))))))))))))))
```

## 9. Presión máxima admisible de la virola (psi)

Calculada con ASME VIII Div. 1 Apéndice 1-1, tubería sin costura (E = 1), tolerancia de fabricación -12.5 % y sobreespesor de corrosión de 1/16" en acero al carbono. Úsala para revisar que el schedule elegido aguanta la presión del código. Solo cubre la virola: cierre, bridas y soldaduras se verifican aparte. También está en `datos/presion_maxima.xlsx`.

**A.C.** (S = 17100 psi, sobreespesor 1.59 mm)

| Ø | Sch 10 | Sch 20 | Sch 40 | Sch 60 | Sch 80 |
|---|---|---|---|---|---|
| 02 (2") | 480 | — | 1066 | — | 1933 |
| 03 (3") | 420 | — | 1274 | — | 2048 |
| 04 (4") | 326 | — | 1130 | — | 1842 |
| 05 (5") | 338 | — | 1027 | — | 1699 |
| 06 (6") | 284 | — | 963 | — | 1692 |
| 08 (8") | 267 | 629 | 887 | 1193 | 1540 |
| 10 (10") | 262 | 503 | 833 | 1227 | 1506 |
| 12 (12") | 256 | 423 | 800 | 1183 | 1498 |
| 14 (14") | 385 | 520 | 799 | 1147 | 1501 |
| 16 (16") | 337 | 454 | 817 | 1122 | 1496 |
| 18 (18") | 299 | 403 | 831 | 1159 | 1491 |
| 20 (20") | 269 | 459 | 797 | 1137 | 1486 |
| 24 (24") | 224 | 382 | 783 | 1149 | 1480 |
| 30 (30") | 241 | 432 | — | — | — |

**S.S. 304** (S = 20000 psi, sobreespesor 0 mm)

| Ø | Sch 10 | Sch 20 | Sch 40 | Sch 60 | Sch 80 |
|---|---|---|---|---|---|
| 02 (2") | 1661 | — | 2377 | — | 3437 |
| 03 (3") | 1230 | — | 2259 | — | 3191 |
| 04 (4") | 952 | — | 1914 | — | 2766 |
| 05 (5") | 857 | — | 1677 | — | 2478 |
| 06 (6") | 717 | — | 1524 | — | 2390 |
| 08 (8") | 608 | 1035 | 1342 | 1703 | 2115 |
| 10 (10") | 543 | 827 | 1217 | 1682 | 2012 |
| 12 (12") | 499 | 696 | 1139 | 1591 | 1963 |
| 14 (14") | 633 | 792 | 1120 | 1531 | 1948 |
| 16 (16") | 553 | 692 | 1118 | 1477 | 1917 |
| 18 (18") | 491 | 614 | 1117 | 1502 | 1893 |
| 20 (20") | 441 | 665 | 1062 | 1462 | 1872 |
| 24 (24") | 367 | 553 | 1024 | 1454 | 1843 |
| 30 (30") | 366 | 590 | — | — | — |

**S.S. 316** (S = 20000 psi, sobreespesor 0 mm)

| Ø | Sch 10 | Sch 20 | Sch 40 | Sch 60 | Sch 80 |
|---|---|---|---|---|---|
| 02 (2") | 1661 | — | 2377 | — | 3437 |
| 03 (3") | 1230 | — | 2259 | — | 3191 |
| 04 (4") | 952 | — | 1914 | — | 2766 |
| 05 (5") | 857 | — | 1677 | — | 2478 |
| 06 (6") | 717 | — | 1524 | — | 2390 |
| 08 (8") | 608 | 1035 | 1342 | 1703 | 2115 |
| 10 (10") | 543 | 827 | 1217 | 1682 | 2012 |
| 12 (12") | 499 | 696 | 1139 | 1591 | 1963 |
| 14 (14") | 633 | 792 | 1120 | 1531 | 1948 |
| 16 (16") | 553 | 692 | 1118 | 1477 | 1917 |
| 18 (18") | 491 | 614 | 1117 | 1502 | 1893 |
| 20 (20") | 441 | 665 | 1062 | 1462 | 1872 |
| 24 (24") | 367 | 553 | 1024 | 1454 | 1843 |
| 30 (30") | 366 | 590 | — | — | — |

## 10. Familia multicartucho con tu modelo real (ENDABLE 2 WT)

Nombres de cota después de ejecutar `macros/PrepararModeloReal.bas` sobre una copia hecha con Pack and Go. Las relaciones salen de tus planos PAH y WAT; ver `docs/analisis-modelo-real.md`. `ID` = OD − 2 × espesor.

**ID (diámetro interior del cuerpo, referencia)** — 8" Sch 10 = 211.58

```
((IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))-2*(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))))
```

**DiamExt@Croquis1 en SOPORTE 2 CANAS WT** — apoya en el paso del anillo: 211.6

```
ROUND(((IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))-2*(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))));1)
```

**DiamExt@Croquis1 en TAPA SOPORTE WT** — 207

```
ROUND(((IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))-2*(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))))-4,6;1)
```

**DiamExt@Croquis1 en plato guia centro** — hoy está en 213; debe pasar por el interior del tubo, revisa §3.2 del análisis

```
ROUND(((IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))-2*(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))))-2;1)
```

**DiamPCD@Croquis1 en las tres placas** — 130 con 5 cartuchos, 140 con 6; otros valores con paso de 70 mm

```
IF([CartuchosAlrededor]=5;130;IF([CartuchosAlrededor]=6;140;ROUND(70/SIN(PI()/[CartuchosAlrededor]);0)))
```

**NumCartuchos@MatrizC local1 y NumCartuchos@MatrizC local2 en ENSANBLE 2 SART WT (y ENSAMBLE 444)** — una matriz repite los cartuchos y la otra sus soportes

```
[CartuchosAlrededor]
```

**Largo@Saliente-Extruir1 en TORNILLO WT** — 1016 + 84 = 1100

```
[LargoElemento]+84
```

**DiamCuerpo@Croquis1 en tapa pata wt**

```
ROUND(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))));0)
```

**DiamAnillo@Croquis1 en SOPORTE BISAGRA WT**

```
ROUND(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))+37;0)
```

**DiamInterior@Croquis6 en couplin un cuarto wt**

```
ROUND(((IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))-2*(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))));1)
```

### Piezas reconstruidas con `macros/CrearPiezasFaltantes.bas`

Estas piezas no venían en la carpeta. La macro las crea con el mismo nombre de archivo y estas cotas. Las orejas, el brazo, el soporte de bisagra, la tuerca, la pata y el miple no cambian con el diámetro.

**DiamExt@Croquis_Tubo en CUERPO FILTRO PAH WT**

```
IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))
```

**DiamInt@Croquis_Tubo en CUERPO FILTRO PAH WT**

```
((IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))-2*(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))))
```

**Largo@Tubo en CUERPO FILTRO PAH WT** — 1016 + 184 = 1200

```
([LargoElemento]+184)
```

**RadioExt@Croquis_Cap en CAP PAH WT y CAP SUPERIOR Ø8 PULGADAS PAH WT**

```
(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))/2
```

**Espesor@Croquis_Cap y EspesorCorona@Croquis_Cap (los dos caps)**

```
IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual]))))))
```

**RadioExt@Croquis_Anillo en los dos anillos de cierre** — 256 / 2

```
ROUND(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))+37;0)/2
```

**RadioInt@Croquis_Anillo en los dos anillos de cierre** — 211.58 / 2

```
(((IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))-2*(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";1,65;IF(LEFT([DiamCarcaza];2)="03";1,65;IF(LEFT([DiamCarcaza];2)="04";2,11;IF(LEFT([DiamCarcaza];2)="06";2,77;IF(LEFT([DiamCarcaza];2)="08";2,77;IF(LEFT([DiamCarcaza];2)="10";3,4;IF(LEFT([DiamCarcaza];2)="12";3,4;3)))))));IF(LEFT([Schedule];1)="2";IF(LEFT([DiamCarcaza];2)="02";2,77;IF(LEFT([DiamCarcaza];2)="03";3,05;IF(LEFT([DiamCarcaza];2)="04";3,05;IF(LEFT([DiamCarcaza];2)="05";3,4;IF(LEFT([DiamCarcaza];2)="06";3,4;IF(LEFT([DiamCarcaza];2)="08";3,76;IF(LEFT([DiamCarcaza];2)="10";4,19;IF(LEFT([DiamCarcaza];2)="12";4,57;IF(LEFT([DiamCarcaza];2)="14";6,35;IF(LEFT([DiamCarcaza];2)="16";6,35;IF(LEFT([DiamCarcaza];2)="18";6,35;IF(LEFT([DiamCarcaza];2)="20";6,35;IF(LEFT([DiamCarcaza];2)="24";6,35;IF(LEFT([DiamCarcaza];2)="30";7,92;0))))))))))))));IF(LEFT([Schedule];1)="3";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";6,35;IF(LEFT([DiamCarcaza];2)="10";6,35;IF(LEFT([DiamCarcaza];2)="12";6,35;IF(LEFT([DiamCarcaza];2)="14";7,92;IF(LEFT([DiamCarcaza];2)="16";7,92;IF(LEFT([DiamCarcaza];2)="18";7,92;IF(LEFT([DiamCarcaza];2)="20";9,53;IF(LEFT([DiamCarcaza];2)="24";9,53;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="4";IF(LEFT([DiamCarcaza];2)="02";3,91;IF(LEFT([DiamCarcaza];2)="03";5,49;IF(LEFT([DiamCarcaza];2)="04";6,02;IF(LEFT([DiamCarcaza];2)="05";6,55;IF(LEFT([DiamCarcaza];2)="06";7,11;IF(LEFT([DiamCarcaza];2)="08";8,18;IF(LEFT([DiamCarcaza];2)="10";9,27;IF(LEFT([DiamCarcaza];2)="12";10,31;IF(LEFT([DiamCarcaza];2)="14";11,13;IF(LEFT([DiamCarcaza];2)="16";12,7;IF(LEFT([DiamCarcaza];2)="18";14,27;IF(LEFT([DiamCarcaza];2)="20";15,09;IF(LEFT([DiamCarcaza];2)="24";17,48;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="5";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";10,31;IF(LEFT([DiamCarcaza];2)="10";12,7;IF(LEFT([DiamCarcaza];2)="12";14,27;IF(LEFT([DiamCarcaza];2)="14";15,09;IF(LEFT([DiamCarcaza];2)="16";16,66;IF(LEFT([DiamCarcaza];2)="18";19,05;IF(LEFT([DiamCarcaza];2)="20";20,62;IF(LEFT([DiamCarcaza];2)="24";24,61;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));IF(LEFT([Schedule];1)="6";IF(LEFT([DiamCarcaza];2)="02";5,54;IF(LEFT([DiamCarcaza];2)="03";7,62;IF(LEFT([DiamCarcaza];2)="04";8,56;IF(LEFT([DiamCarcaza];2)="05";9,53;IF(LEFT([DiamCarcaza];2)="06";10,97;IF(LEFT([DiamCarcaza];2)="08";12,7;IF(LEFT([DiamCarcaza];2)="10";15,09;IF(LEFT([DiamCarcaza];2)="12";17,48;IF(LEFT([DiamCarcaza];2)="14";19,05;IF(LEFT([DiamCarcaza];2)="16";21,44;IF(LEFT([DiamCarcaza];2)="18";23,83;IF(LEFT([DiamCarcaza];2)="20";26,19;IF(LEFT([DiamCarcaza];2)="24";30,96;IF(LEFT([DiamCarcaza];2)="30";12,7;0))))))))))))));[EspesorManual])))))))))/2
```

**RadioAsiento@Croquis_Anillo en los dos anillos de cierre** — asiento del tubo: 219.1 / 2

```
(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0))))))))))))))))/2
```

**RadioRanuraInt@Croquis_Anillo en el anillo inferior** — 227.97 / 2

```
(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))+8,87)/2
```

**RadioRanuraExt@Croquis_Anillo en el anillo inferior** — 241.95 / 2; la ranura queda siempre de 6.99 de ancho

```
(IF(LEFT([Schedule];1)="1";IF(LEFT([DiamCarcaza];2)="02";50,8;IF(LEFT([DiamCarcaza];2)="03";76,2;IF(LEFT([DiamCarcaza];2)="04";101,6;IF(LEFT([DiamCarcaza];2)="06";152,4;IF(LEFT([DiamCarcaza];2)="08";203,2;IF(LEFT([DiamCarcaza];2)="10";254;IF(LEFT([DiamCarcaza];2)="12";304,8;IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))))))));IF(LEFT([DiamCarcaza];2)="02";60,3;IF(LEFT([DiamCarcaza];2)="03";88,9;IF(LEFT([DiamCarcaza];2)="04";114,3;IF(LEFT([DiamCarcaza];2)="05";141,3;IF(LEFT([DiamCarcaza];2)="06";168,3;IF(LEFT([DiamCarcaza];2)="08";219,1;IF(LEFT([DiamCarcaza];2)="10";273,1;IF(LEFT([DiamCarcaza];2)="12";323,9;IF(LEFT([DiamCarcaza];2)="14";355,6;IF(LEFT([DiamCarcaza];2)="16";406,4;IF(LEFT([DiamCarcaza];2)="18";457,2;IF(LEFT([DiamCarcaza];2)="20";508;IF(LEFT([DiamCarcaza];2)="24";609,6;IF(LEFT([DiamCarcaza];2)="30";762;0)))))))))))))))+22,85)/2
```

**DiamExt@Croquis_Brida en brida 2 pulgadas slip on carcasa 8 pulgadas PAH WT** — ASME B16.5 según Ø de conexión y clase

```
IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=150;IF(LEFT([DiamConexion];4)="0050";88,9;IF(LEFT([DiamConexion];4)="0075";98,55;IF(LEFT([DiamConexion];4)="0100";107,95;IF(LEFT([DiamConexion];4)="0125";117,35;IF(LEFT([DiamConexion];4)="0150";127;IF(LEFT([DiamConexion];4)="0200";152,4;IF(LEFT([DiamConexion];4)="0300";190,5;IF(LEFT([DiamConexion];4)="0400";228,6;IF(LEFT([DiamConexion];4)="0600";279,4;IF(LEFT([DiamConexion];4)="0800";342,9;IF(LEFT([DiamConexion];4)="1000";406,4;IF(LEFT([DiamConexion];4)="1200";482,6;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=300;IF(LEFT([DiamConexion];4)="0050";95,25;IF(LEFT([DiamConexion];4)="0075";117,35;IF(LEFT([DiamConexion];4)="0100";123,95;IF(LEFT([DiamConexion];4)="0125";133,35;IF(LEFT([DiamConexion];4)="0150";155,45;IF(LEFT([DiamConexion];4)="0200";165,1;IF(LEFT([DiamConexion];4)="0300";209,55;IF(LEFT([DiamConexion];4)="0400";254;IF(LEFT([DiamConexion];4)="0600";317,5;IF(LEFT([DiamConexion];4)="0800";381;IF(LEFT([DiamConexion];4)="1000";444,5;IF(LEFT([DiamConexion];4)="1200";520,7;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=600;IF(LEFT([DiamConexion];4)="0050";95,25;IF(LEFT([DiamConexion];4)="0075";117,35;IF(LEFT([DiamConexion];4)="0100";123,95;IF(LEFT([DiamConexion];4)="0125";133,35;IF(LEFT([DiamConexion];4)="0150";155,45;IF(LEFT([DiamConexion];4)="0200";165,1;IF(LEFT([DiamConexion];4)="0300";209,55;IF(LEFT([DiamConexion];4)="0400";273,05;IF(LEFT([DiamConexion];4)="0600";355,6;IF(LEFT([DiamConexion];4)="0800";419,1;IF(LEFT([DiamConexion];4)="1000";508;IF(LEFT([DiamConexion];4)="1200";558,8;0))))))))))));0)))
```

**Espesor@Brida en brida 2 pulgadas slip on carcasa 8 pulgadas PAH WT**

```
IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=150;IF(LEFT([DiamConexion];4)="0050";11,18;IF(LEFT([DiamConexion];4)="0075";12,7;IF(LEFT([DiamConexion];4)="0100";14,22;IF(LEFT([DiamConexion];4)="0125";15,75;IF(LEFT([DiamConexion];4)="0150";17,53;IF(LEFT([DiamConexion];4)="0200";19,05;IF(LEFT([DiamConexion];4)="0300";23,88;IF(LEFT([DiamConexion];4)="0400";23,88;IF(LEFT([DiamConexion];4)="0600";25,4;IF(LEFT([DiamConexion];4)="0800";28,45;IF(LEFT([DiamConexion];4)="1000";30,23;IF(LEFT([DiamConexion];4)="1200";31,75;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=300;IF(LEFT([DiamConexion];4)="0050";14,22;IF(LEFT([DiamConexion];4)="0075";15,75;IF(LEFT([DiamConexion];4)="0100";17,53;IF(LEFT([DiamConexion];4)="0125";19,05;IF(LEFT([DiamConexion];4)="0150";20,57;IF(LEFT([DiamConexion];4)="0200";22,35;IF(LEFT([DiamConexion];4)="0300";28,45;IF(LEFT([DiamConexion];4)="0400";31,75;IF(LEFT([DiamConexion];4)="0600";36,58;IF(LEFT([DiamConexion];4)="0800";41,15;IF(LEFT([DiamConexion];4)="1000";47,75;IF(LEFT([DiamConexion];4)="1200";50,8;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=600;IF(LEFT([DiamConexion];4)="0050";14,22;IF(LEFT([DiamConexion];4)="0075";15,75;IF(LEFT([DiamConexion];4)="0100";17,53;IF(LEFT([DiamConexion];4)="0125";20,57;IF(LEFT([DiamConexion];4)="0150";22,35;IF(LEFT([DiamConexion];4)="0200";25,4;IF(LEFT([DiamConexion];4)="0300";31,75;IF(LEFT([DiamConexion];4)="0400";38,1;IF(LEFT([DiamConexion];4)="0600";47,75;IF(LEFT([DiamConexion];4)="0800";55,63;IF(LEFT([DiamConexion];4)="1000";63,5;IF(LEFT([DiamConexion];4)="1200";66,55;0))))))))))));0)))
```

**Radio@Croquis_Brida en brida 2 pulgadas slip on carcasa 8 pulgadas PAH WT** — círculo de pernos / 2; la pieza tiene 4 agujeros, sirve hasta las bridas de 4 pernos

```
(IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=150;IF(LEFT([DiamConexion];4)="0050";60,45;IF(LEFT([DiamConexion];4)="0075";69,85;IF(LEFT([DiamConexion];4)="0100";79,25;IF(LEFT([DiamConexion];4)="0125";88,9;IF(LEFT([DiamConexion];4)="0150";98,55;IF(LEFT([DiamConexion];4)="0200";120,65;IF(LEFT([DiamConexion];4)="0300";152,4;IF(LEFT([DiamConexion];4)="0400";190,5;IF(LEFT([DiamConexion];4)="0600";241,3;IF(LEFT([DiamConexion];4)="0800";298,45;IF(LEFT([DiamConexion];4)="1000";361,95;IF(LEFT([DiamConexion];4)="1200";431,8;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=300;IF(LEFT([DiamConexion];4)="0050";66,55;IF(LEFT([DiamConexion];4)="0075";82,55;IF(LEFT([DiamConexion];4)="0100";88,9;IF(LEFT([DiamConexion];4)="0125";98,55;IF(LEFT([DiamConexion];4)="0150";114,3;IF(LEFT([DiamConexion];4)="0200";127;IF(LEFT([DiamConexion];4)="0300";168,15;IF(LEFT([DiamConexion];4)="0400";200,15;IF(LEFT([DiamConexion];4)="0600";269,75;IF(LEFT([DiamConexion];4)="0800";330,2;IF(LEFT([DiamConexion];4)="1000";387,35;IF(LEFT([DiamConexion];4)="1200";450,85;0))))))))))));IF(IF(LEFT([Presion];1)="0";150;IF(LEFT([Presion];1)="1";150;IF(LEFT([Presion];1)="2";300;IF(LEFT([Presion];1)="3";300;IF(LEFT([Presion];1)="4";600;IF(LEFT([Presion];1)="5";600;150))))))=600;IF(LEFT([DiamConexion];4)="0050";66,55;IF(LEFT([DiamConexion];4)="0075";82,55;IF(LEFT([DiamConexion];4)="0100";88,9;IF(LEFT([DiamConexion];4)="0125";98,55;IF(LEFT([DiamConexion];4)="0150";114,3;IF(LEFT([DiamConexion];4)="0200";127;IF(LEFT([DiamConexion];4)="0300";168,15;IF(LEFT([DiamConexion];4)="0400";215,9;IF(LEFT([DiamConexion];4)="0600";292,1;IF(LEFT([DiamConexion];4)="0800";349,25;IF(LEFT([DiamConexion];4)="1000";431,8;IF(LEFT([DiamConexion];4)="1200";488,95;0))))))))))));0))))/2
```

**DiamInt@Croquis_Brida, DiamInt@Croquis_Cubo y DiamTubo@Croquis_Tubo en brida 2 pulgadas slip on carcasa 8 pulgadas PAH WT**

```
IF(LEFT([TipoConexion];1)="E";IF(LEFT([DiamConexion];4)="0050";12,7;IF(LEFT([DiamConexion];4)="0075";19,05;IF(LEFT([DiamConexion];4)="0100";25,4;IF(LEFT([DiamConexion];4)="0125";31,75;IF(LEFT([DiamConexion];4)="0150";38,1;IF(LEFT([DiamConexion];4)="0200";50,8;IF(LEFT([DiamConexion];4)="0300";76,2;IF(LEFT([DiamConexion];4)="0400";101,6;IF(LEFT([DiamConexion];4)="0600";152,4;IF(LEFT([DiamConexion];4)="0800";203,2;IF(LEFT([DiamConexion];4)="1000";254;IF(LEFT([DiamConexion];4)="1200";304,8;0))))))))))));IF(LEFT([DiamConexion];4)="0050";21,3;IF(LEFT([DiamConexion];4)="0075";26,7;IF(LEFT([DiamConexion];4)="0100";33,4;IF(LEFT([DiamConexion];4)="0125";42,2;IF(LEFT([DiamConexion];4)="0150";48,3;IF(LEFT([DiamConexion];4)="0200";60,3;IF(LEFT([DiamConexion];4)="0300";88,9;IF(LEFT([DiamConexion];4)="0400";114,3;IF(LEFT([DiamConexion];4)="0600";168,3;IF(LEFT([DiamConexion];4)="0800";219,1;IF(LEFT([DiamConexion];4)="1000";273,1;IF(LEFT([DiamConexion];4)="1200";323,9;0)))))))))))))
```

**DiamCubo@Croquis_Cubo en brida 2 pulgadas slip on carcasa 8 pulgadas PAH WT** — provisional: 77.7 en 2"

```
ROUND((IF(LEFT([TipoConexion];1)="E";IF(LEFT([DiamConexion];4)="0050";12,7;IF(LEFT([DiamConexion];4)="0075";19,05;IF(LEFT([DiamConexion];4)="0100";25,4;IF(LEFT([DiamConexion];4)="0125";31,75;IF(LEFT([DiamConexion];4)="0150";38,1;IF(LEFT([DiamConexion];4)="0200";50,8;IF(LEFT([DiamConexion];4)="0300";76,2;IF(LEFT([DiamConexion];4)="0400";101,6;IF(LEFT([DiamConexion];4)="0600";152,4;IF(LEFT([DiamConexion];4)="0800";203,2;IF(LEFT([DiamConexion];4)="1000";254;IF(LEFT([DiamConexion];4)="1200";304,8;0))))))))))));IF(LEFT([DiamConexion];4)="0050";21,3;IF(LEFT([DiamConexion];4)="0075";26,7;IF(LEFT([DiamConexion];4)="0100";33,4;IF(LEFT([DiamConexion];4)="0125";42,2;IF(LEFT([DiamConexion];4)="0150";48,3;IF(LEFT([DiamConexion];4)="0200";60,3;IF(LEFT([DiamConexion];4)="0300";88,9;IF(LEFT([DiamConexion];4)="0400";114,3;IF(LEFT([DiamConexion];4)="0600";168,3;IF(LEFT([DiamConexion];4)="0800";219,1;IF(LEFT([DiamConexion];4)="1000";273,1;IF(LEFT([DiamConexion];4)="1200";323,9;0))))))))))))))*1,05+14;1)
```

**DiamInt@Croquis_Tubo en brida 2 pulgadas slip on carcasa 8 pulgadas PAH WT** — provisional, igual que FC_Boquilla

```
ROUND((IF(LEFT([TipoConexion];1)="E";IF(LEFT([DiamConexion];4)="0050";12,7;IF(LEFT([DiamConexion];4)="0075";19,05;IF(LEFT([DiamConexion];4)="0100";25,4;IF(LEFT([DiamConexion];4)="0125";31,75;IF(LEFT([DiamConexion];4)="0150";38,1;IF(LEFT([DiamConexion];4)="0200";50,8;IF(LEFT([DiamConexion];4)="0300";76,2;IF(LEFT([DiamConexion];4)="0400";101,6;IF(LEFT([DiamConexion];4)="0600";152,4;IF(LEFT([DiamConexion];4)="0800";203,2;IF(LEFT([DiamConexion];4)="1000";254;IF(LEFT([DiamConexion];4)="1200";304,8;0))))))))))));IF(LEFT([DiamConexion];4)="0050";21,3;IF(LEFT([DiamConexion];4)="0075";26,7;IF(LEFT([DiamConexion];4)="0100";33,4;IF(LEFT([DiamConexion];4)="0125";42,2;IF(LEFT([DiamConexion];4)="0150";48,3;IF(LEFT([DiamConexion];4)="0200";60,3;IF(LEFT([DiamConexion];4)="0300";88,9;IF(LEFT([DiamConexion];4)="0400";114,3;IF(LEFT([DiamConexion];4)="0600";168,3;IF(LEFT([DiamConexion];4)="0800";219,1;IF(LEFT([DiamConexion];4)="1000";273,1;IF(LEFT([DiamConexion];4)="1200";323,9;0))))))))))))))*0,85;1)
```

**Largo@Cartucho en filtrante polinero wt**

```
[LargoElemento]
```

Tus ensambles ubican la entrada a `[AlturaEntrada]` (800 en PAH, 434 en WAT) y la salida a 46 mm del fondo del tubo. Esas alturas están en las relaciones de posición de `ENDABLE 2 WT`, que hay que rehacer contra las piezas nuevas; si las haces con una distancia, captúrala y usa esas mismas reglas.

Los agujeros de las placas tienen que ser una **matriz circular** con su número de instancias como cota; si siguen dibujados en el croquis, DriveWorksXpress no puede cambiar cuántos hay.

