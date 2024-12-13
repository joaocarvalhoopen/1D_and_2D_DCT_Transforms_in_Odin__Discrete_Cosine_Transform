package dct_transform

import "core:fmt"
import "core:math"

// The len of side of the square matrix,
// can be 8 for 8x8 or 16 for 16x16. 
N :: 16


// Converts 2D coordinates to 1D coordinate.
c2d_to_1d :: #force_inline proc ( x     : int,
                                  y     : int,
                                  x_len : int  ) ->
                                  int {
    
    return y * x_len + x
}

CU_or_CV_0     : f64 = math.sqrt_f64( 1.0 / N )
CU_or_CV_other : f64 = math.sqrt_f64( 2.0 / N )


// In here we are using the 16x16 DCT.
// u is x and v is y.
dct_2d_16_by_16 :: proc ( input : [ ]f64, output : [ ]f64 ) {
    
    assert( len( input )  == N * N )
    assert( len( output ) == N * N )


    for v in 0 ..< N {        // v is y
 
        cv : f64

        if v == 0 {
            cv = CU_or_CV_0
        } else {
            cv = CU_or_CV_other
        }

        for u in 0 ..< N {    // u is x   <- So it's cache friendly.
            
            cu : f64

            // Compute normalization constants
            if u == 0 {
                cu = CU_or_CV_0
            } else {
                cu = CU_or_CV_other
            }
 
            sum : f64 = 0.0
            for y in 0 ..< N {
                for x in 0 ..< N {

                    index := c2d_to_1d( x, y, N )
                    sum += input[ index ] *
                        //   math.cos_f64( ( ( 2 * f64( x ) + 1 ) * f64( u ) * math.PI ) / ( 2 * N ) ) *
                        //   math.cos_f64( ( ( 2 * f64( y ) + 1 ) * f64( v ) * math.PI ) / ( 2 * N ) )

                        f64( math.cos_f32( ( ( 2 * f32( x ) + 1 ) * f32( u ) * math.PI ) / ( 2 * N ) ) ) *
                        f64( math.cos_f32( ( ( 2 * f32( y ) + 1 ) * f32( v ) * math.PI ) / ( 2 * N ) ) ) 

                        // f64( math.cos_f16( ( ( 2 * f16( x ) + 1 ) * f16( u ) * math.PI ) / ( 2 * N ) ) ) *
                        // f64( math.cos_f16( ( ( 2 * f16( y ) + 1 ) * f16( v ) * math.PI ) / ( 2 * N ) ) ) 

                }
            }
            index_2 := c2d_to_1d( u, v, N )
            output[ index_2 ] = cu * cv * sum
        }
    }
}

// In here we are using the 16x16 DCT.
// u is x and v is y.
inv_dct_2d_16_x_16 :: proc ( input : [ ]f64, output : [ ]f64 ) {
    
    assert( len( input )  == N * N )
    assert( len( output ) == N * N )


    for y in 0 ..< N {
        for x in 0 ..< N {

            sum : f64 = 0.0;
            for v in 0 ..< N {      // v is y
    
                cv : f64

                if v == 0 {
                    cv = CU_or_CV_0
                } else {
                    cv = CU_or_CV_other
                }
                    
                for u in 0 ..< N {   // u is x   <- So it's cache friendly.

                    cu : f64

                    // Compute normalization constants
                    if u == 0 {
                        cu = CU_or_CV_0
                    } else {
                        cu = CU_or_CV_other
                    }
         
                    index_1 := c2d_to_1d( u, v, N )
                    sum += cu * cv * input[ index_1 ] *
                        //   math.cos_f64( ( ( 2 * f64( x ) + 1 ) * f64( u ) * math.PI ) / ( 2 * N ) ) *
                        //   math.cos_f64( ( ( 2 * f64( y ) + 1 ) * f64( v ) * math.PI ) / ( 2 * N ) )

                        f64( math.cos_f32( ( ( 2 * f32( x ) + 1 ) * f32( u ) * math.PI ) / ( 2 * N ) ) ) *
                        f64( math.cos_f32( ( ( 2 * f32( y ) + 1 ) * f32( v ) * math.PI ) / ( 2 * N ) ) )

                        // f64( math.cos_f16( ( ( 2 * f16( x ) + 1 ) * f16( u ) * math.PI ) / ( 2 * N ) ) ) *
                        // f64( math.cos_f16( ( ( 2 * f16( y ) + 1 ) * f16( v ) * math.PI ) / ( 2 * N ) ) )
                }
            }

            index_2 := c2d_to_1d( x, y, N )
            output[ index_2 ] = sum
        }
    }
}

print_2d_slice :: proc ( slice_2d : [ ]f64 ) {
    
    for row in 0 ..< N {
        for col in 0 ..< N {

            index := c2d_to_1d( col, row, N )
            fmt.printf( "%.2f\t", slice_2d[ index ] )
        }

        fmt.printf("\n");
    }

}

test_dct_and_inv_dct :: proc (  ) {

    total_len := N * N

    input       := make( [ ]f64, total_len )
    dct_output  := make( [ ]f64, total_len )
    idct_output := make( [ ]f64, total_len )


    // Initialize the input array with test data
    for row in 0 ..< N {
        for col in 0 ..< N {
            
            index := c2d_to_1d( col, row, N )
            input[ index ] = f64( ( row + col ) % 16 )
        }
    }


    // Print the original image before DCT
    fmt.printfln( "Original Image before DCT:\n" )
    print_2d_slice( input )

    // Perform the 2D DCT
    dct_2d_16_by_16( input[ : ], dct_output[ : ] )

    // Print the DCT coefficients
    fmt.printfln( "\nDCT Coefficients:\n" )
    print_2d_slice( dct_output )

    // Perform the Inverse 2D DCT
    inv_dct_2d_16_x_16( dct_output[ : ], idct_output[ : ] )

    // Print the reconstructed image after Inverse DCT
    fmt.printfln( "\nReconstructed Image after IDCT:\n" )
    print_2d_slice( idct_output )

}



