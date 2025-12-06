;; -*- lexical-binding: t; -*-

(setq mkprj--nix-file-contents
      "{\n\
  description = \"Nix devshell for project.\";\n
  inputs = {\n\
    nixpkgs.url = \"github:nixos/nixpkgs?ref=nixos-unstable\";\n\
    utils.url = \"github:numtide/flake-utils\";\n\
  };\n
  outputs = { self, nixpkgs, utils }:\n\
    utils.lib.eachDefaultSystem (system:\n\
      let\n\
        pkgs = import nixpkgs { inherit system; };\n\
      in\n\
        {\n\
          devShell = with pkgs; mkShell {\n\
            buildInputs = [\n\
              # TODO: add your dev dependencies\n\
            ];\n\
          };\n\
        }\n\
    );\n\
}")

(defun create-project-file (project-name file-name file-contents)
  (let ((file-name (format "%s/%s" project-name file-name)))
    (find-file file-name)
    (previous-buffer)
    (write-region file-contents
                  nil
                  file-name)))

;;;###autoload
(defun mkprj (project-name)
  (interactive "sProject Name: ")
  (catch 'dir-exists
    (when (file-directory-p project-name)
      (throw 'dir-exists
             (message (format "Directory %s already exists!" project-name))))
    (mkdir project-name)
    (create-project-file project-name "flake.nix" mkprj--nix-file-contents)
    (create-project-file project-name ".envrc" "use flake")
    (find-file project-name)
    (direnv-allow)
    (message (format "Project '%s' created." project-name))))

(provide 'mkprj)
