# 1D and 2D DCT Transforms in Odin - Discrete Cosine Transform
Those are two simple implementations of the Discrete Cosine Transform.

# Description
In this repository, there is a dct_transform_lee directory that is a port from C to Odin of an MIT licensed discrete cosine transform that uses the fast Lee algorithm and the original can be found in the following file link: <br>

Fast Discrete Cosine Transform algoriothm <br>
by Nayuki Minase <br>
[https://github.com/nayuki/Nayuki-web-published-code/blob/master/fast-discrete-cosine-transform-algorithms/fast-dct-lee.c](https://github.com/nayuki/Nayuki-web-published-code/blob/master/fast-discrete-cosine-transform-algorithms/fast-dct-lee.c) <br>

<br>

from Project Nayuki <br>
Fast discrete cosine transform algorithms <br>
[https://www.nayuki.io/page/fast-discrete-cosine-transform-algorithms](https://www.nayuki.io/page/fast-discrete-cosine-transform-algorithms) <br>

<br>

Then, I added to that file the 2D transform 16x16, constructed from the 1D transform and the correction factors for the transform.
The other is a simple directed and slower implementation of the 2D Cosine Transform.
Both give the same exact values but the one that uses Lee Algorithm is significantly faster.

# License
MIT Open Source License

# Have fun
Best regards, <br>
Joao Carvalho <br>

