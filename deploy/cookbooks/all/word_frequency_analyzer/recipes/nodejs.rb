include_recipe "nodejs"
include_recipe "nodejs::npm"

npm_package "grunt-cli"

execute "npm install" do
  cwd node[:word_frequency_analyzer][:deploy_to]
  not_if { ::File.exists?("#{node[:word_frequency_analyzer][:deploy_to]}/node_modules/")}
end
