#!/bin/sh

sensors | awk '/Core/ {print substr ($3, 2, 2) " C"}' | tr '\n' ' '
