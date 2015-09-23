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

window.onload = () ->
	this.nav = document.getElementsByTagName('nav')[0]
	nav_init this.nav
	this.vault.fetch()
	routie '*', () -> routie 'vault'
