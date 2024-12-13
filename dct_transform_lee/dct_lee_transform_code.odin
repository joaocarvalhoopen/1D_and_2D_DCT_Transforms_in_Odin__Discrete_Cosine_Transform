// This file has MIT license and is port of source code implementation:
//
// Fast Discrete Cosine Transform algoriothm
// by Nayuki Minase
// https://github.com/nayuki/Nayuki-web-published-code/blob/master/fast-discrete-cosine-transform-algorithms/fast-dct-lee.c
//
// Project Nayuki
// Fast discrete cosine transform algorithms
// https://www.nayuki.io/page/fast-discrete-cosine-transform-algorithms
//


// The original source code has MIT license, so this file has MIT license too.

/* 
 * Fast discrete cosine transform algorithms (C)
 * 
 * Copyright (c) 2021 Project Nayuki. (MIT License)
 * https://www.nayuki.io/page/fast-discrete-cosine-transform-algorithms
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

package dct_transform_lee

import "core:fmt"
import "core:math"

import dct_transform "./../dct_transform"

BLOCK_SIDE_LEN : int : 16

DCT_DIRECTION :: enum {

    DCT_FORWARD,
    DCT_INVERSE
} 

test_fast_dct_lee_transform :: proc ( ) {
    
    fmt.println( "Begin test the fast dct function..." ) 
 

    len_vec : int = 16

    vector : [ ]f64 = { 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0,
                        8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0 }
    
    vector_clone : [ ]f64 = make( [ ]f64, len_vec )
    
    for i in 0 ..< len_vec {
        vector_clone[ i ] = vector[ i ]
    }


    vector_tmp : [ ]f64 = make( [ ]f64, len_vec )

    // Call the DCT function.
    fast_dct_lee_transform( vector_clone, vector_tmp, len_vec )

    // Print the dct_value.
    for i in 0 ..< len_vec {
        fmt.printfln( "vector_clone[ %d ] = %f",
                      i, vector_clone[ i ] )
    }

    // To make the values 
    normalization_scale_after_forward_dct_transform( vector_clone )
 
    // Print the dct_value.
    for i in 0 ..< len_vec {
        fmt.printfln( "vector_clone_after[ %d ] = %f",
                  i, vector_clone[ i ] )
    }

    inv_normalization_scale_before_inverse_dct_transform( vector_clone )

    // Print the dct_value.
    for i in 0 ..< len_vec {
        fmt.printfln( "vector_clone_before[ %d ] = %f",
                      i, vector_clone[ i ] )
    }
    

    // Call the inverse DCT function.
    fast_inverse_dct_lee_transform( vector_clone, vector_tmp, len_vec )

    // Calculates the scale inverse DCT transform.
    // scale_inverse_dct_transform( vector_clone )

    // Compare the values.
    for i in 0 ..< len_vec {
        fmt.printfln( "vector_original[ %d ] = %f vector_final[ %d ] = %f",
                      i, vector[ i ], i, vector_clone[ i ] )
    }

    fmt.println( "...End test the fast dct function." ) 
}

test_dct_of_a_16x16_block :: proc ( ) {

    N := BLOCK_SIDE_LEN

    total_len := N * N
    
    input       := make( [ ]f64, total_len )
    dct_output  := make( [ ]f64, total_len )
    idct_output := make( [ ]f64, total_len )

    input_2       := make( [ ]f64, total_len )
    dct_output_2  := make( [ ]f64, total_len )
    idct_output_2 := make( [ ]f64, total_len )


    // Initialize the input array with test data
    for row in 0 ..< N {
        for col in 0 ..< N {
            
            index := c2d_to_1d( col, row, N )
            input[ index ] = f64( ( row + col ) % 16 )
        }
    }

    // Copy the input to the input_2
    for i in 0 ..< total_len {
        input_2[ i ] = input[ i ]
    }

    // Print the original image before DCT
    fmt.printfln( "Original Image before DCT:\n" )
    print_2d_slice( input )

    // ------
    // Control DCT and inverse DCT.

    // Perform the 2D DCT
    dct_transform.dct_2d_16_by_16( input[ : ], dct_output[ : ] )

    // Perform the Inverse 2D DCT
    dct_transform.inv_dct_2d_16_x_16( dct_output[ : ], idct_output[ : ] )



    // ------
    // Test 2D DCT and inverse 2D DCT

    // Scratch pad temporary vectors for the 2D DCT_2.
    vector_16x16_tmp : [ ]f64 = make( [ ]f64, len( input_2 ) )
    vector_16_tmp    : [ ]f64 = make( [ ]f64, N )

    // Perform the 2D DCT transform of a 16x16 block.
    dct_of_a_16x16_block( input_2[ : ],
                          vector_16x16_tmp,
                          vector_16_tmp,
                          DCT_DIRECTION.DCT_FORWARD )

    // Copy the 2D block data to the dct_output_2 .
    for i in 0 ..< total_len {
        dct_output_2[ i ] = input_2[ i ]
    }

    // Perform the 2D DCT transform of a 16x16 block.
    dct_of_a_16x16_block( input_2[ : ],
                          vector_16x16_tmp,
                          vector_16_tmp,
                          DCT_DIRECTION.DCT_INVERSE )

    // Copy the 2D block data to the idct_output_2 .
    for i in 0 ..< total_len {
        idct_output_2[ i ] = input_2[ i ]
    }


    // ----------
    // Print the results.

    // Print the DCT_1 coefficients
    fmt.printfln( "\nDCT Coefficients_1:\n" )
    print_2d_slice( dct_output )

    // Print the DCT_2 coefficients
    fmt.printfln( "\nDCT Coefficients_2:\n" )
    print_2d_slice( dct_output_2 )

    // Print the reconstructed image after Inverse DCT_1
    fmt.printfln( "\nReconstructed Image after IDCT_1:\n" )
    print_2d_slice( idct_output )

    // Print the reconstructed image after Inverse DCT_2
    fmt.printfln( "\nReconstructed Image after IDCT_2 :\n" )
    print_2d_slice( idct_output_2 )

}

// Convert 2D coordinates to 1D coordinates.
c2d_to_1d :: #force_inline proc ( x     : int,
                                  y     : int,
                                  len_x : int ) -> 
                                ( index : int ) {

    return y * len_x + x
}

print_2d_slice :: proc ( slice_2d : [ ]f64 ) {

    N := BLOCK_SIDE_LEN

    for row in 0 ..< N {
        for col in 0 ..< N {

            index := c2d_to_1d( col, row, N )
            fmt.printf( "%.2f\t", slice_2d[ index ] )
        }

        fmt.printf("\n");
    }

}

// Apply a 2D dct transform or it's inverse to a 16x16 block.
// The dct is applyed in place, that is in the original block.
// 
// Parameters:
//     block_16x16     : The 16x16 block to apply the dct or
//                       inverse dct.
//
//     block_16x16_tmp : The temporary 16x16 block has a scratch
//                       pad for the transposes.
//
//     vec_tmp_16      : The temporary vector has a scratch pad
//                       for the 1D dct and inverse transpose.
//
//     direction       : The direction of the dct, forward or
//                       inverse.
//
dct_of_a_16x16_block :: proc ( block_16x16     : []f64,
                               block_16x16_tmp : []f64,
                               vec_tmp_16      : []f64,
                               direction       : DCT_DIRECTION ) {


    apply_1d_dct_transform_to_each_row :: #force_inline proc ( 
                                    block_16x16 : []f64,
                                    vec_tmp_16  : []f64,
                                    direction   : DCT_DIRECTION ) {

        // For each row apply the 1D dct transform.
        for row in 0 ..< BLOCK_SIDE_LEN {
            
            start_index :=  row * BLOCK_SIDE_LEN
            end_index   :=  ( row + 1 ) * BLOCK_SIDE_LEN
            if direction == DCT_DIRECTION.DCT_FORWARD {

                fast_dct_lee_transform( block_16x16[ start_index : end_index],
                                        vec_tmp_16,
                                        BLOCK_SIDE_LEN )

                normalization_scale_after_forward_dct_transform(
                        block_16x16[ start_index : end_index ] )
        
            } else {

                inv_normalization_scale_before_inverse_dct_transform(
                        block_16x16[ start_index : end_index ] )

                fast_inverse_dct_lee_transform( block_16x16[ start_index : end_index],
                                                vec_tmp_16,
                                                BLOCK_SIDE_LEN )

            }
        }

    }

    transpose_the_16x16_block :: proc ( block_16x16_from : []f64,
                                        block_16x16_to   : []f64  ) {

        // Transpose the matrix.
        for row in 0 ..< BLOCK_SIDE_LEN {
            
            for column in 0 ..< BLOCK_SIDE_LEN {

                // 2D coordinates to 1D coordinates.
                from_index := row    * BLOCK_SIDE_LEN + column
                to_index   := column * BLOCK_SIDE_LEN + row
                
                block_16x16_to[ to_index ] = block_16x16_from[ from_index ]
            }
        }
    }



    // For each row apply the 1D dct transform.
    apply_1d_dct_transform_to_each_row( block_16x16, vec_tmp_16, direction )

    // The transposition is to apply in the other axies, but with the same
    // dct function and in a cache friendly way.
    // Read from block_16x16 and write the transpose to block_16x16_tmp.
    transpose_the_16x16_block( block_16x16, block_16x16_tmp )

    // For each row apply the 1D dct transform.
    apply_1d_dct_transform_to_each_row( block_16x16_tmp, vec_tmp_16, direction )

    // This transposition is to restore the matrix to the original orientation
    // of rows and columns.
    // Read from block_16x16 and write the transpose to block_16x16_tmp.
    transpose_the_16x16_block( block_16x16_tmp, block_16x16 )
}

// DCT type II, unscaled. Algorithm by Byeong Gi Lee, 1984.
// See: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.118.3056&rep=rep1&type=pdf#page=34
fast_dct_lee_transform :: proc ( vector     : [ ]f64,
                                 vector_tmp : [ ]f64,
                                 len_vec    : int     ) ->
                               ( sucess : bool        ) {

	if len_vec <= 0 || (len_vec & (len_vec - 1)) != 0 {
		return false  // Length is not power of 2
    }

    // temp : [ ]f64 = make( [ ]f64, len_vec )
	// if temp == nil {
	// 	return false
    // }

	forward_transform( vector, vector_tmp, len_vec )
	
    // free(temp)
	return true
}

forward_transform :: proc ( vector  : [ ]f64,
                            temp    : [ ]f64,
                            len_vec : int     ) {
	if len_vec == 1 {
		return
    }
	halfLen : int = len_vec / 2
	for i in 0 ..< halfLen {

		x : f64 = vector[ i ]
		y : f64 = vector[ len_vec - 1 - i ]
		temp[ i ] = x + y

        // IMPORTANTE: F64
		temp[ i + halfLen ] = ( x - y ) / ( math.cos_f64( ( f64( i ) + 0.5 ) * math.PI / f64( len_vec ) ) * 2 )
        
        // IMPORTANTE: F32
        // temp[ i + halfLen ] = ( x - y ) /  f64( math.cos_f32( ( f32( i ) + 0.5 ) * math.PI / f32( len_vec ) ) * 2 )
	}
	forward_transform( temp, vector, halfLen )
	// forward_transform( & temp[ halfLen ], vector, halfLen )
    forward_transform( temp[ halfLen : ], vector, halfLen )
	for i in 0 ..< halfLen - 1 {

		vector[ i * 2 + 0 ] = temp[ i ]
		vector[ i * 2 + 1 ] = temp[ i + halfLen] + temp[ i + halfLen + 1 ]
	}
	vector[ len_vec - 2 ] = temp[ halfLen - 1 ]
	vector[ len_vec - 1 ] = temp[ len_vec - 1 ]
}

// DCT type III, unscaled. Algorithm by Byeong Gi Lee, 1984.
// See: https://www.nayuki.io/res/fast-discrete-cosine-transform-algorithms/lee-new-algo-discrete-cosine-transform.pdf
fast_inverse_dct_lee_transform :: proc ( vector     : [ ]f64,
                                         vector_tmp : [ ]f64,
                                         len_vec    : int     ) ->
                                       ( sucess : bool        ) {
	if len_vec <= 0 || ( len_vec & ( len_vec - 1 ) ) != 0 {
		return false  // Length is not power of 2
    }
		
    // double *temp = malloc(len * sizeof(double));
	// if (temp == NULL)
	//	return false;
	
    vector[ 0 ] /= 2

    inverse_transform( vector, vector_tmp, len_vec )
	
    // free(temp);

	return true
}

inverse_transform :: proc ( vector  : [ ]f64,
                            temp    : [ ]f64,
                            len_vec : int     ) {
	if len_vec == 1 {
		return
    }
	halfLen : int = len_vec / 2
	temp[ 0 ] = vector[ 0 ]
	temp[ halfLen ] = vector[ 1 ]
	for i in 1 ..< halfLen {

		temp[ i ] = vector[ i * 2 ]
		temp[ i + halfLen ] = vector[ i * 2 - 1 ] + vector[ i * 2 + 1 ]
	}
	inverse_transform( temp, vector, halfLen )
    // inverse_transform( &temp[halfLen], vector, halfLen);
	inverse_transform( temp[ halfLen : ], vector, halfLen )
	for i in 0 ..< halfLen {

		x : f64 = temp[ i ]
		
        // IMPORTANTE: F64
        y : f64 = temp[ i + halfLen ] / ( math.cos_f64( ( f64( i ) + 0.5 ) * math.PI / f64( len_vec ) ) * 2 )
		
        // IMPORTANTE: F32
        // y : f64 = temp[ i + halfLen ] / f64( math.cos_f32( ( f32( i ) + 0.5 ) * math.PI / f32( len_vec ) ) * 2 )

        vector[ i ] = x + y
		vector[ len_vec - 1 - i ] = x - y
	}
}


// Normalize the values after the forward DCT transform.
// Scalling factors.


// 4 * sqrt( 1 / ( 4 * N ) )
DCT_SCALLING_FACTOR_INDEX_ZERO         : f64 = 2.0 * math.sqrt_f64( 1 / ( 4.0 * f64( BLOCK_SIDE_LEN ) ) )
// 2 * sqrt( 1 / ( 2 * N ) )
DCT_SCALLING_FACTOR_INDEX_NON_ZERO     : f64 = 2.0 * math.sqrt_f64( 1 / ( 2.0 * f64( BLOCK_SIDE_LEN ) ) )


// Normalize the values after the forward DCT transform.
// Inverse scalling factors.
INV_DCT_SCALLING_FACTOR_INDEX_ZERO     : f64 = 1 / DCT_SCALLING_FACTOR_INDEX_ZERO

INV_DCT_SCALLING_FACTOR_INDEX_NON_ZERO : f64 = 1 / DCT_SCALLING_FACTOR_INDEX_NON_ZERO

// Normalize the return values after the inverse DCT transform, but that can also
// be applyed before the inverse DCT transform.
INV_internal_DCT_SCALLING_FACTOR_all_indexes : f64 = 1.0 / ( f64( BLOCK_SIDE_LEN ) / 2.0 )


normalization_scale_after_forward_dct_transform :: #force_inline proc ( vector  : [ ]f64 ) {
  
    vector[ 0 ] *= DCT_SCALLING_FACTOR_INDEX_ZERO
    for i in 1 ..< len( vector ) {

        vector[ i ] *= DCT_SCALLING_FACTOR_INDEX_NON_ZERO
    }
}

inv_normalization_scale_before_inverse_dct_transform :: #force_inline proc ( vector  : [ ]f64 ) {

    vector[ 0 ] *= INV_DCT_SCALLING_FACTOR_INDEX_ZERO
    for i in 1 ..< len( vector ) {

        vector[ i ] *= INV_DCT_SCALLING_FACTOR_INDEX_NON_ZERO
    }
    
    // This function call is here to make the result of the inverse DCT with the values scalled,
    // to be the same as the original values, before the forward.
    // Much care was made to make the inverse DCT to be the same as the original values for the
    // Lee DCT algorithm. And to make the forward DCT present the scalled values of the Python version,
    // that exists in SciPy, ORTHO NORMALIZED.
    scale_inverse_dct_transform( vector )
}

scale_inverse_dct_transform :: #force_inline proc ( vector  : [ ]f64 ) {

    for i in 0 ..< len( vector ) {

        vector[ i ] *= INV_internal_DCT_SCALLING_FACTOR_all_indexes
    }
}



