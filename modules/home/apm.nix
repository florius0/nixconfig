{ flake, pkgs, ... }:

let
  mattSkills = {
    type = "github";
    owner = "mattpocock";
    repo = "skills";
    rev = "bc4cf903ff4855ce23199a8dd3bf98b3dbd7ad71";
    hash = "sha256-eoSnNEQENmmqCpZ6E2h9OV1KCjVi1eEo9q9RAkpDWQ4=";
  };

  mattSkillsWithDiagnosingAndWriting = {
    type = "github";
    owner = "mattpocock";
    repo = "skills";
    rev = "6a62d72ab1de2cdaee548a9117664f4b5452995c";
    hash = "sha256-SzToJfduRFhG8oB+okQlU2MtExnw8KvMR/P8JMoe6Lo=";
  };

  ponytail = {
    type = "github";
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "2ed6c52c9d7e5e56942508591085fd45dea277d3";
    hash = "sha256-bGdXvzhWPwGdz3T2Yh2h6lf+3PBRFAfdBxP5pESmCHI=";
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

  diagnosingBugsSource = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = mattSkillsWithDiagnosingAndWriting.rev;
    hash = mattSkillsWithDiagnosingAndWriting.hash;
  };

  diagnosingBugsSkill = pkgs.runCommand "apm-diagnosing-bugs-skill" { } ''
    mkdir -p "$out/diagnosing-bugs"
    cp "${diagnosingBugsSource}/skills/engineering/diagnosing-bugs/SKILL.md" "$out/diagnosing-bugs/SKILL.md"
  '';

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
      ponytail = {
        source = ponytail;
        path = "skills/ponytail";
      };
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

      # Engineering discipline
      diagnosing-bugs = {
        src = diagnosingBugsSkill;
        path = "diagnosing-bugs";
      };
      verification-before-completion = {
        source = superpowers;
        path = "skills/verification-before-completion";
      };

      # Session workflow
      handoff = {
        source = mattSkills;
        path = "skills/productivity/handoff";
      };

      # Meta
      writing-great-skills = {
        source = mattSkillsWithDiagnosingAndWriting;
        path = "skills/productivity/writing-great-skills";
      };

      # Ponytail extras
      ponytail-review = {
        source = ponytail;
        path = "skills/ponytail-review";
      };
      ponytail-audit = {
        source = ponytail;
        path = "skills/ponytail-audit";
      };

      # Caveman extras
      caveman-compress = {
        src = cavemanCompressSkill;
        path = "caveman-compress";
      };

    };
  };
}
