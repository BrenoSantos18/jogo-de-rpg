
class Gametime
    attr_accessor :day, :time

    def initialize
        @day= 1
        @time= "manhã"
    end
    def pass_time
        if time == "manhã"
            time = "tarde"

        elsif time == "tarde"
            time = "noite"

        elsif time == "noite"
            time = "noite"
            @day += 1
        end
    end
    def pass_day
        @day += 1
    end
end

class Mission
    attr_accessor :completed, :on_going, :inative

    def initialize
        @on_going = Hash.new
        @completed = Hash.new
        @inative = {
        "caça aos lobos"=> {type: "hunt", description: "caçar 5 lobos.", progress: 0, status:"not finished"}
        }
    end


    def mission_start(missionset)
        self.on_going[missionset] = self.inative[missionset]
        self.inative.delete(missionset)
    end


    #mostra as missoes ativas e completas.
    def check_missions
        @on_going.each do |mission, data|
            puts "#{mission}= em andamento."
            puts "Descrição: #{data[:description]}"
            puts "-" * 10
        end

        @completed.each do |mission, data|
            puts "#{mission}= Completa."
            puts "Descrição: #{data[:description]}"
            puts "-" * 10
        end

        print ""
        continue = gets.chomp
    end

    #reconhece o que é missão e o que nao é
    def is_mission?(mission)
        @missions.include?(mission)
    end

    def is_completed?(mission)
        @completed.include?(mission)
    end

    def is_on_going?(mission)
        @on_going.include?(mission)
    end

    def is_inative?(mission)
        @inative.include?(mission)
    end

    def is_hunt?(mission, progresso)
        if mission["type"] == "hunt"
            self.inative[mission] = {progresso: progresso}
        end
    end
end
