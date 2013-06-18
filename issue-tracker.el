(defun issue-uid-increment-jira-id ()
  (interactive)
  (let ((id (thing-at-point 'symbol)))
    ;; get symbol under cursor
    (string-match ".*-[0-9]+" "hello-912")
    (message "str=%s" (match 0))
    (match-end 1)
    (message "id=%s" id)
    ))
