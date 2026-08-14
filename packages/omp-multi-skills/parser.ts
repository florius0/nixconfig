export interface SkillReferenceParse {
  names: string[];
  text: string;
}

export function filterKnownSkillNames(names: readonly string[], knownNames: Iterable<string>): string[] {
  const known = new Set(knownNames);
  return names.filter(name => known.has(name));
}

const SKILL_NAME = /[a-z][a-z0-9-]*/;
const SKILL_URI_PREFIX = "skill://";

/** Parse lowercase OMP-style skill tokens ($name and skill://name) while ignoring Markdown code. */
export function parseSkillReferences(input: string): SkillReferenceParse {
  const names: string[] = [];
  const seen = new Set<string>();
  let text = "";
  let inlineCode = false;
  let fence = false;

  for (let i = 0; i < input.length; i += 1) {
    if (input.startsWith("```", i)) {
      fence = !fence;
      text += "```";
      i += 2;
      continue;
    }
    const char = input[i];
    if (!fence && char === "`") {
      inlineCode = !inlineCode;
      text += char;
      continue;
    }
    if (!fence && !inlineCode && char === "\\" && input[i + 1] === "$") {
      text += "$";
      i += 1;
      continue;
    }
    if (!fence && !inlineCode && char === "$") {
      const match = SKILL_NAME.exec(input.slice(i + 1));
      const name = match?.[0];
      const next = input[i + 1 + (name?.length ?? 0)];
      const previous = input[i - 1];
      if (name && !/[A-Za-z0-9_-]/.test(previous ?? "") && !/[A-Za-z0-9_-]/.test(next ?? "")) {
        if (!seen.has(name)) {
          seen.add(name);
          names.push(name);
        }
      }
    } else if (!fence && !inlineCode && input.startsWith(SKILL_URI_PREFIX, i)) {
      const previous = input[i - 1];
      const match = SKILL_NAME.exec(input.slice(i + SKILL_URI_PREFIX.length));
      const name = match?.[0];
      const next = input[i + SKILL_URI_PREFIX.length + (name?.length ?? 0)];
      if (name && !/[A-Za-z0-9_-]/.test(previous ?? "") && !/[A-Za-z0-9_-]/.test(next ?? "")) {
        if (!seen.has(name)) {
          seen.add(name);
          names.push(name);
        }
      }
    }
    text += char;
  }

  return { names, text };
}

if (import.meta.main) {
  const cases: Array<[string, string[]]> = [
    ["$ponytail do X", ["ponytail"]],
    ["$ponytail $caveman do X", ["ponytail", "caveman"]],
    ["$ponytail foo $ponytail", ["ponytail"]],
    ["$PATH $1 $100", []],
    ["\\$ponytail", []],
    ["`$ponytail`\n```\n$ponytail\n```", []],
    ["skill://ponytail do X", ["ponytail"]],
    ["skill://ponytail skill://caveman", ["ponytail", "caveman"]],
    ["$ponytail skill://ponytail", ["ponytail"]],
    ["`skill://ponytail`\n```\nskill://ponytail\n```", []],
  ];
  for (const [input, expected] of cases) {
    const actual = parseSkillReferences(input).names;
    if (JSON.stringify(actual) !== JSON.stringify(expected)) {
      throw new Error(`${input}: expected ${expected}, got ${actual}`);
    }
  }
}
