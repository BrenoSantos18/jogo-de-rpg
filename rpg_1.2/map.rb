class Map
    attr_accessor :position_x, :position_y, :allPlaces, :visitedPlaces

    def initialize
        @position_x = 5
        @position_y = 5

        @allPlaces= {
        "cabana" => {:x=> 5, :y=> 5},
        "bosque" => {:x=> 4, :y=> 4},
        "floresta" => {:x=> 6, :y=> 4},
        "mercador" => {:x=> 5, :y=> 4}
        }

        @visitedPlaces = {"cabana" => {:x=> 5, :y=> 5}}
    end

    def setVisited(place)
        @visitedPlaces[place] = @allPlaces[place]
    end

    def explore(menu)
        loop do
            system("clear")
            puts "Sua atual posição é #{self.position_x}x, #{self.position_y}y."
            paths= ["Norte", "Leste", "Oeste", "Sul", "Voltar"]
            paths.each do |path|
                puts "-->#{path}"
            end
            puts "Escolha o caminho."
            path= gets.chomp.downcase

            case path
            when "norte"
                if self.position_y > 0
                    self.position_y -= 1
                else
                    puts "Não há nada por ai."
                end

            when "sul"
                if self.position_y < 10
                    self.position_y += 1
                else
                    puts "Não há nada por ai."
                end

            when "leste"
                if self.position_x < 10
                    self.position_x += 1
                else
                    puts "Não há nada por ai."
                end

            when "oeste"
                if self.position_x > 0
                    self.position_x -= 1
                else
                    puts "Não há nada por ai."
                end

            when "sudeste"
                if self.position_y < 10 && self.position_x < 10
                    self.position_y += 1
                    self.position_x += 1
                else
                    puts "Não há nada por ai."
                end
            when "sudoeste"
                if self.position_y < 10 && self.position_x > 0
                    self.position_y += 1
                    self.position_x -= 1
                else
                    puts "Não há nada por ai."
                end
            when "nordeste"
                if self.position_y > 0 && self.position_x < 10
                    self.position_y -= 1
                    self.position_x += 1
                else
                    puts "Não há nada por ai."
                end
            when "noroeste"
                if self.position_y > 0 && self.position_x > 0
                    self.position_y -= 1 if self.position_y > 0
                    self.position_x -= 1 if self.position_x > 0
                else
                    puts "Não há nada por ai."
                end

            when "voltar"
                break

            else
                puts "Pra onde você esta indo?"
            end

            if self.position_x == 5 && self.position_y == 5
                puts "Voce chegou à sua cabana!"
                continue = gets.chomp
                menu.lastMenu = menu.actualmenu
                menu.actualmenu= "cabana"
                break

            elsif self.position_x == 4 && self.position_y == 4
                if map.visitedPlaces.include?("bosque")
                    puts "Voce chegou ao bosque!"
                else
                    map.setVisited("bosque")
                    puts "Você encontrou o bosque!"
                end
                continue = gets.chomp
                menu.lastMenu = menu.actualmenu
                menu.actualmenu= "bosque"
                break

            elsif self.position_x == 3 && self.position_y == 4
                if self.visitedPlaces.include?("floresta")
                    puts "Voce chegou à floresta!"
                else
                    self.setVisited("floresta")
                    puts "Você encontrou a floresta!"
                end
                continue = gets.chomp
                menu.lastMenu = menu.actualmenu
                menu.actualmenu= "floresta"
                break

            elsif self.position_x == 5 && self.position_y == 4
                puts "Voce chegou ao mercador!"
                continue = gets.chomp
                menu.lastMenu = menu.actualmenu
                menu.actualmenu= "mercador"
                break
            end
        end
    end

    def checkPlaces
        @visitedPlaces.each do |place, data|
            puts "#{place}   #{data[:x]} X,  #{data[:y]} Y"
        end
    end

end

