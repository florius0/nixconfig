import type { AutocompleteItem, AutocompleteProvider, AutocompleteSuggestions } from "@oh-my-pi/pi-tui";
import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import {
  buildSkillPromptMessage,
  getActiveSkills,
} from "@oh-my-pi/pi-coding-agent/extensibility/skills";
import { SKILL_PROMPT_MESSAGE_TYPE } from "@oh-my-pi/pi-coding-agent/session/messages";
import { parseSkillReferences } from "./parser";

type Skill = ReturnType<typeof getActiveSkills>[number];

const SKILL_TRIGGER = /(?:^|[^A-Za-z0-9_-])\$([a-z][a-z0-9-]*)?$/;

function matchSkillSuggestions(
  lines: string[],
  cursorLine: number,
  cursorCol: number,
  skills: () => readonly Skill[],
): AutocompleteSuggestions | null {
  const line = lines[cursorLine] ?? "";
  const beforeCursor = line.slice(0, cursorCol);
  const match = SKILL_TRIGGER.exec(beforeCursor);
  if (!match) return null;
  const query = match[1] ?? "";
  const prefix = `$${query}`;
  const items: AutocompleteItem[] = skills()
    .filter(skill => skill.name.includes(query))
    .map(skill => ({
      value: `$${skill.name} `,
      label: `$${skill.name}`,
      description: skill.description,
    }));
  return { items, prefix };
}

function withSkillAutocomplete(
  current: AutocompleteProvider,
  skills: () => readonly Skill[],
): AutocompleteProvider {
  const methods = {
    async getSuggestions(lines: string[], cursorLine: number, cursorCol: number) {
      return (
        matchSkillSuggestions(lines, cursorLine, cursorCol, skills) ??
        current.getSuggestions(lines, cursorLine, cursorCol)
      );
    },
    applyCompletion(
      lines: string[],
      cursorLine: number,
      cursorCol: number,
      item: AutocompleteItem,
      prefix: string,
    ) {
      if (!prefix.startsWith("$")) {
        return current.applyCompletion(lines, cursorLine, cursorCol, item, prefix);
      }
      const line = lines[cursorLine] ?? "";
      const start = cursorCol - prefix.length;
      const nextLines = [...lines];
      nextLines[cursorLine] = `${line.slice(0, start)}${item.value}${line.slice(cursorCol)}`;
      return { lines: nextLines, cursorLine, cursorCol: start + item.value.length };
    },
    getInlineHint(lines: string[], cursorLine: number, cursorCol: number) {
      return current.getInlineHint?.(lines, cursorLine, cursorCol) ?? null;
    },
    trySyncSlashCompletion(textBeforeCursor: string) {
      return current.trySyncSlashCompletion?.(textBeforeCursor) ?? null;
    },
    trySyncInlineReplace(textBeforeCursor: string) {
      return current.trySyncInlineReplace?.(textBeforeCursor) ?? null;
    },
    async getForceFileSuggestions(lines: string[], cursorLine: number, cursorCol: number) {
      return (
        matchSkillSuggestions(lines, cursorLine, cursorCol, skills) ??
        current.getForceFileSuggestions?.(lines, cursorLine, cursorCol) ??
        null
      );
    },
    shouldTriggerFileCompletion(lines: string[], cursorLine: number, cursorCol: number) {
      return (
        SKILL_TRIGGER.test((lines[cursorLine] ?? "").slice(0, cursorCol)) ||
        (current.shouldTriggerFileCompletion?.(lines, cursorLine, cursorCol) ?? false)
      );
    },
  } satisfies AutocompleteProvider;
  return methods;
}

export default function multiSkills(pi: ExtensionAPI): void {
  pi.on("session_start", (_event, ctx) => {
    ctx.ui.addAutocompleteProvider((current) => withSkillAutocomplete(current, getActiveSkills));
  });

  pi.on("input", async (event, ctx) => {
    const parsed = parseSkillReferences(event.text);
    if (parsed.names.length === 0) {
      return parsed.text === event.text ? undefined : { text: parsed.text };
    }

    const skills = getActiveSkills();
    const byName = new Map(skills.map(skill => [skill.name, skill]));
    const unknown = parsed.names.filter(name => !byName.has(name));
    if (unknown.length > 0) {
      ctx.ui.notify(`Unknown skill: ${unknown.join(", ")}`, "error");
      return { handled: true };
    }

    const built = await Promise.all(
      parsed.names.map(async name => {
        const skill = byName.get(name);
        if (!skill) throw new Error(`Unknown skill: ${name}`);
        const prompt = await buildSkillPromptMessage(skill, "", "user");
        return {
          customType: SKILL_PROMPT_MESSAGE_TYPE,
          content: prompt.message,
          display: true,
          details: prompt.details,
          attribution: "user" as const,
        };
      }),
    );
    for (const message of built) {
      pi.sendMessage(message, { deliverAs: "nextTurn" });
    }
    return parsed.text === event.text ? undefined : { text: parsed.text };
  });
}
