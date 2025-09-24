#!/usr/bin/env bash

print_gum_heading() {
    gum style --foreground $1 "$2"
}

print_heading1() {
    print_gum_heading "#00FF00" $1
    sleep 5
}

print_heading2() {
    print_gum_heading "#FFFF00" $1
    sleep 4
}

print_heading3() {
    print_gum_heading "00FFFF" $1
    sleep 3
}

print_item() {
    print_gum_heading "FF00FF" $1
    sleep 1
}

print_start() {
    title="Anarchy Installation"
    gum style \
    --align center \
    --border double \
    --border-foreground "#0082c7" \
    --foreground "#0082c7" \
    --margin "1 2" \
    --padding "2 4" \
    --width 50 \
    "$title"
}