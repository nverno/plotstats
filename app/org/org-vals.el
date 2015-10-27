;;; org-vals.el --- 
;; Filename: org-vals.el
;; Description: 
;; Author: Noah Peart
;; Created: Mon Oct 26 21:13:26 2015 (-0400)
;; Last-Updated: Tue Oct 27 03:07:00 2015 (-0400)
;;           By: Noah Peart
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ox-publish)

(setq projdir
      (cond
       ((string-equal system-type "windows-nt")
	"C:/home/work/plotstats/app/org/")
       (t "~/work/plotstats/app/org")))
(setq htmldir (concat projdir "html/"))
(setq theme-file "theme-bigblow.setup")
(setq preamble (prep-org (get-string-from-file theme-file)))

(setq org-publish-project-alist
      `(
	("orgfiles"
	 :auto-sitemap t
	 :html-head ,preamble
	 :sitemap-title "Sitemap"
	 :base-directory ,projdir
	 :base-extenstion "org"
	 :publishing-directory ,htmldir
	 :publishing-function org-html-publish-to-html
	 :recursive t
	 :html-link-home "sitemap.html"
	 :auto-preamble t)

	("plotstats" :components ("orgfiles"))))




