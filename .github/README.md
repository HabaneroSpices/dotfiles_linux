<h1 align="center">Automatic Dotfile Management for Linux</h1>

<div align="center">
	<a href="https://github.com/HabaneroSpices/dotfiles_linux">Home</a>
  <span> • </span>
    	<a href="https://github.com/HabaneroSpices/dotfiles_linux/#getting-started">Install</a>
  <span> • </span>
        <a href="https://github.com/HabaneroSpices/dotfiles_linux/#Key-Features">Features</a>
  <span> • </span>
        <a href="https://github.com/HabaneroSpices/dotfiles_linux/#Acknowledgments">Acknowledgments</a>
  <p></p>
</div> 

<div align="center">

[![Neovim Minimum Version](https://img.shields.io/badge/Neovim-0.9.0-blueviolet.svg?style=flat-square&logo=Neovim&color=90E59A&logoColor=white)](https://github.com/neovim/neovim)

Simplify and streamline the management of your dotfiles on Linux with this powerful automation tool. Organize and synchronize your configuration files effortlessly across multiple Linux distributions, ensuring a consistent and personalized computing environment. Say goodbye to the manual hassle of configuring your system preferences and embrace a more efficient and tailored Linux experience. (_Written by AI_)

</div>

## Screenshots

![billede](https://github.com/HabaneroSpices/dotfiles_linux/assets/45343924/a118736f-c8ee-497c-8200-dfd6eb2a4ebc)

<!--![billede](https://user-images.githubusercontent.com/45343924/210256056-6e899508-3c78-498d-b723-4905ef709b34.png)-->

<details><summary> <b>View more (Click to expand!)</b></summary>
	
![billede](https://github.com/HabaneroSpices/dotfiles_linux/assets/45343924/a3c298fa-92a0-4e52-9e59-0a51a3513d36)

![billede](https://user-images.githubusercontent.com/45343924/212410322-3dd83aca-3541-4246-a7a1-c2db9ed42fa5.png)

</details>

## Key Features:

- Supported Distributions: Debian, Arch Linux
- Seamless Installation: Get up and running quickly with easy-to-follow setup instructions.
- Nerdfont Integration: Enhance your terminal and code editor with Nerdfont support (Recommended: Hack NFM).

## Getting Started

### Requirements
- Any Nerdfont (Recommended: [Hack NFM](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack))

### Installation

#### Debian Instructions:

1. Update your package lists:
```shell
sudo apt update
```

2. Install the required packages:
```bash
sudo apt install -y make git wget curl gh ssh lsb-release fuse libfuse2
```

3. Authenticate with your GitHub account using gh:
```bash
gh auth login
```
>Follow the interactive setup to log in.

4. Clone this repository to your home directory and navigate to it:
```bash
gh repo clone HabaneroSpices/dotfiles_linux ~/.dotfiles && cd ~/.dotfiles
```
5. Run the installation:
```bash
make
```

## Usage

Sync dotfiles to remote (Not Implemented)
```bash
make sync
```

## License

    This project is licensed under the GPL-3.0 License - see the LICENSE.md file for details.

## Acknowledgments

- [khuedoan/dotfiles](https://github.com/khuedoan/dotfiles)
- [NvChad/NvChad](https://github.com/NvChad/NvChad)
