package main

import "testing"

func TestCalcFileSHA(t *testing.T) {
	sha, err := CalcFileSHA("test_files/file1.txt")
	valid_sha := "e3bcf148cf4aba61ad59042dcca53e018f685cdc009f5e9f239e6f83de6dcc4d8ef0c714721b596627b7d8f9e2edb6c093298f95589c47ba82e439e1ae519f41"
	if err == nil {
		if sha != valid_sha {
			t.Log("SHA-512 of file_01.bin is invalid")
			t.Log("got", sha)
			t.Log("expected", valid_sha)
			t.Fail()
		}
	} else {
		t.Log("SHA-512 of file_01.bin returned an error", err)
		t.Fail()
	}
}

func TestCalcFilesSHA(t *testing.T) {
	valid_shas := []string{
		"e3bcf148cf4aba61ad59042dcca53e018f685cdc009f5e9f239e6f83de6dcc4d8ef0c714721b596627b7d8f9e2edb6c093298f95589c47ba82e439e1ae519f41",
		"8434c713370e20d9001acb4f018d04e92705c89880fb9a316e38b395e1d4ef12fa0c24253300b36504cf8bddba79a5e213b55df607b81a4d25f3d7e4d4dab215",
	}
	paths := []string{"test_files/file1.txt", "test_files/file2.txt"}
	shas := CalcFilesSHA(paths)
	if len(shas) != 2 {
		t.Log("multi SHA-512 returned invalid slice length, got", len(shas), "expected 2")
		t.Fail()
	}
	for i, s := range shas {
		if s != valid_shas[i] {
			t.Log("multi SHA-512 returned wrong hash for", paths[i])
			t.Log("got", s)
			t.Log("expected", valid_shas[i])
			t.Fail()
		}
	}
}
