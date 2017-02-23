Attribute VB_Name = "UniteCaller"

Public UniteCandidatesList As Collection '
Public unite_source As String
Public unite_argument As String
Public isExistPython As Boolean

Public Sub unite(Optional sourceName As String = "") '{{{
	If sourceName = "" Then
		Msgbox "source���w�肵�Ă���������g�p�o����source�ꗗ��\���o����悤�ɂ���\��"
	End If

	On Error GoTo Myerror
		Set UniteCandidatesList = ExeStringPro("GatherCandidates_" & sourceName) 'CandidateList�̐ݒ�
	On Error GoTo 0
	unite_source = sourceName 'source���̐ݒ�

	'TODO soure��candidate�͂����Ŏ������̂ł͂Ȃ�,form�I�u�W�F�N�g�̃C���X�^���X�ϐ��Ƃ��Ď�����������������q�E�B���h�E�𗧂��������悢�H
	UniteInterface.Show
	Exit Sub
	Myerror:
		MsgBox "sourceName���s���ł��" & Err.Description
End Sub '}}}

'mru
Function GatherCandidates_mru() As Collection '{{{
	Dim result As New Collection
	Dim reverseResult As New Collection
	Set FSO = CreateObject("Scripting.FileSystemObject")

	Open ThisWorkbook.Path & "/.cache/mru.txt" For Input As #1
	Do Until EOF(1)
		Line Input #1, buf
		FileName = Split(buf, ":::")(0)
		' If fso.FileExists(filename) Then ���Ԃ������肷���邽�ߡ
		If True Then
			result.Add buf
		End If
	Loop
	Close #1

	'sort.pyw���g���Ȃ��ꍇ�mru�t�@�C���͍ŏI�s����ǂ߂ΊJ���ꂽ���ɂȂ��Ă���͂��
	If Not isExistPython Then
		For i = result.Count to 1 Step -1
			reverseResult.Add result(i)
		Next
		Set GatherCandidates_mru = reverseResult
	Else
		Set GatherCandidates_mru = result
	End If
End Function '}}}
Function defaultAction_mru(arg) 'table�ɂ��������悢��'{{{
	For Each f in Split(arg, vbCrLf)
		SmartOpenBook(f)
	Next f
End Function'}}}

'sheet
Function GatherCandidates_sheet() As Collection '{{{
	Dim result As New Collection
	Dim sh As Worksheet
	Set Wb = ActiveWorkbook
	For Each sh In Wb.Worksheets
		result.Add sh.Name
	Next sh
	Set GatherCandidates_sheet = result
End Function '}}}
Function defaultAction_sheet(arg) 'table�ɂ��������悢��'{{{
	Worksheets(arg).Activate
End Function'}}}

'book
Function GatherCandidates_book() As Collection '{{{
	Dim result As New Collection
	Dim wb As Workbook

	For Each wb In Workbooks()
		result.Add wb.Name
	Next wb

	Set GatherCandidates_book = result
End Function '}}}
Function defaultAction_book(arg) 'table�ɂ��������悢��'{{{
	Workbooks(arg).Activate
End Function'}}}

'filter
Function GatherCandidates_filter() As Collection '{{{
	Dim ValueCollection As New Collection
	Set targetColumnRange = InterSect(GetFilterRange, Columns(ActiveCell.Column))
	Set targetColumnRange = targetColumnRange.SpecialCells(xlCellTypeVisible)

	On Error Resume Next
		For Each c in targetColumnRange
			If c.Value <> "" Then
				Debug.Print c.Value
				ValueCollection.Add c.Value, Cstr(c.Value)
			End If
		Next c
	On Error GoTo 0

	Set GatherCandidates_filter = ValueCollection
End Function '}}}
Function defaultAction_filter(SelectionMerged As String) 'table�ɂ��������悢��'{{{
	Application.ScreenUpdating = False
	' If ActiveSheet.FilterMode Then
	' 	ActiveSheet.ShowAllData
	' End If
	GetFilterRange.AutoFilter field:= ActiveCell.Column - GetFilterRange.Column + 1, Criteria1:=Split(SelectionMerged, vbCrLf), Operator:=xlFilterValues
	Call gg()
	Call move_down()
End Function '}}}

'project
Function GatherCandidates_project() As Collection '{{{
	Dim ValueCollection As New Collection
	Set targetColumnRange = InterSect(GetFilterRange, Columns(GetFilterRange.Column))

	On Error Resume Next
		For Each c in targetColumnRange
			If c.Value <> "" Then
				ValueCollection.Add c.Value, Cstr(c.Value)
			End If
		Next c
	On Error GoTo 0

	Set GatherCandidates_project = ValueCollection
End Function '}}}
Function defaultAction_project(SelectionMerged As String) 'table�ɂ��������悢��'{{{
	Application.ScreenUpdating = False
	If ActiveSheet.FilterMode Then
		ActiveSheet.ShowAllData
	End If
	GetFilterRange.AutoFilter field:= GetFilterRange.Column, Criteria1:=Split(SelectionMerged, vbCrLf), Operator:=xlFilterValues
	Call gg()
	Call move_down()
End Function '}}}

'kind