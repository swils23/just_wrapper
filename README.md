<div align=right>Table of Contents↗️</div>

<div align="center">
    <h3 align="center">Just Wrapper</h3>
    <p align="center">
        A wrapper for <a href="https://github.com/casey/just">Just</a>, enabling custom commands without the need to write, modify, or extend a Justfile.
    </p>
</div>


## About The Project
`just_wrapper` is a wrapper for the `just` command in the form of a [custom Zsh plugin](https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#adding-a-new-plugin). This plugin enables the use of custom commands without the need to write, modify, or extend a Justfile. This is useful for adding commands that you don't want to add to a project's Justfile, or for adding global commands that don't require the presence of a Justfile.


### Built With
* [![Zsh][ZSH-logo]][ZSH-url]
* [![Bash][Bash-logo]][Bash-url]


## Getting Started
To install the `just_wrapper` plugin, follow these simple steps.

### Prerequisites
`just_wrapper` requires the following to work:

* Zsh ([Install](https://ohmyz.sh/#install))
* Just ([Install](https://github.com/casey/just#installation))

### Installation
1. Install the plugin
    ```sh
    bash <(curl -s https://raw.githubusercontent.com/swils23/just_wrapper/main/install_script) "$ZSH_CUSTOM"
    ```
2. (Optional) Alias `just` to `just_wrapper` by adding the following line in `~/.zshrc`:
    ```sh
    alias just=just_wrapper
    ```
3. Finally, reload your shell by running
    ```sh 
    exec $SHELL
    ```

<details>
  <summary>Manual Installation</summary>
  1. TODO
</details>


## Usage
`just_wrapper` comes with a few built-in commands that can be used globally. These commands are:

* `just_wrapper_edit` - Opens VS Code in the commands directory
* `just_wrapper_reload` - Reloads the shell to apply changes
* `just_wrapper_update` - Updates the plugin to the latest version


### Adding Custom Commands
All commands are in the `$ZSH_CUSTOM/plugins/just_wrapper/commands/` directory.
```
$ZSH_CUSTOM/plugins/just_wrapper/commands/
├── .commands - (add simple commands here by defining new functions)
├── example_command - (add more complex commands here as script files)
└── ...more scripts here
```

You can add custom commands to `just_wrapper` in two ways:
- Defining functions in the `.commands` file
    ```sh
        # define commands here

        function custom_command() {
            echo "This is a custom command"
        }

        # ...
    ```

- Adding scripts to the commands directory
    
These can all be called using `just_wrapper <command>`
```
~ ➜ just_wrapper custom_command
This is a custom command
```


## Planned Features
- [ ] Project-specific commands (i.e. multiple `just download_db` that are specific to different projects)
- [ ] Get aliases from `~/.zshrc` working
- [ ] Recursion for nested `just_wrapper` commands
- [ ] Interactive installer to set up `just_wrapper` and aliases
- [ ] Versioning
    - [ ] `just_wrapper --version` or `just_wrapper just_wrapper_version`
- [ ] Handle scripts ending in `.sh`

See the [open issues](https://github.com/swils23/just_wrapper/issues) for a full list of proposed features (and known issues).


## License
![License][license-img]


## Contact
Sam Wilson - [sam@swils.dev](mailto:sam@swils.dev)


[license-img]: images/LICENSE.jpg

[ZSH-url]: https://ohmyz.sh/
[ZSH-logo]: https://img.shields.io/badge/Zsh-1A2C34?style=for-the-badge&logo=gnu-bash&logoColor=white

[Bash-url]: https://www.gnu.org/software/bash/
[Bash-logo]: https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white
