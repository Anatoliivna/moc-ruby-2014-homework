require 'json'


module MagicWords

  module ClassMethods

    def magic_methods(*magic_words)
      magic_words.each do |magic_word|

         case magic_word
           when :additional_info
             define_method ("armed?") do
               self.additional_info.key?("devices") && (self.additional_info["devices"].key?("Gun") || self.additional_info["devices"].key?("Knife"))
             end
         end
      end
    end
  end

  #avoid extend and include
  def self.included(base)
    base.extend(ClassMethods)
  end

end



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


if response.key?("person")

  magicKeys = *response["person"].keys.collect(&:to_sym)
  person_class = Struct.new("Person", *magicKeys)

  Struct::Person.class_eval do

    include MagicWords
    magic_methods(*magicKeys)

  end


  person_object = person_class.new(*response["person"].values)
  if person_object.armed?
    p "Warning! Agent is armed!"
  end

end




class AgentsFactory

def self.create_agent(name, position, &block) #лямда створена методом create_player, створює лямди

  agent_name = name

  ->(own_block) do # лямда передається в якості параметра, параметр надходить з рядка 32
    yield          # тут виконується &block
    own_block.call                                                              # 3
    p "My name #{agent_name}, agent  #{position}"
  end

end

end

class SecretAgents


  attr_accessor :country_name, :agents

  def initialize(country_name, agent_involved)

    self.country_name = country_name
    self.agents = [] #повноцінні обєкти створені без класів, з одним методом
    agent_involved.each do |agent|
      agents.push AgentsFactory.create_agent(agent[:name], agent[:position]) { p "I'm Secret agent from #{self.country_name}" } if agent.has_key?(:name) && agent.has_key?(:position)
      # {} - запис лямди однострочних блоків, do-end - запис лямди багатострочних блоків
    end
  end

  def call_over(actions)
    self.agents.each_with_index { |agent, index| agent.call(actions[index]) }  # 2
  end

end

p_actions = [] #масив

p_actions.push -> { p "Resourceful, skilled in hand-to-hand combat, a proficient marksman and lucky man." }                #дія гравця
p_actions.push -> { p "Tall, beautiful, appearance is useful in undercover operations." }       #дія гравця
p_actions.push -> { p "Chief, intelligent and serious" }               #дія гравця               # 1

secretagents = SecretAgents.new("CONTROL", [{name: "Maxwell Smart", position: "86"}, {name: "Susan Hilton", position: "99"}, {name: "Harold Clark", position: "Q"}])
#набір гравців, базове і основне записати в самого гравця
secretagents.call_over(p_actions) #будь що в чому є метод call - виконається
#викликали кожного гравця

#Maxwell Smart 86 CONTROL
#Susan Hilton 99 CONTROL
#James Bond 007 MI6
#Harold Clark Q CONTROL
#Johnny English One British Intelligence

#різниця між liamda and Proc:
#ретурн
#аргумент
#перевірка ?liamda
#JSON + динамічно створені обєкти, доповнити дз з використанням Liamd
