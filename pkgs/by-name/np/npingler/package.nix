{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

let
  emulatorAvailable = stdenv.hostPlatform.emulatorAvailable buildPackages;
  emulator = stdenv.hostPlatform.emulator buildPackages;
in
rustPlatform.buildRustPackage {
  pname = "npingler";
  version = "unstable-2025-08-24";

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "npingler";
    rev = "b897098be1df890b669dc734edcb10bf8fc798cb";
    hash = "sha256-mMwfonIP8fnJDNdl9ANhLmYlM8tPLtBCWNIPSRBT/D4=";
  };

  cargoHash = "sha256-VhMpgrNy0NauwBSCR+5vjod9H216HPC+rdQUIFVjnRg=";


  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString emulatorAvailable ''
    installShellCompletion --cmd npingler \
      --bash <(${emulator} $out/bin/npingler util generate-completions bash) \
      --fish <(${emulator} $out/bin/npingler util generate-completions fish) \
      --zsh  <(${emulator} $out/bin/npingler util generate-completions zsh)
  '';

  meta = {
    description = "Nix profile manager for use with npins";
    homepage = "https://github.com/9999years/npingler";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "npingler";
  };

  passthru.updateScript = nix-update-script { };
}
