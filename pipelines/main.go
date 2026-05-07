package main

import (
	"context"

	"dagger/ara-zsh/internal/dagger"
)

const (
	PythonVersion = "3.14"
)

type AraZsh struct{}

// Check sources
func (a *AraZsh) Check(
	ctx context.Context,
	// +defaultPath="/"
	source *dagger.Directory,
) error {
	var err error

	_, err = runner(source).
		WithExec([]string{"uvx", "black", ".", "--check"}).
		Sync(ctx)

	if err != nil {
		return err
	}

	_, err = runner(source).
		WithExec([]string{"uvx", "mypy", "."}).
		Sync(ctx)

	if err != nil {
		return err
	}

	_, err = runner(source).
		WithExec([]string{"shellcheck", "setup.sh"}).
		Sync(ctx)

	if err != nil {
		return err
	}

	return nil
}

func runner(source *dagger.Directory) *dagger.Container {
	return dag.
		Container().
		From("ghcr.io/astral-sh/uv:python"+PythonVersion+"-alpine").
		WithExec([]string{"apk", "update"}).
		WithExec([]string{"apk", "add", "--no-cache", "shellcheck"}).
		WithExec([]string{"uv", "tool", "install", "black"}).
		WithExec([]string{"uv", "tool", "install", "mypy"}).

		// Source
		WithDirectory("/src", source).
		WithWorkdir("/src")
}
