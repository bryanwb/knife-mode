;; knife-mode.el
;; Copyright Bryan W. Berry (<bryan.berry@gmail.com>), 2012
;; Apache 2.0 license
;;

(defun get-item-after (myitem myitems)
  "gets item after myitem"
  (cadr (member myitem myitems)))

(defun process-cmd (cmd)
  (defun process-exitcode (code) (if (= code 0)
      (message "command completed successfully")
    (message (format "command unsuccessfully with exitcode %s" code))
    ))
  (process-exitcode (shell-command cmd))
  )

(defun get-cookbook-path ()
  (setq cookbook-path (split-string (buffer-file-name) "/" t))
  (setq cookbook-index
        (+ 1 (position 
              (get-item-after "cookbooks" cookbook-path) cookbook-path)
              ))
  (concat "/" 
          (mapconcat 'identity
                     (subseq cookbook-path 0 cookbook-index)
                     "/"))
  )

(defun knife-cookbook-test ()
  "runs knife cookbook test on the current cookbook"
  (interactive)
  (save-some-buffers t)
  (setq cookbook-path (get-cookbook-path))
  (shell-command (format "knife cookbook test %s &" cookbook-path))
  )

(defun knife-cookbook-foodcritic ()
  "runs knife cookbook test on the current cookbook"
  (interactive)
  (save-some-buffers t)
  (message (format "foodcritic %s &" (get-cookbook-path)))
  (shell-command 
   (format "foodcritic %s &" (get-cookbook-path))))
                 


(defun knife-load-cookbook (cookbook-path)
  (setq cookbook-name (get-item-after "cookbooks" cookbook-path))
  (process-cmd (format "knife cookbook upload %s" cookbook-name))
  )

(defun knife-load-role ()
  (process-cmd 
   (format "knife role from file %s" (buffer-file-name)
           )))

(defun knife-load-environment ()
  (process-cmd 
   (format "knife environment from file %s" (buffer-file-name)
           )))

(defun knife-load-data-bag ()
  (setq data-bag-path-list (split-string (buffer-file-name) "/" t))
  (setq bag-name (get-item-after "data_bags" data-bag-path-list))
  (setq bag-item (car (last data-bag-path-list)))
  (message (format "knife data bag from file %s %s" bag-name bag-item))
  (process-cmd (format "knife data bag from file %s %s" bag-name bag-item)))
                    
(defun knife-from-file ()
  "Load a cookbook, environment, role, or databag from file.
   All open buffers are saved, then this command parses the filename
   for the current buffer."
  (interactive)
  (save-some-buffers t)
  (setq knife-types '("data_bags" "cookbooks" "environments" "roles"))
  (setq knife-path-list (split-string (buffer-file-name) "/" t))
  ;;(setq knife-path-list '("home" "hitman" "chef-repo" "roles" "environment.rb"))
  ;;(setq knife-path-list '("home" "hitman" "chef-repo" "cookbooks" "java" "recipes" "default.rb"))
  (setq knife-type 
        (find-if 
         (lambda (x)
           (member x knife-path-list)) 
         knife-types))
  (cond 
   ((equal knife-type "cookbooks")(knife-load-cookbook knife-path-list))
   ((equal knife-type "roles")(knife-load-role))
   ((equal knife-type "environments")(knife-load-environment))
   ((equal knife-type "data_bags")(knife-load-data-bag))
   )
  )

(provide 'knife)



