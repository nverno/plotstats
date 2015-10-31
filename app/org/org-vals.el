;;; org-vals.el --- 
;; Filename: org-vals.el
;; Description: 
;; Author: Noah Peart
;; Created: Mon Oct 26 21:13:26 2015 (-0400)
;; Last-Updated: Sat Oct 31 02:02:59 2015 (-0400)
;;           By: Noah Peart
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ox-publish)

(setq projdir
      (cond
       ((string-equal system-type "windows-nt")
	"C:/home/work/plotstats/app/org/")
       (t "~/work/plotstats/app/org")))
(setq htmldir
      (cond
       ((string-equal system-type "windows-nt")
	"C:/home/work/plotstats/app/www/org/html/")
       (t "~/work/plotstats/app/www/org/html/")))
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




