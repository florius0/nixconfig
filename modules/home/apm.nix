{ flake, pkgs, ... }:

let
  mattSkills = {
    type = "github";
    owner = "mattpocock";
    repo = "skills";
    rev = "5beb35b040e3de97e54fa9e386d7e42d15c295c2";
    hash = "sha256-2FKfe3/Fwc4MmwBLa+d/oQW4/gtYIssdWapy2MPd39I=";
  };

  caveman = {
    type = "github";
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "bad48a0e1df55e05e3f52249afa35ecc1909ee76";
    hash = "sha256-G2i54t+5fFCRI3lXP6fXV9oPWwIKklmx6F3EfrqntBY=";
  };

  superpowers = {
    type = "github";
    owner = "obra";
    repo = "superpowers";
    rev = "b739a8af570e10a95898f2bdf6cec97467fa6c12";
    hash = "sha256-hy6aavA88hoqdUsV7vCTa0nV4YooZDSBPPPX6Jb7ZCs=";
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

      # Session workflow
      handoff = {
        source = mattSkills;
        path = "skills/productivity/handoff";
      };

      simplify = {
        source = {
          type = "github";
          owner = "bholmesdev";
          repo = "skills";
          rev = "81be8791eee5a43f016efcb9230bdceca0ff7e77";
          hash = "sha256-Gaz6gh/+v9Fx69NfCEAm49n1MzIhHpQJoYrqWdMM/h4=";
        };
        path = "skills/simplify";
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
