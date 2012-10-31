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
(provide 'go-compile)
