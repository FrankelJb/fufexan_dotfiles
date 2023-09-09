set -x PATH $HOME/.cargo/bin $HOME/.local/bin $PATH

set -x EDITOR nvim

if command -v yarn > /dev/null
  set -x PATH (yarn global bin) $PATH
end

if test -e ~/.cargo-target
	setenv CARGO_TARGET_DIR ~/.cargo-target
end
