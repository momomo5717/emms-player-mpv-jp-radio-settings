;;; emms-player-mpv-radiru.el --- An emms simple mpv player for らじる★らじる -*- lexical-binding: t -*-

;; Copyright (C) 2015 momomo5717

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by

;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This provides emms-player-mpv-radiru.

;; (require 'emms-player-mpv-radiru)
;; (add-to-list 'emms-player-list 'emms-player-mpv-radiru)

;;; Code:
(require 'emms-player-simple-mpv)
(require 'emms-streams)
(require 'later-do)

(define-emms-simple-player-mpv mpv-radiru '(streamlist)
  "\\`radiru://"
  "mpv" "--no-terminal" "--force-window=no" "--audio-display=no")

(emms-player-simple-mpv-add-to-converters
 'emms-player-mpv-radiru "." t
 'emms-player-mpv-radiru--track-name-to-input-form)

(emms-player-set 'emms-player-mpv-radiru 'get-media-title
                 'emms-player-mpv-radiru--get-media-title)

(defun emms-player-mpv-radiru--loading-message ()
  "Loading message."
  (message "Loading らじる★らじる ... It takes a few seconds."))

(defvar emms-player-mpv-radiru--swf-url
  "http://www3.nhk.or.jp/netradio/files/swf/rtmpe.swf")

(defun emms-player-mpv-radiru--track-name-to-input-form (track-name)
  "Retrun \"rtmpe://radiru-url live=1 swfUrl=swf-url swfVfy=1\" from TRACK-NAME."
  (later-do #'emms-player-mpv-radiru--loading-message)
  (format "%s live=1 swfUrl=%s swfVfy=1"
          (replace-regexp-in-string "\\`radiru://" "" track-name)
          emms-player-mpv-radiru--swf-url))

(defun emms-player-mpv-radiru--get-media-title (track)
  (if (eq (emms-track-type track) 'streamlist)
      (emms-stream-name (emms-track-get track 'metadata))
    (file-name-nondirectory (emms-track-name track))))

(provide 'emms-player-mpv-radiru)
;;; emms-player-mpv-radiru.el ends here
