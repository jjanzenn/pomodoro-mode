# pomodoro-mode

Add a simple [pomodoro](https://en.wikipedia.org/wiki/Pomodoro_Technique) timer to your Emacs mode-line. To run the timer, type `M-x pomodoro-mode`. To stop the timer, type `M-x pomodoro-mode` once again. The package is not on Melpa, but it is relatively easy to install in Emacs 30.1 with
```cl
(use-package pomodoro-mode
  :ensure (pomodoro-mode :host github :repo "jjanzenn/pomodoro-mode"))
```
