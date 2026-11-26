# Commands and keybindings

## zsh

| Command            | Description      |
| ------------------ | ---------------- |
| `set -o`           | List options     |
| `zle -al`          | List keybindings |

## fzf

| Keybinding             | Description                      |
| ---------------------- | -------------------------------- |
| `ctrl` + `t`           | List files and directories       |
| `option (right)` + `c` | List directories (`cd`: `enter`) |
| `ctrl` + `r`           | History                          |

---

arch: declarative package installation

custom command for commands and keybindings

---

MODES

Esc               ->    normal mode
i / a / o         ->    insert mode before cursor / after cursor / on a new line below
I / A / O         ->    insert mode at start of line / end of line / on a new line above
v / V / ctrl+v    ->    visual mode character / line / block
:                 ->    command-line mode


NAVIGATION

h / j / K / l       ->    move left / down / up / right
w / b / e           ->    jump forward to word start / backward to word start / to word end
0 / ^ / $           ->    jump to start of line / first non-blank character / end of line
gg / G / {line}G    ->    jump to top of file / bottom of file / go to a line
ctrl+d / ctrl+u     ->    scroll half a page down / up
ctrl+o / ctrl+i     ->    jump backward / forward in the jump list


EDITING, COPY & PASTE

dd / dw / D        ->    delete line / delete word / delete to the end of line
cc / cw / C        ->    change line / change word / change to end of line (enters inster mode)
yy / yw            ->    yank (copy) line / word
p / P              ->    paste after / before cursor
u / ctrl+r         ->    undo / redo
.                  ->    repeat last change
>> / <<            ->    indent / unindent line
ci" / di( / yiw    ->    change inside quotes / delete inside parentheses / yank inner word


SEARCH AND REPLACE

/ / ?            ->    search forward / backward
n / N            ->    next / previous search
* / #            ->    search forward / backward for word under cursor
:noh             ->    clear search highlight
:%s/old/new/g    ->    replace all occurrences in the file


FILES, WINDOWS & BUFFERS

:w / :q / :wq / :q!    ->    save / quit / save & quit / quit without saving
:e {file}              ->    open or edit a file
:sp / :vsp             ->    split window horizontally / vertically
ctrl+w + h/j/k/l       ->    move between split windows
:bn / :bp / :bd        ->    next buffer / previous buffer / close buffer