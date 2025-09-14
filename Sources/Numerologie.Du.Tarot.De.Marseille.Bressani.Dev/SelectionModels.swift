//
//  SelectionModels.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 14.09.2025.
//

import Foundation

public struct SelectionMotCle: Codable {
    public let mot_cle: String
    public let mot_cle_indice: String?
    public let polarite: String?
}

public struct SelectionNoteDeCours: Codable {
    public let mots_cles: [SelectionMotCle]
    public let aspects_cles: [String]
    public let html: String
    public let html_r: String?
    public let html_r2: String?
}

public struct SelectionTraitment: Codable {
    public let html: String
    public let html_b: String?
    public let html_r: String?
}

public struct Selection: Codable {
    public let note_de_cours: [SelectionNoteDeCours]
    public let traitement: SelectionTraitment
}

public enum TypeTraitement: Int, Codable {
    case ppr = 1
    case cae = 2
    case coe = 3
    case cai = 4
    case coi = 5
    case int = 6
    case nem = 7
    case pex = 8
    case rha = 9
}
