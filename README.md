# rubik

# 2x2x2 Rubik's Cube

It enumerates all 3,674,160 configurations of 2x2x2 Rubik's Cube by performing all possible turns in each step, thereby determining its God's number (the minimal number of turns to solve the Cube in any initial configuration; the diameter of the Cayley graph of the Rubik's Cube group) in various metrics. It also reports the frequency of the appearances of duplicate configurations and the numbers of the turns used to reach all configurations.

## how to compile
cd rubik2x2x2
make

## how to run
2x2x2

## available metrics

### half-turn metric (God's number is 11)
R, D, B, R<sup>-1</sup>, D<sup>-1</sup>, B<sup>-1</sup>, R<sup>2</sup>, D<sup>2</sup>, B<sup>2</sup> in the Singmaster notation.

### quarter-turn metric (God's number is 14)
R, D, B, R<sup>-1</sup>, D<sup>-1</sup>, B<sup>-1</sup> in the Singmaster notation.

### semi-quarter-turn metric (God's number is 19)
R, D, B in the Singmaster notation.

### bi-quarter-turn metric (God's number is 10)
R, D, B, R<sup>-1</sup>, D<sup>-1</sup>, B<sup>-1</sup>, R<sup>2</sup>, D<sup>2</sup>, B<sup>2</sup>, RD, R<sup>-1</sup>D<sup>-1</sup>, DB, D<sup>-1</sup>B<sup>-1</sup>, BR, B<sup>-1</sup>R<sup>-1</sup> in the Singmaster notation.

## available algorithms

### bisection search in sorted list
The list of configurations is sorted and new configurations are rapidly compared against it by a bisection search.

### linear search in unsorted list
The list of configurations is unsorted and new configurations are compared sequentially.

# 3x3x3 Rubik's Cube

It enumerates unique configurations of 3x3x3 Rubik's Cube by performing all possible turns in each step, starting from the completely solved configuration. The numbers of unique configurations in the first few steps can be used to determine the branching ratio.

## how to compile
cd rubik3x3x3
make

## how to run
3x3x3

### half-turn metric (God's number is 20 according to Rikicki <i>et al.</i>, SIAM J. Discrete Math. <b>27</b>, 1082-1105 (2013))
R, D, B, L, U, F, R<sup>-1</sup>, D<sup>-1</sup>, B<sup>-1</sup>, L<sup>-1</sup>, U<sup>-1</sup>, F<sup>-1</sup>, R<sup>2</sup>, D<sup>2</sup>, B<sup>2</sup>, L<sup>2</sup>, U<sup>2</sup>, F<sup>2</sup> in the Singmaster notation.

### quarter-turn metric (God's number is 26 according to Rikicki <i>et al.</i>, SIAM J. Discrete Math. <b>27</b>, 1082-1105 (2013))
R, D, B, L, U, F, R<sup>-1</sup>, D<sup>-1</sup>, B<sup>-1</sup>, L<sup>-1</sup>, U<sup>-1</sup>, F<sup>-1</sup> in the Singmaster notation.

# 4x4x4 Rubik's Cube

It enumerates unique configurations of 4x4x4 Rubik's Cube by performing all possible turns in each step, starting from the completely solved configuration. The numbers of unique configurations in the first few steps can be used to determine the branching ratio.

## how to compile
cd rubik4x4x4
make

## how to run
4x4x4

### half-turn metric (God's number is unknown)
R1, R2, R3, D1, D2, D3, B1, B2, B3, R1<sup>-1</sup>, R2<sup>-1</sup>, R3<sup>-1</sup>, D1<sup>-1</sup>, D2<sup>-1</sup>, D3<sup>-1</sup>, B1<sup>-1</sup>, B2<sup>-1</sup>, B3<sup>-1</sup>, R1<sup>2</sup>, R2<sup>2</sup>, R3<sup>2</sup>, D1<sup>2</sup>, D2<sup>2</sup>, D3<sup>2</sup>, B1<sup>2</sup>, B2<sup>2</sup>, B3<sup>2</sup>.

### quarter-turn metric (God's number is unknown)
R1, R2, R3, D1, D2, D3, B1, B2, B3, R1<sup>-1</sup>, R2<sup>-1</sup>, R3<sup>-1</sup>, D1<sup>-1</sup>, D2<sup>-1</sup>, D3<sup>-1</sup>, B1<sup>-1</sup>, B2<sup>-1</sup>, B3<sup>-1</sup>.

