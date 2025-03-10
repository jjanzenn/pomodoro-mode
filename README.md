# pomodoro-mode

Add a simple [pomodoro](https://en.wikipedia.org/wiki/Pomodoro_Technique) timer to your Emacs mode-line.

Defaults to `🍅 (MM:SS)` when working and `🥫 (MM:SS)` when taking a break.

## Installation

The package can be manually installed by saving `pomodoro-mode.el` to `~/emacs.d/` or wherever your emacs configuration is stored and load the package with
```cl
(add-to-list 'load-path "~/.emacs.d/") ; Adjust this path if necessary

(require 'pomodoro-mode)
```

In Emacs 30.1 and above, `use-package` works well with version control, allowing the following
```cl
(use-package pomodoro-mode
  :ensure (pomodoro-mode :host github :repo "jjanzenn/pomodoro-mode"))
```

## Usage

- Start a pomodoro session with `M-x pomodoro-mode`.
- Stop a pomodoro session with `M-x pomodoro-mode`.
- Move to the next work or break period with `M-x pomodoro-toggle-state`.

## Customization

This is a simple package that doesn't do much. That being said, you can customize some aspects of the mode:
- `pomodoro-work-time`: the number of seconds in a work session; defaults to 1500 (25 minutes)
- `pomodoro-break-time`: the number of seconds in a break session; defaults to 300 (5 minutes)
- `pomodoro-work-symbol`: the string to display while in a work session; defaults to 🍅
- `pomodoro-break-symbol`: the string to display while in a break session; defaults to 🥫

These can be customized with `M-x customize-group` in the `pomodoro` group. Alternatively, you can modify your `init.el` file to set the variables with `setq`.

## Contributing

Feel free to publish issues or create pull requests if you have suggestions on how to improve this package.

## License

Distributed under the GNU General Public License v3.0. See `LICENSE` for more information.
