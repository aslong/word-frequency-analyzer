group node[:word_frequency_analyzer][:group]

user node[:word_frequency_analyzer][:user] do
  group node[:word_frequency_analyzer][:group]
  system true
  shell "/bin/bash"
  home node[:word_frequency_analyzer][:user_dir]
  password node[:word_frequency_analyzer][:password]
  supports :manage_home=>true
end

sudo node[:word_frequency_analyzer][:user] do
  user node[:word_frequency_analyzer][:user]
  nopasswd true
end

#user_account node[:word_frequency_analyzer][:user] do
#  ssh_keys  ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC22oc9PamZJukZ0p7uNPCPRiOHgE95cBLgLi9qnbuMeJXYpTNW3DxEFivWcPo3D7sN7WdHBRZOW8RYTVmhIjJOynbRbrK/JEGsu0o6WzRfLoXHpJapjH5p6Kd8tMqyp2yiChzuiiw8zgpvkGqdkBLNDqO+9cs5Sp4496n33m82BRx4na7IQcdL3/CgQCPIN5+rrbQsNfzFvirCc8u1PDsnzPc0/XaNbzEB+ESMpKoWxEcgZ842QA7QeL5IAJcdfunKvvKFkgN/AIWkHIOlfXYhoaQ+tehTzCn6L28SEzND59zKqLA/wsAZ266e686K+RyqhuR57XYlIeHdzCNlB9av"]
#  action [:manage]
#end
