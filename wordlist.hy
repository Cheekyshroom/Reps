(import database)

(defclass Words [database.Table]
  [fields [
    (, "word" "text")
    (, "translation" "text")
    (, "last_seen" "int")
    (, "times_seen" "int")
    (, "times_correct" "int")
    (, "times_incorrect" "int")
    (, "comment" "text")
   ]
   table-name "words"]

  (defn next-trainable-words [self &optional [n 6]]
    (self.get "
where (times_seen < 6) or
      (abs(random() % 10) < 2)
order by last_seen + (random() % 500)
limit ?" (, n)))

  (defn next-distraction-words [self &optional [n 18]]
    (self.get "order by (random() % 69) limit ?" (, n )))

  (defn import-words [self words]
    (self.execute (.format "insert into words values {};"
                           (.join ",\n" (lfor w (.split words "\n")
                                          :if (!= w "")
                                          (.format "({}, 0, 0, 0, 0, \"\")" w))))))

  (defn export-words [self]
    (print (self.fetchall "select * from words;")))
  )
