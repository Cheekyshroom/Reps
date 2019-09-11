#!/usr/bin/env hy3
(import argparse
        [pathlib [Path]]
        [database [Database]]
        [wordlist [Words]]
        [trainer [Trainer]])

(defn slurp [filename]
  (with [f (open filename)]
    (return (.read f))))

(defmain [&rest _]
  (setv parser (argparse.ArgumentParser))
  (.add-argument parser "-n" :type int :default 6
    :help "Number of words to train per session.")
  (.add-argument parser "--flip" :dest "flip" :action "store_const"
    :const True :default False
    :help "Invert the questions and answers.")
  (.add-argument parser "--review" :dest "review" :action "store_const"
    :const True :default False
    :help "Review words you've already learned.")
  (.add-argument parser "-file" :type string :default None
    :help "Import a file.")
  (.add-argument parser "-list" :type string :default None
    :help "The list that you're going to import or train on.")
  (setv args (parser.parse-args))

  (setv db-filename (.format "{}/.reps.db" (str (Path.home))))
  (setv db (Database db-filename))
  (setv wl (Words db))

  (when args.file
    (print "Importing list from" args.file "into" args.list)
    (wl.import-words (slurp args.file) args.list))

  (setv trainer (Trainer wl))
  (try
    (trainer.train args.flip args.review (or args.list "%") args.n)
    (while (in (.lower (input "Would you like to train again? "))
              ["y" "yes" "yee" "yarp" "yea" "yeah" "yap" "duh" "si" "oui" "."])
      (trainer.train args.flip args.review (or args.list "%") args.n))
    (except [e EOFError]
      (print "Goodbye.")))


  (db.close))
