#!/bin/bash
export GOOS=linux
go build -o bin\caddy2 cmd\caddy\main.go
export GOOS=windows
go build -o bin\caddy2.exe cmd\caddy\main.go
