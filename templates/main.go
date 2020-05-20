package main

import (
	"fmt"
	"os"

	{{ if .CLI.EnablePProf }}
	"log"
	"runtime/pprof"
	{{end}}

	"{{ .CLI.Package }}/cmd"
)

func main() {
	{{ if .CLI.EnablePProf }}
	if fn := os.Getenv("{{.CLI.CLI_NAME}}_CPU_PROFILE"); fn != "" {
		f, err := os.Create(fn)
		if err != nil {
			log.Fatal("Could not create file for CPU profile:", err)
		}
		defer f.Close()

		err = pprof.StartCPUProfile(f)
		if err != nil {
			log.Fatal("Could not start CPU profile process:", err)
		}

		defer pprof.StopCPUProfile()
	}
	{{ end }}

	cmd.RootInit()
	if err := cmd.RootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
}
