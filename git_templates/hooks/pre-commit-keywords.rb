#!/usr/bin/env ruby

# Git pre-commit hook that prevents accidentally committing configured keywords.
#
# To bypass this commit hook (and others), commit with the "--no-verify" option.
#
# Based on Henrik Nyh's work:
# https://github.com/henrik/dotfiles/blob/master/git_template/hooks/pre-commit-keywords.rb

FORBIDDEN = [
  /\bsave_and_open_page\b/,
  /\bconsole\.log\b/,
  /\bbinding\.pry\b/
]

full_diff = `git diff --cached --`.force_encoding("ASCII-8BIT")

full_diff.scan(%r{^\+\+\+ b/(.+)\n@@.*\n([\s\S]*?)(?:^diff|\z)}).each do |file, diff|
  added = diff.split("\n").select { |x| x.start_with?("+") }.join("\n")
  if FORBIDDEN.any? { |re| added.match(re) }
    puts %{Git hook forbids adding "#{$1 || $&}" to #{file}}
    puts "To commit anyway, use --no-verify"
    exit 1
  end
end
