require 'rake'

desc "Install dotfiles by symlinking from user's home directory"
task :install do
  %w(aliases bash_profile bashrc bin exports functions gemrc hemnet
     gitconfig gitignore_global tmux.conf tmuxinator vimrc).each do |source|
    target = "#{ENV['HOME']}/.#{source}"
    `ln -fhs "$PWD/#{source}" "#{target}"`
  end

  # Clean install of Vundle for Vim plugin management.
  `rm -rf ~/.vim/bundle/vundle`
  `git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`
end

task default: :install
