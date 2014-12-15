require 'json'

RESPONSE = '{
    "person": {
        "personal_data": {
            "name": "James Bond",
            "gender": "male",
            "agent": "007"
        },
        "information_links": [
            "http://www.007.com/",
            "http://en.wikipedia.org/wiki/James_Bond",
            "http://www.007james.com/"
        ],
        "additional_info": {
            "hobby": [
                "women",
                "gambling",
                "alcohol",
                "cars"
            ],
            "devices": {
                "Vehicle": "Aston Martin",
                "Gun": " Walther PPK",
                "Gadget": "jet pack",
                "Watch": "Rolex"
            }
        }
    }
}'

response = JSON.parse(RESPONSE)

module PoliceM
  def is_armed(devices)

    if devices.key? ("Gun")
      armed = true
    else
      armed = false
    end

  end
end

class Person

  include PoliceM

end

Person.class_eval do
  def personal_information(personal_data)

    "Person: " + personal_data["gender"] + "," + personal_data["name"] + "(" + personal_data["agent"] + ")"

  end
end



agent = Person.new

armed = agent.is_armed(response ["person"]["additional_info"]["devices"])
agent_data = agent.personal_information(response["person"]["personal_data"])

puts agent_data

if armed

  puts "Warning! Agent is armed!"

end
