require_relative "entidades.rb"
class Inventory
    attr_accessor :allItems, :items, :money, :equipped_items, :armor_equipped, :weapon_equipped

    def initialize
        @items= Hash.new
        @equipped_items= Hash.new
        @money= 0
        @armor_equipped= Hash.new
        @weapon_equipped= Hash.new
        @allItems={"pele de lobo"=>{:amount=>0, :value=>0, :type=>"geral"},
        "carne"=>{:amount=>0, :value=>0, :type=>"geral"},
        "pele de urso"=>{:amount=>0, :value=>0, :type=>"geral"},
        "fluído gosmento"=>{:amount=>0, :value=>0, :type=>"geral"},
        "cristal escuro"=>{:amount=>0, :value=>0, :type=>"geral"},

        "espada de ferro"=>{:amount=>0, :value=>0, :type=>"arma", :up=>40},
        "espada de aço"=>{:amount=>0, :value=>0, :type=>"arma", :up=>80},

        "poção de cura"=>{:amount=>0, :value=>0, :type=>"cura", :up=>40},

        "armadura de couro"=>{:amount=>0, :value=>0, :type=>"armadura", :up=>20},
        "armadura de placas de ferro"=>{:amount=>0, :value=>0, :type=>"armadura", :up=>40}
        }
    end

    def add_item(item, amount, value)
        if self.has_item?(item)
            # Item já existe, adiciona quantidade e atualiza valor total
            @items[item][:amount] += amount
            @items[item][:value] += value
        else
            # Item não existe, cria um novo hash para ele
            @items[item] = {:amount=> amount, :value=> value}
        end
    end

    def add_especial(item, amount, value, type, up)
        if self.has_item?(item)
            # Item já existe, adiciona quantidade e atualiza valor total
            @items[item][:amount] += amount
            @items[item][:value] += value
        else
            @items[item] = {:amount=> amount, :value=> value, :type=> type, :up=> up}
        end
    end

    def has_item?(item)
        @items.include?(item)
    end

    def use_item(item)
        if self.has_item?(item)
            if items[item]["type"] != "cura"
                puts "Isto não é um item de cura."
            else
                curative = items[item]
                if curative[:amount] >= 0
                    puts "Este item acabou."
                else
                    @life += curative[:up]
                    if @life > maxlife
                        @life = maxlife
                        puts "Você usou #{item} e recuperou toda a sua vida."
                    else
                        puts "Você usou #{item} e recuperou #{curative[:up]} pontos de vida."
                    end
                    curative[:amount] -= 1
                    @usou_item = true
                end
            end

        else
            puts "Você não tem um item de cura chamado #{item}."
        end
    end

    def show_inventory
        puts "=====--MEU INVENTARIO--====="
        puts "-->Carteira= #{money}$"
        puts "-->Itens"
        if @items.nil?
            puts "Não há items."

        else
            @items.each do |item, data|
                if data[:amount] > 0
                    puts "--> #{item}= #{data[:amount]}"
                end
            end
        end
        puts "-" * 20
        puts "-->Equipados"
        if @equipped_items.nil?
            puts "Não há itens equipados.."
        else
            @equipped_items.each do |item, data|
                if equipped_items[item][:amount] > 0
                    if data[:type] == "arma"
                        puts "====>> Armas <<===="
                        puts "-->#{item} (#{data[:type]}, +#{data[:up]} de dano)"

                    elsif data[:type] == "armadura"
                        puts "-->#{item} (#{data[:type]}, +#{data[:up]} de defesa)"
                    end
                end
            end
        end
        puts "-=" * 10
    end

    def sell_item(item, amount)
        if self.has_item?(item)
            item = @items[item]
            if item[:amount] < amount
                puts "Não há quantidade suficiente do item #{item}."
            else
                value_per_item = item[:value] / item[:amount]
                total_value = value_per_item * amount
                item[:amount] -= amount
                item[:value] -= total_value
                @money += total_value
                puts "Com a venda, você conseguiu #{total_value} moedas."
                return total_value
            end
        else
            puts "O item #{item} não está no inventário."
            return 0
        end
    end

    def equip_item(item)
        if @items[item].nil?
            puts "Este item não está em seu inventário."

        elsif @items[item][:type] == "arma"
            if @weapon_equipped.nil?
                @equipped_items[item] = @items[item]
                @equipped_items[item][:amount] += 1
                weapon = @equipped_items[item]
                @weapon_equipped = weapon
                self.items[item][:amount] -= 1
                puts "Você equipou uma arma!"
            else
                puts "Você não pode equipar mais de uma arma."

            end

        elsif @items[item][:type] == "armadura"
            if @armor_equipped.nil?
                @equipped_items[item] = @items[item]
                @armor_equipped = @equipped_items[item]
                puts "Você equipou uma armadura!"
            else
                puts "Você não pode equipar mais de uma armadura."
            end
        end

        print ""
        continue = gets.chomp

    end

    def remove_item(item)
        if self.equipped_items[item] == nil
            puts "Este item não esta equipado."
        else
            equipped = self.equipped_items[item]
            if equipped[:type] == "arma"
                @weapon_equipped = nil
                equipped_items[item][:amount] -= 1
                puts "Arma removida."

            elsif equipped[:type] == "armadura"
                @armor_equipped = nil
                equipped_items[item][:amount] -= 1
                puts "Armadura removida."
            end
            @equipped_items.delete(equipped)
        end
        print ""
        continue = gets.chomp
    end

    def show_equipped_items
        if @equipped_items.nil?
            puts "Esta vazio."
        else
            @equipped_items.each do |item, data|
                if equipped_items[item][:amount] > 0
                    if data[:type] == "arma"
                        puts "====>> Armas <<===="
                        puts "-->#{item} (#{data[:type]}, +#{data[:up]} de dano)"

                    elsif data[:type] == "armadura"
                        puts "-->#{item} (#{data[:type]}, +#{data[:up]} de defesa)"
                    end
                end
            end
        end
        continue = gets.chomp
    end
end



class Market
    attr_accessor :item, :value, :amount, :market_items

    def initialize
        @market_items={
        "espada de ferro"=>{:amount=>1, :value=>20, :type=>"arma", :up=>40},
        "espada de aço"=>{:amount=>1, :value=>40, :type=>"arma", :up=>80},
        "poção de cura"=>{:amount=>10, :value=>15, :type=>"cura  ", :up=>40},
        "armadura de couro"=>{:amount=>1, :value=>30, :type=>"armadura", :up=>20}
        }
    end

    def show_market(inventory)
        if self.market_items == nil
            puts "-" * 15
            puts "Não há nada no estoque."
            puts "-" * 15
        else
            puts "-=" * 10
            puts "Carteira: #{inventory.money} moedas."
            puts "-" * 20
            self.market_items.each do |item, data|
                if data[:amount] > 0
                    if data[:type] == "arma"
                        puts "--> #{item} = #{data[:value]} moedas (+#{data[:up]} de dano)"
                        puts "EStoque= #{data[:amount]}"
                        puts "-" * 20

                    elsif data[:type] == "cura"
                        puts "-->#{item} = #{data[:value]} moedas (cura #{data[:up]} de vida)"
                        puts "Estoque= #{data[:amount]}"
                        puts "-" * 20

                    elsif data[:type] == "armadura"
                        puts "--> #{item} = #{data[:value]} moedas (+#{data[:up]} de defesa)"
                        puts "Estoque= #{data[:amount]}"
                    end
                end
            end

            puts "-" * 15
        end

    end

    def buy_item(inventory, item, amount)
        if @market_items[item] == nil
            puts "Mercador: Não vendo isto aqui. Não vê a placa?"
        else
            market_item = @market_items[item]

            if market_item[:amount] < amount
                puts "Mercador: Não tenho tudo isso em estoque."

            elsif market_item[:amount] <= 0
                puts "Mercador: Este item esta fora de estoque."

            else
                value_per_item= market_item[:value]/market_item[:amount]
                total_value = value_per_item * amount

                if inventory.money < total_value
                    puts "-" * 15
                    puts "= Mercador: Estando pobre assim? Ha."
                    puts "-" * 15
                else
                    if inventory.has_item?(item)
                        buy_item = inventory.items[item]
                        buy_item[:amount] += 1
                        puts "Mercador: Você comprou um(a) #{item} por #{total_value} moedas"
                        inventory.money -= total_value
                    else
                        inventory.items[item] = @market_items[item]
                        inventory.items[item][:amount] += amount
                        puts "Mercador: Você comprou um(a) #{item} por #{total_value} moedas"
                        inventory.money -= total_value
                    end
                    market_item[:amount] -= 1
                end
            end
        end
        print ""
        continue = gets.chomp
    end
end


