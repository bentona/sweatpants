require './sweatpants.rb'

client = Sweatpants.new

client.index index: "matches", type: 'MyIndex', id: "999999999", body: {stuff: 'some stuff'}




client.join # wait for tick_thread to die, i.e. never