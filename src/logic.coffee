# --------------------------------------------------
# The triangle
#
window['△'] =
	root: (data) -> this.branch e, data for e in document.getElementsByClassName 'tri_branch'
	branch: (element, data) ->
		prefix = element.getAttribute 'tri_prefix'
		this.leaf e, data, prefix for e in element.getElementsByClassName 'tri_leaf'
	leaf: (element, data, prefix) ->
		this[element.getAttribute('tri')] element, data, prefix
	text_content: (element, data, prefix) ->
		path = element.getAttribute 'tri_path'
		element.textContent = this.get data, path, prefix
	text_format: (element, data, prefix) ->
		self = this
		element.textContent = element.getAttribute('tri_format').replace /{(\w+)}/g, (m, p, o, s) -> self.get data, element.getAttribute(p), prefix
	get: (data, path, prefix) ->
		parts = path.split '.'
		parts[0] = prefix if parts[0].length < 1
		ptr = data
		ptr = ptr[p] for p in parts
		ptr

# --------------------------------------------------
# The vault
#
window.vault = new XMLHttpRequest()
window.vault.fetch = () ->
	this.overrideMimeType 'application/json'
	this.open 'GET', 'vault.json'
	this.send()
window.vault.onreadystatechange = () ->
	return if this.readyState < 4
	this.data = JSON.parse this.response
	this.calculate_all()
	window['△'].root this.data

# --------------------------------------------------
# The Calc
#
window.vault.storage = (room) ->
	10
window.vault.calculate = (k, v) ->
	parts = ('calc.' + k).split '.'
	last = parts.pop()
	ptr = this.data
	(ptr[p] = {} unless ptr[p]?; ptr = ptr[p]) for p in parts
	ptr[last] = v
window.vault.calculate_all = () ->
	d = this.data
	self = this
	this.calculate 'vault.max.stimpacks', ((d.vault.rooms.filter (a,b,c) -> "MedBay" == a.type).map (a,b,c) -> self.storage a).reduce ((ax, i, id, a) -> ax += i), 0

# --------------------------------------------------
# Navigation
#
HTMLDivElement.prototype.down = () -> this.style.display = 'none'
HTMLDivElement.prototype.up   = () -> this.style.display = 'block'

nav_init = (nav) ->
	nav.ul = nav.getElementsByTagName('ul')[0]
	nav.switch = (part) ->
		p.down() for p in this.parts
		part.up()
	nav.add = (part) ->
		a = document.createElement 'a'
		a.href = '#' + part.id
		a.textContent = part.id
		li = document.createElement('li')
		li.appendChild(a)
		this.ul.appendChild li
		part.down()
		routie part.id, () -> nav.switch part
	nav.parts = document.getElementsByClassName('part')
	nav.add p for p in nav.parts

# --------------------------------------------------
# Let's get dangerous
#
window.onload = () ->
	this.nav = document.getElementsByTagName('nav')[0]
	nav_init this.nav
	this.vault.fetch()
	routie '*', () -> routie 'vault'
