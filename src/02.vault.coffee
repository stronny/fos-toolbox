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

#window.vault.graph_push = (graph, dweller) ->
#	did = dweller.serializeId
#	graph.edges.push {id: "#{aid}->#{did}", source: '' + aid, target: '' + did} for aid in dweller.relations.ascendants.filter (i) -> i != -1

window.sigma.classes.graph.addMethod 'self',          () -> return this
window.sigma.classes.graph.addMethod 'getNodesIndex', () -> return @nodesIndex
window.sigma.classes.graph.addMethod 'nodeExists',    (id) -> return undefined != @nodesIndex[id]
window.sigma.classes.graph.addMethod 'getDescIndex',  () -> return @outNeighborsIndex
window.sigma.classes.graph.addMethod 'descs',         (id) -> return @outNeighborsIndex[id]
window.vault.sigma = new window.sigma { graph: { nodes: [], edges: [] }, settings: { labelColor: 'node', minEdgeSize: 3, maxEdgeSize: 3 } }
window.vault.sigma.dweller2node = (d) ->
	@graph.addNode {
		dweller: d,
		id:      d.serializeId.toString(),
		label:   "#{d.name} #{d.lastName} (#{d.serializeId.toString()})",
		color:   (if d.gender < 2 then '#F00' else '#00F'),
		size:    1,
		x:       Math.random(),
		y:       Math.random(),
	}
window.vault.sigma.dweller2edges = (d) ->
	(console.log "#{d.serializeId} -> #{aid}" if aid < -1; @graph.addEdge {
		id: "#{aid} -> #{d.serializeId}",
		source: aid.toString(),
		target: d.serializeId.toString(),
		type:   'arrow',
		size:   200,
	} if @graph.nodeExists aid) for aid in d.relations.ascendants.map (aid) -> switch aid            # 13, 31
		when -11 then 36    # probably
		when -18 then -18
		when -22 then -22
		else aid

window.vault.sigma.process_ancestor = (n) ->
	descs = (desc for desc of @graph.descs n)
	console.log [n, descs]

window.vault.plot = () ->
	@sigma.addRenderer { container: document.getElementById 'sigma' }
	@sigma.dweller2node d for d in @data.dwellers.dwellers
	@sigma.dweller2edges d for d in @data.dwellers.dwellers
	@sigma.process_ancestor n for n of @sigma.graph.getDescIndex()

	@sigma.refresh()

#	@sigma.graph.addNode {id: d.serializeId.toString(), label: "#{d.name} #{d.lastName}", size: 2 } for d in @data.dwellers.dwellers.filter (d) -> d.relations.ascendants.some (i) -> i != -1
#
# unless @sigma.graph.nodeExists d.serializeId 
#
#	@graph_push graph, d 
#	ids = {}
#	ids[id] = id for id in graph.edges.map((e) -> e.source).concat graph.edges.map (e) -> e.target
#	graph.nodes.push {id: '' + id, label: '' + id, x: Math.random(), y: Math.random(), size: 2} for id of ids
#	console.log graph.nodes

window.vault.fetch = () ->
	@overrideMimeType 'application/json'
	@open 'GET', 'vault.json'
	@send()

window.vault.onreadystatechange = () ->
	return if @readyState < 4
	@data = JSON.parse @response
	@calculate()
	window['△'].root @data
	@plot()
