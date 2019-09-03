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
    :help "Whether to invert the questions and answers.")
  (.add-argument parser "-file" :type string :default None
    :help "File to import.")
  (setv args (parser.parse-args))

  (setv db-filename (.format "{}/.reps.db" (str (Path.home))))
  (setv db (Database db-filename))
  (setv wl (Words db))

  (when args.file
    (print "Importing list from" args.file)
    (wl.import-words (slurp args.file)))

  (setv trainer (Trainer wl))
  (trainer.train args.flip args.n)
  (try
    (while (in (.lower (input "Would you like to train again? "))
              ["y" "yes" "yee" "yarp" "yea" "yeah" "yap" "duh" "si" "oui" "."])
      (trainer.train args.flip args.n))
    (except [e EOFError]
      (print "Goodbye.")))


  (db.close))
