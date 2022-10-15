{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  stdenv,
}: {
  "absolute-enable-right-click" = buildFirefoxXpiAddon {
    pname = "absolute-enable-right-click";
    version = "1.3.8";
    addonId = "{9350bc42-47fb-4598-ae0f-825e3dd9ceba}";
    url = "https://addons.mozilla.org/firefox/downloads/file/1205179/absolute_enable_right_click-1.3.8.xpi";
    sha256 = "d1ca76d23234e6fd0f5d521caef62d20d071c8806887cda89914fd8325715a0a";
    meta = with lib; {
      description = "Force Enable Right Click &amp; Copy";
      license = licenses.bsd2;
      platforms = platforms.all;
    };
  };
  "active-forks" = buildFirefoxXpiAddon {
    pname = "active-forks";
    version = "1.0.1";
    addonId = "{a00ce3b7-1008-4c5c-9c5d-6353680a407b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3800993/active_forks-1.0.1.xpi";
    sha256 = "075cc41e94c2910e465693382f07be14828fc97e31f36066aa9ef4cca298bdff";
    meta = with lib; {
      homepage = "https://github.com/ridvanaltun/active-forks-extension";
      description = "Show Active Forks for any GitHub project.";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
  "adblock-for-youtube" = buildFirefoxXpiAddon {
    pname = "adblock-for-youtube";
    version = "0.3.5";
    addonId = "jid1-q4sG8pYhq8KGHs@jetpack";
    url = "https://addons.mozilla.org/firefox/downloads/file/3969115/adblock_for_youtube-0.3.5.xpi";
    sha256 = "5b9acc636c706fa3bb229e9d907480e90438f26322c33e8999acbeb3a32724fc";
    meta = with lib; {
      homepage = "https://mybrowseraddon.com/adblocker-for-youtube.html";
      description = "Remove all annoying ads from YouTube.";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };
  "betterviewer" = buildFirefoxXpiAddon {
    pname = "betterviewer";
    version = "1.0.5";
    addonId = "ademking@betterviewer";
    url = "https://addons.mozilla.org/firefox/downloads/file/4002455/betterviewer-1.0.5.xpi";
    sha256 = "01b90d2afc4dc5de93dbb2eff2cc1cbd8eac181ddefb9d9506ff36788db901a7";
    meta = with lib; {
      homepage = "https://github.com/Ademking/BetterViewer";
      description = "BetterViewer was designed as a replacement for the image viewing mode built into Firefox and Chrome-based web browsers. With BetterViewer you can use various keyboard shortcuts to quickly pan, zoom images, edit and a lot more!";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
  "buster-captcha-solver" = buildFirefoxXpiAddon {
    pname = "buster-captcha-solver";
    version = "1.3.2";
    addonId = "{e58d3966-3d76-4cd9-8552-1582fbc800c1}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3997075/buster_captcha_solver-1.3.2.xpi";
    sha256 = "bd8b13aebb7437b57acd898c5f0a1326e5af61ac41316abbca30c075636fa1f7";
    meta = with lib; {
      homepage = "https://github.com/dessant/buster";
      description = "Save time by asking Buster to solve captchas for you.";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };
  "catppuccin-mocha-sky" = buildFirefoxXpiAddon {
    pname = "catppuccin-mocha-sky";
    version = "2.0";
    addonId = "{12eeb304-58cd-4bcb-9676-99562b04f066}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3954372/catppuccin_dark_sky-2.0.xpi";
    sha256 = "d9453ae265608d3a1b17c812d77422ab2aaf357365e527812268a407643efa25";
    meta = with lib; {
      description = "Firefox theme based on <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/110954a3f2718cf03892676379416caed51099b639f643aaf12989b7e698f073/https%3A//github.com/catppuccin/catppuccin\" rel=\"nofollow\">https://github.com/catppuccin/catppuccin</a>";
      license = licenses.cc-by-30;
      platforms = platforms.all;
    };
  };
  "clearurls" = buildFirefoxXpiAddon {
    pname = "clearurls";
    version = "1.25.0";
    addonId = "{74145f27-f039-47ce-a470-a662b129930a}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3980848/clearurls-1.25.0.xpi";
    sha256 = "96bf83092830a34427ae4f105dce0422c306d9d95669c0c93f4e55804993435c";
    meta = with lib; {
      homepage = "https://clearurls.xyz/";
      description = "Removes tracking elements from URLs";
      license = licenses.lgpl3;
      platforms = platforms.all;
    };
  };
  "disconnect" = buildFirefoxXpiAddon {
    pname = "disconnect";
    version = "20.3.1.1";
    addonId = "2.0@disconnect.me";
    url = "https://addons.mozilla.org/firefox/downloads/file/3655554/disconnect-20.3.1.1.xpi";
    sha256 = "f1e98b4b1189975753c5c806234de70cbd7f09ae3925ab65ef834da5915ac64d";
    meta = with lib; {
      homepage = "https://disconnect.me/";
      description = "Make the web faster, more private, and more secure.";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };
  "docsafterdark" = buildFirefoxXpiAddon {
    pname = "docsafterdark";
    version = "0.5.2";
    addonId = "{e8ffc3db-2875-4c7f-af38-d03e7f7f8ab9}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4005136/docsafterdark-0.5.2.xpi";
    sha256 = "2c41c4b1879b40a7e4608b1fa8382b0b4c6d44ab374d5858de32f0de1fcf7eab";
    meta = with lib; {
      homepage = "https://waymondrang.com/docsafterdark/";
      description = "Modern, dark mode for Google Docs";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };
  "font-fingerprint-defender" = buildFirefoxXpiAddon {
    pname = "font-fingerprint-defender";
    version = "0.1.3";
    addonId = "{96ef5869-e3ba-4d21-b86e-21b163096400}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3700935/font_fingerprint_defender-0.1.3.xpi";
    sha256 = "d3bb3cfda0917960a496dfd72fcfea1e2b589c5f94083643f5ba7165bef492b9";
    meta = with lib; {
      homepage = "https://mybrowseraddon.com/font-defender.html";
      description = "Defending against Font fingerprinting by reporting a fake value.";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };
  "hyperchat" = buildFirefoxXpiAddon {
    pname = "hyperchat";
    version = "2.6.8";
    addonId = "{14a15c41-13f4-498e-986c-7f00435c4d00}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4013419/hyperchat-2.6.8.xpi";
    sha256 = "c85932a3eecf67129a7a8aee8cf225afe897b484666395492c4307f629db2173";
    meta = with lib; {
      homepage = "https://livetl.app/hyperchat/";
      description = "Improved YouTube chat with CPU/RAM optimizations, customization options, and cutting-edge features!";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };
  "istilldontcareaboutcookies" = buildFirefoxXpiAddon {
    pname = "istilldontcareaboutcookies";
    version = "1.0.4";
    addonId = "idcac-pub@guus.ninja";
    url = "https://addons.mozilla.org/firefox/downloads/file/4012501/istilldontcareaboutcookies-1.0.4.xpi";
    sha256 = "eca2e6eec1196030a7715a9e5c73ae2eb9eab6148a0feff2a4cd65c26d0259f1";
    meta = with lib; {
      homepage = "https://github.com/OhMyGuus/I-Dont-Care-About-Cookies";
      description = "Community version of the popular extension \"I don't care about cookies\" \n\n<a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/d899243c3222e303a4ac90833f850da61cdf8f7779e2685f60f657254302216d/https%3A//github.com/OhMyGuus/I-Dont-Care-About-Cookies\" rel=\"nofollow\">https://github.com/OhMyGuus/I-Dont-Care-About-Cookies</a>";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };
  "mpris-integration" = buildFirefoxXpiAddon {
    pname = "mpris-integration";
    version = "0.2";
    addonId = "mpris-integration@jsmnbom.github.io";
    url = "https://addons.mozilla.org/firefox/downloads/file/1755623/mpris_integration-0.2.xpi";
    sha256 = "83c547af329f3bebbedf2ec4cbd9efa9ed56a7c44c92b5ad34befbf4d2653736";
    meta = with lib; {
      homepage = "https://github.com/jsmnbom/mpris-integration";
      description = "Adds mpris integration for certain sites. It allows you to have proper media key support for webplayers like youtube and spotify. [only works on linux]";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
  "pinunpin-tab" = buildFirefoxXpiAddon {
    pname = "pinunpin-tab";
    version = "4.2";
    addonId = "jid1-j1RdUbjJ4pH8Yw@jetpack";
    url = "https://addons.mozilla.org/firefox/downloads/file/3816708/pinunpin_tab-4.2.xpi";
    sha256 = "53ef3efec8aaf564d2184c14d6d2f4ecc3660d3ce29924c99bf83cf1fa252f11";
    meta = with lib; {
      homepage = "https://github.com/jayesh-bhoot/pin-unpin-tab";
      description = "Pin Unpin Tab can pin or unpin a tab by:\n- a long left mouse click anywhere on the webpage (an arguably more efficient alternative to the no longer possible double-click on tab)\n- a keyboard shortcut\n- a click on the pin icon on browser toolbar";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };
  "pronoundb" = buildFirefoxXpiAddon {
    pname = "pronoundb";
    version = "0.10.0";
    addonId = "firefox-addon@pronoundb.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4000981/pronoundb-0.10.0.xpi";
    sha256 = "7af3a69e9d5aad03d5efe2025f5ee53d1d34148d468eecfb3230d0aa117c6552";
    meta = with lib; {
      homepage = "https://pronoundb.org";
      description = "PronounDB is a browser extension that helps people know each other's pronouns easily and instantly. Whether hanging out on a Twitch chat, or on any of the supported platforms, PronounDB will make your life easier.";
      license = licenses.bsd2;
      platforms = platforms.all;
    };
  };
  "svg-export" = buildFirefoxXpiAddon {
    pname = "svg-export";
    version = "2.2.17";
    addonId = "{605a075b-09d9-4443-bed6-4baa743f7d79}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3811409/svg_export-2.2.17.xpi";
    sha256 = "387907b29ff3ff38e8311a5a729c04ad96ace6fb4a44122369e4bcb024879869";
    meta = with lib; {
      homepage = "https://svgexport.io/";
      description = "Download SVGs from websites as SVGs, PNGs or JPEGs";
      platforms = platforms.all;
    };
  };
  "ttv-lol" = buildFirefoxXpiAddon {
    pname = "ttv-lol";
    version = "0.0.0.5";
    addonId = "{f4461878-c744-4acf-871a-8311588d35ce}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3764747/ttv_lol-0.0.0.5.xpi";
    sha256 = "36e7c5c96f5ecea799ad7d775d89282339074911ef71aae3c08c6233199d4ef8";
    meta = with lib; {
      description = "TTV LOL removes Livestream ads from your favorite streaming site.";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };
  "twitch-points-autoclicker" = buildFirefoxXpiAddon {
    pname = "twitch-points-autoclicker";
    version = "1.6.1";
    addonId = "{3c9b993f-29b9-44c2-a913-def7b93a70b1}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3708590/twitch_points_autoclicker-1.6.1.xpi";
    sha256 = "cfbbe478452d45d17e6b37fe277d5eee297549e6bfb46479aa876f43baf7ee9e";
    meta = with lib; {
      description = "Automatically claims 'Channel Points' on Twitch for the channel you are watching.\n\nNote: May not be compatible w/ other twitch extensions.";
      platforms = platforms.all;
    };
  };
  "webnowplaying-companion" = buildFirefoxXpiAddon {
    pname = "webnowplaying-companion";
    version = "0.5.0";
    addonId = "{64b2c525-24ed-4c05-aed1-95ff9e6cef70}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3773165/webnowplaying_companion-0.5.0.xpi";
    sha256 = "ee50dd1b578e502f79ecb8eef2a0d65b57343bf9d2ce11951338d7e46eec170b";
    meta = with lib; {
      homepage = "https://github.com/tjhrulz/WebNowPlaying";
      description = "Ever wished music info from your web browser could be used in Rainmeter? Well now it can!";
      license = licenses.gpl2;
      platforms = platforms.all;
    };
  };
  "youtube-addon" = buildFirefoxXpiAddon {
    pname = "youtube-addon";
    version = "3.935";
    addonId = "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3896635/youtube_addon-3.935.xpi";
    sha256 = "9d68b6d4507e2a8aa0b2b1f6f48f91591d2ff81ea18e773021b1d1da95919ea7";
    meta = with lib; {
      homepage = "https://github.com/code4charity/YouTube-Extension/";
      description = "Make YouTube tidy &amp; powerful! YouTube Player Size Theme Quality Auto HD Colors Playback Speed Style ad block Playlist Channel H.264";
      platforms = platforms.all;
    };
  };
}
