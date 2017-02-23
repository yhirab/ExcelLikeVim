VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "fileutility"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'---------------------------------------------------------------------------
Private m_fso As FileSystemObject
Private m_files As Collection

Property Get FSO() As FileSystemObject'{{{
    Set FSO = m_fso
End Property'}}}

Property Get Files() As Collection'{{{
    Set Files = m_files
End Property'}}}

' �����o�ϐ��̏�����'{{{
Private Sub Class_Initialize()
    Set m_fso = New FileSystemObject
    Set m_files = New Collection
End Sub'}}}

' �����o�ϐ��̉��'{{{
Private Sub Class_Terminate()
    Set m_fso = Nothing
    Set m_files = Nothing
End Sub'}}}

' �t�@�C���ꗗ���ċA�I�Ɏ擾����֐�
' �����F folder_path �擾����N�_�̃t�H���_
' �����F pattern �擾�Ώۂ̃p�^�[���i���K�\���j
Public Function getFileListRecursive(folder_path As String, Optional pattern As String = ".*") As FileUtil'{{{
	' �t�@�C���ꗗ�̌��ʊi�[�p
	Dim file_list_tmp As Collection
	' ���[�v�p�ϐ��̐錾
	Dim Folder As Variant
	Dim file_path As Variant
	Dim dir As Variant
	Set file_list_tmp = New Collection

	'�o�^�t�@�C���̐ݒ�
	Dim RE
	Set RE = CreateObject("VBScript.RegExp")
	RE.pattern = pattern
	RE.IgnoreCase = True

	' ���݃f�B���N�g�����̑S�t�@�C���̎擾
	For Each file_path In FSO.GetFolder(folder_path).Files
		buf = CStr(file_path)
		Debug.Print buf
		RE.test (buf)
		If RE.test(buf) Then
			' If file_path Like "*" & pattern & "*" Then
			DoEvents    ' �t���[�Y�h�~�p
			Call Files.Add(CStr(file_path))
		End If
	Next
	' �T�u�f�B���N�g���̍ċA
	For Each dir In FSO.GetFolder(folder_path).SubFolders
		Call getFileListRecursive(dir.Path, pattern)
	Next

	Set RE = Nothing
	Set getFileListRecursive = Me
End Function'}}}
