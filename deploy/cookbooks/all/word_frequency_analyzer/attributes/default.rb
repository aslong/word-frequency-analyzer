default['nodejs']['version'] = '0.10.21'
default['nodejs']['npm'] = '1.3.5'
default['npm']['version'] = default['nodejs']['npm']

default[:word_frequency_analyzer][:user] = "vagrant"
default[:word_frequency_analyzer][:group] = "vagrant"
default[:word_frequency_analyzer][:password] = "$1$CVO0FRa0$fLy7d3zG7/WugH4n44nFP1"

default[:word_frequency_analyzer][:user_dir] = "/home/#{default[:word_frequency_analyzer][:user]}"
default[:word_frequency_analyzer][:deploy_to] = "#{default[:word_frequency_analyzer][:user_dir]}/word_frequency_analyzer"
