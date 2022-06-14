{ lib
, customApps
, customExtensions
, customThemes

, enabledCustomApps
, enabledExtensions
}:
let inherit (lib) concatMapStrings concatStringsSep foldr mapAttrsToList optionalString; in
rec {
  pipeConcat = foldr (a: b: a + "|" + b) "";

  lineBreakConcat = foldr (a: b: a + "\n" + b) "";

  boolToString = x: if x then "1" else "0";

  makeLnCommands = type: mapAttrsToList (name: path: "ln -sf ${path} ./${type}/${name}");

  makeSpicetifyCommands = type: value: lineBreakConcat (makeLnCommands type value);

  spicetifyLnCommands = makeSpicetifyCommands "Themes" customThemes
    + makeSpicetifyCommands "Extensions" customExtensions
    + makeSpicetifyCommands "CustomApps" customApps;

  extensionString = pipeConcat enabledExtensions;

  customAppsString = pipeConcat enabledCustomApps;

  optionalConfig = config: value: optionalString (value != "") ''${config} "${value}"'';
}
