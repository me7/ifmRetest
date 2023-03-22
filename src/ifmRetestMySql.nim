import docopt, batteries
import db_connector/db_mysql

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

  if args["createDb"]:
    let db = open("198.10.10.253", "ifm", "VgjTbkQrJ2T)4VIq", "ifm")
    let createTableStr = sql"""CREATE TABLE panel(
    id varchar(255) NOT NULL PRIMARY KEY,
    fail varchar(255)
    )
    """
    db.exec(createTableStr)
    quit()

  let db = open("198.10.10.253", "ifm", "VgjTbkQrJ2T)4VIq", "ifm")
  defer: db.close
  if args["get"]:
    let selectTableStr = sql"""select fail from panel where id = ?"""
    let rows = db.fastRows(selectTableStr, args["<panelid>"]).toSeq
    if rows.len == 0:
      echo "NO_DATA"
    elif rows.len == 1:
      echo rows[0].join(",")

  if args["set"]:
    let insertTableStr = sql"""insert into panel(id, fail) values (?,?) on duplicate key update fail = ?"""
    db.exec(insertTableStr, args["<panelid>"], args["<failunits>"], args["<failunits>"])

main()
