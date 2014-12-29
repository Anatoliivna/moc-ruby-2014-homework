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

    def check_agent(&block)
      if self.armed?
        yield
      end
    end
  end

  person_object = person_class.new(*response["person"].values)
  person_object.check_agent { p "Warning! Agent is armed!" }

end