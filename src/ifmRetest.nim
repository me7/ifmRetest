import docopt, batteries
import db_connector/db_sqlite

let doc = """
  iFM retest 

  Usage:
    ifmRetest get <panelid>
    ifmRetest set <panelid> <failunits>
    ifmRetest createDb

  Try:
    ifmRetest get 120164951-12_07
    ifmRetest set 120164951-12_07 1,2,3

  Options:
    -a -about About this app
  """.dedent

proc main =
  let
    args = docopt(doc, help = true)
    dbFile = getAppDir() / "resultMapping.db"

  if args["createDb"]:
    if fileExists(dbFile):
      echo dbFile, " already exist"
      quit()
    let db = open(dbFile, "", "", "")
    let createTableStr = sql"""CREATE TABLE panel(
    id string NOT NULL PRIMARY KEY,
    fail string
    )
    """
    db.exec(createTableStr)
    quit()

  let db = open(dbFile, "", "", "")
  defer: db.close
  if args["get"]:
    let selectTableStr = sql"""select fail from panel where id = ?"""
    let rows = db.fastRows(selectTableStr, args["<panelid>"]).toSeq
    if rows.len == 0:
      echo "NO_DATA"
    elif rows.len == 1:
      echo rows[0].join(",")

  if args["set"]:
    let insertTableStr = sql"""insert into panel(id, fail) values (?,?) on conflict(id) do update set fail = ?"""
    db.exec(insertTableStr, args["<panelid>"], args["<failunits>"], args["<failunits>"])

main()
