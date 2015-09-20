desc 'Build HTML'
task :html do
	require 'haml'
	haml = open('src/index.haml') { |fd| fd.read }
	html = Haml::Engine.new(haml).render
	open('index.html', 'w') { |fd| fd.puts html }
end

desc 'Build CoffeeScript'
task :js do
	require 'coffee-script'
	cs = open('src/logic.coffee') { |fd| fd.read }
	js = CoffeeScript.compile(cs)
	open('logic.js', 'w') { |fd| fd.puts js }
end

desc 'Build Everything'
task all: [:html, :js]

task default: :all
