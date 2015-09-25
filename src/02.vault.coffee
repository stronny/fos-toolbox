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

window.vault.cure_aids = (aid) ->
	switch aid            # 13, 31, 36
		when -11 then 36    # probably
		when -18 then 13    # FIXME
		when -22 then 31    # FIXME
		else aid

window.vault.tag_edges = (node, tag) -> (e.tags.push tag; @tag_edges e.target_node, tag) for e in node.down

window.vault.plot = () ->
	nodes = {}
	edges = {}
	for d in @data.dwellers.dwellers
		do (d) =>
			nid = d.serializeId
			node =
				dweller: d,
				id:      nid.toString(),
				label:   "#{d.name} #{d.lastName} (#{nid})",
				color:   (if d.gender < 2 then '#F00' else '#00F'),
				size:    1,
				x:       Math.random(),
				y:       Math.random(),
				down:    [],
				up:      [],
			nodes[nid] = node
			for aid in d.relations.ascendants.filter((aid) -> aid != -1).map @cure_aids
				do (aid) ->
					console.log "#{nid} -> #{aid}" if aid < -1
					eid = "#{aid}.#{nid}"
					edge =
						id:          eid,
						source:      aid.toString(),
						target:      nid.toString(),
						target_node: node
						type:        'arrow',
						size:        200,
						tags:        [],
					edges[eid] = edge
					nodes[aid].down.push edge
					nodes[nid].up.push edge
	@tag_edges node, nid for nid, node of nodes

	console.log nodes, edges

	@sigma = new window.sigma { container: 'sigma', graph: { nodes: [], edges: [] }, settings: { labelColor: 'node', minEdgeSize: 3, maxEdgeSize: 3 } }
	@sigma.graph.addNode n for _, n of nodes when n.down.length > 0 or n.up.length > 0
	@sigma.graph.addEdge e for _, e of edges #when Object.keys(e.tags).length < 2
	@sigma.refresh()

window.vault.fetch = () ->
	@overrideMimeType 'application/json'
	@open 'GET', 'vault.json'
	@send()

window.vault.onreadystatechange = () ->
	return if @readyState < 4
	@data = JSON.parse @response
	@calculate()
	window['△'].root @data
