import { describe, expect, test } from "bun:test";
import { parseSkillReferences } from "./parser";

describe("parseSkillReferences", () => {
  test("keeps first occurrence order and deduplicates", () => {
    expect(parseSkillReferences("$caveman foo $ponytail bar $caveman").names).toEqual([
      "caveman",
      "ponytail",
    ]);
  });

  test("supports prose references", () => {
    expect(parseSkillReferences("Use $ponytail and $caveman to do X").names).toEqual([
      "ponytail",
      "caveman",
    ]);
  });

  test("unescapes literal references", () => {
    expect(parseSkillReferences("\\$ponytail")).toEqual({ names: [], text: "$ponytail" });
  });

  test("ignores shell variables and numeric expansions", () => {
    expect(parseSkillReferences("$PATH $HOME $1 $100 $FOO").names).toEqual([]);
  });

  test("ignores inline and fenced code", () => {
    expect(parseSkillReferences("`$ponytail`\n```sh\necho $ponytail\n```").names).toEqual([]);
  });

  test("reports syntactically valid unknown names for exact resolution", () => {
    expect(parseSkillReferences("$does-not-exist fix this").names).toEqual(["does-not-exist"]);
  });

  test("expands skill:// URI references like $ references", () => {
    expect(parseSkillReferences("skill://ponytail foo skill://caveman").names).toEqual([
      "ponytail",
      "caveman",
    ]);
  });

  test("dedupes $name and skill://name pointing at the same skill", () => {
    expect(parseSkillReferences("$ponytail skill://ponytail").names).toEqual(["ponytail"]);
  });

  test("ignores skill:// inside inline and fenced code", () => {
    expect(
      parseSkillReferences("`skill://ponytail`\n```sh\necho skill://ponytail\n```").names,
    ).toEqual([]);
  });
});
