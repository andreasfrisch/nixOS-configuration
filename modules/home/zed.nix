{ pkgsUnstable, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgsUnstable.zed-editor;
  };
}
