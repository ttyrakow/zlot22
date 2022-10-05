Create and activate a Python 3 virtual environment.
Install all required packages from requirements.txt.
Copy the contents of vevnv's lib\site-packages
to the project's .\lib subdirectory (not the
site-packages itself, just its subdirectiories).
Unzip the Embeddable Python distribution into
the Delphi project's main directory (voicerec).
Add a line containing "lib" to python3xx._pth file
(xx = your specific python version, e.g. python310._pth).
Place official ffmpeg binaries in the voicerec Delphi
project directory (or put it somewhere in the 
system PATH - see whisper docs for details).
