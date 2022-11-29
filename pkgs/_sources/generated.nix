# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
}: {
  copilot-vim = {
    pname = "copilot-vim";
    version = "5a411d19ce7334ab10ba12516743fc25dad363fa";
    src = fetchFromGitHub {
      owner = "github";
      repo = "copilot.vim";
      rev = "5a411d19ce7334ab10ba12516743fc25dad363fa";
      fetchSubmodules = false;
      sha256 = "sha256-8O+7tzQQR5+QHLgXpL+KOISaVn6iOpdfQAQfHtyI4uw=";
    };
  };
  nvim-cokeline = {
    pname = "nvim-cokeline";
    version = "501f93ec84af0d505d95d3827cad470b9c5e86dc";
    src = fetchFromGitHub {
      owner = "noib3";
      repo = "nvim-cokeline";
      rev = "501f93ec84af0d505d95d3827cad470b9c5e86dc";
      fetchSubmodules = false;
      sha256 = "sha256-BQP4jOm55YeDfabsSdfEiRk2O7t7KARklSbyfBK5Zu0=";
    };
  };
  openasar = {
    pname = "openasar";
    version = "7a04cb57dff43f328de78addc234e9d21ff079a8";
    src = fetchFromGitHub {
      owner = "GooseMod";
      repo = "OpenAsar";
      rev = "7a04cb57dff43f328de78addc234e9d21ff079a8";
      fetchSubmodules = false;
      sha256 = "sha256-6zYXv+iAfDEFHQ4FwNVEA4+zWiDyeLvkm17f4LuaCJg=";
    };
  };
  sapling = {
    pname = "sapling";
    version = "c4e447440b0328b2cfd5c53f93f3b2f054e7e8a9";
    src = fetchFromGitHub {
      owner = "facebook";
      repo = "sapling";
      rev = "c4e447440b0328b2cfd5c53f93f3b2f054e7e8a9";
      fetchSubmodules = false;
      sha256 = "sha256-qUM/g7nMco6uIbgHOOCht2K1HkBwVtwUdJRi/P1DAcs=";
    };
  };
  sddm = {
    pname = "sddm";
    version = "3e486499b9300ce8f9c62bd102e5119b27a2fad1";
    src = fetchFromGitHub {
      owner = "sddm";
      repo = "sddm";
      rev = "3e486499b9300ce8f9c62bd102e5119b27a2fad1";
      fetchSubmodules = false;
      sha256 = "sha256-Y9WPm0MLWl/s0e0aoKKk0SSojqBrI/RdyxkgOz2Tk38=";
    };
  };
  zscroll = {
    pname = "zscroll";
    version = "788be9650b647f61f8f899054ad1213eee42e8a4";
    src = fetchFromGitHub {
      owner = "noctuid";
      repo = "zscroll";
      rev = "788be9650b647f61f8f899054ad1213eee42e8a4";
      fetchSubmodules = false;
      sha256 = "sha256-gEluWzCbztO4N1wdFab+2xH7l9w5HqZVzp2LrdjHSRM=";
    };
  };
}
