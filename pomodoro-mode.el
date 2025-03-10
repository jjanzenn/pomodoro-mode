;; -*- lexical-binding: t -*-

(defvar pomodoro-start-time 0)
(defvar pomodoro-state 'working)
(defconst pomodoro-work-time (* 25 60))
(defconst pomodoro-break-time (* 5 60))
(defconst pomodoro-work-symbol "🍅")
(defconst pomodoro-break-symbol "🥫")

(defgroup pomodoro nil
  "Pomodoro timer"
  :group 'convenience)

(defun pomodoro-get-status-string ()
  (defvar pomodoro-curr-time)
  (defvar pomodoro-symbol)
  (defvar pomodoro-delta)
  (defvar pomodoro-max-time)
  (defvar pomodoro-minutes)
  (defvar pomodoro-seconds)

  (setq pomodoro-curr-time (floor (float-time)))
  (setq pomodoro-delta (- pomodoro-curr-time pomodoro-start-time))
  (cond ((equal pomodoro-state 'working)
         (setq pomodoro-symbol pomodoro-work-symbol)
         (setq pomodoro-max-time pomodoro-work-time))
        ((equal pomodoro-state 'break)
         (setq pomodoro-symbol pomodoro-break-symbol)
         (setq pomodoro-max-time pomodoro-break-time))
        (t
         (setq pomodoro-symbol "")
         (setq pomodoro-max-time 0)))
  (if (>= pomodoro-delta pomodoro-max-time)
      (setq pomodoro-delta 0)
    (setq pomodoro-delta (- pomodoro-max-time pomodoro-delta)))
  (setq pomodoro-minutes (/ pomodoro-delta 60))
  (setq pomodoro-seconds (% pomodoro-delta 60))

  (if (= pomodoro-delta 0)
      (progn
        (cond ((equal pomodoro-state 'working)
               (setq pomodoro-state 'break))
              ((equal pomodoro-state 'break)
               (setq pomodoro-state 'working))
              (t (message "should not occur")))
        (setq pomodoro-start-time (floor (float-time)))))
  (format " %s (%02d:%02d)" pomodoro-symbol pomodoro-minutes pomodoro-seconds))

(progn
  (setq pomodoro-start-time (- (floor (float-time)) 100))
  (pomodoro-get-status-string))

(define-minor-mode pomodoro-mode
  "run a pomodoro timer"
  :init-value nil
  :lighter (:eval (pomodoro-get-status-string)))

(define-globalized-minor-mode global-pomodoro-mode
  pomodoro-mode pomodoro-mode
  (setq pomodoro-state 'working)
  (setq pomodoro-start-time (floor (float-time))))
