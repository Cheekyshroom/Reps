(import random
        re
        time)

(defn shuffle [l]
  (random.sample l :k (len l)))

(defclass Trainer [object]
  [words None]

  (defn --init-- [self words]
    (setv self.words words))

  (defn train [self &optional flipped [l "%"] [n 6]]
    (setv total-correct 0)
    (setv total-trained 0)
    (setv training-words (self.words.next-trainable-words l))
    (setv distraction-words (self.words.next-distraction-words l (* n 3)))

    (when (or (= (len distraction-words) 0)
              (= (len training-words) 0))
      (print "No words found in list:" l)
      (raise (EOFError)))

    (setv training-sequence (shuffle (+ training-words
                                        training-words
                                        training-words)))

    (for [correct training-sequence]
      (setv choices (shuffle (+ (random.sample distraction-words :k 5) [correct])))

      (print (.format "What's the translation of: {}?"
             (.get correct (if flipped "translation" "word"))))
      (print (+ "\t" (.join "\n\t" (lfor e choices (.get e (if flipped "word" "translation"))))))

      (try
        (setv choice (input "> "))
        (except [e EOFError]
          (print "Quitting.")
          (break)))

      (assoc correct "last_seen" (int (time.time)))
      (assoc correct "times_seen" (inc (.get correct "times_seen")))
      (cond [(and (!= choice "")
                  (re.search choice (.get correct (if flipped "word" "translation")) :flags re.I))
              (print "CORRECT")
              (assoc correct "times_correct" (inc (.get correct "times_correct")))
              (setv total-correct (inc total-correct))]
            [True
              (print "INCORRECT, ANSWER WAS:" (.get correct (if flipped "word" "translation")))
              (assoc correct "times_incorrect" (inc (.get correct "times_incorrect")))])
      (when (>= (.get correct "times_correct") 3)
        (setv total-trained (inc total-trained)))
      (self.words.write correct))

    (print (.format "You got {} correct out of {}, and you finished training {} words."
                    total-correct
                    (len training-sequence)
                    total-trained))))
