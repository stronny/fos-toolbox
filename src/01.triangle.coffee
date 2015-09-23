window['△'] =

	root: (data) ->
		branches = document.getElementsByClassName '△_branch'
		@branch b, data for b in branches

	branch: (element, data) ->
		prefix = element.getAttribute '△_prefix'
		leaves = element.getElementsByClassName '△_leaf'
		@leaf l, data, prefix for l in leaves

	leaf: (element, data, prefix) ->
		method = element.getAttribute '△'
		this[method] element, data, prefix

	text_content: (element, data, prefix) ->
		path = element.getAttribute '△_path'
		element.textContent = @get data, path, prefix

	text_format: (element, data, prefix) ->
		format = element.getAttribute '△_format'
		element.textContent = format.replace /{(\w+)}/g, (_,p) => @get data, element.getAttribute(p), prefix

	get: (data, path, prefix) ->
		parts = path.split '.'
		parts[0] = prefix if parts[0].length < 1
		ptr = data
		ptr = ptr[p] for p in parts
		ptr
