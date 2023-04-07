class Scenes
    attr_accessor :played_scenes, :non_played_scenes, :display

    def initialize
        @non_played_scenes= ["caça aos lobos"]
        @played_scenes= []
    end

    def had_played?(scene)
        @played_scenes.include?(scene)
    end

    def set_played(scene)
        self.played_scenes.push(scene)
        self.non_played_scenes.delete(scene)
    end

    def wolf_hunt(mission, player, inventory, gametime)
        if mission.is_inative?("caça aos lobos")

            mission.is_hunt?("caça aos lobos", 0)
            puts "Andando pelo bosque, você escuta uma singela melodia. Alguém está cantando? Bom, não importa. Siga com o que você viera fazer: caçar!"
            print ""
            continue = gets.chomp
            puts "-=" * 10
            puts "A medida que você continua, o assovio fica cada vez mais alto. È então que você finalmente nota que, por mais que achasse estar ignorando, na verdade, você estava seguindo a melodia. É ekktão que você encontra uma figura..."
            print ""
            continue = gets.chomp
            puts "-=" * 10
            puts "Caçador: Ora, veja se não é um rosto novo! caçe 5 lobos para mim, e receba meu arco. (Rushei pq to com preguiça de fazer agora.)"
            print ""
            continue = gets.chomp

                
            puts "-=" * 10
            mission.mission_start("caça aos lobos")
            self.set_played("caça aos lobos")
        end
    end
end