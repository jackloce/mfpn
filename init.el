;; 设置垃圾回收，在 Windows 下，emacs25 版本会频繁出发垃圾回收，所以需要设置
(when (eq system-type 'windows-nt) 
(setq gc-cons-threshold (* 512 1024 1024)) 
(setq gc-cons-percentage 0.5) 
(run-with-idle-timer 5 t #'garbage-collect)
;; 显示垃圾回收信息，这个可以作为调试用;; 
(setq garbage-collection-messages t))

;;设置默认路径
(setq default-directory "D:/project/EmacsProject/flower/")

;; Setting English Font
(set-face-attribute 'default nil :font "Courier New-14")
;; Setting Chinese Font
(dolist (charset '(kana han symbol cjk-misc bopomofo))
(set-fontset-font (frame-parameter nil 'font)
charset
(font-spec :family "Microsoft Yahei" :size 16)))

;; emacs python
(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein
    elpy
    flycheck
    material-theme
    py-autopep8))

(mapc #'(lambda (package)
 	(unless (package-installed-p package)
     (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; PYTHON CONFIGURATION
;; --------------------------------------

(elpy-enable)

;; (pyvenv-activate "D:/Anaconda3")
;; (setq python-shell-interpreter "D:/Anaconda3/python.exe")
;; (setq python-python-command "D:/Anaconda3/python.exe")
;; (setenv "WORKON_HOME" "D:/Anaconda3/envs")
;; (pyvenv-mode 1)

(setq python-shell-interpreter "D:/Anaconda3/python.exe"
      python-shell-interpreter-args "-i")
;; 修复解释器不能用的bug
(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))
(setq python-shell-completion-native-disabled-interpreters '("python"))
;; (setq python-shell-interpreter "ipython"
;;      python-shell-interpreter-args "-i --simple-prompt")

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; autocomplate
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)



;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (w3m neotree jedi-direx autopair anaconda-mode jedi py-autopep8 material-theme flycheck elpy ein better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Make C-c C-c behave like C-u C-c C-c in Python mode
(require 'python)
(define-key python-mode-map (kbd "C-c C-c")
  (lambda () (interactive) (python-shell-send-buffer t)))

(global-set-key (kbd "<f5>") (kbd "C-u C-c C-c"))

(add-hook 'python-mode-hook 'anaconda-mode)

;; autopair
(require 'autopair)
(autopair-global-mode)

;;view Python code (right) in a tree style viewer (left)
(eval-after-load "python"
  '(define-key python-mode-map "\C-cx" 'jedi-direx:pop-to-buffer))
(add-hook 'jedi-mode-hook 'jedi-direx:setup)

;; tree mode
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
