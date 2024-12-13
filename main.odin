// 1D and 2D DCT transform.
// 
// This is a test program to test the 1D and 2D DCT transform 16x16.
// It contains a port of the 1D DCT transfome implemented with Lee Algorithm
// and the 2D DCT transform constructed from it.
// See the file and the repository for details.
// There is a second implementation of the 2D DCT transform that is considerably slower.
//
// Author of the Odin port : Joao Carvalho
// Date    : 2024.12.13
// License : MIT Open Source License
//
// Original code in C for the Lee Algorithm implementation of DCT transform:
//
// Fast Discrete Cosine Transform algoriothm
// by Nayuki Minase
// https://github.com/nayuki/Nayuki-web-published-code/blob/master/fast-discrete-cosine-transform-algorithms/fast-dct-lee.c
//
// Project Nayuki
// Fast discrete cosine transform algorithms
// https://www.nayuki.io/page/fast-discrete-cosine-transform-algorithms


package main

import "core:fmt"

import dct_transf        "./dct_transform"

import dct_transform_lee "./dct_transform_lee"

main :: proc () {    
    fmt.printfln( "Begin dct_despecle..." )

    // To test DCT_1 2D of 16x16 .
    // dct_transf.test_dct_and_inv_dct( )


    // To test DCT_2 2D of 16 .
    // dct_transform_lee.test_fast_dct_lee_transform( )

    // To test DCT_2 2D of 16x16 .
    dct_transform_lee.test_dct_of_a_16x16_block( )

    fmt.printfln( "\n...end dct_despeckle." )
}