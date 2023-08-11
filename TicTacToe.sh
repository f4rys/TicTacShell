#!/usr/bin/bash

# Draws current board status
drawBoard(){
    echo "     1   2   3"
    echo "   ═════════════"
    echo "A  ║ ${firstRow[0]} ║ ${firstRow[1]} ║ ${firstRow[2]} ║"
    echo "   ═════════════"
    echo "B  ║ ${secondRow[0]} ║ ${secondRow[1]} ║ ${secondRow[2]} ║"
    echo "   ═════════════"
    echo "C  ║ ${thirdRow[0]} ║ ${thirdRow[1]} ║ ${thirdRow[2]} ║"
    echo "   ═════════════"
}

# Reads user input for current move
userMove(){
    read -r -p "Enter move (eg. A3 or C1): " move
}

# Makes random move
botMove(){
    row=(ABC)
    column=(123)
    move=${row:$(shuf -i 0-$((${#row}-1)) -n1):1}${column:$(shuf -i 0-$((${#column}-1)) -n1):1}
}

# Overwrites board with current move
makeMove(){
    if [ "${move:0:1}" = "A" ] || [ "${move:0:1}" = "a" ]
    then
        firstRow[${move:1:1}-1]="$1"
    fi

    if [ "${move:0:1}" = "B" ] || [ "${move:0:1}" = "b" ]
    then
        secondRow[${move:1:1}-1]="$1"
    fi

    if [ "${move:0:1}" = "C" ] || [ "${move:0:1}" = "c" ]
    then
        thirdRow[${move:1:1}-1]="$1"
    fi
}

# Checks if there are any empty spaces on board left
emptySpaces(){
    hasEmptySpaces=0
    token=⠀

    for i in 0 1 2
    do
        if [ "${firstRow[$i]}" = "$token" ] || [ "${secondRow[$i]}" = "$token" ] ||  [ "${thirdRow[$i]}" = "$token" ]
        then
            hasEmptySpaces=1
        fi
    done
}

# Checks if currently chosen move is available
fieldEmpty(){
    isFieldEmpty=0
    token=⠀

    if [ "${move:0:1}" = "A" ] || [ "${move:0:1}" = "a" ]
    then
        if [ "${firstRow[${move:1:1}-1]}" = "$token" ]
        then
            isFieldEmpty=1
        fi
    fi

    if [ "${move:0:1}" = "B" ] || [ "${move:0:1}" = "b" ]
    then
        if [ "${secondRow[${move:1:1}-1]}" = "$token" ]
        then
            isFieldEmpty=1
        fi
    fi

    if [ "${move:0:1}" = "C" ] || [ "${move:0:1}" = "c" ]
    then
        if [ "${thirdRow[${move:1:1}-1]}" = "$token" ]
        then
            isFieldEmpty=1
        fi
    fi
}

# Computer tries to make a move by choosing random space on board, then tries again if it is already occupied
botLoop(){
    botMove
    fieldEmpty
    if [ $isFieldEmpty = 1 ]
    then
        makeMove "O"
    else
        botLoop
    fi
}

# User tries to make a move by entering move via prompt, then tries again if it is already occupied or out of range
userLoop(){
    userMove
    fieldEmpty
    if [ $isFieldEmpty = 1 ]
    then
        makeMove "X"
    else
        echo "Illegal move! Try again"
        userLoop
    fi
}

# Checks if either user or computer have already won
isWon(){
    if  [[ "${firstRow[0]}" = "$1" && "${firstRow[1]}" = "$1" && "${firstRow[2]}" = "$1" ]]  ||
        [[ "${secondRow[0]}" = "$1" && "${secondRow[1]}" = "$1" && "${secondRow[2]}" = "$1" ]]  ||
        [[ "${thirdRow[0]}" = "$1" && "${thirdRow[1]}" = "$1" && "${thirdRow[2]}" = "$1" ]]  ||

        [[ "${firstRow[0]}" = "$1" && "${secondRow[0]}" = "$1" && "${thirdRow[0]}" = "$1" ]]  ||
        [[ "${firstRow[1]}" = "$1" && "${secondRow[1]}" = "$1" && "${thirdRow[1]}" = "$1" ]]  ||
        [[ "${firstRow[2]}" = "$1" && "${secondRow[2]}" = "$1" && "${thirdRow[2]}" = "$1" ]] ||

        [[ "${firstRow[0]}" = "$1" && "${secondRow[1]}" = "$1" && "${thirdRow[2]}" = "$1" ]]  ||
        [[ "${firstRow[2]}" = "$1" && "${secondRow[1]}" = "$1" && "${thirdRow[0]}" = "$1" ]]
    then
        won=1
    fi
}

# Declaring board
firstRow=(⠀ ⠀ ⠀)
secondRow=(⠀ ⠀ ⠀)
thirdRow=(⠀ ⠀ ⠀)

# Declaring variables in their initial state
move=""
hasEmptySpaces=1
isFieldEmpty=1
won=0

# Drawing empty board once at the beginning of the game
drawBoard

while [ $hasEmptySpaces = 1 ]
do
    # User makes his move
    userLoop
    emptySpaces

    # Computer makes next move if there are empty spaces left
    if [ $hasEmptySpaces = 1 ]
    then
        botLoop
    fi

    drawBoard

    # Checks if user won
    isWon "X"
    if [ $won = 1 ]
    then
        echo "User won!"
        break
    fi

    # Checks if computer won
    isWon "O"
    if [ $won = 1 ]
    then
        echo "Computer won!"
        break
    fi

    # Checks if the result of the game is draw
    emptySpaces
    if [ $hasEmptySpaces = 0 ] && [ $won = 0 ]
    then
        echo "Draw!"
        break
    fi
done