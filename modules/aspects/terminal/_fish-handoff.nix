{
  lib,
  fishBin,
  parentCommand,
  executionStringVar,
  beforeExec ? "",
  fishArgs ? "",
}:
''
  if [[ $(${parentCommand}) != "fish" && -z ${executionStringVar} ]]
  then
    ${beforeExec}
    exec ${fishBin}${lib.optionalString (fishArgs != "") " ${fishArgs}"}
  fi
''
