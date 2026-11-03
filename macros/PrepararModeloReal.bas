Attribute VB_Name = "PrepararModeloReal"
' ============================================================================
' Prepara tu modelo real del filtro multicartucho (carpeta "NUEVO 2") para
' DriveWorksXpress: renombra cotas y agrega propiedades personalizadas.
'
' IMPORTANTE: ejecutala sobre una COPIA hecha con Pack and Go, nunca sobre la
' planoteca. La macro se niega a trabajar en rutas que contengan "PLANOTECA".
'
' Que hace:
'   - Abre cada archivo de la tabla TABLA(), busca la operacion o croquis y la
'     cota (por su nombre actual, p. ej. D1 en Croquis1) y le pone el nombre nuevo.
'   - Agrega las propiedades Codigo, Descripcion, Material, Presion, Espesor y
'     Sello si no existen (no sobrescribe las que ya tengas).
'   - Guarda y cierra. Deja un registro en _registro_preparacion.txt.
'
' Compatible con SOLIDWORKS 2025 en espanol (usa los nombres del arbol tal
' como aparecen: Croquis1, Saliente-Extruir1, MatrizC local1...).
' Uso: Herramientas > Macro > Nueva, Archivo > Importar este .bas, borrar
' Module1 y ejecutar "main" (F5 con el cursor dentro de Sub main).
' ============================================================================
Option Explicit

Dim swApp As SldWorks.SldWorks
Dim gCarpeta As String
Dim gRegistro As String
Dim gFallos As Integer

' archivo | operacion o croquis | cota actual | nombre nuevo
Function TABLA() As Variant
    TABLA = Array( _
        "SOPORTE 2 CANAS WT.SLDPRT|Croquis1|D1|DiamExt", _
        "SOPORTE 2 CANAS WT.SLDPRT|Croquis1|D3|DiamPCD", _
        "SOPORTE 2 CANAS WT.SLDPRT|Croquis1|D4|DiamAgujero", _
        "SOPORTE 2 CANAS WT.SLDPRT|Croquis1|D2|DiamCentro", _
        "SOPORTE 2 CANAS WT.SLDPRT|Saliente-Extruir1|D1|Espesor", _
        "TAPA SOPORTE WT.SLDPRT|Croquis1|193|DiamExt", _
        "TAPA SOPORTE WT.SLDPRT|Croquis1|D2|DiamPCD", _
        "TAPA SOPORTE WT.SLDPRT|Croquis1|D3|DiamAgujero", _
        "TAPA SOPORTE WT.SLDPRT|Croquis1|D7|DiamCentro", _
        "TAPA SOPORTE WT.SLDPRT|Saliente-Extruir1|D1|Espesor", _
        "plato guia centro.SLDPRT|Croquis1|D1|DiamExt", _
        "plato guia centro.SLDPRT|Croquis1|D2|DiamPCD", _
        "plato guia centro.SLDPRT|Croquis1|D3|DiamAgujero", _
        "plato guia centro.SLDPRT|Croquis1|D5|DiamCentro", _
        "plato guia centro.SLDPRT|Saliente-Extruir1|D1|Espesor", _
        "TORNILLO WT.SLDPRT|Saliente-Extruir1|D1|Largo", _
        "TORNILLO WT.SLDPRT|Croquis1|D1|Diam", _
        "tapa pata wt.SLDPRT|Croquis1|D4|DiamCuerpo", _
        "SOPORTE BISAGRA WT.SLDPRT|Croquis1|D1|DiamAnillo", _
        "couplin un cuarto wt.SLDPRT|Croquis6|D1|DiamInterior", _
        "ENSANBLE 2 SART WT.SLDASM|MatrizC local1|D1|NumCartuchos", _
        "ENSANBLE 2 SART WT.SLDASM|MatrizC local2|D1|NumCartuchos", _
        "ENSAMBLE 444.SLDASM|MatrizC local1|D1|NumCartuchos", _
        "ENSAMBLE 444.SLDASM|MatrizC local2|D1|NumCartuchos", _
        "ENDABLE 2 WT.SLDASM|MatrizC local1|D1|NumPivotados", _
        "ENDABLE 2 WT.SLDASM|MatrizC local2|D1|NumPatas")
End Function

Sub main()
    Set swApp = Application.SldWorks
    gRegistro = ""
    gFallos = 0

    gCarpeta = InputBox("Carpeta de la COPIA (Pack and Go) del modelo:", _
                        "Preparar modelo real", "C:\Configurador_Carcazas\Maestro_PAH\")
    If gCarpeta = "" Then Exit Sub
    If Right(gCarpeta, 1) <> "\" Then gCarpeta = gCarpeta & "\"
    If InStr(1, UCase(gCarpeta), "PLANOTECA") > 0 Then
        MsgBox "Esta carpeta parece la planoteca. Haz primero una copia con Pack and Go y ejecuta la macro sobre la copia.", vbCritical
        Exit Sub
    End If
    If Dir(gCarpeta, vbDirectory) = "" Then
        MsgBox "No existe la carpeta " & gCarpeta, vbCritical
        Exit Sub
    End If

    ' Piezas primero y ensambles al final, cada archivo una sola vez
    Dim t As Variant, i As Long, archivos As Collection, a As Variant
    t = TABLA()
    Set archivos = New Collection
    On Error Resume Next
    For i = 0 To UBound(t)
        a = Split(t(i), "|")(0)
        If UCase(Right(a, 6)) = "SLDPRT" Then archivos.Add a, UCase(a)
    Next i
    For i = 0 To UBound(t)
        a = Split(t(i), "|")(0)
        If UCase(Right(a, 6)) = "SLDASM" Then archivos.Add a, UCase(a)
    Next i
    On Error GoTo 0

    For Each a In archivos
        ProcesarArchivo CStr(a), t
    Next a

    EscribirRegistro
    If gFallos = 0 Then
        MsgBox "Listo. Todas las cotas quedaron renombradas." & vbCrLf & _
               "Detalle en " & gCarpeta & "_registro_preparacion.txt", vbInformation
    Else
        MsgBox gFallos & " cambios no se pudieron hacer (ver detalle):" & vbCrLf & vbCrLf & gRegistro, vbExclamation
    End If
End Sub

Sub ProcesarArchivo(archivo As String, t As Variant)
    Dim ruta As String
    ruta = gCarpeta & archivo
    If Dir(ruta) = "" Then
        Anotar "FALTA  " & archivo & " (no esta en la carpeta)", True
        Exit Sub
    End If

    Dim e As Long, w As Long, tipo As Long
    If UCase(Right(archivo, 6)) = "SLDASM" Then tipo = swDocASSEMBLY Else tipo = swDocPART
    Dim m As SldWorks.ModelDoc2
    Set m = swApp.OpenDoc6(ruta, tipo, swOpenDocOptions_Silent, "", e, w)
    If m Is Nothing Then
        Anotar "ERROR  no se pudo abrir " & archivo & " (codigo " & e & ")", True
        Exit Sub
    End If

    Dim i As Long, c() As String
    For i = 0 To UBound(t)
        c = Split(t(i), "|")
        If UCase(c(0)) = UCase(archivo) Then
            If RenombrarCota(m, c(1), c(2), c(3)) Then
                Anotar "OK     " & archivo & ": " & c(2) & "@" & c(1) & " -> " & c(3) & "@" & c(1), False
            Else
                Anotar "NO     " & archivo & ": no encontre " & c(2) & "@" & c(1) & _
                       " (quiza ya estaba renombrada)", True
            End If
        End If
    Next i

    Propiedades m
    m.ForceRebuild3 False
    If Not m.Save3(swSaveAsOptions_Silent, e, w) Then
        Anotar "ERROR  no se pudo guardar " & archivo & " (codigo " & e & ")", True
    End If
    swApp.CloseDoc ruta
End Sub

' Busca la cota por su nombre corto dentro de la operacion o croquis indicado
Function RenombrarCota(m As SldWorks.ModelDoc2, operacion As String, actual As String, nuevo As String) As Boolean
    Dim f As SldWorks.Feature
    Set f = m.FeatureByName(operacion)
    If f Is Nothing Then Exit Function
    Dim dd As SldWorks.DisplayDimension, d As SldWorks.Dimension
    Set dd = f.GetFirstDisplayDimension
    Do While Not dd Is Nothing
        Set d = dd.GetDimension2(0)
        If Not d Is Nothing Then
            If d.Name = actual Then
                d.Name = nuevo
                RenombrarCota = (d.Name = nuevo)
                Exit Function
            ElseIf d.Name = nuevo Then
                ' ya renombrada en una ejecucion anterior
                RenombrarCota = True
                Exit Function
            End If
        End If
        Set dd = f.GetNextDisplayDimension(dd)
    Loop
End Function

Sub Propiedades(m As SldWorks.ModelDoc2)
    Dim cpm As SldWorks.CustomPropertyManager
    Set cpm = m.Extension.CustomPropertyManager("")
    Dim nombres As Variant, n As Variant
    nombres = Array("Codigo", "Descripcion", "Material", "Presion", "Espesor", "Sello")
    For Each n In nombres
        cpm.Add3 CStr(n), swCustomInfoText, " ", swCustomPropertyOnlyIfNew
    Next n
End Sub

Sub Anotar(texto As String, esFallo As Boolean)
    gRegistro = gRegistro & texto & vbCrLf
    If esFallo Then gFallos = gFallos + 1
End Sub

Sub EscribirRegistro()
    On Error Resume Next
    Dim n As Integer
    n = FreeFile
    Open gCarpeta & "_registro_preparacion.txt" For Output As #n
    Print #n, "Preparacion del modelo real - " & Now
    Print #n, gRegistro
    Close #n
End Sub
