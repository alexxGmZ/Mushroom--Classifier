# Mushroom classifier using Naive Bayes classifier

This is a lua program to classify whether a mushroom is edible or poisonous using
Naive Bayes Classifier

**Dependencies:**

* Lua Interpreter
* Luarocks (Lua's Package Manager)
* inspect (Install from Luarocks)

<br>

## How to use the program

The main script is the "script.lua." To execute the script just type

```bash
lua script.lua
```

### Input

Enter the input data inside the "input.csv" without the column/header names
with these columns/headers as a guide:

```csv
CAPSHAPE
SURFACE
COLOR
BRUISES
ODOR
GILL-ATTACHMENT
GILL-SPACING
GILL-SIZE
GILL-COLOR
STALK-SHAPE
STALK-ROOT
STALK-SURFACE-ABOVE-RING
STALK-SURFACE-BELOW-RING
STALK-COLOR ABOVE-RING
STALK-COLOR-BELOW-RING
VEIL-TYPE
VEIL-COLOR
RING-NUMBER
RING-TYPE
SPORE-PRINT-COLOR
POPULATION
HABITAT
```

For Example:

```csv
convex,smooth,brown,yes,pungent,free,close,narrow,black,enlarging,equal,smooth,smooth,white,white,partial,white,one,pendant,black,scattered,urban
convex,smooth,yellow,yes,almond,free,close,broad,black,enlarging,club,smooth,smooth,white,white,partial,white,one,pendant,brown,numerous,grasses
bell,smooth,white,yes,anise,free,close,broad,brown,enlarging,club,smooth,smooth,white,white,partial,white,one,pendant,brown,numerous,meadows
convex,scaly,white,yes,pungent,free,close,narrow,brown,enlarging,equal,smooth,smooth,white,white,partial,white,one,pendant,black,scattered,urban
convex,smooth,gray,no,none,free,crowded,broad,black,tapering,equal,smooth,smooth,white,white,partial,white,one,evanescent,brown,abundant,grasses
convex,scaly,yellow,yes,almond,free,close,broad,brown,enlarging,club,smooth,smooth,white,white,partial,white,one,pendant,black,numerous,grasses
bell,smooth,white,yes,almond,free,close,broad,gray,enlarging,club,smooth,smooth,white,white,partial,white,one,pendant,black,numerous,meadows
bell,scaly,white,yes,anise,free,close,broad,brown,enlarging,club,smooth,smooth,white,white,partial,white,one,pendant,brown,scattered,meadows
convex,scaly,white,yes,pungent,free,close,narrow,pink,enlarging,equal,smooth,smooth,white,white,partial,white,one,pendant,black,several,grasses
bell,smooth,yellow,yes,almond,free,close,broad,gray,enlarging,club,smooth,smooth,white,white,partial,white,one,pendant,black,scattered,meadows
```

The difference between the MushroomCSV.csv and the input.csv is that input.csv has
no CLASS column/header

<br>

### Table

When the program is executed the "likelihoods" table variable will be written inside the
"table.log" file, this will serve as a reference. The numbers can change depending on the
size of the training/historical data

Contentss of table.log
```log
{
    [column-name] = {
        edible = {
            edible probability base on attributes
        },
        poisonous = {
            poisonous probability base on attributes
        },
    }
},
```

For Example:
```log
["RING-TYPE"] = {
    edible = {
        evanescent = 0.23954372623574,
        flaring = 0.011406844106464,
        pendant = 0.74904942965779
    },
    poisonous = {
        evanescent = 0.4514811031665,
        large = 0.33094994892748,
        none = 0.0091930541368744,
        pendant = 0.20837589376915
    }
},
["SPORE-PRINT-COLOR"] = {
    edible = {
        black = 0.39163498098859,
        brown = 0.41444866920152,
        buff = 0.011406844106464,
        chocolate = 0.011406844106464,
        orange = 0.011406844106464,
        purple = 0.011406844106464,
        white = 0.13688212927757,
        yellow = 0.011406844106464
    },
    poisonous = {
        black = 0.057201225740552,
        brown = 0.057201225740552,
        chocolate = 0.40449438202247,
        green = 0.018386108273749,
        white = 0.46271705822268
    }
},
```

<br>

### Output

The output is displayed in the terminal and inside the result.log file.

Contents of result.log file
```blog
[test case number] INPUT: [line inputs from input.csv]
[test case number] EDIBLE PROBABILITY: [computed edible probability]
[test case number] POISONOUS PROBABILITY: [computed poisonous probability]
[test case number] CLASS: [final classification]
```

For Example:
```log
1 INPUT: convex, smooth, brown, yes, pungent, free, close, narrow, black, enlarging, equal, smooth, smooth, white, white, partial, white, one, pendant, black, scattered, urban
1 EDIBLE PROBABILITY: 1.3223715619603e-12
1 POISONOUS PROBABILITY: 1.2756050992962e-13
1 CLASS: edible

2 INPUT: convex, smooth, yellow, yes, almond, free, close, broad, black, enlarging, club, smooth, smooth, white, white, partial, white, one, pendant, brown, numerous, grasses
2 EDIBLE PROBABILITY: 2.2635937728416e-09
2 POISONOUS PROBABILITY: 4.8665818594419e-18
2 CLASS: edible

3 INPUT: bell, smooth, white, yes, anise, free, close, broad, brown, enlarging, club, smooth, smooth, white, white, partial, white, one, pendant, brown, numerous, meadows
3 EDIBLE PROBABILITY: 4.1804027509847e-10
3 POISONOUS PROBABILITY: 5.5445581030416e-21
3 CLASS: edible

4 INPUT: convex, scaly, white, yes, pungent, free, close, narrow, brown, enlarging, equal, smooth, smooth, white, white, partial, white, one, pendant, black, scattered, urban
4 EDIBLE PROBABILITY: 2.694499711715e-12
4 POISONOUS PROBABILITY: 8.63015614588e-14
4 CLASS: edible

5 INPUT: convex, smooth, gray, no, none, free, crowded, broad, black, tapering, equal, smooth, smooth, white, white, partial, white, one, evanescent, brown, abundant, grasses
5 EDIBLE PROBABILITY: 8.7268423270241e-09
5 POISONOUS PROBABILITY: 3.725407224109e-16
5 CLASS: edible
```

A csv file will be also generated named "output.csv" with the final classification

For Example:
```csv
convex, smooth, brown, yes, pungent, free, close, narrow, black, enlarging, equal, smooth, smooth, white, white, partial, white, one, pendant, black, scattered, urban, edible
convex, smooth, yellow, yes, almond, free, close, broad, black, enlarging, club, smooth, smooth, white, white, partial, white, one, pendant, brown, numerous, grasses, edible
bell, smooth, white, yes, anise, free, close, broad, brown, enlarging, club, smooth, smooth, white, white, partial, white, one, pendant, brown, numerous, meadows, edible
convex, scaly, white, yes, pungent, free, close, narrow, brown, enlarging, equal, smooth, smooth, white, white, partial, white, one, pendant, black, scattered, urban, edible
convex, smooth, gray, no, none, free, crowded, broad, black, tapering, equal, smooth, smooth, white, white, partial, white, one, evanescent, brown, abundant, grasses, edible
convex, scaly, yellow, yes, almond, free, close, broad, brown, enlarging, club, smooth, smooth, white, white, partial, white, one, pendant, black, numerous, grasses, edible
bell, smooth, white, yes, almond, free, close, broad, gray, enlarging, club, smooth, smooth, white, white, partial, white, one, pendant, black, numerous, meadows, edible
bell, scaly, white, yes, anise, free, close, broad, brown, enlarging, club, smooth, smooth, white, white, partial, white, one, pendant, brown, scattered, meadows, edible
```

<br>

> WARNING:
> Everytime the program is being executed the contents these files will be modified
> * table.log
> * result.log
> * output.csv
>
> So if you're serious about using this program as a classifier, make sure to backup these files

