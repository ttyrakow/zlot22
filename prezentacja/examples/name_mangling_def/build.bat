cl /c lib.cpp
link lib.obj /dll /def:lib.def /out:lib.dll
dumpbin /EXPORTS lib.dll
