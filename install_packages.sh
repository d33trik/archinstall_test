#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

export GUM_SPIN_SHOW_ERROR=true
export GUM_SPIN_SPINNER=line
export GUM_SPIN_SPINNER_FOREGROUND=10
export GUM_SPIN_TITLE_FOREGROUND=15

main() {
	for script in archinstall_test/packages/*.sh
	do
		local package_name=$(basename "$script" .sh)

		gum spin \
			--title="Installing $package_name..." \
			-- bash "$script"
	done
}

main "$@"
