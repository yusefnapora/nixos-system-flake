let
 storePath = name: (builtins.path { inherit name; path = ./${name}; });
in
{
  firefox = storePath "firefox.svg";
  slack = storePath "slack.svg"; 
  vscode = storePath "vscode.svg";
}