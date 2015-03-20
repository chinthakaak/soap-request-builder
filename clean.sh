#!/bin/bash
rm -rf requests/*
find scripts -type f -not \( -name '*.index' -or -name '*.xmin' \) -delete -print