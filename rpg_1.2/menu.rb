class Interfaces

    def shop_menu(player, market, inventory, gametime, menu, map)
        loop do
            if map.visitedPlaces.include?("mercador")
                puts "Mercador: E ai, o que vai ser hoje?"
                print ""
                continue = gets.chomp
            else
                puts "Andando para o norte, você encontra uma tenda. Parece ser um mercador."
                puts ""
                puts "Mercador; Ei, um rosto novo na área? Venha, tenho itens à venda!"
                map.setVisited("mercador")
                print ""
                continue = gets.chomp

            end

            puts "1. Comprar (C)"
            puts "2. Vender (V)"
            puts "Voltar (ENTER)"
            continue= gets.chomp.downcase
            if continue == "comprar" or continue == "c"
                loop do
                    system('clear')
                    market.show_market(inventory)
                    puts "Mercador: Vai comprar alguma coisa ou vai ficar só olhando?"
                    puts "-->Comprar (C)"
                    puts "-->Voltar"
                    continue = gets.chomp

                    if continue == "c" or continue == "comprar"
                        print "Qual item você quer comprar? "
                        item = gets.chomp
                        print "Quantos?"
                        amount = gets.chomp.to_i
                        market.buy_item(inventory, item, amount)

                    else
                        break
                    end
                end


            elsif continue == "vender" or continue == "v"
                loop do
                    inventory.show_inventory
                    puts "Mercador: Esses bagulhos ai são interessantes... Quer vender alguma coisa? "
                    puts "-->Vender (V)"
                    puts "--> Voltar"

                    continue= gets.chomp

                    if continue == "v" or continue == "vender"
                        print "Mercador: Qual? "
                        item = gets.chomp
                        print "Quantos? "
                        amount = gets.chomp.to_i
                        inventory.sell_item(item, amount)
                    else
                        break
                    end
                end
            else
                break
            end
            menu.actualmenu = "mercador"
        end

    end

    def travel_menu(player, places, menu, map)
        loop do
            puts "1. Ir para um lugar desconhecido."
            puts "2. Explorar novos horizontes."
            continue = gets.chomp.downcase
            if continue == "1"
                system('clear')
                puts "Estes são os lugares que você já visitou. Para aonde quer ir?"
                map.checkPlaces
                puts "-" * 15
                puts "-->Enter para voltar."
                print ""
                map.
                continue = gets.chomp

            elsif continue == "2"
                self.explore_menu(player, places, menu)
            end

        end
    end
end
