(import random
        re
        time)

(setv CORRECT-INTERVAL-MULTIPLIER 1.7)
(setv CORRECT-INTERVAL-STEP 1800)
(setv INCORRECT-INTERVAL-MULTIPLIER 0.8)

(defn shuffle [l]
  (random.sample l :k (len l)))

(defclass Trainer [object]
  [words None]

  (defn --init-- [self words]
    (setv self.words words))

  (defn training-session [self training-sequence distraction-words flipped]
    (setv total-correct 0)
    (setv index (if flipped "translation" "word"))
    (setv answer-index (if flipped "word" "translation"))
    (setv session-data {})
    (for [word training-sequence]
      (unless (.get session-data (.get word index) None)
        (assoc session-data (.get word index) {
          'times-shifted 0
          'word word
        })))

    (for [correct training-sequence]
      (setv choices (shuffle (+ (random.sample distraction-words :k 5) [correct])))

      (print (.format "What's the translation of: {}?"
             (.get correct index)))
      (print (+ "\t" (.join "\n\t" (lfor e choices (.get e answer-index)))))

      (try
        (setv choice (input "> "))
        (except [e EOFError]
          (print "Quitting.")
          (break)))

      (assoc correct "last_seen" (int (time.time))
                     "times_seen" (inc (.get correct "times_seen")))

      (cond [(and (!= choice "")
                  (re.search choice (.get correct answer-index) :flags re.I))
              (print "CORRECT")

              (as-> (.get session-data (.get correct index)) session
                    (when (< (.get session 'times-shifted) 1)
                      (assoc correct "learning_interval" (* (+ (.get correct "learning_interval")
                                                               CORRECT-INTERVAL-STEP)
                                                            CORRECT-INTERVAL-MULTIPLIER))
                      (assoc session 'times-shifted (inc (.get session 'times-shifted)))))

              (assoc correct "times_correct" (inc (.get correct "times_correct")))
              (setv total-correct (inc total-correct))]
            [True
              (print "INCORRECT, ANSWER WAS:" (.get correct answer-index))
              (assoc correct "learning_interval" (* (.get correct "learning_interval")
                                                    INCORRECT-INTERVAL-MULTIPLIER)
                             "times_incorrect" (inc (.get correct "times_incorrect")))])
      (self.words.write correct))

    (setv total-trained (len (list (filter (fn [e] (>= (.get e "times_correct") 3))
                                           (map (fn [e] (.get e 'word))
                                                (.values session-data))))))

    (print (.format "You got {} correct out of {}, and you finished training {} words."
                    total-correct
                    (len training-sequence)
                    total-trained)))

  (defn train [self &optional flipped review [l "%"] [n 6]]
    (setv review-words (self.words.next-reviewable-words l))
    (setv training-words (self.words.next-trainable-words l))
    (setv distraction-words (self.words.next-distraction-words l (* n 3)))

    (when (or (= (len distraction-words) 0)
              (= (len training-words) 0))
      (print "No words found in list:" l)
      (raise (EOFError)))

    (setv training-sequence (shuffle (if (or (> (len review-words) 10)
                                             review)
                                         review-words
                                         (+ training-words
                                            training-words
                                            training-words))))

    (self.training-session training-sequence distraction-words flipped)))

