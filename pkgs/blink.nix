{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fetchNpmDeps,
  cargo-tauri,
  glib-networking,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blink";
  version = "unstable-2025-06-08";

  src = fetchFromGitHub {
    owner = "prayag17";
    repo = "Blink";
    rev = "0f54826";
    hash = "sha256-Fh661dvNC+9M81NF9y3Y1+Bzm/BOpcmhCHLH2L6jr8k=";
  };

  cargoHash = "";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "";
  };

  nativeBuildInputs =
    [
      cargo-tauri.hook
      nodejs
      npmHooks.npmConfigHook
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wrapGAppsHook4
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  cargoRoot = "src-tauri";

  buildAndTestSubdir = finalAttrs.cargoRoot;

  meta = {
    description = "Modern Desktop Jellyfin Client made with Tauri and React :atom_symbol";
    homepage = "https://github.com/prayag17/Blink";
    changelog = "https://github.com/prayag17/Blink/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "blink";
    platforms = lib.platforms.all;
  };
})
