# Sweatpants 
[![Build Status](https://secure.travis-ci.org/bentona/sweatpants.png?branch=master)](http://travis-ci.org/bentona/sweatpants) [![Code Climate](https://codeclimate.com/github/bentona/sweatpants.png)](https://codeclimate.com/github/bentona/sweatpants) [![Coverage Status](https://coveralls.io/repos/bentona/sweatpants/badge.png)](https://coveralls.io/r/bentona/sweatpants)

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
