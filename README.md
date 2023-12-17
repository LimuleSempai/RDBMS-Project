# RDBMS-Project

# Instruction and project structure

Find the instruction [here](project.pdf)

![Entity-Relationship Diagram (ERD) of the bank system (2)](https://github.com/LimuleSempai/RDBMS-Project/assets/125760323/2a8e18f8-1fc9-4055-bc28-9674fdde866d)

## How to run 

In order, run:
- model.sql
- triggers.sql
- monte_carlo.sql
- black_schole.sql
- client_stock_view.sql

look inside the test.sql file and put the right test at each step.

# Issues

## Issues encountered

How to get an array (solved 1)

Monte carlo, 1 row random appears in arrays (solved 2)

You can't enter an array in a variable in a loop. (solved 3)

Black schole, need extension for some functions (solved 4)

Show ERD in readme.md (solved 5)


## How we solved them

1. Just found how.

2. Create a full 0 array, and then replace values inside of it.

3. Loop that goes through each values to put them in variables.

4. Create my own.

5. Get it to PNG

## Known issues

Difference between sql and python for monte carlo implementation :
especially for randomness and calculation capacity (sql has more trouble with large amounts of data)

## Fails

# Credit
This Project was conducted by [CATEZ Benoît](https://github.com/LimuleSempai) and [ODIN Thomas](https://github.com/Todin13).


### Contribution : 
  #### ODIN Thomas : 
  - model.sql
  - necessay triggers (in triggers.sql)
  - monte_carlo.sql
  - test.sql
  - black_schole.sql (repair)
  - client_stock_view.sql

  #### CATEZ Benoît :
  - README.md
  - Entity relationship diagram (ERD)
  - black_schole.sql (not working)
  - triggers updates (in triggers.sql)
  - client_stock_view.sql
