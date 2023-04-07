require_relative "modules.rb"
require_relative "menu.rb"
require_relative "geral.rb"
require_relative "entidades.rb"
require_relative "action.rb"
require_relative "inventory.rb"
require_relative "scenes.rb"
require_relative "map.rb"


myfile = MyGame::Game.new
menu = MyGame::Menu.new

puts "Bem-vindo ao jogo!"
print "Você deseja carregar um jogo salvo? (s/n) "
choice = gets.chomp.downcase

if choice == "s"
    player, mission, scene, menud, gametime, state, market, map, menu, inventory= myfile.load_game

else
    puts "Qual seu nome?"
    name = gets.chomp
    inventory= Inventory.new
    market = Market.new
    mission = Mission.new
    scene= Scenes.new
    gametime= Gametime.new
    map = Map.new
    menud = Interfaces.new
    player= Player.new(name)
    menu.callMenu(menu.actualmenu)
end


loop do
    system("clear")

    actualPlace = menu.actualmenu
    puts "Dia #{gametime.day}, está de #{gametime.time}. #{player.name} está na(o) #{actualPlace}"
    menu.callMenu(actualPlace)
    opcao = gets.chomp.downcase


    case opcao
    when "descansar"
        valid_option = menu.check("Descansar")

        if valid_option
            player.rest(gametime)
        else
            puts "nao"
        end

    when "viajar"
        valid_option = menu.check("Viajar")

        if valid_option
            loop do
                puts "Você quer ir para um lugar já visitado ou explorar? (V/N)"
                puts "Digite EXIT para voltar."
                continue = gets.chomp.downcase
                if continue == "v"
                    map.checkPlaces
                    puts "Para aonde? Escreva EXIT se mudou de ideia."
                    place= gets.chomp.downcase
                    if place == "exit"
                        puts ""
                    else
                        if map.visitedPlaces.include?(place)
                            menu.lastMenu = menu.actualmenu
                            change= map.allPlaces[place]
                            map.position_x = change[:x]
                            map.position_y = change[:y]
                            menu.actualmenu= place
                            break
                        else
                            puts "Tem certeza que ja foi neste lugar?"
                        end
                    end

                elsif continue == "n"
                    map.explore(menu)
                    break

                elsif continue == "exit"
                    break
                end
            end
        else
            puts "nao"
        end

    when "mercador"
        menud.shop_menu(player, market, inventory, gametime, menu, map)

    when "comprar"


    when "menu"
        valid_option = menu.check("Menu")

        if valid_option
            menu.lastMenu = menu.actualmenu
            menu.actualmenu= "menu"
        else
            puts "Nao"
        end

    when "salvar"
        valid_option = menu.check("Salvar jogo")
        if valid_option
            myfile.save_game(player, mission, scene, menud, gametime, state, market, map, menu, inventory)
        else
            puts "Nao"
        end

    when "sair"
        valid_option = menu.check("Sair e salvar")
        if valid_option
            myfile.save_game(player, mission, scene, menud, gametime, state, market, map, menu, inventory)
            exit
        else
            puts "Nao"
        end

    when "perfil"
        valid_option = menu.check("Perfil")
        if valid_option
            player.display_perfil(inventory)
        else
            puts "Nao"
        end

    when "inventario"
        valid_option = menu.check("Inventario")
        if valid_option
            inventory.show_inventory
            menu.callMenu("inventario")
            continue= gets.chomp.downcase
            if continue == "e"
                print "Qual item você deseja equipar?"
                item = gets.chomp
                inventory.equip_item(item)

            elsif continue == "r"
                inventory.show_equipped_items
                print "Qual item você deseja remover?"
                item= gets.chomp
                inventory.remove_item(item)
            end
        end

    when "caçar"
        valid_option = menu.check("Caçar")
        if valid_option
            if menu.actualmenu == "bosque"
                player.hunt_bosque(player, gametime, mission, inventory, scene)
            elsif menu.actualmenu == "floresta"
                player.hunt_forest(player, gametime, mission, inventory, scene)
            end
        else
            puts "Melhor você fazer outra coisa..."
            continue = gets.chomp
        end


    when "voltar"
        menu.actualmenu= menu.lastMenu

    else
        puts "Melhor você fazer outra coisa..."
        continue = gets.chomp
    end
end


