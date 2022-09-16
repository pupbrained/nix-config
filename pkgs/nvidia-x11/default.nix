{
  lib,
  callPackage,
  fetchpatch,
  fetchurl,
  stdenv,
  pkgsi686Linux,
}: let
  generic = args: let
    imported = import ./generic.nix args;
  in
    callPackage imported {
      lib32 =
        (pkgsi686Linux.callPackage imported {
          libsOnly = true;
          kernel = null;
        })
        .out;
    };

  kernel =
    callPackage # a hacky way of extracting parameters from callPackage
    
    ({
      kernel,
      libsOnly ? false,
    }:
      if libsOnly
      then {}
      else kernel)
    {};
in rec {
  # Policy: shoot ourselves in the foot :)
  unfucked = generic {
    version = "515.49.15";
    persistencedVersion = "515.48.07";
    settingsVersion = "515.48.07";
    sha256_64bit = "sha256-yQbNE+YsbHUc4scXvMZFGuuBRrFTa42g1XoMVZEO/zo=";
    openSha256 = "sha256-2RvogIdTA7Rg4oq14TG7Kh31HWuj860xsK7/MYFitpQ=";
    settingsSha256 = "sha256-XwdMsAAu5132x2ZHqjtFvcBJk6Dao7I86UksxrOkknU=";
    persistencedSha256 = "sha256-BTfYNDJKe4tOvV71/1JJSPltJua0Mx/RvDcWT5ccRRY=";
    url = "https://developer.nvidia.com/vulkan-beta-${lib.concatStrings (lib.splitString "." "515.49.15")}-linux";
    patches = [../patches/nvidia-kernel-6.0.patch];
  };
}
