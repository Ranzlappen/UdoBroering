#!/usr/bin/env ruby
# frozen_string_literal: true

# Scaffold stub metadata entries in _data/papers.yml for any PDF in
# assets/papers/ that isn't keyed yet.
#
# The /papers/ page already auto-lists every PDF whether or not it has a
# papers.yml entry, so this is purely a convenience: it gives you a
# ready-to-fill template (with the date pre-parsed from a YYYY-MM-DD filename
# prefix) instead of having to remember the filename-as-key syntax.
#
# Existing entries and the file's leading comments are left untouched — new
# stubs are appended to the end of the file, so nothing you've already filled
# in gets clobbered or reordered.
#
# Usage:  ruby script/sync_papers.rb
# Exits 0 always; prints the names it added (if any) to stdout.

require "yaml"
require "date"

ROOT        = File.expand_path("..", __dir__)
PAPERS_DIR  = File.join(ROOT, "assets", "papers")
DATA_FILE   = File.join(ROOT, "_data", "papers.yml")
DEFAULT_AUTHOR = "Udo Bröring"

# --- gather the PDFs on disk -------------------------------------------------
pdfs = Dir.children(PAPERS_DIR)
          .select { |f| File.extname(f).downcase == ".pdf" }
          .sort

if pdfs.empty?
  puts "No PDFs in assets/papers/ — nothing to do."
  exit 0
end

# --- read the keys already present in papers.yml -----------------------------
raw = File.exist?(DATA_FILE) ? File.read(DATA_FILE) : ""
existing =
  begin
    parsed = YAML.safe_load(raw, permitted_classes: [Date], aliases: false)
    parsed.is_a?(Hash) ? parsed.keys : []
  rescue Psych::SyntaxError => e
    warn "Could not parse #{DATA_FILE}: #{e.message}"
    exit 1
  end

missing = pdfs - existing
if missing.empty?
  puts "papers.yml already has an entry for every PDF — nothing to add."
  exit 0
end

# --- build a stub for each missing PDF ---------------------------------------
def derive_date(filename)
  m = filename.match(/\A(\d{4})-(\d{2})-(\d{2})-/)
  return nil unless m
  Date.new(m[1].to_i, m[2].to_i, m[3].to_i) rescue nil
end

def derive_title(filename)
  base = File.basename(filename, ".*")
  base = base.sub(/\A\d{4}-\d{2}-\d{2}-/, "")        # drop a date prefix
  base.tr("-_", "  ").split.map(&:capitalize).join(" ")
end

# Double-quote a YAML scalar while keeping UTF-8 intact (String#inspect would
# escape "ö" to "ö"); only backslash and double-quote need escaping.
def yq(str)
  %("#{str.gsub('\\', '\\\\\\\\').gsub('"', '\\"')}")
end

stubs = missing.map do |name|
  date  = derive_date(name)
  title = derive_title(name)
  lines = []
  lines << %(#{yq(name)}:)
  lines << %(  title: #{yq(title)}        # TODO: confirm/replace title)
  lines << %(  authors: #{yq(DEFAULT_AUTHOR)})
  lines << %(  date: #{date.iso8601})          if date
  lines << %(  description: >-)
  lines << %(    TODO: add an abstract or summary for this document.)
  lines.join("\n")
end

addition = "\n" + stubs.join("\n\n") + "\n"
addition = addition.sub(/\A\n/, "") if raw.empty? || raw.end_with?("\n\n")
File.open(DATA_FILE, "a") { |f| f.write(addition) }

puts "Added #{missing.size} stub entr#{missing.size == 1 ? "y" : "ies"} to _data/papers.yml:"
missing.each { |n| puts "  + #{n}" }
