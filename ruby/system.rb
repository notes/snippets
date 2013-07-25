
if system(ARGV.join(" "))
  puts "Success"
elsif $?.exited?
  puts "Failure (exit with #{$?.exitstatus})"
elsif $?.signaled?
  if $?.coredump?
    puts "Failure (killed by signal #{$?.termsig} with coredump)"
  else
    puts "Failure (killed by signal #{$?.termsig})"
  end
end


