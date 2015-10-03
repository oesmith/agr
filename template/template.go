package template

import (
	"flag"
	"html/template"
	"log"
	"os"
	"os/signal"
	"path"
	"syscall"
)

var templatePath = flag.String("templates", "template", "Template path")
var T *template.Template

func loadTemplates() {
	c := make(chan os.Signal, 1)
	signal.Notify(c, syscall.SIGHUP)
	for {
		t := template.New("tmpl")
		t, err := t.ParseGlob(path.Join(*templatePath, "**/*.html"))
		if err != nil {
			log.Print(err)
		} else {
			T = t
			log.Print("Reloaded templates")
		}
		// Pause until the next signal.
		_ = <-c
	}
}

func init() {
	go loadTemplates()
}
