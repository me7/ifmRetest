# Package

version       = "1"
author        = "me7/"
description   = "get / set failed units for each panel id"
license       = "MIT"
srcDir        = "src"
bin           = @["ifmRetest"]
binDir        = "bin"


# Dependencies

requires "nim >= 1.9.1"
requires "https://github.com/docopt/docopt.nim#d2ad95f4f95bae7d41493afa7a95c8aaab10b630" #fix --mm:opc
requires "https://github.com/AngelEzquerra/nim-batteries#8be7692f066d53a522eeba49d9054e7c414f3e1f"
requires "https://github.com/nim-lang/db_connector#e65693709dd042bc723c8f1d46cc528701f1c479"


task dist, "build exe to bin dir":
  echo "executing build task"
  withDir "src":
    exec "nim c ifmRetest.nim"
    exec "strip ifmRetest.exe"
    for file in @["ifmRetest.exe"]:
      cpFile file, "../dist/" & file