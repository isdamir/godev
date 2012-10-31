;;; godev.el --- Golang simple dev tool

;; Copyright (C) 2012 <iscode@qq.com>

;; Author: YuFeng <iscode@qq.com>
;; Created: 10 Mar 2012
;; Version: 0.1
;; Keywords: tools

;; This file is not (yet) part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;; 设置默认编码,Golang必须使用utf-8
(when (not (and is-after-emacs-23 window-system))
  (set-language-environment 'utf-8))
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
;;GO模式
(require 'go-mode)
(require 'go-mode-load)
;;自动补全
(require 'go-autocomplete)

;;使用智能编译
(defun gud-run-auto ()
"如果没有运行则运行,否则继续"
    (interactive)
    (gud-call (if gdb-active-process "continue" "run") "")
)

;;;###autoload
(defun go-tool-compile() "编译golang" 
            (interactive)
            (set (make-local-variable 'compile-command) "go build -o debug")
            (setq compilation-read-command nil);;无需确认
            (compile compile-command)
            (setq not-yet nil)
)
;;;###autoload
(defun go-tool-run() "运行golang"
            (interactive)
            (go-tool-getRunPath)
            (setq compilation-finish-functions 'go-tool-runApp);;设置完成后呼叫函数
            (go-tool-compile)
)
(defun go-tool-runApp(buffer string) "打开调试窗口"
  (if (string-match "finished" string);;成功后执行
          (shell-command run-path)
      )
)
;;;###autoload
(defun go-tool-debug() "调试golang" 
  (interactive)
  (go-tool-getRunPath)
  (setq compilation-finish-functions 'go-tool-openGdb);;设置完成后呼叫函数
  (go-tool-compile)
)
(defun go-tool-openGdb(buffer string) "打开调试窗口"
  (gdb (concat "gdb -i=mi " run-path))
)
;;;###autoload
(defun go-tool-make() "编译golang,使用make" 
  (interactive)
  (set (make-local-variable 'compile-command) "make")
  (setq compilation-read-command nil);;无需确认
  (compile compile-command)
  (setq not-yet nil)
)
;;;###autoload
(defun go-tool-format() "格式化golang" 
  (interactive)
  (gofmt)
)
;;;###autoload
(defun go-tool-test(path) "测试golang" ()
  (interactive)
  (shell-command "go test")
)


(defun go-tool-getRunPath() 
  (setq run-path (concat (file-name-directory (buffer-file-name)) "debug"))
)

(defun gud-break-auto ()
"设置/移除断点"
(interactive)
(save-excursion
(if (eq (car (fringe-bitmaps-at-pos (point))) 'breakpoint)
(gud-remove nil)
(gud-break nil))))

(defun gud-kill ()
"退出gdb"
(interactive)
(with-current-buffer gud-comint-buffer (comint-skip-input))
(kill-process (get-buffer-process gud-comint-buffer))
(setq gdb-many-windows t)
)

;;调试界面快捷键
(add-hook 'gdb-mode-hook '(lambda ()
                            (define-key go-mode-map [f5] 'gud-run-auto);;f5没运行就会执行(gud-run)，断点按f5调用(gud-cont)
                            (define-key go-mode-map [S-f5] 'gud-kill);;S-f5退出调试
                            (define-key go-mode-map [f8] 'gud-print);;f8输出变量的值
                            (define-key go-mode-map [C-f8] 'gud-pstar);;C-f8打印出指针对应的值
                            (define-key go-mode-map [f9] 'gud-break-auto);;f9当前f9行没有断点则加入断点,否则移除断点
                            (define-key go-mode-map [f10] 'gud-next);;f10单步执行
                            (define-key go-mode-map [C-f10] 'gud-until);;C-f10 一直执行光标位置
                            (define-key go-mode-map [S-f10] 'gud-jump);;S-f10 跳到光标位置，下一次会从光标处执行
                            (define-key go-mode-map [f11] 'gud-step);;f11单步执行，f11会进入函数内部
                            (define-key go-mode-map [C-f11] 'gud-finish);;C-f11跳出当前函数

))
;;编辑模式下快捷键
(add-hook 'go-mode-hook '(lambda ()               
                           (define-key go-mode-map [(f8)] 'go-tool-format)
                           (define-key go-mode-map [(f5)] 'go-tool-run);;f5运行程序
                           (define-key go-mode-map [C-f5] 'go-tool-debug);;C-f5调试程序
                           ;;重置无关绑定
                            (define-key go-mode-map [S-f5] 'not-in-gdb)
                            (define-key go-mode-map [C-f8] 'not-in-gdb)
                            (define-key go-mode-map [f9] 'not-in-gdb)
                            (define-key go-mode-map [f10] 'not-in-gdb)
                            (define-key go-mode-map [C-f10] 'not-in-gdb)
                            (define-key go-mode-map [S-f10] 'not-in-gdb)
                            (define-key go-mode-map [f11] 'not-in-gdb)
                            (define-key go-mode-map [C-f11] 'not-in-gdb)
))
;;启用行号
(global-linum-mode t)
(provide 'godev)
