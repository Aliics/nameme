# nameme
Random name generator, which should mostly be use for github branch names, if anything.
The main purpose of this is just to use all possible names on my system's dictionary
to solidly obtain a random name for things when I just keep drawing a blank.

# how to use
It's very basic, supply two optional arguments for `word_count(int)` and `casing(string)`.
The program will sort out which is which by it's type. By default it sets camelCase and 2 words.
> $ nameme CAMEL 5 #output ThereonProblemsToriesForelocksGleefully

This result will be piped straight into xclip. (A good linux clipboard tool.)
Also, executing the setup will chuck the shell script into your `/usr/bin` for easier access.

# cases
input	| example
--------|---|
camel	| thisIsLowerCamelCase
CAMEL	| ThisIsUpperCamelCase
snake	| this_is_lower_snake_case
SNAKE	| THIS_IS_UPPER_SNAKE_CASE
case	| thisislowercase
CASE	| THISISUPPERCASE
sentence| This is a lowercase sentence.
SENTENCE| THIS IS AN UPPERCASE SENTENCE!
