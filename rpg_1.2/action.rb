
module Action

    def hunt_bosque(player, gametime, mission, inventory, scene)
        if scene.had_played?("caça aos lobos")
            puts "--> Procurar caça."
            puts "--> Falar com o caçador."
            puts "--> Voltar."
            print ""
            continue= gets.chomp.downcase

            if continue == "caçador"
                print "Caçador: Você trouxe o que lhe pedi? (s/n)"
                continue= gets.chomp.downcase
                if continue == "s" or continue == "sim"
                    if mission.is_on_going?("caça aos lobos")
                        puts "Caçador: Não me parece que você tenha terminado..."

                    elsif mission.is_completed?("caça aos lobos")
                        status_of_mission = mission.completed["caça aos lobos"]
                        if status_of_mission[:status] == "not finished"
                            inventory.money += 100
                            inventory.add_especial("arco do caçador", 1, 20, "arma", 80)
                            puts "Caçador: Fez o que prometeu, nada mais justo do que uma recompensa! Aqui está, um arco e 100 moedas."
                            status_of_mission[:progress] = "finished"
                        else
                            puts "Caçador: Muito obrigado pela sua ajuda!"
                        end
                    end

                else
                    puts "Caçador: Que pena..."
                end
                print ""
                continue = gets.chomp

            elsif continue == "caça"
                chance = rand(1..100)
                puts "Você começou a procurar por uma caça..."

                case chance
                when 90..100
                    puts "você encontrou um urso!"
                    print ""
                    continue= gets.chomp
                    animal= Enemy.new("urso", 120, 60, 20)
                    player.battle(player, animal, gametime, mission, inventory)

                when 20..89
                    puts "Você encontrou um lobo!"
                    print ""
                    continue= gets.chomp
                    animal= Enemy.new("lobo", 80, 20, 10)
                    player.battle(player, animal, gametime, mission, inventory)
                else
                    puts "Você procurou, mas não teve sorte..."
                    print ""
                    continue= gets.chomp
                end
            end

        else
            scene.wolf_hunt(mission, player, inventory, gametime)
        end
    end

    def hunt_forest(player, gametime, mission, inventory, scene)
        system('clear')
        print "Você anda dentre as árvores mortas da floresta sombria, anseando pela sua propria vida. os sussurros são amedontradores..."
        puts "Você começou a procurar por uma caça..."
        chance = rand(1..100)
        case chance
        when 90..100
            puts "você encontrou um espírito sombrio!"
            print ""
            continue= gets.chomp
            animal= Enemy.new("espirito sombrio", 400, 100, 25)
            player.battle(player, animal, gametime, mission, inventory)

        when 20..89
            puts "Você encontrou uma gosma gigante!"
            print ""
            continue= gets.chomp
            animal= Enemy.new("lesma", 300, 80, 10)
            player.battle(player, animal, gametime, mission, inventory)
        else
            puts "Você procurou, mas não teve sorte..."
        end
        print "Pressione enter"
        continue = gets.chomp
    end

    #enemy, player, gametime, inventory, mission
    def battle(player, enemy, gametime, mission, inventory)


        #define quem começará o combate

        if self.attributes["destreza"] >= enemy.enemydex
            puts "Você se aproxima do #{enemy.enemyname}, e ele não parece ter te notado. Aproveitando, você dá o primeiro golpe!"
            self.attack(player, inventory, enemy)


            if enemy.life <= 0
                puts "O #{enemy.enemyname} esta morto."
            end

        else
            puts "o #{enemy.enemyname} te percebe, e ele te ataca!"
            enemy.ataque(player, inventory)
            puts "-=" * 10
            if self.life <= 0
                puts "O(a) #{enemy.enemyname} te estraçalhou. Você morreu."
                exit
            end
        end

        #loop para o combate continuar até um dos dois morrer.

        print ""
        continue= gets.chomp
        system('clear')
        loop do
            @fugir= false

            if enemy.life <= 0
                break
            end

            #se voce estiver vivo em seu turno, voce vai poder agir.
            if self.life <= 0
                puts "O(a) #{enemy.enemyname} te estraçalhou. Você morreu."
                exit
            else
                puts "-=" * 10
                self.your_turn(player, inventory, enemy)
                if @fugir == true
                    break
                end
            end

            #se o animal estiver vivo em seu turno, ele vai atacar.
            if enemy.life > 0
                puts "O #{enemy.enemyname} te ataca!"
                enemy.ataque(player, inventory)

            else
                puts "O(a) #{enemy.enemyname} está morto."
            end
            print ""
            continue= gets.chomp

        end

        if @fugir == true
            puts ""

        else
            if enemy.enemyname == "lobo"
                inventory.add_item("pele de lobo", 1, 5)
                inventory.add_item("carne", 1, 5)
                puts "Carne e pele de lobo foram adicionados ao inventario."
                enemyxp= 150
                self.xp_gain(enemyxp)
                puts "-=" * 10
                gametime.pass_time

                if mission.is_on_going?("caça aos lobos")
                    lobos_cacados = mission.on_going["caça aos lobos"]
                    lobos_cacados[:progress] += 1
                    if lobos_cacados[:progress] == 5
                        puts "Você completou uma missão!"
                        mission.completed["caça aos lobos"] = mission.on_going["caça aos lobos"]
                        mission.on_going.delete("caça aos lobos")
                    elsif lobos_cacados[:progress] < 5
                        puts "Você caçou um lobo. Progresso: #{lobos_cacados[:progress]}/5"
                        puts "-" * 5
                    end
                end

            elsif enemy.enemyname == "urso"
                inventory.add_item("pele de urso", 1, 10)
                inventory.add_item("carne", 2, 5)
                puts "Carne e pele de urso foram adicionados ao inventario."
                enemyxp= 300
                self.xp_gain(enemyxp)
                puts "-=" * 10
                gametime.pass_time

            elsif enemy.enemyname == "lesma"
                inventory.add_item("fluido gosmento", 1, 30)
                puts "Fluido Gosmento foi adicionados ao inventario."
                enemyxp= 500
                self.xp_gain(enemyxp)
                puts "-=" * 10
                gametime.pass_time

            elsif enemy.enemyname == "espirito sombrio"
                inventory.add_item("cristal escuro", 1, 50)
                puts "Cristal Escuro foram adicionados ao inventario."
                enemyxp= 700
                self.xp_gain(enemyxp)
                puts "-=" * 10
                gametime.pass_time
            end
            print ""
            continue = gets.chomp
        end
    end

end



