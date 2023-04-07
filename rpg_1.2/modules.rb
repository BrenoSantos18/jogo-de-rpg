#fazer uma interface, e chamar um bloco com o determinado menu.

module MyGame

    class Game

        def save_game(player, mission, scene, menud, gametime, state, market, map, menu, inventory)
            File.open("save_game.txt", "wb") do |file|
                file.write(Marshal.dump([player, mission, scene, menud, gametime, state, market, map, menu, inventory]))
            end
        end

        def load_game
            if File.exist?("save_game.txt")
                File.open("save_game.txt", "rb") do |file|
                    player, mission, scene, menud, gametime, state, market, map, menu, inventory = Marshal.load(file.read)
                    return [player, mission, scene, menud, gametime, state, market, map, menu, inventory]
                end
            else
                puts "Nenhum jogo salvo encontrado"
                return nil
            end
        end
    end

    class Menu
        attr_accessor :options, :actualmenu, :lastMenu

        def initialize
            @options= []
            @actualmenu = "cabana"
            @lastMenu = "cabana"
        end


        def callMenu(menu)

            if menu == "cabana"
                puts "Nada melhor do que um lugar quente para esquentar seu sangue frio."
                self.options = ["Descansar", "Viajar", "Menu", "Salvar jogo", "Sair e salvar", "Voltar"]
            elsif menu == "bosque"
                puts "É um ótimo lugar para caçar, apesar das marcas de garras nos troncos das árvores..."
                self.options = ["Caçar", "Descansar", "Viajar", "Menu", "Salvar jogo", "Sair e salvar", "Voltar"]
            elsif menu == "floresta"
                puts "Um lugar escuro, aonde os sussurros se tornam gritos..."
                self.options = ["Caçar", "Descansar", "Viajar", "Menu", "Salvar jogo", "Sair e salvar", "Voltar"]
            elsif menu == "menu"
                self.options = ["Perfil", "Inventario", "Voltar"]
            elsif menu == "mercador"
                self.options = ["Mercador", "Viajar", "Salvar jogo", "Voltar"]
            elsif menu == "inventario"
                self.options = ["Equipar item (E)", "Remover arma equipada (R)", "Voltar"]
            end

            i = 1
            for option in options do
                puts "#{i}- #{option}"
                i += 1
            end
        end

        def check(option)
            if self.options.include?(option)
                return true
            else
                return false
            end
        end
    end

end

