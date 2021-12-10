desc "Run brakeman with potential non-0 return code"
task :brakeman do
  # -z flag makes it return non-0 if there are any warnings
  # -q quiets output
  unless system("brakeman -z -q") # system is true if return is 0, false otherwise
    abort("Brakeman detected one or more code problems, please run it manually and inspect the output.")
  end
end

namespace :bundler do
  begin
    require 'bundler/audit/cli'

    desc 'Updates the ruby-advisory-db and runs audit'
    task :audit do
      %w(update check).each do |command|
        Bundler::Audit::CLI.start [command]
      end
    end
  rescue LoadError
    # no-op, probably in a production environment
  end
end

namespace :yarn do
  desc "Run yarn audit"
  task :audit do
    stdout, stderr, status = Open3.capture3("yarn audit --json")
    unless status.success?
      puts stderr
      parsed = JSON.parse("[#{stdout.lines.join(",")}]")
      puts JSON.pretty_generate(parsed)
      if /503 Service Unavailable/.match?(stderr)
        puts "Ignoring unavailable server"
      elsif all_issues_ignored?(parsed)
        puts "Ignoring known and accepted yarn audit results"
      else
        exit status.exitstatus
      end
    end
  end
end

def all_issues_ignored?(issues)
  summary = issues.find { |json| json["type"] == "auditSummary" }["data"]["vulnerabilities"]
  # immediately fail if more findings are discovered, even if they have the same advisory ID,
  # this helps to ensure that we fully evaluate the risk present
  return false unless summary["moderate"] <= 5 && summary["high"] == 3 && summary["critical"] == 0
  advisory_ids = issues.select { |json| json["type"] == "auditAdvisory" }.map { |json| json["data"]["advisory"]["id"] }

  # add any ignored advisory IDs below with a comment as to why ignored
  advisory_ids.all? { |id| [
    1004946, # mod - inefficient regex in dev server and at build time
    1005154, # high - inefficient regex in dev server and at build time
    1004967, # mod - inefficient regex in dev server and at build time
  ].include? id }
end

task default: ["brakeman", "bundler:audit", "yarn:audit"]
