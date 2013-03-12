// note this file only works in interactive mode

// use 'let' can create a value

let x = 1;;

let answerToEverything = 42UL;;
// primitive type: uint64

let pi = 3.1415M;;
// primitive type: decimal

let avogadro = 6.022e23;;
// primitive type: float

let hex, oct, bin = 0xFCAF, 0o7771L, 0b00101010y;;
// base 16, 8, 2

(hex, oct, bin)

// please refer to IEEE32/IEEE64
// LF for float
0x401E000000000000LF;;

// lf for float32
0x00000000lf;;

// might overflow
32767s + 1s;;
-32768s + -1s;;

// show me the bigint!
open System.Numerics

let megabyte = 1024I * 1024I;;
let zettabyte = megabyte * 1024I * 1024I * 1024I * 1024I * 1024I;;

// bitwise
0b1111 &&& 0b0011;; // 0b0011( 3)
0b1010 ||| 0b0111;; // 0b1111(15)
0b0011 ^^^ 0b0101;; // 0b0110( 6)

// left/right shift
2 <<< 10 ;; // 2048
2048 >>> 10 ;; // 2
0b1100 >>> 2 ;; // 3



#quit;;