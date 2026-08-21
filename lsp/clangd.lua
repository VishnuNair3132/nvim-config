-- C / C++ / ObjC.  Install: :MasonInstall clangd   (or  sudo dnf install clang-tools-extra)
-- Needs compile_commands.json for anything non-trivial:
--   cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..     (CMake)
--   bear -- make                                    (Makefiles, dnf install bear)
return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
    "-j=4",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    ".clangd", ".clang-tidy", ".clang-format",
    "compile_commands.json", "compile_flags.txt",
    "configure.ac", "Makefile", "CMakeLists.txt", ".git",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
