;; -*- lexical-binding: t; -*-

;; ==========================================
;; GLOBAL HOTKEYS FOR NAVIGATION
;; ==========================================

;; Quick jump to the definition (functions, variables, classes)
(global-set-key (kbd "C-c i m") 'imenu)

;; Open the file under the cursor (convenient for #include "files")
(global-set-key (kbd "C-x C-g") 'find-file-at-point)


;; ==========================================
;; CODE EDITING UTILITIES
;; ==========================================

(defun my-duplicate-line ()
  "Duplicates the current line along with the indentation."
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

;; duplicate of the familiar and convenient C-.
(global-set-key (kbd "C-,") 'my-duplicate-line)


;; ==========================================
;; PROJECT NOTES MANAGER (ORG-MODE)
;; ==========================================

(defvar my-project-notes-path "~/misc/notes/projects"
  "The path to the root directory containing the project notes.")

(defun my-pick-project ()
  "Interactive selection of a project from existing folders."
  (let* ((all (directory-files my-project-notes-path nil "^[^.].*"))
         (choices (seq-filter (lambda (f)
                                (file-directory-p (expand-file-name f my-project-notes-path)))
                              all)))
    (completing-read "Choose project: " choices)))

(defun my-create-new-project-note ()
  "Creates a new note in the selected project and opens it."
  (interactive)
  (let* ((project-name (my-pick-project))
         (note-name (read-string "Note name: "))
         (full-path (expand-file-name (format "%s/%s.org" project-name note-name)
                                      my-project-notes-path)))
    ;; We create the project folder if it doesn’t exist
    (make-directory (file-name-directory full-path) t)
    ;; Open the file in a separate window
    (find-file-other-window full-path)
    (org-mode)))

;; Calling up the note creation menu
(global-set-key (kbd "C-c n p") 'my-create-new-project-note)


;; inform Emacs that the file has been successfully loaded.
(provide 'my-workflows)
