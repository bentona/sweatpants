sweatpants
==========


[![Build Status](https://secure.travis-ci.org/bentona/sweatpants.png?branch=master)](http://travis-ci.org/bentona/sweatpants)
[![Code Climate](https://codeclimate.com/github/bentona/sweatpants.png)](https://codeclimate.com/github/bentona/sweatpants)


Redis-backed HTTP server that accumulates Elasticsearch requests and sends them as bulk requests. 

Inspired, in part, by https://github.com/nz/elasticmill


Create a sweatpants client.
```
elasticsearch_options = {
	host: 'localhost'
}

sweatpants_options = {
	queue: SweatpantsQueue.new,
	flush_frequency: 1,
	actions_to_trap: [:index]
}

sweatpants = Sweatpants.new elasticsearch_options, sweatpants_options
```

Send sweatpants a request that will be queued.
```
sweatpants.index({
	index: "matches", 
	type: "ExpertMatch", 
	id: "1234",
	body: {some: 'stuff'}
})
```

Send sweatpants a request that will be immediately executed.
```
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
```