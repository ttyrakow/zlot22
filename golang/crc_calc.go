package main

/*
#include <stdlib.h>
#include <stdint.h>
*/
import "C"

import (
	"crypto/sha512"
	"encoding/hex"
	"io"
	"os"
	"runtime/cgo"
	"sync"
	"unsafe"
)

func CalcFileSHA(path string) (string, error) {
	f, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer f.Close()

	sha := sha512.New()
	if _, err := io.Copy(sha, f); err != nil {
		return "", err
	}

	return hex.EncodeToString(sha.Sum(nil)), nil
}

func CalcFilesSHA(paths []string) []string {
	var wg sync.WaitGroup
	res := make([]string, len(paths))

	wg.Add(len(paths))
	for idx, path := range paths {
		go func(path string, index int) {
			defer wg.Done()
			sha, err := CalcFileSHA(path)
			if err != nil {
				sha = ""
			}
			res[index] = sha
		}(path, idx)
	}
	wg.Wait()
	return res
}

//export CalcFilesSHA_CGo
func CalcFilesSHA_CGo(paths []string) C.uintptr_t {
	shas := CalcFilesSHA(paths)
	return C.uintptr_t(cgo.NewHandle(shas))
}

//export NthString
func NthString(strs C.uintptr_t, n int) *C.char {
	h := cgo.Handle(strs)
	var s []string = h.Value().([]string)
	return C.CString(s[n])
}

//export C_Free
func C_Free(p unsafe.Pointer) {
	C.free(p)
}

//export DelHandle
func DelHandle(h C.uintptr_t) {
	cgo.Handle(h).Delete()
}

func main() {}
