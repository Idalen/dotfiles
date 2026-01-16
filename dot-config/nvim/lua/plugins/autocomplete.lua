return {
  "saghen/blink.cmp",
  version = "1.*", 
  build = "cargo build --release", 
  opts = {
    keymap = {
      preset = "super-tab",
    },
    fuzzy = {
      implementation = "prefer_rust",  -- prefer the Rust engine
      -- optional: if you *still* want prebuilt fallbacks:
      -- prebuilt_binaries = { force_version = "1.*" },
    },
  },
}
