#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Ghostty basic
# @raycast.mode silent
# @raycast.icon 👻
# @raycast.packageName Ghostty

TMUX=/opt/homebrew/bin/tmux
YABAI=/opt/homebrew/bin/yabai

# [1] 确保 session basic 存在，含 4 个空窗口（仅首次创建）
if ! "$TMUX" has-session -t basic 2>/dev/null; then
    "$TMUX" new-session -d -s basic
    "$TMUX" new-window -t basic
    "$TMUX" new-window -t basic
    "$TMUX" new-window -t basic
fi

# [2] 当前聚焦的 space
cur=$("$YABAI" -m query --spaces --space | jq -r '.index')

# [3] 开/复用窗口并 attach basic
#   有窗口      → new window（不带 configuration，完整继承 config，含 font-thicken）
#   无窗口/冷启动 → activate 会自动开一个默认窗口，复用它，避免多出一个空窗口
#   两个分支都用 input text 注入命令，避免 surface configuration 重置字体设置
osascript <<'APPLESCRIPT'
set cmd to "/opt/homebrew/bin/tmux new-session -A -s basic"

-- 关键：记录 activate 之前是否已在运行（区分冷启动 vs 运行中）
set wasRunning to running of application "Ghostty"

tell application "Ghostty"
    activate
    if wasRunning then
        -- 已在运行（有无窗口都一样）：显式建新窗口，不依赖 activate 自动开窗
        set w to new window
        delay 0.3
        set t to focused terminal of selected tab of w
    else
        -- 冷启动：activate 会启动并自动开默认窗口，等它出现后复用，避免多出一个空窗口
        repeat 50 times
            if (count of windows) > 0 then exit repeat
            delay 0.1
        end repeat
        delay 0.3
        set t to focused terminal of selected tab of front window
    end if
    input text cmd to t
    send key "enter" to t
end tell
APPLESCRIPT

# [4] 不在 space 1 才把（此刻聚焦的）Ghostty 窗口移过去并切换
if [ "$cur" != "1" ]; then
    sleep 0.3
    win=$("$YABAI" -m query --windows --window 2>/dev/null)
    if [ "$(echo "$win" | jq -r '.app')" = "Ghostty" ]; then
        id=$(echo "$win" | jq -r '.id')
        "$YABAI" -m window "$id" --space 1
        "$YABAI" -m space --focus 1
    fi
fi
