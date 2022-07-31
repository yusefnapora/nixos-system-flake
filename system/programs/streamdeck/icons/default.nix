let
 storePath = name: (builtins.path { inherit name; path = ./${name}; });
in
{
  firefox = storePath "firefox.svg";
  slack = storePath "slack.svg"; 
  vscode = storePath "vscode.svg";
  zoom = storePath "zoom.svg";

  video-off = storePath "video-off.svg";
  mic-off = storePath "mic-off.svg";
  screen-share = storePath "screen-share.svg";
  back-arrow = storePath "back-arrow.svg";
}