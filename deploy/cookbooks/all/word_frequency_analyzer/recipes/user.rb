group node[:word_frequency_analyzer][:group]

user node[:word_frequency_analyzer][:user] do
  group node[:word_frequency_analyzer][:group]
  system true
  shell "/bin/bash"
  home node[:word_frequency_analyzer][:user_dir]
  password node[:word_frequency_analyzer][:password]
  supports :manage_home=>true
end
