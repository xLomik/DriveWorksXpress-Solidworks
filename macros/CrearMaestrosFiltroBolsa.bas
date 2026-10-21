Attribute VB_Name = "CrearMaestrosFiltroBolsa"
' ============================================================================
' Crea los modelos maestros del filtro de bolsa para DriveWorksXpress.
'
' Genera en la carpeta elegida:
'   FB_Cuerpo.SLDPRT, FB_Tapa.SLDPRT, FB_Boquilla.SLDPRT, FB_Canasta.SLDPRT,
'   FB_Ensamble.SLDASM y un plano (.SLDDRW) por cada uno, con el mismo nombre.
'
' Todas las cotas, croquis, planos de referencia y operaciones quedan con
' nombres fijos (ver docs/reglas-driveworksxpress.md) para capturarlos en
' DriveWorksXpress.
'
' Uso: en SOLIDWORKS, Herramientas > Macro > Nueva, borra el contenido del
' modulo, Archivo > Importar este .bas (o pega el texto) y ejecuta "main".
' Valores iniciales: bolsa #1, DN50, bridada, AISI 304, 6 bar.
' ============================================================================
Option Explicit

Dim swApp As SldWorks.SldWorks
Dim gCarpeta As String
Dim gAvisos As String

' Valores iniciales en mm
Const RADIO_EXT As Double = 109.55   ' Ø219.1 / 2
Const ESPESOR As Double = 3
Const ALTURA As Double = 560
Const DIAM_TUBO As Double = 60.3     ' DN50
Const DIAM_BRIDA As Double = 165     ' DN50 PN16
Const PI As Double = 3.14159265358979

Sub main()
    Set swApp = Application.SldWorks
    gAvisos = ""

    gCarpeta = InputBox("Carpeta donde guardar los modelos maestros:", _
                        "Configurador de filtros", "C:\Configurador_Filtros\Maestro\")
    If gCarpeta = "" Then Exit Sub
    If Right(gCarpeta, 1) <> "\" Then gCarpeta = gCarpeta & "\"
    CrearCarpeta gCarpeta

    Dim pedirValor As Boolean
    pedirValor = swApp.GetUserPreferenceToggle(swInputDimValOnCreate)
    swApp.SetUserPreferenceToggle swInputDimValOnCreate, False

    On Error GoTo Fallo
    CrearCuerpo
    CrearTapa
    CrearBoquilla
    CrearCanasta
    CrearEnsamble
    On Error GoTo 0

    CrearPlano "FB_Cuerpo", ".SLDPRT"
    CrearPlano "FB_Tapa", ".SLDPRT"
    CrearPlano "FB_Boquilla", ".SLDPRT"
    CrearPlano "FB_Canasta", ".SLDPRT"
    CrearPlano "FB_Ensamble", ".SLDASM"

    swApp.SetUserPreferenceToggle swInputDimValOnCreate, pedirValor
    If gAvisos = "" Then
        MsgBox "Modelos maestros creados en " & gCarpeta, vbInformation
    Else
        MsgBox "Modelos creados en " & gCarpeta & " con estos avisos:" & vbCrLf & gAvisos, vbExclamation
    End If
    Exit Sub

Fallo:
    swApp.SetUserPreferenceToggle swInputDimValOnCreate, pedirValor
    MsgBox "Error: " & Err.Description & vbCrLf & gAvisos, vbCritical
End Sub

' ----------------------------------------------------------------------------
' Piezas
' ----------------------------------------------------------------------------

' Virola + fondo (revolucion), patas y planos para tapa y boquillas
Sub CrearCuerpo()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager

    Dim Ro As Double, t As Double, H As Double
    Ro = M_(RADIO_EXT): t = M_(ESPESOR): H = M_(ALTURA)

    ' Perfil en L sobre el plano Alzado (Front), revolucionado sobre el eje Y
    AbrirCroquis m, PlanoBase(m, 1)
    Dim l1 As Object, l2 As Object, l3 As Object, l4 As Object, l5 As Object, l6 As Object, eje As Object
    Set l1 = sm.CreateLine(0, 0, 0, Ro, 0, 0)
    Set l2 = sm.CreateLine(Ro, 0, 0, Ro, H, 0)
    Set l3 = sm.CreateLine(Ro, H, 0, Ro - t, H, 0)
    Set l4 = sm.CreateLine(Ro - t, H, 0, Ro - t, t, 0)
    Set l5 = sm.CreateLine(Ro - t, t, 0, 0, t, 0)
    Set l6 = sm.CreateLine(0, t, 0, 0, 0, 0)
    Set eje = sm.CreateCenterLine(0, 0, 0, 0, -0.05, 0)
    Acotar m, l6, l2, Ro / 2, -0.03, "RadioExt"
    Acotar m, l2, l4, Ro - t / 2, H + 0.03, "Espesor"
    Acotar m, l1, l3, Ro + 0.05, H / 2, "Altura"
    Acotar m, l1, l5, Ro / 2, t + 0.03, "EspesorFondo"
    Dim sk As SldWorks.Feature
    Set sk = CerrarCroquis(m, "Croquis_Cuerpo")

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
    If f Is Nothing Then Err.Raise vbObjectError + 10, , "No se pudo crear la revolucion del cuerpo."
    f.Name = "Revolucion_Cuerpo"

    ' Patas: 4 circulos a 90 grados sobre el plano Planta (Top), extruidos hacia abajo
    Dim a As Double, rp As Double
    a = Ro - M_(25): rp = M_(20)
    AbrirCroquis m, PlanoBase(m, 2)
    Dim e1 As Object, e2 As Object, e3 As Object, e4 As Object
    Dim c1 As Object, c2 As Object, c3 As Object, c4 As Object
    Set e1 = sm.CreateCenterLine(0, 0, 0, a, 0, 0)
    Set e2 = sm.CreateCenterLine(0, 0, 0, -a, 0, 0)
    Set e3 = sm.CreateCenterLine(0, 0, 0, 0, a, 0)
    Set e4 = sm.CreateCenterLine(0, 0, 0, 0, -a, 0)
    Set c1 = sm.CreateCircleByRadius(a, 0, 0, rp)
    Set c2 = sm.CreateCircleByRadius(-a, 0, 0, rp)
    Set c3 = sm.CreateCircleByRadius(0, a, 0, rp)
    Set c4 = sm.CreateCircleByRadius(0, -a, 0, rp)
    Igualar m, e1, e2: Igualar m, e1, e3: Igualar m, e1, e4
    Igualar m, c1, c2: Igualar m, c1, c3: Igualar m, c1, c4
    Acotar m, e1, Nothing, a / 2, 0.02, "RadioPatas"
    Acotar m, c1, Nothing, a + 0.04, 0.04, "DiamPata"
    Set sk = CerrarCroquis(m, "Croquis_Patas")
    Set f = Extruir(m, sk, 150, True, "Patas")
    NombrarCotaOperacion f, "Largo"

    ' Planos de referencia (sus distancias se controlan desde DriveWorksXpress)
    PlanoOffset m, PlanoBase(m, 2), ALTURA, False, "Plano_Tapa"
    PlanoOffset m, PlanoBase(m, 2), 420, False, "Plano_Entrada"
    PlanoOffset m, PlanoBase(m, 2), 140, False, "Plano_Salida"
    PlanoOffset m, PlanoBase(m, 3), RADIO_EXT + 100, False, "Plano_Boq_Ent"
    PlanoOffset m, PlanoBase(m, 3), RADIO_EXT + 100, True, "Plano_Boq_Sal"

    Propiedades m
    Guardar m, "FB_Cuerpo.SLDPRT"
End Sub

' Tapa plana con toma de manometro central
Sub CrearTapa()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    Dim c As Object, sk As SldWorks.Feature, f As SldWorks.Feature

    AbrirCroquis m, PlanoBase(m, 2)
    Set c = sm.CreateCircleByRadius(0, 0, 0, M_(RADIO_EXT + 20))
    Acotar m, c, Nothing, M_(RADIO_EXT), 0.05, "DiamTapa"
    Set sk = CerrarCroquis(m, "Croquis_Tapa")
    Set f = Extruir(m, sk, ESPESOR, False, "Extruir_Tapa")
    NombrarCotaOperacion f, "Espesor"

    AbrirCroquis m, PlanoBase(m, 2)
    Set c = sm.CreateCircleByRadius(0, 0, 0, M_(15))
    Acotar m, c, Nothing, 0.03, 0.03, "Diam"
    Set sk = CerrarCroquis(m, "Croquis_Manometro")
    Set f = Extruir(m, sk, ESPESOR + 40, False, "Toma_Manometro")
    NombrarCotaOperacion f, "Altura"

    Propiedades m
    Guardar m, "FB_Tapa.SLDPRT"
End Sub

' Boquilla: tubo a lo largo de +Y con brida (activa) y manguito roscado (suprimido)
Sub CrearBoquilla()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    Dim ce As Object, ci As Object, sk As SldWorks.Feature, f As SldWorks.Feature

    AbrirCroquis m, PlanoBase(m, 2)
    Set ce = sm.CreateCircleByRadius(0, 0, 0, M_(DIAM_TUBO / 2))
    Set ci = sm.CreateCircleByRadius(0, 0, 0, M_(DIAM_TUBO / 2 - 3))
    Acotar m, ce, Nothing, M_(DIAM_TUBO), 0.03, "DiamTubo"
    Acotar m, ci, Nothing, M_(DIAM_TUBO), -0.03, "DiamInt"
    Set sk = CerrarCroquis(m, "Croquis_Tubo")
    Set f = Extruir(m, sk, 100 + ESPESOR, False, "Tubo")
    NombrarCotaOperacion f, "Largo"

    AbrirCroquis m, PlanoBase(m, 2)
    Set ce = sm.CreateCircleByRadius(0, 0, 0, M_(DIAM_BRIDA / 2))
    Set ci = sm.CreateCircleByRadius(0, 0, 0, M_(DIAM_TUBO / 2 - 3))
    Acotar m, ce, Nothing, M_(DIAM_BRIDA), 0.03, "DiamBrida"
    Acotar m, ci, Nothing, M_(DIAM_BRIDA), -0.03, "DiamInt"
    Set sk = CerrarCroquis(m, "Croquis_Brida")
    Set f = Extruir(m, sk, 18, False, "Brida")
    NombrarCotaOperacion f, "Espesor"

    AbrirCroquis m, PlanoBase(m, 2)
    Set ce = sm.CreateCircleByRadius(0, 0, 0, M_(DIAM_TUBO / 2 + 6))
    Set ci = sm.CreateCircleByRadius(0, 0, 0, M_(DIAM_TUBO / 2 - 3))
    Acotar m, ce, Nothing, M_(DIAM_TUBO), 0.03, "DiamExt"
    Acotar m, ci, Nothing, M_(DIAM_TUBO), -0.03, "DiamInt"
    Set sk = CerrarCroquis(m, "Croquis_Manguito")
    Set f = Extruir(m, sk, 30, False, "Manguito_Roscado")
    NombrarCotaOperacion f, "Largo"

    m.ClearSelection2 True
    f.Select2 False, 0
    m.EditSuppress2
    m.ClearSelection2 True

    Propiedades m
    Guardar m, "FB_Boquilla.SLDPRT"
End Sub

' Canasta perforada (tubo de chapa de 2 mm) que cuelga desde la tapa hacia abajo
Sub CrearCanasta()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    Dim ce As Object, ci As Object, sk As SldWorks.Feature, f As SldWorks.Feature
    Dim dc As Double
    dc = 2 * (RADIO_EXT - ESPESOR) - 10

    AbrirCroquis m, PlanoBase(m, 2)
    Set ce = sm.CreateCircleByRadius(0, 0, 0, M_(dc / 2))
    Set ci = sm.CreateCircleByRadius(0, 0, 0, M_(dc / 2 - 2))
    Acotar m, ce, Nothing, M_(dc / 2), 0.04, "DiamExt"
    Acotar m, ci, Nothing, M_(dc / 2), -0.04, "DiamInt"
    Set sk = CerrarCroquis(m, "Croquis_Canasta")
    Set f = Extruir(m, sk, ALTURA - 60, True, "Extruir_Canasta")
    NombrarCotaOperacion f, "Altura"

    Propiedades m
    Guardar m, "FB_Canasta.SLDPRT"
End Sub

' ----------------------------------------------------------------------------
' Ensamble: todo se relaciona con planos, nunca con caras
' ----------------------------------------------------------------------------
Sub CrearEnsamble()
    Dim m As SldWorks.ModelDoc2
    Set m = swApp.NewDocument(swApp.GetUserPreferenceStringValue(swDefaultTemplateAssembly), 0, 0, 0)
    If m Is Nothing Then Err.Raise vbObjectError + 20, , "No se pudo crear el ensamble. Revisa la plantilla por defecto de ensamble."
    m.Extension.SetUserPreferenceInteger swUnitSystem, swDetailingNoOptionSpecified, swUnitSystem_MMGS
    Dim asm As SldWorks.AssemblyDoc
    Set asm = m

    Dim cCuerpo As SldWorks.Component2, cTapa As SldWorks.Component2, cCanasta As SldWorks.Component2
    Dim cEnt As SldWorks.Component2, cSal As SldWorks.Component2

    Set cCuerpo = Insertar(asm, "FB_Cuerpo.SLDPRT", 0, 0, 0)
    m.ClearSelection2 True
    cCuerpo.Select4 False, Nothing, False
    asm.FixComponent
    m.ClearSelection2 True

    Set cTapa = Insertar(asm, "FB_Tapa.SLDPRT", 0, M_(ALTURA + 200), 0)
    Unir asm, PlanoComp(cTapa, 2), cCuerpo.FeatureByName("Plano_Tapa"), swMateAlignALIGNED, "Tapa/arriba"
    Unir asm, PlanoComp(cTapa, 1), PlanoComp(cCuerpo, 1), swMateAlignALIGNED, "Tapa/alzado"
    Unir asm, PlanoComp(cTapa, 3), PlanoComp(cCuerpo, 3), swMateAlignALIGNED, "Tapa/lateral"

    Set cCanasta = Insertar(asm, "FB_Canasta.SLDPRT", 0, M_(ALTURA + 400), 0)
    Unir asm, PlanoComp(cCanasta, 2), cCuerpo.FeatureByName("Plano_Tapa"), swMateAlignALIGNED, "Canasta/arriba"
    Unir asm, PlanoComp(cCanasta, 1), PlanoComp(cCuerpo, 1), swMateAlignALIGNED, "Canasta/alzado"
    Unir asm, PlanoComp(cCanasta, 3), PlanoComp(cCuerpo, 3), swMateAlignALIGNED, "Canasta/lateral"

    ' La cara de la brida queda en Plano_Boq_*; el tubo entra hacia el cuerpo.
    ' Si una boquilla aparece apuntando hacia afuera, invierte la alineacion de
    ' su relacion "Boquilla .../exterior" en el FeatureManager.
    Set cEnt = Insertar(asm, "FB_Boquilla.SLDPRT", M_(RADIO_EXT + 300), M_(420), 0)
    Unir asm, PlanoComp(cEnt, 2), cCuerpo.FeatureByName("Plano_Boq_Ent"), swMateAlignANTI_ALIGNED, "Boquilla entrada/exterior"
    Unir asm, PlanoComp(cEnt, 1), PlanoComp(cCuerpo, 1), swMateAlignALIGNED, "Boquilla entrada/alzado"
    Unir asm, PlanoComp(cEnt, 3), cCuerpo.FeatureByName("Plano_Entrada"), swMateAlignALIGNED, "Boquilla entrada/altura"

    Set cSal = Insertar(asm, "FB_Boquilla.SLDPRT", -M_(RADIO_EXT + 300), M_(140), 0)
    Unir asm, PlanoComp(cSal, 2), cCuerpo.FeatureByName("Plano_Boq_Sal"), swMateAlignANTI_ALIGNED, "Boquilla salida/exterior"
    Unir asm, PlanoComp(cSal, 1), PlanoComp(cCuerpo, 1), swMateAlignALIGNED, "Boquilla salida/alzado"
    Unir asm, PlanoComp(cSal, 3), cCuerpo.FeatureByName("Plano_Salida"), swMateAlignALIGNED, "Boquilla salida/altura"

    m.ForceRebuild3 False
    Propiedades m
    Guardar m, "FB_Ensamble.SLDASM"
End Sub

' ----------------------------------------------------------------------------
' Planos: mismo nombre que el modelo, vistas estandar y cotas del modelo
' ----------------------------------------------------------------------------
Sub CrearPlano(nombre As String, ext As String)
    On Error GoTo FalloPlano
    Dim m As SldWorks.ModelDoc2
    Set m = swApp.NewDocument(swApp.GetUserPreferenceStringValue(swDefaultTemplateDrawing), swDwgPaperA3size, 0.42, 0.297)
    If m Is Nothing Then
        gAvisos = gAvisos & "- No se pudo crear el plano de " & nombre & " (plantilla de dibujo)." & vbCrLf
        Exit Sub
    End If
    Dim d As SldWorks.DrawingDoc
    Set d = m
    If Not d.Create1stAngleViews2(gCarpeta & nombre & ext) Then
        gAvisos = gAvisos & "- No se pudieron insertar las vistas de " & nombre & "." & vbCrLf
    End If
    d.InsertModelAnnotations3 swImportModelItemsFromEntireModel, swInsertDimensionsMarkedForDrawing, True, False, False, False
    Guardar m, nombre & ".SLDDRW"
    swApp.CloseDoc m.GetTitle
    Exit Sub
FalloPlano:
    gAvisos = gAvisos & "- Plano de " & nombre & ": " & Err.Description & vbCrLf
End Sub

' ----------------------------------------------------------------------------
' Utilidades
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

' Planos por defecto por orden (1 = Alzado/Front, 2 = Planta/Top, 3 = Vista lateral/Right),
' asi funciona con SOLIDWORKS en cualquier idioma
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
Sub Acotar(m As SldWorks.ModelDoc2, a As Object, b As Object, x As Double, y As Double, nombre As String)
    m.ClearSelection2 True
    a.Select4 False, Nothing
    If Not b Is Nothing Then b.Select4 True, Nothing
    Dim dd As SldWorks.DisplayDimension
    Set dd = m.AddDimension2(x, y, 0)
    If dd Is Nothing Then Err.Raise vbObjectError + 3, , "No se pudo crear la cota " & nombre
    dd.GetDimension2(0).Name = nombre
    m.ClearSelection2 True
End Sub

Sub Igualar(m As SldWorks.ModelDoc2, a As Object, b As Object)
    m.ClearSelection2 True
    a.Select4 False, Nothing
    b.Select4 True, Nothing
    m.SketchAddConstraints "sgSAMELENGTH"
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

Sub Propiedades(m As SldWorks.ModelDoc2)
    Dim cpm As SldWorks.CustomPropertyManager
    Set cpm = m.Extension.CustomPropertyManager("")
    cpm.Add3 "Codigo", swCustomInfoText, "FB-MAESTRO", swCustomPropertyReplaceValue
    cpm.Add3 "Descripcion", swCustomInfoText, "Filtro de bolsa (maestro)", swCustomPropertyReplaceValue
    cpm.Add3 "Material", swCustomInfoText, "AISI 304", swCustomPropertyReplaceValue
    cpm.Add3 "PresionDiseno", swCustomInfoText, "6 bar", swCustomPropertyReplaceValue
    cpm.Add3 "Espesor", swCustomInfoText, "3 mm", swCustomPropertyReplaceValue
End Sub

Sub Guardar(m As SldWorks.ModelDoc2, nombre As String)
    Dim ruta As String, errs As Long, warns As Long
    ruta = gCarpeta & nombre

    ' Un croquis abierto o una seleccion activa impiden guardar
    If m.GetType <> swDocDRAWING Then
        If Not m.SketchManager.ActiveSketch Is Nothing Then m.SketchManager.InsertSketch True
    End If
    m.ClearSelection2 True
    m.ForceRebuild3 False

    ' Si ya existe un archivo con ese nombre (de una ejecucion anterior), se reemplaza
    If Dir(ruta) <> "" Then
        If swApp.GetOpenDocumentByName(ruta) Is Nothing Then
            Kill ruta
        Else
            Err.Raise vbObjectError + 6, , ruta & " esta abierto en SOLIDWORKS. Cierralo y vuelve a ejecutar la macro."
        End If
    End If

    If m.Extension.SaveAs(ruta, swSaveAsCurrentVersion, swSaveAsOptions_Silent, Nothing, errs, warns) Then Exit Sub
    ' Segundo intento con la llamada clasica
    errs = m.SaveAs3(ruta, swSaveAsCurrentVersion, swSaveAsOptions_Silent)
    If errs = 0 And Dir(ruta) <> "" Then Exit Sub

    Err.Raise vbObjectError + 6, , "No se pudo guardar " & ruta & vbCrLf & _
        "Errores: " & errs & "  Avisos: " & warns & vbCrLf & _
        "Carpeta escribible: " & CarpetaEscribible() & vbCrLf & _
        "Titulo del documento: " & m.GetTitle
End Sub

Function CarpetaEscribible() As String
    On Error GoTo NoSe
    Dim n As Integer, prueba As String
    prueba = gCarpeta & "_prueba_escritura.txt"
    n = FreeFile
    Open prueba For Output As #n
    Print #n, "ok"
    Close #n
    Kill prueba
    CarpetaEscribible = "si"
    Exit Function
NoSe:
    CarpetaEscribible = "NO (" & Err.Description & ")"
End Function

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
