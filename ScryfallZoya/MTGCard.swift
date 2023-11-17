// MTGCard.swift
import Foundation

struct MTGCard: Codable, Identifiable {
    var id: UUID
    var name: String
    var type_line: String
    var oracle_text: String
    var image_uris: ImageURIs?
    var legalities: Legalities
    var collector_number: String
    var rarity: String
    var mana_cost: String

    // Define other properties as needed based on your JSON structure

    struct ImageURIs: Codable {
        var small: String?
        var normal: String?
        var large: String?
        var art_crop: String?
        var border_crop: String?
        var png: String?
        // Add other image URL properties if needed
    }
    
    struct Legalities: Codable {  // Nested struct for legalities
            var standard: String
            var future: String
            var historic: String
            var gladiator: String
            var pioneer: String
            var explorer: String
            var modern: String
            var legacy: String
            var pauper: String
            var vintage: String
            var penny: String
            var commander: String
            var oathbreaker: String
            var brawl: String
            var historicbrawl: String
            var alchemy: String
            var paupercommander: String
            var duel: String
            var oldschool: String
            var premodern: String
            var predh: String
        }
    
}

struct MTGCardList: Codable {
    var object: String
    var total_cards: Int
    var has_more: Bool
    var data: [MTGCard]
}


