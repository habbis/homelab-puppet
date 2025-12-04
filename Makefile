SHELL = /bin/bash

.PHONY: all
all: git_hooks
	$(info make git_hooks:   set up Git repository hooks)

.PHONY: git_hooks
git_hooks:
	@if ! git config --get remote.origin.push '^HEAD$$' >/dev/null; then \
		git config --add remote.origin.push HEAD; \
	fi
	@if git config --get remote.origin.push '^refs/notes/audit:refs/notes/audit$$' >/dev/null; then \
		git config --unset remote.origin.push refs/notes/audit:refs/notes/audit; \
	fi
	@if git config --get branch.master.rebase true >/dev/null; then \
		git config branch.master.rebase true; \
	fi
	@ln -sf ../../tools/git-hooks/pre-commit .git/hooks/pre-commit
	@$(RM) .git/hooks/post-commit
