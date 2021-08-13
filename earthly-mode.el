;;; earthly-mode.el --- Major mode for editing Earthly Earthfile. -*- lexical-binding: t -*-

;; Author: Thanabodee Charoenpiriyakij <wingyminus@gmail.com>
;; URL: https://github.com/wingyplus/earthly-mode
;; Version: 0.1.0
;; Package-Requires: ((emacs "24"))

;; This file is not part of GNU Emacs.

;;; Code:

(defconst earthly-keywords
  '("FROM"
    "RUN"
    "COPY"
    "ARG"
    "SAVE ARTIFACT"
    "SAVE IMAGE"
    "BUILD"
    "VERSION"
    "GIT CLONE"
    "CMD"
    "LABEL"
    "EXPOSE"
    "ENV"
    "ENTRYPOINT"
    "VOLUME"
    "USER"
    "WORKDIR"
    "HEALTHCHECK NONE"
    "HEALTHCHECK CMD"
    "FROM DOCKERFILE"
    "WITH DOCKER"
    "IF"
    "ELSE"
    "ELSE IF"
    "FOR"
    "END"
    "LOCALLY"
    "COMMAND"
    "DO"
    "IMPORT"))

(defun earthly-build-font-lock-keywords ()
  (list
    `(,(rx line-start (*? space) (eval `(or ,@earthly-keywords)) (*? space))
      .
      font-lock-keyword-face)
    `(,(rx
	(sequence "$" (? "{")
		  (+ (in (?A . ?Z) (?a . ?z) (?0 . ?9) ?- ?_))
		  (? "}")))
      .
      font-lock-variable-name-face)
    ;; FOR .. IN ..
    `(,(rx line-start (*? space) (group "FOR") word-boundary (*? (regex ".")) word-boundary (group "IN") word-boundary)
      (1 font-lock-keyword-face)
      (2 font-lock-keyword-face))
    ;; SAVE ARTIFACT .. AS LOCAL ..
    `(,(rx line-start (*? space) (group "SAVE ARTIFACT") word-boundary (*? (regex ".")) word-boundary (group "AS LOCAL") word-boundary)
      (1 font-lock-keyword-face)
      (2 font-lock-keyword-face))))

(defvar earthly-syntax-table
  (let ((syntax-table (make-syntax-table)))
    (modify-syntax-entry ?\# "<" syntax-table)
    (modify-syntax-entry ?\n ">" syntax-table)
    (modify-syntax-entry ?\" "\"" syntax-table)
    (modify-syntax-entry ?\' "\"" syntax-table)
    syntax-table)
  "Syntax table for `earthly-mode'.")

(define-derived-mode earthly-mode prog-mode "Earthly"
  "A major mode for editing Earthly Earthfile."
  :syntax-table earthly-syntax-table
  (setq-local comment-start "#")
  (setq-local comment-end "")
  (setq-local font-lock-defaults '(earthly-build-font-lock-keywords)))

(add-to-list 'auto-mode-alist '("Earthfile\\'" . earthly-mode))

(provide 'earthly-mode)
