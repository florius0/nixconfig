{ flake, pkgs, ... }:

let
  mattSkills = {
    type = "github";
    owner = "mattpocock";
    repo = "skills";
    rev = "bc4cf903ff4855ce23199a8dd3bf98b3dbd7ad71";
    hash = "sha256-eoSnNEQENmmqCpZ6E2h9OV1KCjVi1eEo9q9RAkpDWQ4=";
  };

  caveman = {
    type = "github";
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "309834233183478e6fd7800d26e1fbaa6210274e";
    hash = "sha256-jm5/xMkG/WpF8OGW2mkhXA9xVS1LBE2j9iwAiJzPXs0=";
  };

  superpowers = {
    type = "github";
    owner = "obra";
    repo = "superpowers";
    rev = "44c9b2d6e889982ac18c27d05a19fefe335194e1";
    hash = "sha256-fnl+HbPL2qD5Zgz8a1NctjFJSqu6UsyHJAhQMLQNXXc=";
  };

  superpowersSkills = [
    "brainstorming"
    "dispatching-parallel-agents"
    "executing-plans"
    "finishing-a-development-branch"
    "receiving-code-review"
    "requesting-code-review"
    "subagent-driven-development"
    "systematic-debugging"
    "test-driven-development"
    "using-git-worktrees"
    "using-superpowers"
    "verification-before-completion"
    "writing-plans"
    "writing-skills"
  ];

  superpowersPackages = builtins.listToAttrs (
    map (name: {
      inherit name;
      value = {
        source = superpowers;
        path = "skills/${name}";
      };
    }) superpowersSkills
  );

  cavemanCompressSource = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = caveman.rev;
    hash = caveman.hash;
  };

  cavemanCompressSkill = pkgs.runCommand "apm-caveman-compress-skill" { } ''
    mkdir -p "$out/caveman-compress"
    cp "${cavemanCompressSource}/skills/caveman-compress/SKILL.md" "$out/caveman-compress/SKILL.md"
  '';
in
{

  programs.apm = {
    enable = true;
    targets = [
      "agent-skills"
      "codex"
    ];

    packages = {
      # Behavior
      caveman = {
        source = caveman;
        path = "skills/caveman";
      };

      # Thinking / design
      grill-me = {
        source = mattSkills;
        path = "skills/productivity/grill-me";
      };
      grilling = {
        source = mattSkills;
        path = "skills/productivity/grilling";
      };
      grill-with-docs = {
        source = mattSkills;
        path = "skills/engineering/grill-with-docs";
      };
      zoom-out = {
        source = mattSkills;
        path = "skills/engineering/zoom-out";
      };

      # Session workflow
      handoff = {
        source = mattSkills;
        path = "skills/productivity/handoff";
      };

      # Caveman extras
      caveman-compress = {
        src = cavemanCompressSkill;
        path = "caveman-compress";
      };

    }
    // superpowersPackages;
  };
}
