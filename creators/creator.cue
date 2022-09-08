package creators

import (
	"github.com/hofstadter-io/hof/schema/common"
	"github.com/hofstadter-io/hof/schema/gen"
)

Creator: gen.#Generator & {
	@gen(creator)

	Outdir: "./"

	CreateMessage: {
	  let name = CreateInput.name
		Before: "Creating a new Go Cli"
		After: """
		Your new Cli generator is ready, run the following
		to generate the code, build the binary, and run \(name).

		now run 'make first'    (cd to the --outdir if used)
		"""
	}

	CreateInput: _
	CreatePrompt: [{
		Name:       "name"
		Type:       "input"
		Prompt:     "What is your CLI named"
		Required:   true
		Validation: common.NameLabel
	},{
		Name:       "repo"
		Type:       "input"
		Prompt:     "Git repository"
		Default:    "github.com/user/repo"
		Validation: common.NameLabel
	},{
		Name:       "about"
		Type:       "input"
		Prompt:     "Tell us a bit about it..."
		Required:   true
		Validation: common.NameLabel
	},{
		Name:       "updates"
		Type:       "confirm"
		Prompt:     "Enable self updating"
		Default:    true
	},{
		Name:       "telemetry"
		Type:       "confirm"
		Prompt:     "Enable telemetry"
	},{
		Name:       "releases"
		Type:       "confirm"
		Prompt:     "Enable GoReleaser tooling"
		Default:    true
	}]

	In: {
		CreateInput
		...
	}

	Out: [...gen.#File] & [ 
		// { TemplatePath: "debug",  Filepath: "debug.yaml" },
		for file in [
			"cue.mods",
			"cue.mod/module.cue",
			"cli.cue",
			"Makefile",
		]{ TemplatePath: file, Filepath: file }
	]

	gen.#SubdirTemplates & { #subdir: "creators" }

	EmbeddedTemplates: {
		debug: {
			Content: """
			{{ yaml . }}
			"""
		}
	}
}
