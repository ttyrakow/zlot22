go build -buildmode=c-shared -o crc_calc.dll crc_calc.go
copy /B /Y crc_calc.dll sha512
