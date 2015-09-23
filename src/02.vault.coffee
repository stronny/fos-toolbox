window.vault = new XMLHttpRequest()

window.vault.storage_map =
	MedBay: [
		[10, 10, 10],
		[20, 20, 20],
		[30, 30, 30],
	]
	Science: [
		[10, 10, 10],
		[20, 20, 20],
		[30, 30, 30],
	]

window.vault.type = (type) -> (room) -> room.type is type
window.vault.storage = () ->
	(room) => @storage_map[room.type][room.mergeLevel - 1][room.level - 1]
window.vault.sum = (ax, i) -> ax += i

window.vault.calculate = () ->
	@data.calc =
		vault:
			max:
				stimpacks: @data.vault.rooms.filter(@type 'MedBay').map(@storage()).reduce(@sum, 5)
				radaways:  @data.vault.rooms.filter(@type 'Science').map(@storage()).reduce(@sum, 5)

window.vault.fetch = () ->
	@overrideMimeType 'application/json'
	@open 'GET', 'vault.json'
	@send()

window.vault.onreadystatechange = () ->
	return if @readyState < 4
	@data = JSON.parse @response
	@calculate()
	window['△'].root @data
