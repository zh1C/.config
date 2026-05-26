#!/bin/zsh

echo "\033[33mStarting services...\033[0m"

launch_service() {
    local service=$1
    if ! command -v "$service" &>/dev/null; then
        echo "\033[31m$service not found, skipping.\033[0m"
        return 0
    fi
    if launchctl list | grep -q "$service" 2>/dev/null; then
        echo "\033[34mRestarting $service service.\033[0m"
        "$service" --restart-service
    else
        echo "\033[34mStarting $service service.\033[0m"
        "$service" --start-service
    fi
}

launch_service "yabai"
launch_service "skhd"

echo "\033[32mServices started.\033[0m"
