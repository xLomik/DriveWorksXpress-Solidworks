Attribute VB_Name = "CrearMaestrosCarcaza"
' ============================================================================
' Crea los modelos maestros de la CARCAZA codificada para DriveWorksXpress.
'
' Genera en la carpeta elegida:
'   FC_Cuerpo.SLDPRT    virola + fondo, planos para cierre, elemento y boquillas
'   FC_Cierre.SLDPRT    todas las variantes de cierre como operaciones suprimibles
'   FC_Boquilla.SLDPRT  tubo + brida / ferula clamp / union NPT / espiga manguera
'   FC_Elemento.SLDPRT  elemento filtrante (provisional: un cilindro)
'   FC_Ensamble.SLDASM  y un plano .SLDDRW por cada modelo, con el mismo nombre
'
' Los nombres de cotas y operaciones coinciden con docs/reglas-carcazas.md.
' Valores iniciales = codigo ZAB020021084 (Z colineal 1 cartucho, brida,
' cierre B, conexion 2", S.S. 304, 150 psi, carcaza 8" Sch 40), elemento 500 mm.
'
' Uso: Herramientas > Macro > Nueva, Archivo > Importar este .bas, borrar
' Module1 y ejecutar "main" (F5 con el cursor dentro de Sub main).
' ============================================================================
Option Explicit

Dim swApp As SldWorks.SldWorks
Dim gCarpeta As String
Dim gAvisos As String

' Valores iniciales en mm
Const OD_CARCAZA As Double = 219.1
Const ESPESOR As Double = 8.18
Const ALTURA As Double = 650
Const DIAM_BRIDA_CUERPO As Double = 334
Const OD_CONEXION As Double = 60.3
Const PI As Double = 3.14159265358979

Sub main()
    Set swApp = Application.SldWorks
    gAvisos = ""

    gCarpeta = InputBox("Carpeta donde guardar los modelos maestros:", _
                        "Configurador de carcazas", "C:\Configurador_Carcazas\Maestro\")
    If gCarpeta = "" Then Exit Sub
    If Right(gCarpeta, 1) <> "\" Then gCarpeta = gCarpeta & "\"
    CrearCarpeta gCarpeta

    Dim pedirValor As Boolean
    pedirValor = swApp.GetUserPreferenceToggle(swInputDimValOnCreate)
    swApp.SetUserPreferenceToggle swInputDimValOnCreate, False

    On Error GoTo Fallo
    CrearCuerpo
    CrearCierre
    CrearBoquilla
    CrearElemento
    CrearEnsamble
    On Error GoTo 0

    HacerPlanos
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

Sub HacerPlanos()
    CrearPlano "FC_Cuerpo", ".SLDPRT"
    CrearPlano "FC_Cierre", ".SLDPRT"
    CrearPlano "FC_Boquilla", ".SLDPRT"
    CrearPlano "FC_Elemento", ".SLDPRT"
    CrearPlano "FC_Ensamble", ".SLDASM"
End Sub

' ----------------------------------------------------------------------------
' Piezas
' ----------------------------------------------------------------------------

' Virola + fondo (revolucion sobre el eje Y) y planos de referencia
Sub CrearCuerpo()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager

    Dim Ro As Double, t As Double, H As Double
    Ro = M_(OD_CARCAZA / 2): t = M_(ESPESOR): H = M_(ALTURA)

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

    PlanoOffset m, PlanoBase(m, 2), ALTURA, False, "Plano_Cierre"
    PlanoOffset m, PlanoBase(m, 2), ALTURA - 20, False, "Plano_Elemento"
    PlanoOffset m, PlanoBase(m, 2), 455, False, "Plano_Entrada"
    PlanoOffset m, PlanoBase(m, 2), 455, False, "Plano_Salida"
    PlanoOffset m, PlanoBase(m, 3), OD_CARCAZA / 2 + 100, False, "Plano_Boq_Ent"
    PlanoOffset m, PlanoBase(m, 3), OD_CARCAZA / 2 + 100, True, "Plano_Boq_Sal"

    Propiedades m
    Guardar m, "FC_Cuerpo.SLDPRT"
End Sub

' Cierre: el origen queda en el plano de cierre. Cada variante es una operacion
' que DriveWorksXpress activa o suprime segun la letra de cierre.
' Valores iniciales = cierre B (brida con top davit, esparragos).
Sub CrearCierre()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim f As SldWorks.Feature
    Dim rPernos As Double, rDavit As Double
    rPernos = DIAM_BRIDA_CUERPO / 2 - 20
    rDavit = DIAM_BRIDA_CUERPO / 2 + 30

    Set f = Anillo(m, "Croquis_Brida_Cuerpo", "DiamBrida", DIAM_BRIDA_CUERPO, OD_CARCAZA - 2 * ESPESOR, 25, True, "Brida_Cuerpo")
    NombrarCotaOperacion f, "Espesor"
    Set f = Anillo(m, "Croquis_Tapa", "DiamTapa", DIAM_BRIDA_CUERPO, 0, 25, False, "Tapa_Plana")
    NombrarCotaOperacion f, "Espesor"
    Set f = Anillo(m, "Croquis_Clamp", "DiamClamp", OD_CARCAZA + 40, OD_CARCAZA, 30, False, "Abrazadera_Clamp")
    Suprimir m, f
    Set f = Anillo(m, "Croquis_Tapa_Roscada", "DiamTapa", OD_CARCAZA + 40, 0, 40, False, "Tapa_Roscada")
    Suprimir m, f
    Set f = CirculosRadiales(m, "Croquis_Davit", rDavit, 40, 1, 400, "Davit")
    Set f = CirculosRadiales(m, "Croquis_Pernos", rPernos, 20, 4, 60, "Esparragos")
    Set f = CirculosRadiales(m, "Croquis_Pivotados", rPernos, 24, 4, 70, "Tornillos_Pivotados")
    Suprimir m, f
    Set f = CirculosRadiales(m, "Croquis_Tornillo_Central", 0, 40, 1, 120, "Tornillo_Central")
    Suprimir m, f
    Set f = CirculosRadiales(m, "Croquis_Bisagra", rDavit, 40, 1, 50, "Bisagra")
    Suprimir m, f

    Propiedades m
    Guardar m, "FC_Cierre.SLDPRT"
End Sub

' Boquilla a lo largo de +Y; el origen es la cara exterior. Valores iniciales = brida 2" clase 150.
Sub CrearBoquilla()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim f As SldWorks.Feature
    Dim di As Double
    di = Round(OD_CONEXION * 0.85, 1)

    Set f = Anillo(m, "Croquis_Tubo", "DiamTubo", OD_CONEXION, di, 100 + ESPESOR, False, "Tubo")
    NombrarCotaOperacion f, "Largo"
    Set f = Anillo(m, "Croquis_Brida", "DiamBrida", 152.4, di, 19.05, False, "Brida")
    NombrarCotaOperacion f, "Espesor"
    Set f = Anillo(m, "Croquis_Ferrula", "DiamExt", 64, di, 21.5, False, "Ferrula_Clamp")
    NombrarCotaOperacion f, "Largo"
    Suprimir m, f
    Set f = Anillo(m, "Croquis_Union", "DiamExt", Round(OD_CONEXION * 1.5, 0), di, 40, False, "Union_NPT")
    NombrarCotaOperacion f, "Largo"
    Suprimir m, f
    Set f = Anillo(m, "Croquis_Espiga", "DiamExt", Round(OD_CONEXION * 0.9, 1), di, 60, True, "Espiga_Manguera")
    NombrarCotaOperacion f, "Largo"
    Suprimir m, f

    Propiedades m
    Guardar m, "FC_Boquilla.SLDPRT"
End Sub

' Elemento filtrante provisional: cilindro que cuelga desde Plano_Elemento
Sub CrearElemento()
    Dim m As SldWorks.ModelDoc2
    Set m = NuevaPieza()
    Dim f As SldWorks.Feature
    Set f = Anillo(m, "Croquis_Elemento", "Diam", 162, 0, 500, True, "Elemento")
    NombrarCotaOperacion f, "Largo"
    Propiedades m
    Guardar m, "FC_Elemento.SLDPRT"
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

    Dim cCuerpo As SldWorks.Component2, cCierre As SldWorks.Component2, cElem As SldWorks.Component2
    Dim cEnt As SldWorks.Component2, cSal As SldWorks.Component2

    Set cCuerpo = Insertar(asm, "FC_Cuerpo.SLDPRT", 0, 0, 0)
    m.ClearSelection2 True
    cCuerpo.Select4 False, Nothing, False
    asm.FixComponent
    m.ClearSelection2 True

    Set cCierre = Insertar(asm, "FC_Cierre.SLDPRT", 0, M_(ALTURA + 300), 0)
    Unir asm, PlanoComp(cCierre, 2), cCuerpo.FeatureByName("Plano_Cierre"), swMateAlignALIGNED, "Cierre/altura"
    Unir asm, PlanoComp(cCierre, 1), PlanoComp(cCuerpo, 1), swMateAlignALIGNED, "Cierre/alzado"
    Unir asm, PlanoComp(cCierre, 3), PlanoComp(cCuerpo, 3), swMateAlignALIGNED, "Cierre/lateral"

    Set cElem = Insertar(asm, "FC_Elemento.SLDPRT", 0, M_(ALTURA + 600), 0)
    Unir asm, PlanoComp(cElem, 2), cCuerpo.FeatureByName("Plano_Elemento"), swMateAlignALIGNED, "Elemento/altura"
    Unir asm, PlanoComp(cElem, 1), PlanoComp(cCuerpo, 1), swMateAlignALIGNED, "Elemento/alzado"
    Unir asm, PlanoComp(cElem, 3), PlanoComp(cCuerpo, 3), swMateAlignALIGNED, "Elemento/lateral"

    ' La cara exterior de la boquilla queda en Plano_Boq_*; el tubo entra hacia el cuerpo.
    ' Si una boquilla aparece apuntando hacia afuera, invierte la alineacion de
    ' su relacion "Boquilla .../exterior" en el FeatureManager.
    Set cEnt = Insertar(asm, "FC_Boquilla.SLDPRT", M_(OD_CARCAZA / 2 + 300), M_(455), 0)
    Unir asm, PlanoComp(cEnt, 2), cCuerpo.FeatureByName("Plano_Boq_Ent"), swMateAlignANTI_ALIGNED, "Boquilla entrada/exterior"
    Unir asm, PlanoComp(cEnt, 1), PlanoComp(cCuerpo, 1), swMateAlignALIGNED, "Boquilla entrada/alzado"
    Unir asm, PlanoComp(cEnt, 3), cCuerpo.FeatureByName("Plano_Entrada"), swMateAlignALIGNED, "Boquilla entrada/altura"

    Set cSal = Insertar(asm, "FC_Boquilla.SLDPRT", -M_(OD_CARCAZA / 2 + 300), M_(455), 0)
    Unir asm, PlanoComp(cSal, 2), cCuerpo.FeatureByName("Plano_Boq_Sal"), swMateAlignANTI_ALIGNED, "Boquilla salida/exterior"
    Unir asm, PlanoComp(cSal, 1), PlanoComp(cCuerpo, 1), swMateAlignALIGNED, "Boquilla salida/alzado"
    Unir asm, PlanoComp(cSal, 3), cCuerpo.FeatureByName("Plano_Salida"), swMateAlignALIGNED, "Boquilla salida/altura"

    m.ForceRebuild3 False
    Propiedades m
    Guardar m, "FC_Ensamble.SLDASM"
End Sub

' ----------------------------------------------------------------------------
' Constructores de operaciones
' ----------------------------------------------------------------------------

' Circulo (diamInt = 0) o anillo concentrico al origen en el plano Planta,
' extruido hacia arriba (o hacia abajo si invertir). Cotas: <nombreDiam> y DiamInt.
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

' 1 o 4 circulos de diametro "Diam" sobre lineas constructivas desde el origen
' a distancia "Radio" (con radio 0, un circulo centrado), extruidos hacia arriba "Largo".
Function CirculosRadiales(m As SldWorks.ModelDoc2, croquis As String, radio As Double, diam As Double, _
                          cantidad As Integer, largo As Double, nombre As String) As SldWorks.Feature
    Dim sm As SldWorks.SketchManager
    Set sm = m.SketchManager
    Dim a As Double, rc As Double
    a = M_(radio): rc = M_(diam / 2)
    AbrirCroquis m, PlanoBase(m, 2)
    Dim e(3) As Object, c(3) As Object, i As Integer
    If radio = 0 Then
        Set c(0) = sm.CreateCircleByRadius(0, 0, 0, rc)
    Else
        Set e(0) = sm.CreateCenterLine(0, 0, 0, a, 0, 0)
        Set c(0) = sm.CreateCircleByRadius(a, 0, 0, rc)
        If cantidad = 4 Then
            Set e(1) = sm.CreateCenterLine(0, 0, 0, -a, 0, 0)
            Set e(2) = sm.CreateCenterLine(0, 0, 0, 0, a, 0)
            Set e(3) = sm.CreateCenterLine(0, 0, 0, 0, -a, 0)
            Set c(1) = sm.CreateCircleByRadius(-a, 0, 0, rc)
            Set c(2) = sm.CreateCircleByRadius(0, a, 0, rc)
            Set c(3) = sm.CreateCircleByRadius(0, -a, 0, rc)
            For i = 1 To 3
                Igualar m, e(0), e(i)
                Igualar m, c(0), c(i)
            Next i
        End If
        Acotar m, e(0), Nothing, a / 2, 0.02, "Radio"
    End If
    Acotar m, c(0), Nothing, a + rc + 0.03, 0.04, "Diam"
    Dim sk As SldWorks.Feature
    Set sk = CerrarCroquis(m, croquis)
    Dim f As SldWorks.Feature
    Set f = Extruir(m, sk, largo, False, nombre)
    NombrarCotaOperacion f, "Largo"
    Set CirculosRadiales = f
End Function

Sub Suprimir(m As SldWorks.ModelDoc2, f As SldWorks.Feature)
    m.ClearSelection2 True
    f.Select2 False, 0
    m.EditSuppress2
    m.ClearSelection2 True
End Sub

' ----------------------------------------------------------------------------
' Planos: mismo nombre que el modelo, vistas estandar y cotas del modelo
' ----------------------------------------------------------------------------
Sub CrearPlano(nombre As String, ext As String)
    On Error GoTo FalloPlano
    Dim ruta As String
    ruta = gCarpeta & nombre & ext

    ' El modelo debe estar abierto para insertar sus vistas
    Dim mdl As SldWorks.ModelDoc2
    Set mdl = swApp.GetOpenDocumentByName(ruta)
    If mdl Is Nothing Then
        Dim e As Long, w As Long, tipo As Long
        If UCase(ext) = ".SLDASM" Then tipo = swDocASSEMBLY Else tipo = swDocPART
        Set mdl = swApp.OpenDoc6(ruta, tipo, swOpenDocOptions_Silent, "", e, w)
        If mdl Is Nothing Then
            gAvisos = gAvisos & "- No se pudo abrir " & ruta & " para hacer su plano." & vbCrLf
            Exit Sub
        End If
    End If

    Dim m As SldWorks.ModelDoc2
    Set m = swApp.NewDocument(swApp.GetUserPreferenceStringValue(swDefaultTemplateDrawing), swDwgPaperA3size, 0.42, 0.297)
    If m Is Nothing Then
        gAvisos = gAvisos & "- No se pudo crear el plano de " & nombre & " (plantilla de dibujo)." & vbCrLf
        Exit Sub
    End If
    Dim d As SldWorks.DrawingDoc
    Set d = m
    If InsertarVistas(d, mdl, ruta) Then
        d.InsertModelAnnotations3 swImportModelItemsFromEntireModel, swInsertDimensionsMarkedForDrawing, True, False, False, False
    Else
        gAvisos = gAvisos & "- No se pudieron insertar las vistas de " & nombre & " (el plano se guardo vacio)." & vbCrLf
    End If
    Guardar m, nombre & ".SLDDRW"
    swApp.CloseDoc m.GetTitle
    Exit Sub
FalloPlano:
    gAvisos = gAvisos & "- Plano de " & nombre & ": " & Err.Description & vbCrLf
End Sub

' Intenta tres metodos; devuelve True si quedo al menos una vista
Function InsertarVistas(d As SldWorks.DrawingDoc, mdl As SldWorks.ModelDoc2, ruta As String) As Boolean
    On Error Resume Next
    If d.Create1stAngleViews2(ruta) Then InsertarVistas = True: Exit Function
    If d.Create3rdAngleViews2(ruta) Then InsertarVistas = True: Exit Function

    ' Vistas con nombre del modelo (los nombres estandar empiezan con "*" y
    ' dependen del idioma, por eso se leen del propio modelo)
    Dim nombres As Variant, i As Integer, k As Integer
    Dim px As Variant, py As Variant
    px = Array(0.1, 0.1, 0.27, 0.3)
    py = Array(0.2, 0.08, 0.2, 0.08)
    nombres = mdl.GetModelViewNames
    If IsEmpty(nombres) Then Exit Function
    For i = 0 To UBound(nombres)
        If k > 3 Then Exit For
        If Left(nombres(i), 1) = "*" Then
            If Not d.CreateDrawViewFromModelView3(ruta, nombres(i), px(k), py(k), 0) Is Nothing Then k = k + 1
        End If
    Next i
    If k = 0 Then
        For Each px In Array("*Front", "*Top", "*Right", "*Isometric")
            If Not d.CreateDrawViewFromModelView3(ruta, CStr(px), 0.1 + 0.1 * k, 0.15, 0) Is Nothing Then k = k + 1
        Next px
    End If
    InsertarVistas = (k > 0)
End Function

' Ejecuta solo esta rutina para rehacer los planos sin volver a crear los modelos
Sub SoloPlanos()
    Set swApp = Application.SldWorks
    gAvisos = ""
    gCarpeta = InputBox("Carpeta donde estan los modelos maestros:", _
                        "Configurador de carcazas", "C:\Configurador_Carcazas\Maestro\")
    If gCarpeta = "" Then Exit Sub
    If Right(gCarpeta, 1) <> "\" Then gCarpeta = gCarpeta & "\"
    HacerPlanos
    If gAvisos = "" Then
        MsgBox "Planos creados en " & gCarpeta, vbInformation
    Else
        MsgBox "Avisos:" & vbCrLf & gAvisos, vbExclamation
    End If
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
    cpm.Add3 "Codigo", swCustomInfoText, "ZAB020021084", swCustomPropertyReplaceValue
    cpm.Add3 "Descripcion", swCustomInfoText, "Carcaza (maestro)", swCustomPropertyReplaceValue
    cpm.Add3 "Material", swCustomInfoText, "S.S. 304", swCustomPropertyReplaceValue
    cpm.Add3 "Presion", swCustomInfoText, "150 psi", swCustomPropertyReplaceValue
    cpm.Add3 "ClaseBrida", swCustomInfoText, "Clase 150", swCustomPropertyReplaceValue
    cpm.Add3 "Espesor", swCustomInfoText, "8.18 mm", swCustomPropertyReplaceValue
    cpm.Add3 "Sello", swCustomInfoText, "O'ring", swCustomPropertyReplaceValue
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
