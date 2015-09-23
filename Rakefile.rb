desc 'Build HTML'
task :html do
	require 'haml'
	class String
		def & prefix
			{id: self, class: [:part, :△_branch], △_prefix: prefix}
		end
		def +@
			{class: :△_leaf, △: :text_content, △_path: self}
		end
		def ~@
			{class: :△_leaf, △: :text_format, △_format: self}
		end
	end

	haml = open('src/index.haml') { |fd| fd.read }
	html = Haml::Engine.new(haml).render
	open('index.html', 'w') { |fd| fd.puts html }
end

desc 'Build CoffeeScript'
task :js do
	require 'coffee-script'
	css = {}
	Dir.glob('src/*.coffee') { |fn| open(fn) { |fd| css[fn] = fd.read } }
	jss = css.sort.map { |fn, cs| CoffeeScript.compile(cs, filename: fn) }
	open('logic.js', 'w') { |fd| fd.puts jss.join("\n") }
end

desc 'Build Everything'
task all: [:html, :js]

task default: :all
