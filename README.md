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
reps -file <filename>
```
To import them.

You can invert the questions and answers with:
```
reps --flip
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
