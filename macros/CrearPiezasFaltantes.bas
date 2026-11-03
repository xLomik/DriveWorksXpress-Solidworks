Attribute VB_Name = "CrearPiezasFaltantes"
' ============================================================================
' Reconstruye las piezas que faltan en la carpeta "NUEVO 2" (filtro
' multicartucho de 8", version WAT) con el MISMO nombre de archivo que usan tus
' ensambles, para que ENDABLE 2 WT y ENSANBLE 2 SART WT las encuentren.
'
' Las medidas salen del plano general WAT (hojas 1 a 4). Lo que el plano no
' acota (orejas, brazo, soporte de bisagra, tuerca) va simplificado.
' Valores iniciales = codigo PAH-0200-21-082: 8" Sch 10, brida 2" clase 150.
'
' Cada pieza lleva sus cotas con nombre (DiamExt, RadioInt, Largo...) para
' DriveWorksXpress y las propiedades Codigo, Descripcion, Material, Presion,
' Espesor, Sello y Reconstruida.
'
' Como usarla:
'   1. Copia la carpeta NUEVO 2 a una carpeta de trabajo, por ejemplo
'      C:\Configurador_Carcazas\Maestro_PAH\ (nunca trabajes en la planoteca).
'   2. Herramientas > Macro > Nueva, Archivo > Importar este .bas, borrar
'      Module1 y ejecutar "main" (F5). Indica esa carpeta de trabajo.
'   3. Abre ENDABLE 2 WT.SLDASM desde esa carpeta. SOLIDWORKS encontrara las
'      piezas por su nombre. Como son piezas nuevas, las relaciones de posicion
'      que tocaban esas piezas saldran con error: hay que rehacerlas.
'
' SOLIDWORKS 2025 en espanol. Si una pieza falla, la macro sigue con las demas
' y al final dice cuales no se crearon.
' ============================================================================
Option Explicit

Dim swApp As SldWorks.SldWorks
Dim gCarpeta As String
Dim gAvisos As String
Dim gCreadas As Integer

' Valores iniciales en mm (8" Sch 10, plano WAT)
Const OD_CUERPO As Double = 219.1
Const ESPESOR As Double = 3.76
Const LARGO_CUERPO As Double = 1200
Const OD_ANILLO As Double = 256
Const ALTO_ANILLO As Double = 22
Const RANURA_INT As Double = 227.97
Const RANURA_EXT As Double = 241.95
Const PROF_RANURA As Double = 4
Const PROF_ASIENTO As Double = 8
Const LARGO_CARTUCHO As Double = 1016
Const PI As Double = 3.14159265358979

Sub main()
    Set swApp = Application.SldWorks
    gAvisos = ""
    gCreadas = 0

    gCarpeta = InputBox("Carpeta de trabajo con la COPIA de NUEVO 2:", _
                        "Piezas que faltan", "C:\Configurador_Carcazas\Maestro_PAH\")
    If gCarpeta = "" Then Exit Sub
    If Right(gCarpeta, 1) <> "\" Then gCarpeta = gCarpeta & "\"
    If InStr(1, UCase(gCarpeta), "PLANOTECA") > 0 Then
        MsgBox "Esta carpeta parece la planoteca. Usa una copia.", vbCritical
        Exit Sub
    End If
    CrearCarpeta gCarpeta

    Dim pedirValor As Boolean
    pedirValor = swApp.GetUserPreferenceToggle(swInputDimValOnCreate)
    swApp.SetUserPreferenceToggle swInputDimValOnCreate, False

    On Error Resume Next
    Call CrearCuerpo
    Revisar "CUERPO FILTRO PAH WT"
    Call CrearCap(False)
    Revisar "CAP PAH WT"
    Call CrearCap(True)
    Revisar "CAP SUPERIOR 8 PULGADAS PAH WT"
    Call CrearAnillo(False)
    Revisar "Anillo de cierre inferior"
    Call CrearAnillo(True)
    Revisar "Anillo de cierre superior"
    Call CrearBrida
    Revisar "brida 2 pulgadas slip on"
    Call CrearOreja(True)
    Revisar "OREJA SUPERIOR"
    Call CrearOreja(False)
    Revisar "OREJA INFERIOR"
    Call CrearBrazo
    Revisar "BRAZO PAH WT"
    Call CrearSoporteBisagra
    Revisar "Soporte de bisagra 8 PULGADAS"
    Call CrearTornillo
    Revisar "TORNILLO PAH WT"
    Call CrearTuerca
    Revisar "TUERCA ROSCA PAH WT"
    Call CrearPata
    Revisar "pata wt"
    Call CrearMiple
    Revisar "MIPLE media pulgada wt"
    Call CrearCartucho
    Revisar "filtrante polinero wt"
    Call CrearSoporteCartucho
    Revisar "soporte cartucho wt"
    Call CrearGuiaCartucho
    Revisar "guia sartucho wt"
    Call CrearEnsambleSoporte
    Revisar "ensamble soporte cartucho"
    On Error GoTo 0

    swApp.SetUserPreferenceToggle swInputDimValOnCreate, pedirValor
    If gAvisos = "" Then
        MsgBox gCreadas & " archivos creados en " & gCarpeta, vbInformation
    Else
        MsgBox gCreadas & " archivos creados en " & gCarpeta & vbCrLf & vbCrLf & _
               "Avisos:" & vbCrLf & gAvisos, vbExclamation
    End If
End Sub

' Despues de cada pieza: si hubo error, lo anota y cierra el documento a medias
Sub Revisar(nombre As String)
    If Err.Number <> 0 Then
        gAvisos = gAvisos & "- " & nombre & ": " & Err.Description & vbCrLf
        Err.Clear
        Dim d As SldWorks.ModelDoc2
        Set d = swApp.ActiveDoc
        If Not d Is Nothing Then
            If d.GetPathName = "" Then swApp.CloseDoc d.GetTitle
        End If
    Else
        gCreadas = gCreadas + 1
    End If
End Sub

' ----------------------------------------------------------------------------
' Piezas
' ----------------------------------------------------------------------------

' Tubo del cuerpo: Croquis_Tubo (DiamExt, DiamInt) extruido "Largo" hacia arriba
Sub CrearCuerpo()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim f As SldWorks.Feature
    Set f = Anillo(m, "Croquis_Tubo", "DiamExt", OD_CUERPO, OD_CUERPO - 2 * ESPESOR, LARGO_CUERPO, False, "Tubo")
    NombrarCotaOperacion f, "Largo"
    Propiedades m, "Cuerpo tuberia 8 pulg"
    Guardar m, "CUERPO FILTRO PAH WT.SLDPRT"
End Sub

' Cap bombeado: falda recta + casquete, revolucion sobre el eje Y.
' Cotas: RadioExt, Espesor, EspesorCorona, Falda, Altura. Abre hacia abajo (y = 0).
Sub CrearCap(superior As Boolean)
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager

    Dim Ro As Double, t As Double, s As Double, hd As Double, ri As Double, hi As Double
    Dim yco As Double, yci As Double
    Ro = OD_CUERPO / 2: t = ESPESOR: s = 10: hd = 35
    ri = Ro - t: hi = hd - t
    yco = s - (Ro * Ro - hd * hd) / (2 * hd)
    yci = s - (ri * ri - hi * hi) / (2 * hi)

    AbrirCroquis m, PlanoBase(m, 1)
    Dim l1 As Object, l2 As Object, l3 As Object, l4 As Object, aI As Object, aO As Object, eje As Object
    Set l1 = sm.CreateLine(M_(Ro), 0, 0, M_(ri), 0, 0)
    Set l3 = sm.CreateLine(M_(ri), 0, 0, M_(ri), M_(s), 0)
    Set aI = sm.CreateArc(0, M_(yci), 0, M_(ri), M_(s), 0, 0, M_(s + hi), 0, 1)
    Set l2 = sm.CreateLine(0, M_(s + hi), 0, 0, M_(s + hd), 0)
    Set aO = sm.CreateArc(0, M_(yco), 0, 0, M_(s + hd), 0, M_(Ro), M_(s), 0, -1)
    Set l4 = sm.CreateLine(M_(Ro), M_(s), 0, M_(Ro), 0, 0)
    Set eje = sm.CreateCenterLine(0, 0, 0, 0, M_(s + hd + 20), 0)
    If aI Is Nothing Or aO Is Nothing Then Err.Raise vbObjectError + 30, , "No se pudieron dibujar los arcos del cap."

    ' Centros de los arcos sobre el eje, corona sobre el eje, borde inferior en y = 0
    ' y las dos faldas iguales
    Relacionar m, Centro(aI), eje, "sgCOINCIDENT"
    Relacionar m, Centro(aO), eje, "sgCOINCIDENT"
    Relacionar m, l2, eje, "sgCOLINEAR"
    Relacionar m, Inicio(eje), l1, "sgCOINCIDENT"
    Igualar m, l3, l4

    Acotar m, eje, l4, M_(Ro / 2), M_(-15), "RadioExt"
    Acotar m, l3, l4, M_(Ro - t / 2), M_(-25), "Espesor"
    Acotar m, l2, Nothing, M_(-15), M_(s + hd - t / 2), "EspesorCorona"
    Acotar m, l4, Nothing, M_(Ro + 15), M_(s / 2), "Falda"
    Acotar m, Fin(l2), l1, M_(Ro + 30), M_((s + hd) / 2), "Altura"
    Dim sk As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Cap")
    Revolver m, sk, eje, "Cap"

    If superior Then
        Propiedades m, "Cap tapa 8 pulg"
        Guardar m, "CAP SUPERIOR " & ChrW(216) & "8 PULGADAS PAH WT.SLDPRT"
    Else
        Propiedades m, "Cap fondo 8 pulg"
        Guardar m, "CAP PAH WT.SLDPRT"
    End If
End Sub

' Anillo de cierre: revolucion. Abajo el asiento del tubo (RadioAsiento x ProfAsiento),
' arriba la ranura del O'ring (solo el inferior). Plano WAT hoja 2.
Sub CrearAnillo(superior As Boolean)
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager

    Dim rE As Double, rI As Double, rA As Double, rR1 As Double, rR2 As Double
    Dim H As Double, pr As Double, pa As Double
    rE = OD_ANILLO / 2: rI = (OD_CUERPO - 2 * ESPESOR) / 2: rA = OD_CUERPO / 2
    rR1 = RANURA_INT / 2: rR2 = RANURA_EXT / 2
    H = ALTO_ANILLO: pr = PROF_RANURA: pa = PROF_ASIENTO

    AbrirCroquis m, PlanoBase(m, 1)
    Dim L As Variant, eje As Object
    If superior Then
        L = Poligono(sm, Array(rI, pa, rI, H, rE, H, rE, 0, rA, 0, rA, pa))
    Else
        L = Poligono(sm, Array(rI, pa, rI, H, rR1, H, rR1, H - pr, rR2, H - pr, rR2, H, _
                               rE, H, rE, 0, rA, 0, rA, pa))
    End If
    Set eje = sm.CreateCenterLine(0, 0, 0, 0, M_(H + 20), 0)

    If superior Then
        ' L: 0 bore, 1 cara superior, 2 exterior, 3 cara inferior, 4 asiento, 5 escalon
        Relacionar m, Inicio(eje), L(3), "sgCOINCIDENT"
        Acotar m, eje, L(2), M_(rE / 2), M_(H + 10), "RadioExt"
        Acotar m, eje, L(0), M_(rI / 2), M_(H + 20), "RadioInt"
        Acotar m, eje, L(4), M_(rA / 2), M_(-10), "RadioAsiento"
        Acotar m, L(3), L(1), M_(rE + 15), M_(H / 2), "Altura"
        Acotar m, L(3), L(5), M_(rA - 2), M_(-20), "ProfAsiento"
    Else
        ' L: 0 bore, 1 cara sup. interior, 2 y 4 flancos de la ranura, 3 fondo de ranura,
        '    5 cara sup. exterior, 6 exterior, 7 cara inferior, 8 asiento, 9 escalon
        Relacionar m, L(1), L(5), "sgCOLINEAR"
        Relacionar m, Inicio(eje), L(7), "sgCOINCIDENT"
        Acotar m, eje, L(6), M_(rE / 2), M_(H + 10), "RadioExt"
        Acotar m, eje, L(0), M_(rI / 2), M_(H + 20), "RadioInt"
        Acotar m, eje, L(8), M_(rA / 2), M_(-10), "RadioAsiento"
        Acotar m, eje, L(2), M_(rR1 / 2), M_(H + 30), "RadioRanuraInt"
        Acotar m, eje, L(4), M_(rR2 / 2), M_(H + 40), "RadioRanuraExt"
        Acotar m, L(7), L(5), M_(rE + 15), M_(H / 2), "Altura"
        Acotar m, L(3), L(5), M_(rE + 25), M_(H - pr / 2), "ProfRanura"
        Acotar m, L(7), L(9), M_(rA - 2), M_(-20), "ProfAsiento"
    End If
    Dim sk As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Anillo")
    Revolver m, sk, eje, "Anillo"

    If superior Then
        Propiedades m, "Anillo de cierre superior 8 pulg"
        Guardar m, "Anillo de cierre superior para 8 PULGADAS PAH WT.SLDPRT"
    Else
        Propiedades m, "Anillo de cierre inferior 8 pulg, ranura O'ring"
        Guardar m, "Anillo de cierre inferior 8 PULGADAS  WT.SLDPRT"
    End If
End Sub

' Brida slip-on 2" clase 150 (ASME B16.5) con su tubo. La cara de la brida
' queda en y = 0 y el tubo sale hacia +Y (hacia el cuerpo).
Sub CrearBrida()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    Dim odT As Double
    odT = 60.3

    ' Disco con 4 agujeros: DiamExt, DiamInt (= OD del tubo), Radio, DiamAgujero
    AbrirCroquis m, PlanoBase(m, 2)
    Dim ce As Object, ci As Object
    Set ce = sm.CreateCircleByRadius(0, 0, 0, M_(152.4 / 2))
    Acotar m, ce, Nothing, M_(152.4 / 2), 0.03, "DiamExt"
    Set ci = sm.CreateCircleByRadius(0, 0, 0, M_(odT / 2))
    Acotar m, ci, Nothing, M_(odT / 2), -0.03, "DiamInt"
    CuatroAgujeros m, 120.65 / 2, 19.05
    Dim sk As SldWorks.Feature, f As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Brida")
    Set f = Extruir(m, sk, 19.05, False, "Brida")
    NombrarCotaOperacion f, "Espesor"

    ' Cubo y tubo
    Set f = Anillo(m, "Croquis_Cubo", "DiamCubo", 77.7, odT, 23.9, False, "Cubo")
    NombrarCotaOperacion f, "Largo"
    Set f = Anillo(m, "Croquis_Tubo", "DiamTubo", odT, odT - 2 * 3.91, 110, False, "Tubo")
    NombrarCotaOperacion f, "Largo"

    Propiedades m, "Brida slip on 2 pulg clase 150 con tubo"
    Guardar m, "brida 2 pulgadas slip on carcasa 8 pulgadas PAH WT.SLDPRT"
End Sub

' Oreja (simplificada): placa de 40 x 50 x 9.5 con agujero para el pasador
Sub CrearOreja(superior As Boolean)
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    AbrirCroquis m, PlanoBase(m, 1)
    Dim L As Variant, c As Object
    L = Poligono(sm, Array(-20, 0, 20, 0, 20, 50, -20, 50))
    Set c = sm.CreateCircleByRadius(0, M_(35), 0, M_(12.7 / 2))
    Acotar m, L(0), Nothing, 0, M_(-10), "Ancho"
    Acotar m, L(1), Nothing, M_(30), M_(25), "Alto"
    Acotar m, c, Nothing, M_(10), M_(45), "DiamAgujero"
    Dim sk As SldWorks.Feature, f As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Oreja")
    Set f = Extruir(m, sk, 9.5, False, "Oreja")
    NombrarCotaOperacion f, "Espesor"
    If superior Then
        Propiedades m, "Oreja superior (simplificada)"
        Guardar m, "OREJA SUPERIOR ESP  PAH WT.SLDPRT"
    Else
        Propiedades m, "Oreja inferior (simplificada)"
        Guardar m, "OREJA INFERIOR ESP PAH WT.SLDPRT"
    End If
End Sub

' Brazo de la tapa (simplificado): platina de 250 x 30 x 12.7 con dos agujeros
Sub CrearBrazo()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    AbrirCroquis m, PlanoBase(m, 1)
    Dim L As Variant, c1 As Object, c2 As Object
    L = Poligono(sm, Array(0, -15, 250, -15, 250, 15, 0, 15))
    Set c1 = sm.CreateCircleByRadius(M_(15), 0, 0, M_(19.05 / 2))
    Set c2 = sm.CreateCircleByRadius(M_(235), 0, 0, M_(19.05 / 2))
    Acotar m, L(0), Nothing, M_(125), M_(-30), "Largo"
    Acotar m, L(1), Nothing, M_(265), 0, "Ancho"
    Igualar m, c1, c2
    Acotar m, c1, Nothing, M_(15), M_(25), "DiamAgujero"
    Dim sk As SldWorks.Feature, f As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Brazo")
    Set f = Extruir(m, sk, 12.7, False, "Brazo")
    NombrarCotaOperacion f, "Espesor"
    Propiedades m, "Brazo de la tapa (simplificado)"
    Guardar m, "BRAZO PAH WT.SLDPRT"
End Sub

' Soporte de bisagra (simplificado): placa de 60 x 80 x 9.5 con agujero
Sub CrearSoporteBisagra()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    AbrirCroquis m, PlanoBase(m, 1)
    Dim L As Variant, c As Object
    L = Poligono(sm, Array(-30, 0, 30, 0, 30, 80, -30, 80))
    Set c = sm.CreateCircleByRadius(0, M_(60), 0, M_(19.05 / 2))
    Acotar m, L(0), Nothing, 0, M_(-10), "Ancho"
    Acotar m, L(1), Nothing, M_(40), M_(40), "Alto"
    Acotar m, c, Nothing, M_(12), M_(70), "DiamAgujero"
    Dim sk As SldWorks.Feature, f As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Soporte")
    Set f = Extruir(m, sk, 9.5, False, "Soporte")
    NombrarCotaOperacion f, "Espesor"
    Propiedades m, "Soporte de bisagra (simplificado)"
    Guardar m, "Soporte de bisagra 8 PULGADAS.SLDPRT"
End Sub

' Tornillo pivotado 3/4" (plano WAT hoja 2): ojo de 25.4 con agujero de 14.5 y
' vastago de 19.05 x 82.8
Sub CrearTornillo()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim f As SldWorks.Feature
    Set f = Anillo(m, "Croquis_Vastago", "Diam", 19.05, 0, 82.8, False, "Vastago")
    NombrarCotaOperacion f, "Largo"

    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    AbrirCroquis m, PlanoBase(m, 1)
    Dim ce As Object, ci As Object
    Set ce = sm.CreateCircleByRadius(0, M_(-10), 0, M_(25.4 / 2))
    Set ci = sm.CreateCircleByRadius(0, M_(-10), 0, M_(14.5 / 2))
    Acotar m, ce, Nothing, M_(20), M_(-10), "DiamOjo"
    Acotar m, ci, Nothing, M_(-20), M_(-10), "DiamAgujero"
    Dim sk As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Ojo")
    Set f = ExtruirMedio(m, sk, 19.05, "Ojo")
    NombrarCotaOperacion f, "Ancho"
    Propiedades m, "Tornillo pivotado 3/4 pulg"
    Guardar m, "TORNILLO PAH WT.SLDPRT"
End Sub

' Tuerca de mariposa (simplificada): cuerpo de 50 x 30 con rosca de 3/4" y dos alas
Sub CrearTuerca()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim f As SldWorks.Feature
    Set f = Anillo(m, "Croquis_Tuerca", "DiamExt", 50, 19.05, 30, False, "Tuerca")
    NombrarCotaOperacion f, "Alto"

    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    AbrirCroquis m, PlanoBase(m, 1)
    Dim L1 As Variant, L2 As Variant
    L1 = Poligono(sm, Array(20, 15, 50, 15, 50, 27.7, 20, 27.7))
    L2 = Poligono(sm, Array(-50, 15, -20, 15, -20, 27.7, -50, 27.7))
    Dim sk As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Alas")
    Set f = ExtruirMedio(m, sk, 12.7, "Alas")
    Propiedades m, "Tuerca de mariposa 3/4 pulg (simplificada)"
    Guardar m, "TUERCA ROSCA PAH WT.SLDPRT"
End Sub

' Pata (plano WAT hoja 4, simplificada): base de 90 x 9 y angulo de 30 x 30 x 3, alto 196.82
Sub CrearPata()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim f As SldWorks.Feature
    Set f = Anillo(m, "Croquis_Base", "DiamBase", 90, 0, 9, False, "Base")
    NombrarCotaOperacion f, "Espesor"

    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    AbrirCroquis m, PlanoBase(m, 2)
    Dim L As Variant
    L = Poligono(sm, Array(0, 0, 30, 0, 30, 3, 3, 3, 3, 30, 0, 30))
    Dim sk As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Angulo")
    Set f = Extruir(m, sk, 196.82, False, "Angulo")
    NombrarCotaOperacion f, "Alto"
    Propiedades m, "Pata base"
    Guardar m, "pata wt.SLDPRT"
End Sub

Sub CrearMiple()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim f As SldWorks.Feature
    Set f = Anillo(m, "Croquis_Miple", "DiamExt", 21.3, 15.8, 60, False, "Miple")
    NombrarCotaOperacion f, "Largo"
    Propiedades m, "Niple 1/2 pulg (drenaje)"
    Guardar m, "MIPLE media pulgada wt.SLDPRT"
End Sub

' Cartucho 2.5" x 40": DiamExt 63.5, DiamInt 28 (entra en el soporte), Largo 1016
Sub CrearCartucho()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim f As SldWorks.Feature
    Set f = Anillo(m, "Croquis_Cartucho", "DiamExt", 63.5, 28, LARGO_CARTUCHO, False, "Cartucho")
    NombrarCotaOperacion f, "Largo"
    Propiedades m, "Cartucho 2.5 x 40 pulg"
    Guardar m, "filtrante polinero wt.SLDPRT"
End Sub

' Soporte del cartucho (plano WAT hoja 4): vaso de 28 / 22 x 25 y plano para la guia
Sub CrearSoporteCartucho()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim f As SldWorks.Feature
    Set f = Anillo(m, "Croquis_Soporte", "DiamExt", 28, 22, 25, False, "Soporte")
    NombrarCotaOperacion f, "Alto"
    PlanoOffset m, PlanoBase(m, 2), 25, False, "Plano_Guia"
    Propiedades m, "Soporte de cartucho"
    Guardar m, "soporte cartucho wt.SLDPRT"
End Sub

' Guia del cartucho (simplificada como cono de 28 x 35 en vez de las 3 aletas)
Sub CrearGuiaCartucho()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    AbrirCroquis m, PlanoBase(m, 1)
    Dim L As Variant, eje As Object
    L = Poligono(sm, Array(0, 0, 14, 0, 0, 35))
    Set eje = sm.CreateCenterLine(0, 0, 0, 0, M_(50), 0)
    Acotar m, L(0), Nothing, M_(7), M_(-10), "Radio"
    Acotar m, L(2), Nothing, M_(-10), M_(17), "Alto"
    Dim sk As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Guia")
    Revolver m, sk, eje, "Guia"
    Propiedades m, "Guia de cartucho (simplificada)"
    Guardar m, "guia sartucho wt.SLDPRT"
End Sub

' Subensamble soporte + guia, como lo usa ENSANBLE 2 SART WT
Sub CrearEnsambleSoporte()
    Dim m As SldWorks.ModelDoc2
    Set m = swApp.NewDocument(swApp.GetUserPreferenceStringValue(swDefaultTemplateAssembly), 0, 0, 0)
    If m Is Nothing Then Err.Raise vbObjectError + 20, , "No se pudo crear el ensamble (revisa la plantilla de ensamble)."
    m.Extension.SetUserPreferenceInteger swUnitSystem, swDetailingNoOptionSpecified, swUnitSystem_MMGS
    Dim asm As SldWorks.AssemblyDoc
    Set asm = m
    Dim cS As SldWorks.Component2, cG As SldWorks.Component2
    Set cS = Insertar(asm, "soporte cartucho wt.SLDPRT", 0, 0, 0)
    m.ClearSelection2 True
    cS.Select4 False, Nothing, False
    asm.FixComponent
    m.ClearSelection2 True
    Set cG = Insertar(asm, "guia sartucho wt.SLDPRT", 0, M_(60), 0)
    Unir asm, PlanoComp(cG, 2), cS.FeatureByName("Plano_Guia"), swMateAlignALIGNED, "Guia/altura"
    Unir asm, PlanoComp(cG, 1), PlanoComp(cS, 1), swMateAlignALIGNED, "Guia/alzado"
    Unir asm, PlanoComp(cG, 3), PlanoComp(cS, 3), swMateAlignALIGNED, "Guia/lateral"
    m.ForceRebuild3 False
    Guardar m, "ensamble soporte cartucho.SLDASM"
End Sub

' ----------------------------------------------------------------------------
' Constructores
' ----------------------------------------------------------------------------

' Poligono cerrado de lineas. pts = Array(x1, y1, x2, y2, ...) en mm.
' Devuelve las lineas: la i va del punto i al i+1 (la ultima cierra al primero).
Function Poligono(sm As SldWorks.SketchManager, pts As Variant) As Variant
    Dim n As Integer, i As Integer, j As Integer
    n = (UBound(pts) - LBound(pts) + 1) \ 2
    Dim L() As Object
    ReDim L(n - 1)
    For i = 0 To n - 1
        j = (i + 1) Mod n
        Set L(i) = sm.CreateLine(M_(CDbl(pts(2 * i))), M_(CDbl(pts(2 * i + 1))), 0, _
                                 M_(CDbl(pts(2 * j))), M_(CDbl(pts(2 * j + 1))), 0)
        If L(i) Is Nothing Then Err.Raise vbObjectError + 31, , "No se pudo dibujar una linea del croquis."
    Next i
    Poligono = L
End Function

' Revolucion completa del croquis alrededor de la linea constructiva "eje"
Sub Revolver(m As SldWorks.ModelDoc2, sk As SldWorks.Feature, eje As Object, nombre As String)
    m.ClearSelection2 True
    sk.Select2 False, 0
    Dim sd As SldWorks.SelectData
    Set sd = m.SelectionManager.CreateSelectData
    sd.Mark = 4
    eje.Select4 True, sd
    Dim f As SldWorks.Feature
    Set f = m.FeatureManager.FeatureRevolve2(True, True, False, False, False, False, _
            swEndCondBlind, swEndCondBlind, 2 * PI, 0, False, False, 0, 0, _
            swThinWallOneDirection, 0, 0, True, True, True)
    If f Is Nothing Then Err.Raise vbObjectError + 10, , "No se pudo crear la revolucion " & nombre
    f.Name = nombre
    m.ClearSelection2 True
End Sub

' Circulo (diamInt = 0) o anillo concentrico al origen en el plano Planta,
' extruido hacia arriba. Cotas: <nombreDiam> y DiamInt.
Function Anillo(m As SldWorks.ModelDoc2, croquis As String, nombreDiam As String, diamExt As Double, _
                diamInt As Double, prof As Double, invertir As Boolean, nombre As String) As SldWorks.Feature
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    AbrirCroquis m, PlanoBase(m, 2)
    Dim ce As Object, ci As Object
    Set ce = sm.CreateCircleByRadius(0, 0, 0, M_(diamExt / 2))
    Acotar m, ce, Nothing, M_(diamExt / 2), 0.03, nombreDiam
    If diamInt > 0 Then
        Set ci = sm.CreateCircleByRadius(0, 0, 0, M_(diamInt / 2))
        Acotar m, ci, Nothing, M_(diamExt / 2), -0.03, "DiamInt"
    End If
    Dim sk As SldWorks.Feature
    Set sk = CerrarCroquis(m, croquis)
    Set Anillo = Extruir(m, sk, prof, invertir, nombre)
End Function

' 4 agujeros a 90 grados sobre lineas constructivas desde el origen.
' Cotas: Radio (circulo de pernos / 2) y DiamAgujero. Se dibujan en el croquis abierto.
Sub CuatroAgujeros(m As SldWorks.ModelDoc2, radio As Double, diam As Double)
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    Dim a As Double, rc As Double
    a = M_(radio): rc = M_(diam / 2)
    Dim e(3) As Object, c(3) As Object, i As Integer
    Set e(0) = sm.CreateCenterLine(0, 0, 0, a, 0, 0)
    Set e(1) = sm.CreateCenterLine(0, 0, 0, -a, 0, 0)
    Set e(2) = sm.CreateCenterLine(0, 0, 0, 0, a, 0)
    Set e(3) = sm.CreateCenterLine(0, 0, 0, 0, -a, 0)
    Set c(0) = sm.CreateCircleByRadius(a, 0, 0, rc)
    Set c(1) = sm.CreateCircleByRadius(-a, 0, 0, rc)
    Set c(2) = sm.CreateCircleByRadius(0, a, 0, rc)
    Set c(3) = sm.CreateCircleByRadius(0, -a, 0, rc)
    For i = 1 To 3
        Igualar m, e(0), e(i)
        Igualar m, c(0), c(i)
    Next i
    Acotar m, e(0), Nothing, a / 2, 0.01, "Radio"
    Acotar m, c(0), Nothing, a + rc + 0.01, 0.02, "DiamAgujero"
End Sub

' ----------------------------------------------------------------------------
' Utilidades (las mismas de CrearMaestrosCarcaza.bas)
' ----------------------------------------------------------------------------
Function M_(mm As Double) As Double
    M_ = mm / 1000#
End Function

Sub CrearCarpeta(ruta As String)
    Dim partes() As String, i As Integer, acum As String
    partes = Split(ruta, "\")
    acum = partes(0)
    For i = 1 To UBound(partes)
        If partes(i) <> "" Then
            acum = acum & "\" & partes(i)
            If Dir(acum, vbDirectory) = "" Then MkDir acum
        End If
    Next i
End Sub

Function NuevaPieza() As SldWorks.ModelDoc2
    Dim m As SldWorks.ModelDoc2
    Set m = swApp.NewDocument(swApp.GetUserPreferenceStringValue(swDefaultTemplatePart), 0, 0, 0)
    If m Is Nothing Then Err.Raise vbObjectError + 1, , "No se pudo crear la pieza. Revisa la plantilla por defecto en Opciones > Ubicaciones de archivos."
    m.Extension.SetUserPreferenceInteger swUnitSystem, swDetailingNoOptionSpecified, swUnitSystem_MMGS
    Set NuevaPieza = m
End Function

' Planos por defecto por orden (1 = Alzado, 2 = Planta, 3 = Vista lateral)
Function PlanoBase(m As SldWorks.ModelDoc2, indice As Integer) As SldWorks.Feature
    Set PlanoBase = EnesimoPlano(m.FirstFeature, indice)
End Function

Function PlanoComp(c As SldWorks.Component2, indice As Integer) As SldWorks.Feature
    Set PlanoComp = EnesimoPlano(c.FirstFeature, indice)
End Function

Function EnesimoPlano(f As SldWorks.Feature, indice As Integer) As SldWorks.Feature
    Dim n As Integer
    Do While Not f Is Nothing
        If f.GetTypeName2 = "RefPlane" Then
            n = n + 1
            If n = indice Then
                Set EnesimoPlano = f
                Exit Function
            End If
        End If
        Set f = f.GetNextFeature
    Loop
    Err.Raise vbObjectError + 2, , "No se encontro el plano base " & indice
End Function

Sub AbrirCroquis(m As SldWorks.ModelDoc2, plano As SldWorks.Feature)
    m.ClearSelection2 True
    plano.Select2 False, 0
    m.SketchManager.InsertSketch True
End Sub

Function CerrarCroquis(m As SldWorks.ModelDoc2, nombre As String) As SldWorks.Feature
    m.ClearSelection2 True
    m.SketchManager.InsertSketch True
    Dim f As SldWorks.Feature
    Set f = m.FeatureByPositionReverse(0)
    f.Name = nombre
    Set CerrarCroquis = f
End Function

' Acota una entidad (diametro / longitud) o la distancia entre dos y le da nombre
Sub Acotar(m As SldWorks.ModelDoc2, ByVal a As Object, ByVal b As Object, ByVal x As Double, ByVal y As Double, nombre As String)
    m.ClearSelection2 True
    a.Select4 False, Nothing
    If Not b Is Nothing Then b.Select4 True, Nothing
    Dim dd As SldWorks.DisplayDimension
    Set dd = m.AddDimension2(x, y, 0)
    If dd Is Nothing Then Err.Raise vbObjectError + 3, , "No se pudo crear la cota " & nombre
    dd.GetDimension2(0).Name = nombre
    m.ClearSelection2 True
End Sub

Sub Igualar(m As SldWorks.ModelDoc2, ByVal a As Object, ByVal b As Object)
    Relacionar m, a, b, "sgSAMELENGTH"
End Sub

' Puntos de una linea o centro de un arco (con el tipo correcto para la API)
Function Inicio(ByVal seg As Object) As Object
    Dim ln As SldWorks.SketchLine
    Set ln = seg
    Set Inicio = ln.GetStartPoint2
End Function

Function Fin(ByVal seg As Object) As Object
    Dim ln As SldWorks.SketchLine
    Set ln = seg
    Set Fin = ln.GetEndPoint2
End Function

Function Centro(ByVal seg As Object) As Object
    Dim ar As SldWorks.SketchArc
    Set ar = seg
    Set Centro = ar.GetCenterPoint2
End Function

' Agrega una relacion de croquis entre dos entidades (sgCOINCIDENT, sgCOLINEAR...)
Sub Relacionar(m As SldWorks.ModelDoc2, ByVal a As Object, ByVal b As Object, relacion As String)
    m.ClearSelection2 True
    a.Select4 False, Nothing
    b.Select4 True, Nothing
    m.SketchAddConstraints relacion
    m.ClearSelection2 True
End Sub

Function Extruir(m As SldWorks.ModelDoc2, croquis As SldWorks.Feature, prof As Double, _
                 invertir As Boolean, nombre As String) As SldWorks.Feature
    m.ClearSelection2 True
    croquis.Select2 False, 0
    Dim f As SldWorks.Feature
    Set f = m.FeatureManager.FeatureExtrusion2(True, False, invertir, swEndCondBlind, swEndCondBlind, _
            M_(prof), 0, False, False, False, False, 0, 0, False, False, False, False, _
            True, True, True, swStartSketchPlane, 0, False)
    If f Is Nothing Then Err.Raise vbObjectError + 4, , "No se pudo crear la extrusion " & nombre
    f.Name = nombre
    Set Extruir = f
End Function

' Extrusion simetrica respecto al plano del croquis
Function ExtruirMedio(m As SldWorks.ModelDoc2, croquis As SldWorks.Feature, prof As Double, _
                      nombre As String) As SldWorks.Feature
    m.ClearSelection2 True
    croquis.Select2 False, 0
    Dim f As SldWorks.Feature
    Set f = m.FeatureManager.FeatureExtrusion2(True, False, False, swEndCondMidPlane, swEndCondBlind, _
            M_(prof), 0, False, False, False, False, 0, 0, False, False, False, False, _
            True, True, True, swStartSketchPlane, 0, False)
    If f Is Nothing Then Err.Raise vbObjectError + 4, , "No se pudo crear la extrusion " & nombre
    f.Name = nombre
    Set ExtruirMedio = f
End Function

Sub NombrarCotaOperacion(f As SldWorks.Feature, nombre As String)
    Dim dd As SldWorks.DisplayDimension
    Set dd = f.GetFirstDisplayDimension
    If Not dd Is Nothing Then dd.GetDimension2(0).Name = nombre
End Sub

Sub PlanoOffset(m As SldWorks.ModelDoc2, base As SldWorks.Feature, dist As Double, _
                invertir As Boolean, nombre As String)
    m.ClearSelection2 True
    base.Select2 False, 0
    Dim c As Long
    c = swRefPlaneReferenceConstraint_Distance
    If invertir Then c = c + swRefPlaneReferenceConstraint_OptionFlip
    If m.FeatureManager.InsertRefPlane(c, M_(dist), 0, 0, 0, 0) Is Nothing Then
        Err.Raise vbObjectError + 5, , "No se pudo crear el plano " & nombre
    End If
    Dim f As SldWorks.Feature
    Set f = m.FeatureByPositionReverse(0)
    f.Name = nombre
    NombrarCotaOperacion f, "Distancia"
    m.ClearSelection2 True
End Sub

Sub Propiedades(m As SldWorks.ModelDoc2, descripcion As String)
    Dim cpm As SldWorks.CustomPropertyManager
    Set cpm = m.Extension.CustomPropertyManager("")
    cpm.Add3 "Codigo", swCustomInfoText, "PAH-0200-21-082", swCustomPropertyReplaceValue
    cpm.Add3 "Descripcion", swCustomInfoText, descripcion, swCustomPropertyReplaceValue
    cpm.Add3 "Material", swCustomInfoText, "S.S. 304", swCustomPropertyReplaceValue
    cpm.Add3 "Presion", swCustomInfoText, "150 psi", swCustomPropertyReplaceValue
    cpm.Add3 "Espesor", swCustomInfoText, "3.76 mm", swCustomPropertyReplaceValue
    cpm.Add3 "Sello", swCustomInfoText, "O'ring", swCustomPropertyReplaceValue
    cpm.Add3 "Reconstruida", swCustomInfoText, "Si, desde el plano WAT", swCustomPropertyReplaceValue
End Sub

Sub Guardar(m As SldWorks.ModelDoc2, nombre As String)
    Dim ruta As String, errs As Long, warns As Long
    ruta = gCarpeta & nombre

    If m.GetType <> swDocDRAWING Then
        If Not m.SketchManager.ActiveSketch Is Nothing Then m.SketchManager.InsertSketch True
    End If
    m.ClearSelection2 True
    m.ForceRebuild3 False

    ' Nunca reemplaza un archivo tuyo: si ya existe, no se crea
    If Dir(ruta) <> "" Then
        swApp.CloseDoc m.GetTitle
        Err.Raise vbObjectError + 6, , "ya existe en la carpeta, no se reemplazo"
    End If

    If Not m.Extension.SaveAs(ruta, swSaveAsCurrentVersion, swSaveAsOptions_Silent, Nothing, errs, warns) Then
        errs = m.SaveAs3(ruta, swSaveAsCurrentVersion, swSaveAsOptions_Silent)
        If Not (errs = 0 And Dir(ruta) <> "") Then
            Err.Raise vbObjectError + 6, , "no se pudo guardar (errores " & errs & ", avisos " & warns & ")"
        End If
    End If
    swApp.CloseDoc ruta
End Sub

Function Insertar(asm As SldWorks.AssemblyDoc, archivo As String, x As Double, y As Double, z As Double) As SldWorks.Component2
    Dim c As SldWorks.Component2
    Set c = asm.AddComponent5(gCarpeta & archivo, swAddComponentConfigOptions_CurrentSelectedConfig, "", False, "", x, y, z)
    If c Is Nothing Then Err.Raise vbObjectError + 7, , "No se pudo insertar " & archivo
    Set Insertar = c
End Function

Sub Unir(asm As SldWorks.AssemblyDoc, f1 As SldWorks.Feature, f2 As SldWorks.Feature, alineacion As Long, nombre As String)
    Dim m As SldWorks.ModelDoc2
    Set m = asm
    m.ClearSelection2 True
    If f1 Is Nothing Or f2 Is Nothing Then
        gAvisos = gAvisos & "- Relacion " & nombre & ": no se encontro un plano." & vbCrLf
        Exit Sub
    End If
    f1.Select2 False, 1
    f2.Select2 True, 1
    Dim e As Long, mate As Object
    Set mate = asm.AddMate5(swMateCOINCIDENT, alineacion, False, 0, 0, 0, 0, 0, 0, 0, 0, False, False, 0, e)
    If mate Is Nothing Then
        gAvisos = gAvisos & "- Relacion " & nombre & " no se pudo crear (codigo " & e & ")." & vbCrLf
    Else
        Dim fm As SldWorks.Feature
        Set fm = mate
        fm.Name = nombre
    End If
    m.ClearSelection2 True
End Sub
