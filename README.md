# Reps
A featureless command line spaced repetition program, it requires python3, and will install hy.

# To install
```
make install
```

Then use the example import `test-import.sql`, or create an import file in the form of:
```
"word", "translation"
...
```

And run:
```
reps -file <filename> -list <list name>
```
To import them.

You can invert the questions and answers with:
```
reps --flip
```

You can study specific lists
```
reps -list <a list>
```

You can review words, when you have some that you've trained.
```
reps --review
```

And give yourself more words per session with (the default is 6):
```
reps -n <amount of words>
```

# To use:
Just run
```
reps
```
And type in a case insensitive match for what you think the translation of your word is.

Expect an output like:
```
What's the translation of: Детрóйт?
  stove
  July
  journalist (female)
  everything
  probably
  Detroit
> detroit
CORRECT
What's the translation of: лимузин?
  we
  five
  everything
  grade school student (female)
  limousine
  to have lunch
> limo
CORRECT
What's the translation of: клиника?
  closet, walk-in closet, wardrobe
  closet
  Madison
  we
  clinic
  five
> clinic
CORRECT
What's the translation of: Детрóйт?
  everything
  key
  journalist (female)
  stove
  Detroit
  whose (m.)
> stove
INCORRECT, ANSWER WAS: Detroit
What's the translation of: певица?
  (indecl.) metro, subway
  key
  grade school student (female)
  stove
  Madison
  singer (female)
> Quitting.
You got 3 correct out of 18, and you finished training 0 words.
Would you like to train again? Goodbye.
```
