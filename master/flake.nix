{
  description = ''Engine-agnostic library for computing 2D raycasted lights'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-delight-master.flake = false;
  inputs.src-delight-master.ref   = "refs/heads/master";
  inputs.src-delight-master.owner = "liquid600pgm";
  inputs.src-delight-master.repo  = "delight";
  inputs.src-delight-master.type  = "github";
  
  inputs."glm".owner = "nim-nix-pkgs";
  inputs."glm".ref   = "master";
  inputs."glm".repo  = "glm";
  inputs."glm".dir   = "v1_1_1";
  inputs."glm".type  = "github";
  inputs."glm".inputs.nixpkgs.follows = "nixpkgs";
  inputs."glm".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-delight-master"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-delight-master";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}