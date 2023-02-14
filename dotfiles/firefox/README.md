<div align="center">

![Firefox Onebar](https://codeberg.org/Freeplay/pages/raw/branch/master/project-assets/onebar/images/header.png)
<a href="https://nogithub.codeberg.page"><img src="https://nogithub.codeberg.page/badge.svg" alt="Please don't upload to GitHub"></a>

<br>

<details>
<summary>

## What can it do?

</summary>

<br><br>

|

![Singe Tab as Titlebar](https://codeberg.org/Freeplay/pages/raw/commit/64d54ae2fd3bade136399d129f3edc31d171e763/project-assets/onebar/images/single-tab.png) 

| ![Small Windows](https://codeberg.org/Freeplay/pages/raw/commit/64d54ae2fd3bade136399d129f3edc31d171e763/project-assets/onebar/images/small-windows-1.png) | ![](https://codeberg.org/Freeplay/pages/raw/commit/64d54ae2fd3bade136399d129f3edc31d171e763/project-assets/onebar/images/small-windows-2.png) |
|--|--|

![Centered Search](https://codeberg.org/Freeplay/pages/raw/commit/64d54ae2fd3bade136399d129f3edc31d171e763/project-assets/onebar/images/search.png)

| ![Works with _almost_ all customizations](https://codeberg.org/Freeplay/pages/raw/commit/64d54ae2fd3bade136399d129f3edc31d171e763/project-assets/onebar/images/customizations.png) |
|--|

</details>

<br>

|

<br>

# Installation

</div>

**NOTES:** Currently, this has only been tested on Gnome Linux. However, it does seem to work fine for others. [**It is also possible to install with Firefox UI Fix**](#use-with-firefox-ui-fix)


#### In Firefox
- Firstly, make sure you are on the latest firefox stable version. ESR & other editions may not work as intended.
1. Visit `about:config` 
    - Search for `toolkit.legacyUserProfileCustomizations.stylesheets`, set it to **true**
    - While you're here, [you can enable other customizations you may want here](#customizations)
2. Visit `about:support`
3. In the `Profile Directory` row, copy the full path
    - May look something _like_: `/home/{username}/.mozilla/firefox/...`

#### Then, in a Terminal
```sh
cd #paste the path you copied before here

git clone https://codeberg.org/Freeplay/firefox-onebar.git chrome
```

#### OR, to add it manually:
1. Go to the path you copied before in your file explorer
2. If there is no `chrome` folder, create one
3. Then, inside the `chrome` folder, create a file called `userChrome.css`
    - Copy & Paste the contents of [`userChrome.css`](https://codeberg.org/Freeplay/Firefox-Onebar/raw/branch/main/userChrome.css) into the file

#### Restart Firefox, and enjoy :)

<br>

## Updating
#### If you used the Terminal Method:
```sh
cd #the path you copied before

cd chrome && git pull
```
#### If you've added it manually:
1. Go to the path you copied before
2. Enter the `chrome` folder
3. Copy & paste the contents of [`userChrome.css`](https://codeberg.org/Freeplay/Firefox-Onebar/raw/branch/main/userChrome.css) into the file

#### Then, restart Firefox.

<br>


## Customizations
1. Copy the preference name of the customization you want to enable from the table below
2. Visit `about:config`
3. Paste the preference name into the search bar
4. Click the plus button at the bottom right
#### Then, restart Firefox.

<br>

| Customization | Preference Name |
|--|--|
| Disable autohiding of URLbar icons (prevents movement of URLbar) | `onebar.disable-autohide-of-URLbar-icons` |
| Disable single-tab styling | `onebar.disable-single-tab` |
| Hide navigation buttons | `onebar.hide-navigation-buttons` |

<br>

## Use with [Firefox UI Fix](https://github.com/black7375/Firefox-UI-Fix/tree/proton-style):

1. Install the [**Proton-style**](https://github.com/black7375/Firefox-UI-Fix/tree/proton-style#installation-guide) version of the Firefox UI fix **first**
2. Once that is done, visit `about:support`
3. In the `Profile Directory` row, click "Open Directory"
4. Enter the `chrome` folder
5. Locate & open the `userChrome.css` file
6. Copy & paste the contents of [`userChrome.css`](https://codeberg.org/Freeplay/Firefox-Onebar/raw/branch/main/userChrome.css) **at the end of the file**

#### Then, restart Firefox.

<br><br>
<div align="center">
<details>
<summary>🍓</summary>
Although I'm definitely lower priority than some others...<br>If you support my work and can actually afford to, 

[**you can donate to me here :)**](https://www.buymeacoffee.com/freeplay)


</details>
</div>
