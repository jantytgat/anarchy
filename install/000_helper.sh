#!/usr/bin/env bash

print_gum_heading() {
    gum style --foreground "$1" "$2"
}

print_heading1() {
    print_gum_heading "#F54927" "$1"
    sleep 1
}

print_heading2() {
    print_gum_heading "#F5B027" "\t$1"
    sleep 1
}

print_heading3() {
    print_gum_heading "#27F5B0" "\t\t$1"
    sleep 1
}

print_item() {
    print_gum_heading "#276CF5" "\t\t\t-$1"
    sleep 1
}

print_start() {
    title="Anarchy Installation"
    gum style \
    --align center \
    --border double \
    --border-foreground "#0082c7" \
    --foreground "#F5276C" \
    --margin "1 2" \
    --padding "2 4" \
    --width 50 \
    "$title"
}