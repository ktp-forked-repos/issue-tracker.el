(defun issue-tracker-share-str (msg)
  (kill-new msg)
  (with-temp-buffer
    (insert msg)
    (shell-command-on-region (point-min) (point-max)
                             (cond
                              ((eq system-type 'cygwin) "putclip")
                              ((eq system-type 'darwin) "pbcopy")
                              (t "xsel -ib")
                              )))
  )

(defun issue-tracker-bounds-of-bigword-under-cursor ()
  (interactive)
  (let ((big-word-chars " \t\r\n")
        (old-position (point))
        (b (line-beginning-position))
        (e (line-end-position)))
    (re-search-backward "[ \t\r\n]" nil t)
    (goto-char (+ (point) 1))
    (setq b (point))
    (re-search-forward "[ \t\r\n]" nil t)
    (goto-char (- (point) 1))
    (setq e (point))
    ;; restore the position
    (goto-char old-position)
    ;; (message "b=%d e=%d" b e)
    (list b e)
    ))

(defun issue-tracker-increment-issue-id-under-cursor ()
  (interactive)
  (let ((bounds (issue-tracker-bounds-of-bigword-under-cursor))
        ;; (id (buffer-substring (car bounds) (nth 1 bounds)))
        id
        nid
        num)
    (setq id (buffer-substring (car bounds) (nth 1 bounds)))
    ;; get symbol under cursor
    (if (string-match "^\\(.*[^0-9]\\)\\([0-9]+\\)$" id)
        (progn
          (setq nid (match-string 1 id))
          (setq num (string-to-number (match-string 2 id)))
          (setq num (+ num 1))
          (setq nid (concat nid (number-to-string num)))
          (issue-tracker-share-str nid)
          ;; change current issue id under cursor into new id
          (delete-region (car bounds) (nth 1 bounds))
          (insert nid)
          (goto-char (car bounds))
          )
      (message "INVALID issue id under cursor! It must ends with digits.")
      )
    ))