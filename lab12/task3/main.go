package main

import (
	"fmt"
	"runtime"
)

func main() {
	if runtime.GOOS == "windows" {
		fmt.Println("Hello from Windows!")
	} else if runtime.GOOS == "linux" {
		fmt.Println("Hello from Linux!")
	} else {
		fmt.Println("Goodbye you Mac user")
	}
}
