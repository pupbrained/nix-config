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
    version = "2.0.1";
    addonId = "{e58d3966-3d76-4cd9-8552-1582fbc800c1}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4044701/buster_captcha_solver-2.0.1.xpi";
    sha256 = "9910d2d0add8ba10d7053fd90818e17e6d844050c125f07cb4e4f5759810efcf";
    meta = with lib; {
      homepage = "https://github.com/dessant/buster#readme";
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
    version = "1.26.0";
    addonId = "{74145f27-f039-47ce-a470-a662b129930a}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4032442/clearurls-1.26.0.xpi";
    sha256 = "222ce5056b79db8d3b574a98ce359902786a6cbb3939ddace254ed15688cee55";
    meta = with lib; {
      homepage = "https://clearurls.xyz/";
      description = "Removes tracking elements from URLs";
      license = licenses.lgpl3;
      platforms = platforms.all;
    };
  };
  "darkreader" = buildFirefoxXpiAddon {
    pname = "darkreader";
    version = "4.9.61";
    addonId = "addon@darkreader.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4051026/darkreader-4.9.61.xpi";
    sha256 = "376a195a30de305c5e8afc5e6a365af5812c1219cac7d05c08459edf260bf3fb";
    meta = with lib; {
      homepage = "https://darkreader.org/";
      description = "Dark mode for every website. Take care of your eyes, use dark theme for night and daily browsing.";
      license = licenses.mit;
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
  "don-t-fuck-with-paste" = buildFirefoxXpiAddon {
    pname = "don-t-fuck-with-paste";
    version = "2.7";
    addonId = "DontFuckWithPaste@raim.ist";
    url = "https://addons.mozilla.org/firefox/downloads/file/3630212/don_t_fuck_with_paste-2.7.xpi";
    sha256 = "ef17dcef7e2034a25982a106e54d19e24c9f226434a396a808195ef0de021a40";
    meta = with lib; {
      homepage = "https://github.com/aaronraimist/DontFuckWithPaste";
      description = "This add-on stops websites from blocking copy and paste for password fields and other input fields.";
      license = licenses.mit;
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
    version = "1.1.0";
    addonId = "idcac-pub@guus.ninja";
    url = "https://addons.mozilla.org/firefox/downloads/file/4035245/istilldontcareaboutcookies-1.1.0.xpi";
    sha256 = "4d1d2dfa04095eec4157399effa9d60ed16e4349c1a8230d58ef90e47592de7f";
    meta = with lib; {
      homepage = "https://github.com/OhMyGuus/I-Dont-Care-About-Cookies";
      description = "Community version of the popular extension \"I don't care about cookies\"  \n\n<a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/d899243c3222e303a4ac90833f850da61cdf8f7779e2685f60f657254302216d/https%3A//github.com/OhMyGuus/I-Dont-Care-About-Cookies\" rel=\"nofollow\">https://github.com/OhMyGuus/I-Dont-Care-About-Cookies</a>";
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
  "new-tab-override" = buildFirefoxXpiAddon {
    pname = "new-tab-override";
    version = "15.1.1";
    addonId = "newtaboverride@agenedia.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/3782413/new_tab_override-15.1.1.xpi";
    sha256 = "74d97de74c1d4d5cc146182dbbf9cdc3f383ba4c5d1492edbdb14351549a9d64";
    meta = with lib; {
      homepage = "https://www.soeren-hentzschel.at/firefox-webextensions/new-tab-override/";
      description = "New Tab Override allows you to set the page that shows whenever you open a new tab.";
      license = licenses.mpl20;
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
    version = "0.11.5";
    addonId = "firefox-addon@pronoundb.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4051035/pronoundb-0.11.5.xpi";
    sha256 = "b2a261a31e9fcff9b13ef4bee9224cc0b4dcdcc85f14c2f3705c38bb18a4cd24";
    meta = with lib; {
      homepage = "https://pronoundb.org";
      description = "PronounDB is a browser extension that helps people know each other's pronouns easily and instantly. Whether hanging out on a Twitch chat, or on any of the supported platforms, PronounDB will make your life easier.";
      license = licenses.bsd2;
      platforms = platforms.all;
    };
  };
  "react-devtools" = buildFirefoxXpiAddon {
    pname = "react-devtools";
    version = "4.27.1";
    addonId = "@react-devtools";
    url = "https://addons.mozilla.org/firefox/downloads/file/4040280/react_devtools-4.27.1.xpi";
    sha256 = "c0cf290a4dab2d18f840d7267da68033779bb3a001986aed2a78ed5e92432a1e";
    meta = with lib; {
      homepage = "https://github.com/facebook/react";
      description = "React Developer Tools is a tool that allows you to inspect a React tree, including the component hierarchy, props, state, and more. To get started, just open the Firefox devtools and switch to the \"⚛️ Components\" or \"⚛️ Profiler\" tab.";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
  "return-youtube-dislikes" = buildFirefoxXpiAddon {
    pname = "return-youtube-dislikes";
    version = "3.0.0.7";
    addonId = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4032427/return_youtube_dislikes-3.0.0.7.xpi";
    sha256 = "343f9b966ad7c0341f46e94892f811623190529d964b6d6cdddbe8da96b653ec";
    meta = with lib; {
      description = "Returns ability to see dislike statistics on youtube";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };
  "sponsorblock" = buildFirefoxXpiAddon {
    pname = "sponsorblock";
    version = "5.1.11";
    addonId = "sponsorBlocker@ajay.app";
    url = "https://addons.mozilla.org/firefox/downloads/file/4047157/sponsorblock-5.1.11.xpi";
    sha256 = "7762b7b9fbeead69d8573a8b6f247ffcc81e8f26e463d7b18ad01ff5174b351a";
    meta = with lib; {
      homepage = "https://sponsor.ajay.app";
      description = "Easily skip YouTube video sponsors. When you visit a YouTube video, the extension will check the database for reported sponsors and automatically skip known sponsors. You can also report sponsors in videos.\n\nOther browsers: https://sponsor.ajay.app";
      license = licenses.lgpl3;
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
  "ublock-origin" = buildFirefoxXpiAddon {
    pname = "ublock-origin";
    version = "1.46.0";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4047353/ublock_origin-1.46.0.xpi";
    sha256 = "6bf8af5266353fab5eabdc7476de026e01edfb7901b0430c5e539f6791f1edc8";
    meta = with lib; {
      homepage = "https://github.com/gorhill/uBlock#ublock-origin";
      description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };
  "unpaywall" = buildFirefoxXpiAddon {
    pname = "unpaywall";
    version = "3.98";
    addonId = "{f209234a-76f0-4735-9920-eb62507a54cd}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3816853/unpaywall-3.98.xpi";
    sha256 = "6893bea86d3c4ed7f1100bf0e173591b526a062f4ddd7be13c30a54573c797fb";
    meta = with lib; {
      homepage = "https://unpaywall.org/products/extension";
      description = "Get free text of research papers as you browse, using Unpaywall's index of ten million legal, open-access articles.";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
  "vimium-ff" = buildFirefoxXpiAddon {
    pname = "vimium-ff";
    version = "1.67.6";
    addonId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4046008/vimium_ff-1.67.6.xpi";
    sha256 = "e8d6c98842bd7221d62d1079e4153e3e0d20c5ca5412316dd71cb5c3bdb7d457";
    meta = with lib; {
      homepage = "https://github.com/philc/vimium";
      description = "The Hacker's Browser. Vimium provides keyboard shortcuts for navigation and control in the spirit of Vim.\n\nThis is a port of the popular Chrome extension to Firefox.\n\nMost stuff works, but the port to Firefox remains a work in progress.";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
  "violentmonkey" = buildFirefoxXpiAddon {
    pname = "violentmonkey";
    version = "2.13.5";
    addonId = "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4050539/violentmonkey-2.13.5.xpi";
    sha256 = "219080699af452a1de3d01f0adbbb6c9cebf789a956ab18422a708cf1d3b73f8";
    meta = with lib; {
      homepage = "https://violentmonkey.github.io/";
      description = "Violentmonkey provides userscripts support for browsers.\nIt's open source! <a rel=\"nofollow\" href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/c8bcebd9a0e76f20c888274e94578ab5957439e46d59a046ff9e1a9ef55c282c/https%3A//github.com/violentmonkey/violentmonkey\">https://github.com/violentmonkey/violentmonkey</a>";
      license = licenses.mit;
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
