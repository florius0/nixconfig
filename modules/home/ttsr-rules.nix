{ ... }:

let
  rule = name: text: {
    name = ".omp/agent/rules/${name}.mdc";
    value.text = text;
  };
in
{
  home.file = builtins.listToAttrs [
    (rule "policy-final-diff-cleanup" ''
      ---
      description: Review the final diff and remove unrelated noise
      alwaysApply: true
      ---

      # Final diff cleanup

      Before completion, review the complete final diff after formatting and verification. For every changed hunk, identify the requested behaviour, correctness fix, required verification change, or unavoidable formatter adjustment that justifies it.

      Revert changes introduced during the current task when they do not contribute logically to the requested result, including:

      - formatting or rewrapping of previously existing code when the project formatter did not require it
      - unrelated import, declaration, attribute, or member reordering
      - equivalent syntax substitutions without a requested behavioural or readability benefit
      - renamed locals, rewritten comments, or restyled expressions outside the affected path
      - incidental cleanup, speculative refactoring, and generated scaffolding not required by the task
      - temporary debugging, instrumentation, compatibility paths, and test artifacts

      Keep unavoidable output from the repository's canonical formatter and supporting changes required for compilation, tests, documentation, or the requested behaviour.

      Never revert pre-existing user changes. Revert only noise introduced while performing the current task.
    '')

    (rule "policy-elixir" ''
      ---
      description: Elixir readability, organization, branching, and style policy
      globs: ["*.ex", "*.exs"]
      alwaysApply: true
      ---

      # Elixir policy

      Optimize for top-to-bottom reading. A reader should understand a module or function without jumping through small wrappers, helper modules, or distant one-use private functions.

      ## Organization

      Inside `defmodule`, use this order unless framework macros require otherwise:

      1. Group `use`, `import`, `alias`, then `require`, in that order.
      2. Put `@moduledoc` after those groups.
      3. Declare module attributes, behaviours, types, opaque types, callbacks, and `defstruct`.
      4. Put the public API and primary behaviour implementation next. Keep clauses of the same function contiguous.
      5. Put a unique private pattern-matching function immediately after its public caller when that avoids jumping.
      6. Put remaining private API next and genuine shared helpers last.

      In Elixir documentation, interpolate module names as `#{inspect MyModule}` instead of writing a plain `MyModule`, so renames and rendered aliases remain accurate.

      ## Branching and pattern matching

      - Aggressively replace nested `case`, `cond`, and `if` success/failure flows with `with` when clauses form a dependent sequence.
      - Do not convert one obvious branch into `with` merely for uniformity.
      - Keep `with` clauses focused on the success path. Avoid a large or ambiguous `else` that obscures which clause failed.
      - If failure normalization is needed, allow a small private multi-clause function only when it simplifies pattern matching or makes error provenance explicit; place it next to its sole caller.
      - Prefer function heads, guards, multi-clause functions, destructuring, `case`, `with`, and `if let`-like `=` matches over boolean flag plumbing.
      - Prefer pattern matching or `String` functions before regular expressions when the input shape is structural or literal.

      ## Abstraction

      - Do not generate small helper functions merely to shorten a function, wrap one call, rename an expression, or serve one caller.
      - Keep linear work inline with meaningful local names.
      - Do not create `Utils`, `Helpers`, service wrappers, behaviours with one implementation, or modules used only as namespaces.
      - A private helper is justified when multi-clause pattern matching materially simplifies branching. A module is justified only by a real domain boundary or independently maintained invariant.

      ## Selected Elixir style-guide rules

      1. Prefer pipelines of named functions for multi-step data transformations; call a single function directly.
      2. Do not use `then/2`, `tap/2`, or anonymous functions as pipeline stages. Use an existing named operation or keep the transformation inline; do not invent a small helper merely to preserve a pipeline.
      3. Never use `unless` with `else`; state the positive case first with `if`.
      4. Use `and`, `or`, and `not` for strict booleans; reserve `&&`, `||`, and `!` for truthy/falsy values.
      5. Prefer pattern matching or `String` functions before regex.
      6. Use `snake_case` for functions, variables, module attributes, and atoms.
      7. Use `CamelCase` module names and preserve established acronyms.
      8. End predicates with `?`; reserve an `is_` prefix for guard-safe predicates.
      9. Reference the current module with `__MODULE__`.
      10. Group and order `use`, `import`, `alias`, and `require` as specified above.

      ## Verification

      Use the project's existing Elixir linters and static checks, including configured Credo checks; do not introduce a new linter merely for verification. Prefer the full `mix test` suite, including all umbrella applications, when its runtime and resource cost are practical. Otherwise run the broadest relevant test target and state what was omitted.

      ## Diff discipline

      Run the repository formatter when required, but do not create formatting-only churn. Preserve an existing valid formatting variant when the language formatter permits several forms. Do not reorder or rewrap unrelated code. Every changed line must support the requested behaviour, a required check, or the smallest surrounding formatter adjustment.
    '')

    (rule "policy-swift" ''
      ---
      description: Swift readability, organization, branching, and style policy
      globs: ["*.swift"]
      alwaysApply: true
      ---

      # Swift policy

      Optimize for top-to-bottom reading with minimal jumping.

      ## Organization

      1. Put imports first. Group regular module imports, individual declaration imports, then `@testable` imports; sort each group lexicographically and separate groups with one blank line.
      2. Put documentation directly on the primary type or declaration after imports.
      3. Inside a type, place nested data types and stored properties first, followed by initializers.
      4. Put the public API and primary protocol implementation next.
      5. Keep a private member used by only one public member adjacent to that caller when practical; put remaining private API next and genuine shared helpers last.
      6. Use focused extensions for protocol conformances. Do not create extensions merely to hide arbitrary helper buckets.

      ## Branching and abstraction

      Prefer `guard` for early exits, `switch` for exhaustive state handling, and `if case`/pattern binding where they expose the data shape. Avoid boolean flag plumbing and nested pyramids.

      Do not generate `Helper`, `Utils`, namespace enums, wrapper objects, protocols with one implementation, or tiny methods used once. Keep linear transformations inline with named locals. A local/nested enum or type is justified when it makes branching exhaustive or models real state; a separate type is justified only by an independent invariant or protocol conformance.

      ## Verification

      Use the linters and analyzers already configured by the Swift package or Xcode project, such as SwiftLint or the project's formatter checks; do not add a new tool merely for verification. Prefer the full `swift test` suite or the project's complete Xcode scheme when its runtime and resource cost are practical. Otherwise run the broadest relevant target and state what was omitted.

      ## Diff discipline

      Let the repository's Swift formatter own canonical formatting. Do not rewrap, reorder, or restyle unrelated code, and preserve existing valid variants when no formatter rule chooses between them. Every changed line must support the requested behaviour or a required formatter adjustment.
    '')

    (rule "policy-go" ''
      ---
      description: Go readability, organization, branching, and style policy
      globs: ["*.go"]
      alwaysApply: true
      ---

      # Go policy

      Optimize for top-to-bottom reading and the conventions enforced by `gofmt` and `goimports`.

      ## Organization

      1. A package comment, when present, precedes the `package` clause; the `package` clause necessarily precedes imports.
      2. Group imports as standard library, other project/vendor packages, generated protocol-buffer packages, then side-effect imports. Let `goimports` sort within groups.
      3. Put package constants, variables, and data types before the API that uses them when this improves comprehension.
      4. Put exported API and primary interface implementation next.
      5. Keep an unexported function used by one exported function near its caller; put remaining unexported API next and genuine shared helpers last.

      ## Branching and abstraction

      Prefer early returns, type switches, ordinary switches, and type assertions that expose the handled cases. Avoid deeply nested `if` chains and boolean mode parameters.

      Do not generate tiny helper functions, `util`/`common`/`helper` packages, one-method wrapper types, factories for one implementation, or interfaces with one implementation. Keep linear work inline. A private function or small type is justified when it materially simplifies branching, centralizes error-state handling, or represents an independent invariant.

      ## Verification

      Use the project's existing Go checks, such as configured `go vet`, Staticcheck, or golangci-lint; do not introduce a new linter merely for verification. Prefer `go test ./...` or the repository's full test command when its runtime and resource cost are practical. Otherwise test the broadest relevant package set and state what was omitted.

      ## Diff discipline

      `gofmt` is canonical, so required formatter output is allowed. Do not format or reorganize unrelated files or declarations. Preserve existing import grouping unless `goimports` or a real dependency change requires adjustment.
    '')

    (rule "policy-zig" ''
      ---
      description: Zig readability, organization, branching, and style policy
      globs: ["*.zig"]
      alwaysApply: true
      ---

      # Zig policy

      Optimize for top-to-bottom reading while respecting that every Zig source file is an implicit struct and top-level declarations are order-independent.

      ## Organization

      1. `//!` top-level documentation must be first because Zig requires it before expressions.
      2. Put `@import` declarations next, starting with `std`, then builtin/generated modules, then project imports; keep aliases near their import.
      3. Put public data types, error sets, constants, and fields before the public functions that use them.
      4. Put public API next. Keep a private function used by one public function nearby, followed by remaining private API and genuine shared helpers.

      ## Branching and abstraction

      Prefer `switch` over tagged unions and enums, optional/error-union captures, `try`, `catch`, `orelse`, `errdefer`, and labeled blocks when they make state transitions explicit. Avoid boolean mode flags and nested condition pyramids.

      Do not create utility namespaces, empty structs used only as namespaces, wrapper functions, or types named `Manager`, `Context`, `Data`, `Utils`, or `Helpers` without a specific independent concept. Keep one-use linear operations inline. A function or type is justified when it simplifies branching/error cleanup or owns a real invariant.

      ## Verification

      Use the lint and validation steps already exposed by `build.zig` or repository scripts; do not introduce a new linter merely for verification. Prefer the full `zig build test` or project-wide test step when its runtime and resource cost are practical. Otherwise run the broadest relevant build/test target and state what was omitted.

      ## Diff discipline

      `zig fmt` is canonical. Apply it only where required by the changed file and do not introduce unrelated declaration reordering or formatting churn.
    '')

    (rule "policy-nix" ''
      ---
      description: Nix readability, organization, branching, and style policy
      globs: ["*.nix"]
      alwaysApply: true
      ---

      # Nix policy

      Optimize for top-to-bottom evaluation and keep provenance explicit. Nix has no import statement; distinguish imported expressions, NixOS/Home Manager module `imports`, and lexical `let` bindings.

      ## Organization

      For NixOS and Home Manager modules:

      1. Put the function argument set and useful file documentation first.
      2. Put local `let` bindings next; keep them minimal and close to their use.
      3. In the result attribute set, order `imports`, `options`, `config`, then `meta` when present.
      4. Group related options and definitions by subsystem rather than alphabetizing across semantic groups.

      For derivations:

      1. Put function arguments and local source/version bindings first.
      2. Put the primary derivation and its build inputs/hooks in execution order.
      3. Put `passthru` and `meta` last.

      ## Branching and abstraction

      Prefer explicit attribute selection, `inherit`, `optionalAttrs`, `optionals`, `mkIf`, and `mkMerge` where they make conditional structure visible. Avoid broad `with`, unnecessary `rec`, hidden dynamic attribute selection, and nested conditional expressions.

      Do not generate one-use helper functions, helper attribute sets, overlays, or modules merely to shorten an expression. Keep linear composition inline. A helper is justified when it simplifies repeated conditional merging, makes branching exhaustive, or represents a reusable module boundary.

      Preserve import and list order when order may affect overrides, hooks, or readability. Otherwise group inputs logically: standard/framework inputs, external inputs, then local modules.

      ## Verification

      Use project-available Nix checks such as configured statix, deadnix, formatter checks, evaluations, or repository scripts; do not introduce a new linter merely for verification. Prefer the full `nix flake check` or repository-wide check when its runtime, evaluation cost, and required network access are practical. Otherwise run the broadest relevant evaluation/check and state what was omitted.

      ## Diff discipline

      Follow the formatter already selected by the repository. Nix formatters permit different valid layouts, so do not switch layout styles, sort unrelated attributes, or reformat untouched expressions. Every changed line must support the requested behaviour or the smallest formatter adjustment.
    '')

    (rule "policy-rust" ''
      ---
      description: Rust readability, organization, branching, and style policy
      globs: ["*.rs"]
      alwaysApply: true
      ---

      # Rust policy

      Optimize for top-to-bottom reading while preserving Rust item and documentation constraints.

      ## Organization

      1. Put crate/module inner documentation (`//!`) and inner attributes before imports because Rust requires them at the module start.
      2. Put `use` items before `mod` declarations and other items. Group standard library, external crates, then `crate`/`super`/`self` imports; let rustfmt preserve canonical layout.
      3. Put public data types, errors, traits, constants, and fields before their implementations.
      4. Put inherent and trait implementations containing the public API next.
      5. Within an impl, keep a private method used by one public method near that method; put remaining private API next and genuine shared helpers last.

      ## Branching and abstraction

      Prefer exhaustive `match`, `if let`, `let else`, destructuring, guards, combinators only when clearer, and `?` for error propagation. Avoid boolean mode parameters and nested condition pyramids.

      Do not generate tiny helper functions, helper traits, modules, newtypes, builders, factories, or wrapper structs solely to rename one operation or serve one caller. Keep linear work inline. A private function or local type is justified when it materially simplifies pattern matching/branching, owns cleanup through RAII, or represents an independent invariant.

      ## Verification

      Use the project's existing Rust checks, including configured Clippy and repository lint commands; do not introduce a new linter merely for verification. Prefer the full workspace test command, commonly `cargo test --workspace --all-targets`, when its runtime and resource cost are practical. Otherwise run the broadest relevant package/target set and state what was omitted.

      ## Diff discipline

      `rustfmt` is canonical. Do not reorder unrelated items, rewrite valid import layouts without need, or create formatting-only diffs outside the formatter's unavoidable adjustment to changed code.
    '')

    (rule "elixir-credo-unsafe-to-atom" ''
      ---
      description: Credo Warning.UnsafeToAtom - prevent atom-table exhaustion
      condition: ['\b(?:String|List)\.to_atom\s*\(', ':erlang\.(?:binary|list)_to_atom\s*\(', '\bModule\.concat\s*\(', '(?s)\bJason\.decode!?\s*\(.*?\bkeys:\s*:atoms(?![!\w])']
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Do not create atoms from unknown or external data. Atoms are not garbage-collected and unbounded creation can exhaust the VM atom table.

      Use an explicit finite mapping, `String.to_existing_atom/1`, `List.to_existing_atom/1`, `Module.safe_concat/1,2`, or Jason string keys/`keys: :atoms!` as appropriate. Prove that the input set is compile-time bounded before retaining dynamic atom creation.
    '')

    (rule "elixir-credo-unsafe-exec" ''
      ---
      description: Credo Warning.UnsafeExec - avoid shell command injection
      condition: [':os\.cmd\s*\(', '(?s):erlang\.open_port\s*\(\s*\{\s*:spawn\s*,']
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Do not pass a command string through a shell. Use `System.cmd/2,3` with an executable and explicit argument list, or `:erlang.open_port/2` with `{:spawn_executable, executable}` and an `:args` option. Keep untrusted data out of executable names and shell syntax.
    '')

    (rule "elixir-credo-application-config-module-attribute" ''
      ---
      description: Credo Warning.ApplicationConfigInModuleAttribute - distinguish compile-time and runtime configuration
      condition: '(?s)@[a-zA-Z_]\w*\s+Application\.(?:fetch_env!?|get_env|get_all_env)\s*\('
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Module attributes are evaluated at compile time. Do not read runtime application configuration into them with `Application.fetch_env/2`, `fetch_env!/2`, `get_env/2,3`, or `get_all_env/1`.

      Read runtime configuration in the function that uses it. If compile-time configuration is intentional, use `Application.compile_env/2,3` or `compile_env!/2` and preserve release-time semantics.
    '')

    (rule "elixir-credo-dbg" ''
      ---
      description: Credo Warning.Dbg - remove debugging calls
      condition: '(?:\b(?:Kernel\.)?dbg\s*\(|\|>\s*dbg(?:\s*\(|\b)|&dbg/)'
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Do not leave `dbg` calls or captures in generated code. Remove the debugging expression. Use the project's structured logging or telemetry only when observability is part of the requested behaviour.
    '')

    (rule "elixir-credo-iex-pry" ''
      ---
      description: Credo Warning.IExPry - remove interactive breakpoints
      condition: '\bIEx\.pry\s*\('
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Do not leave `IEx.pry/0` in generated code. Remove the interactive breakpoint rather than hiding or guarding it.
    '')

    (rule "elixir-credo-io-inspect" ''
      ---
      description: Credo Warning.IoInspect - remove ad hoc inspection
      condition: '\b(?:Elixir\.)?IO\.inspect\s*\('
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Do not leave `IO.inspect/1,2` debugging calls in generated production code. Remove them. Use structured logging only when the requested behaviour requires durable observability; do not substitute logging merely to silence this rule.
    '')

    (rule "elixir-credo-nesting" ''
      ---
      description: Credo Refactor.Nesting - flatten nested control flow with aggressive with usage
      condition: '(?s)\b(?:case|cond|if|unless)\b(?:(?!\bend\b).)*\bdo\b(?:(?!\bend\b).)*\b(?:case|cond|if|unless)\b'
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Flatten nested `case`, `cond`, and `if` flows. Prefer `with` aggressively when two or more dependent matches form a success path. Prefer function-head pattern matching for dispatch.

      Keep a simple branch direct. Do not replace nesting with opaque boolean flags or a complex `with else`. A small adjacent private multi-clause normalizer is allowed only when it simplifies pattern matching or identifies which step failed.
    '')

    (rule "elixir-credo-function-arity" ''
      ---
      description: Credo Refactor.FunctionArity - keep function interfaces comprehensible
      condition: '(?m)\bdefp?\s+[a-zA-Z_]\w*[!?]?\s*\(\s*[^,\n]+(?:\s*,\s*[^,\n]+){8,}\s*\)'
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Keep function arity at eight or fewer. Group related inputs into an existing struct, map, or keyword options when that improves the caller. Do not invent a parameter object or helper module solely to satisfy the number; if inputs are unrelated, the function likely owns too many responsibilities.
    '')

    (rule "elixir-credo-match-in-condition" ''
      ---
      description: Credo Refactor.MatchInCondition - make matching control flow explicit
      condition: '(?s)\b(?:if|unless)\s+(?:\{[^}]+\}|%[^=\n]+|[A-Z][A-Za-z0-9_.]*\{[^}]+\})\s*='
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Do not combine a non-trivial pattern match with an `if` or `unless` condition. Use a function head, `case`, or `with` so the match and fallback are explicit. Prefer `with` when the match is one step in a dependent success path.
    '')

    (rule "elixir-credo-unless-with-else" ''
      ---
      description: Credo Refactor.UnlessWithElse - state the positive branch first
      condition: '(?s)\bunless\b(?:(?!\bend\b).)*\bdo\b(?:(?!\bend\b).)*\belse\b'
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Never use `unless` with `else`; the double inversion is difficult to read. Rewrite it as `if` with the positive condition and positive branch first.
    '')

    (rule "elixir-style-function-pipelines" ''
      ---
      description: Elixir style guide - prefer named function pipelines and avoid then/tap
      condition: ['(?s)\|>\s*\(\s*fn\b.*?\bend\s*\)\.\s*\(', '(?<![A-Za-z0-9_.])(?:Kernel\.)?(?:then|tap)\s*\(']
      scope: ["tool:edit(*.ex)", "tool:edit(*.exs)", "tool:write(*.ex)", "tool:write(*.exs)"]
      interruptMode: tool-only
      ---

      Prefer pipelines composed of named functions for multi-step transformations. Do not use `then/2`, `tap/2`, or an immediately invoked anonymous function as a pipeline stage.

      Use an existing named operation when it expresses the step. Otherwise bind the intermediate result and keep the transformation or side effect inline. Do not create a one-line helper merely to preserve the pipeline; private helpers remain reserved for materially simpler pattern matching or branching.
    '')
  ];
}
