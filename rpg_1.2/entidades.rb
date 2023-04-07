require_relative "action.rb"
require_relative "inventory.rb"

class Player
    attr_accessor :name, :xp, :xp_necessario, :level, :maxlife, :life, :attributes, :attributepoints, :lower_damage, :higher_damage, :actual_damage

    include Action

    def initialize(name)
        @name = name
        @xp = 0
        @xp_necessario = 50
        @level = 1
        @maxlife = 100
        @life = maxlife
        @attributes = {"força"=> 1, "destreza"=> 1, "constituição"=> 1, "Inteligência"=> 1}
        @attributepoints = 10
        @lower_damage = 30
        @higher_damage = lower_damage + 30
    end

    def xp_gain(enemyxp)
        self.xp += enemyxp

        level_up= 0

        while self.xp >= self.xp_necessario
            case self.level

            when 1..10
                @level += 1
                @lower_damage += 2
                @higher_damage += 2
                @maxlife += 5
                @life += 5
                @attributepoints += 5
                self.xp -= self.xp_necessario
                self.xp_necessario += 50
                level_up += 1

            when 11..30
                @level += 1
                @lower_damage += 5
                @higher_damage += 5
                @maxlife += 10
                @life += 10
                @attributepoints += 10
                self.xp -= self.xp_necessario
                self.xp_necessario += 50
                level_up += 1

            else
                @level += 1
                @lower_damage += 10
                @higher_damage += 10
                @maxlife += 15
                @life += 15
                @attributepoints += 15
                self.xp -= self.xp_necessario
                self.xp_necessario += 40
                level_up += 1
            end
        end

        puts "Você ganhou #{enemyxp} de experiência."
        if level_up > 0
            puts "Você upou #{level_up} niveis."
        end
    end

    def distribuir

        if attributepoints <= 0
            puts "-=" * 10
            puts "Você não possui pontos para distribuir."
            puts "-=" * 10
            print "Enter para continuar."

            continue = gets.chomp

        else
            loop do
                if attributepoints <= 0
                    puts "-=" * 10
                    puts "Você não possui pontos para distribuir."
                    puts "-=" * 10
                    puts "Pressione enter para continuar."
                    continue = gets.chomp
                    break
                else


                    puts "-=" * 10
                    puts "Você tem #{attributepoints}"
                    puts "Em qual atributo você quer aplicar pontos?"
                    puts "1. Força"
                    puts "2. Destreza"
                    puts "3. Constituição"
                    puts "4. Sair"
                    puts "-=" * 10
                    print ""

                    status = gets.chomp
                    if status == "1"
                        print "Quantos pontos?"
                        amount_points = gets.chomp.to_i

                        if amount_points > attributepoints
                            puts "Você não tem essa quantidade de pontos."

                        elsif amount_points <= attributepoints
                            @attributes["força"] += amount_points
                            @lower_damage += amount_points * 2
                            @higher_damage += amount_points * 2
                            @attributepoints -= amount_points
                            puts "Foram adicionados #{amount_points} em força."
                            print "Pressione enter"
                            continue = gets.chomp
                        end

                    elsif status == "2"
                        print "Quantos pontos?"
                        amount_points = gets.chomp.to_i

                        if amount_points > attributepoints
                            puts "Você não tem essa quantidade de pontos."

                        elsif amount_points <= attributepoints
                            @attributes["destreza"] += amount_points
                            @attributepoints -= amount_points
                            puts "Foram adicionados #{amount_points} em destreza."
                            print "Pressione enter"
                            continue = gets.chomp
                        end

                    elsif status == "3"
                        print "Quantos pontos?"
                        amount_points = gets.chomp.to_i

                        if amount_points > attributepoints
                            puts "Você não tem essa quantidade de pontos."

                        elsif amount_points <= attributepoints
                            @attributes["constituição"] += amount_points
                            @maxlife += amount_points * 2
                            @life += amount_points * 2
                            @attributepoints -= amount_points
                            puts "Foram adicionados #{amount_points} em constituição."
                            print "Pressione enter"
                            continue = gets.chomp
                        end

                    elsif status == "4"
                        break

                    else
                        "Digite o numero correto."
                    end
                end
            end
        end
    end

    def display_perfil(inventory)
        puts "=" * 15
        puts "Nivel= #{@level}"
        puts "XP= #{@xp} / #{@xp_necessario}"
        puts "-" * 15
        puts "Força= #{@attributes["força"]}"
        puts "Destreza= #{@attributes["destreza"]}"
        puts "Constituição= #{@attributes["constituição"]}"
        puts "-" * 15
        puts "Vida= #{@maxlife}/#{@life}"
        puts "Dano= #{@lower_damage} - #{higher_damage}"
        if @armor_equipped != nil
            defense= @armor_equipped[:up]
            puts "Defesa= #{defense}"
        end
        puts "=" * 15
        puts "Escreva 'D' para distribuir pontos."
        puts "Escreve 'I' para mostrar informações dos atributos."
        puts "Pressione enter para voltar."
        print ""
        continue= gets.chomp

        if continue == "i"
            puts "Força --> Aumenta o dano."
            puts "Destreza --> Define se você começa o combate ou não."
            puts "Constituição --> Aumenta sua vida."

            print "Presione enter  para continuar. "
            continue= gets.chomp

        elsif continue == "d"
            self.distribuir

        else
            puts ""
        end
    end

    def check_weapon(inventory)
        if @weapon_equipped != nil
            actual_damage += @equipped_items[item][:up]
        end
    end

    def attack(player, inventory, enemy)
        self.check_weapon(inventory)

        dado= rand(1..20)
        if dado >= 18
            total_damage= rand(self.lower_damage...self.higher_damage)
            @actual_damage= total_damage * 2
            enemy.life -= self.actual_damage
            puts "Ataque crítico!"
        else
            @actual_damage= rand(self.lower_damage..self.higher_damage)
            enemy.life -= self.actual_damage
        end
        puts "Você acertou, e o #{enemy.enemyname} levou #{actual_damage} de dano, o deixando com #{enemy.life} de vida!"
    end

    def your_turn(player, inventory, enemy)
        loop do

            @usou_item= false

            puts "Seu turno."
            puts "-Atacar (A)"
            puts "-Itens (I)"
            puts "-Fugir (F)"
            print ""
            continue= gets.chomp
            if continue == "a" or continue == "atacar"
                self.attack(player, inventory, enemy)
                break

            elsif continue == "i" or continue == "itens"
                puts "ITENS"
                puts "-" * 10
                if inventory.nil?
                    puts "Esta vazio."
                else
                    inventory.items.each do |item, data|
                        if data["type"] == "cura"
                            if inventory.items.nil?
                                puts "Você não tem itens utilizáveis."
                            else
                                puts "#{item} +#{data[:up]} de vida."
                            end
                        end
                    end
                end
                puts "-" * 10
                puts "-->Usar item de cura (C)"
                puts "-->Voltar (enter)"
                print ""
                continue = gets.chomp

                if continue == "c" or continue == "cura"
                    puts "-" * 10
                    puts "-->Qual item você deseja usar?"
                    print ""
                    item= gets.chomp
                    inventory.use_item(item)
                    if @usou_item == true
                        break
                    end
                else
                    puts ""
                end

            elsif continue == "f" or continue == "fugir"
                @fugir = true
                puts "Você fugiu."
                break

            else
                puts "Isto não esta em sua lista de ações"
            end
        end
    end

    def rest(gametime)
        system('clear')
        puts "-=" * 10
        puts "Voce descansou. Sua vida foi recuperada."
        puts "-=" * 10
        self.life = self.maxlife
        gametime.time = "manhã"
        gametime.pass_time
        continue = gets.chomp
    end
end


class Enemy
    attr_accessor :enemyname, :life, :damage, :enemydex

    def initialize(enemyname, life, damage, enemydex)
        @enemyname = enemyname
        @life = life
        @damage = damage
        @enemydex = enemydex
    end

    def ataque(player, inventory)
        if inventory.armor_equipped != nil
            armor = inventory.armor_equipped
            self.damage -= armor[:up]
            player.life -= self.damage
            puts "Ele te deu #{self.damage} de dano, mas sua armadura reduziu #{armor[:up]}!"
            puts "Você esta com #{player.life} de vida!"
        else
            player.life -= self.damage
            puts "Ele te deu #{self.damage} de dano!"
            puts "Você esta com #{player.life} de vida!"
        end
    end
end





