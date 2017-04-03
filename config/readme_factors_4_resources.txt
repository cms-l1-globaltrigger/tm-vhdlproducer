There are three CSV files for the basic values of resources:
- resource_comb.csv
- resource_dist.csv
- resource_mass.csv ("mass_type" => 0 for 'invariant mass', 1 for 'transverse mass')

The values for "luts" and "processors" have to be multiplied by
a factor (in VHDL Producer):

1. Multiplication factor for values in resource_comb.csv:
factor = number of objects x number of requirements (value of column "req")

2. Multiplication factor for values in resource_dist.csv and resource_mass.csv:
2.1. if "object_1" and "object_2" are from same type and same bx:
factor = number of objects x (number of objects - 1) x 0.5

2.2. all others:
factor = number of objects "object_1" x number of objects "object_2" 

