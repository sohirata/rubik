# rubik
It enumerates all 3,674,160 configurations of 2x2x2 Rubik's Cube by performing all possible turns in each step, thereby determining its God's number (the minimal number of turns to solve the Cube in any initial configuration; the diameter of the Cayley graph of the Rubik's Cube group) in various metrics. It also reports the frequency of the appearances of duplicate configurations and the numbers of the turns used to reach all configurations.

# how to compile
make

# how to run
2x2x2

# available metrics

## half-turn metric (God's number is 11)
R, D, B, R<sup>-1</sup>, D<sup>-1</sup>, B<sup>-1</sup>, R<sup>2</sup>, D<sup>2</sup>, B<sup>2</sup> in the Singmaster notation.

## quarter-turn metric (God's number is 14)
R, D, B, R<sup>-1</sup>, D<sup>-1</sup>, B<sup>-1</sup> in the Singmaster notation.

## semi-quarter-turn metric (God's number is 19)
R, D, B in the Singmaster notation.

## bi-quarter-turn metric (God's number is 10)
R, D, B, R<sup>-1</sup>, D<sup>-1</sup>, B<sup>-1</sup>, R<sup>2</sup>, D<sup>2</sup>, B<sup>2</sup>, RD, R<sup>-1</sup>D<sup>-1</sup>, DB, D<sup>-1</sup>B<sup>-1</sup>, BR, B<sup>-1</sup>R<sup>-1</sup> in the Singmaster notation.

# available algorithms

## bisection search in sorted list
The list of configurations is sorted and new configurations are rapidly compared against it by a bisection search.

## linear search in unsorted list
The list of configurations is unsorted and new configurations are compared sequentially.
