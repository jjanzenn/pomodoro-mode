;; pomodoro-mode.el --- Introduces a pomodoro timer to your mode-line -*- lexical-binding: t -*-
;; Copyright (C) 2025 jjanzen
;; Author: j. janzen <jjanzen@jjanzen.ca>
;; Version: 0.2
;; Package-Requires: ()
;; Keywords: productivity, convenience

;;; Commentary:
;; This package provides a minor mode to add a simple pomodoro timer to your mode-line.
;; To activate it, run `M-x pomodoro-mode`.
;; To turn it off, run `M-x pomodoro-mode` once again.

;;;###autoload
(defgroup pomodoro nil
  "Pomodoro timer"
  :group 'convenience)

;;;###autoload
(defcustom pomodoro-start-time 0
  "When the current pomodoro break/work session has begun"
  :type '(integer)
  :group 'pomodoro)

;;;###autoload
(defcustom pomodoro-state 'working
  "The current pomodoro state"
  :type '(working break)
  :group 'pomodoro)

;;;###autoload
(defcustom pomodoro-work-time (* 25 1)
  "The length of a pomodoro work session in seconds"
  :type '(integer)
  :group 'pomodoro)

;;;###autoload
(defcustom pomodoro-break-time (* 5 1)
  "The length of a pomodoro break session in seconds"
  :type '(integer)
  :group 'pomodoro)

;;;###autoload
(defcustom pomodoro-work-symbol "🍅"
  "The symbol to display while in a work session"
  :type '(string)
  :group 'pomodoro)

;;;###autoload
(defcustom pomodoro-break-symbol "🥫"
  "The symbol to display while in a break session"
  :type '(string)
  :group 'pomodoro)

;;;###autoload
(defun pomodoro-toggle-state ()
  "Restart the pomodoro timer and switch to the other state."
  (interactive)
  (cond ((equal pomodoro-state 'working)
         (setq pomodoro-state 'break))
        ((equal pomodoro-state 'break)
         (setq pomodoro-state 'working))
        (t
         (user-error "Invalid pomodoro state")))
  (setq pomodoro-start-time (floor (float-time))))

(defun pomodoro-get-status-string ()
  "Get the status string for the pomodoro timer. May update the state if necessary."
  (let ((curr-time) ;; the current Unix time
        (symbol)    ;; the symbol to be displayed
        (delta)     ;; the difference in time
        (max-time)  ;; the maximum time that can be represented in the current state
        (minutes)   ;; the number of minutes to display
        (seconds))  ;; the number of seconds to display


    ;; check how far into the countdown we are
    (setq curr-time (floor (float-time)))
    (setq delta (- curr-time pomodoro-start-time))
    (cond ((equal pomodoro-state 'working)
           (setq symbol pomodoro-work-symbol)
           (setq max-time pomodoro-work-time))
          ((equal pomodoro-state 'break)
           (setq symbol pomodoro-break-symbol)
           (setq max-time pomodoro-break-time))
          (t
           (setq symbol "")
           (setq max-time 0)))
    (if (>= delta max-time)
        (setq delta max-time))
    (setq delta (- max-time delta))

    ;; Get the time in minutes and seconds
    (setq minutes (/ delta 60))
    (setq seconds (% delta 60))

    ;; Changing state here kinda violates the single-responsibility principle,
    ;; but this also prevents me from needing to work with timers which might
    ;; just be worse that a function that does more than one thing.
    (if (<= delta 0)
        (progn
          (setq delta 0)
          (pomodoro-toggle-state)))

    (format " %s (%02d:%02d)" symbol minutes seconds)))

(define-minor-mode pomodoro-local-mode
  "Run a pomodoro timer. Use pomodoro-mode instead of this."
  :init-value nil
  :group 'pomodoro
  :lighter (:eval (pomodoro-get-status-string)))

;;;###autoload
(define-globalized-minor-mode pomodoro-mode
  pomodoro-local-mode pomodoro-local-mode
  "Initialize pomodoro-mode in all buffers"
  :group 'pomodoro
  (setq pomodoro-state 'working)
  (setq pomodoro-start-time (floor (float-time))))

(provide 'pomodoro-mode)
