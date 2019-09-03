(import sqlite3)

(defclass Database [object]
  [db None
   c None]
    
  (defn --init-- [self filename]
    (setv self.db (sqlite3.connect filename))
    (setv self.c (self.db.cursor)))

  (defn execute [self statement &rest args]
    (self.c.execute statement #*args)
    (self.db.commit))

  (defn fetchall [self statement &rest args]
    (self.c.execute statement #*args)
    (self.c.fetchall))

  (defn close [self]
    (self.db.close)))

(defclass Table [object]
  [db None
   fields []
   out-fields []
   table-name ""]

  (defn --init-- [self db]
    (setv self.db db)
    (setv create
      (.format "create table if not exists words (\n\t{}\n);"
               (.join ",\n\t" (lfor f self.fields
                                (.join " " f)))))
    (setv self.out-fields (+ [(, "rowid" "int")]
                             self.fields))
    (self.db.execute create))

  (defn fetchall [self statement &rest args]
    (self.db.fetchall statement #*args))

  (defn execute [self statement &rest args]
    (self.db.execute statement #*args))

  (defn to-sql [self datum]
    (tuple (lfor f self.out-fields
             (.get datum (first f) None))))

  (defn to-dict [self datum]
    (dfor f (zip self.out-fields datum)
      [(first (first f)) (second f)]))

  (defn get [self statement &rest args]
    (setv statement
      (.format "select rowid, * from {} {};"
               self.table-name
               statement))
    (setv data (self.db.fetchall statement #*args))
    (lfor datum data
      (self.to-dict datum)))

  (defn write [self datum]
    (setv element (self.to-sql datum))
    (setv statement
      (.format "update {} set {} where rowid = {};"
               self.table-name
               (.join ",\n\t" (lfor f (.keys datum)
                                (.format "{} = ?"
                                         f)))
               (.get datum "rowid")))
    (self.execute statement element))
  )
