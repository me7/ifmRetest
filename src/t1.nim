# evaluate ideas
import std/db_sqlite

let db = open("retest.db", "", "", "")
block: ## Create database
  ## Binary datas needs to be of type BLOB in SQLite
  let createTableStr = sql"""CREATE TABLE panel(
    id string NOT NULL PRIMARY KEY,
    fail string
  )
  """
  db.exec(createTableStr)
