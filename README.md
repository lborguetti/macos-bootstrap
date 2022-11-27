# macos-workstation-bootstrap

![shellcheck](https://github.com/lborguetti/macos-workstation-bootstrap/actions/workflows/github-actions-shellcheck.yml/badge.svg)

Keeping in mind the KISS principle this few lines of code can be used
to create/setup an entire workspace without complexity. 

This is a idempotent script used to provision my entire developer environment.

Idempotent scripts can be called multiple times and each time it’s called, it will
have the same effects on the system.

To understand how to use this script I recommend you to read the code, after all, 
it's not good practice to run a script that you don't know.

Currently tested only in macOS Ventura 13+.

Note/Tip: before to start use this script you need to install [Homebrew](https://docs.brew.sh/Installation).
