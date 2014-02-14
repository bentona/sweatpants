sweatpants
==========

Redis-backed HTTP server that accumulates Elasticsearch requests and sends them as bulk requests. 

elasticsearch_options = {
	host: 'localhost'
}

sweatpants_options = {
	queue: SweatpantsQueue.new,
	flush_frequency: 1,
	actions_to_trap: [:index]
}

sweatpants = Sweatpants.new elasticsearch_options, sweatpants_options

sweatpants.index({
	index: "matches", 
	type: "ExpertMatch", 
	id: "1234",
	body: {some: 'stuff'}
})

sweatpants.index(
	{
		index: "matches",
		type: "ExpertMatch",
		id: "5678",
		body: {some: "really important stuff"}
	}, 
	{
		immediate: true
	}
)