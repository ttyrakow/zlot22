unit PythonMinimal;
// Minimal Python interface to use OpenAI/Whisper in a Delphi app.

interface

const
  // set this constant to the Python DLL you wish to use
  PYTHON_DLL = 'python310.dll';

// Basic Python interop

type
  PyObject = Pointer;
  Py_ssize_t = NativeUInt;

// Initialization / finalization / modules
procedure Py_Initialize(); cdecl;
external PYTHON_DLL name 'Py_Initialize';

procedure Py_Finalize(); cdecl;
external PYTHON_DLL name 'Py_Finalize';

function PyImport_Import(name: PyObject): PyObject; cdecl;
external PYTHON_DLL name 'PyImport_Import';

function PyRun_SimpleString(const command: PAnsiChar): NativeInt; cdecl;
external PYTHON_DLL name 'PyRun_SimpleString';

// Refcount
procedure Py_IncRef(p: PyObject); cdecl;
external PYTHON_DLL name 'Py_IncRef';

procedure Py_DecRef(p: PyObject); cdecl;
external PYTHON_DLL name 'Py_DecRef';

// PyObject methods
function PyObject_GetAttrString(o: PyObject; attr_name: PAnsiChar): PyObject;
cdecl; external PYTHON_DLL name 'PyObject_GetAttrString';

function PyObject_Call(callable, args, kwargs: PyObject): PyObject; cdecl;
external PYTHON_DLL name 'PyObject_Call';

// Strings
function PyUnicode_FromString(const s: PAnsiChar): PyObject; cdecl;
external PYTHON_DLL name 'PyUnicode_FromString';

function PyUnicode_AsUTF8AndSize(unicode: PyObject; var size: Py_ssize_t): PAnsiChar; cdecl;
external PYTHON_DLL name 'PyUnicode_AsUTF8AndSize';

function PyUnicode_AsUTF8(unicode: PyObject): string;

// Tuples
function PyTuple_New(len: Py_ssize_t): PyObject; cdecl;
external PYTHON_DLL name 'PyTuple_New';

function PyTuple_SetItem(p: PyObject; pos: Py_ssize_t; o: PyObject): NativeInt;
cdecl; external PYTHON_DLL name 'PyTuple_SetItem';

// Dictionaries
function PyDict_GetItem(p, key: PyObject): PyObject; cdecl;
external PYTHON_DLL name 'PyDict_GetItem';

implementation
uses SysUtils, IOUtils, Winapi.Windows;

function PyUnicode_AsUTF8(unicode: PyObject): string;
begin
  var size: Py_ssize_t;
  Result := UTF8ToWideString(PyUnicode_AsUTF8AndSize(unicode, size));
end;

end.
