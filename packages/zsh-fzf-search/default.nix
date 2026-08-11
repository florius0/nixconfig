{ writeTextFile }:

# fzf-backed file/content search: `fs`/`fsc`/`fse`/`fsce` shell functions plus
# `__fs`/`__fsc` ZLE widgets bound to ^F/^T. Depends on fzf, fd, ripgrep, bat,
# and eza being on PATH at runtime.
writeTextFile {
  name = "zsh-fzf-search";
  destination = "/share/zsh-fzf-search/search-widgets.zsh";
  text = builtins.readFile ./search-widgets.zsh;
}
