//
//  SelectionModels.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 14.09.2025.
//

import Foundation

public struct SelectionMotCle: Codable {
    let mot_cle: String
    let mot_cle_indice: String?
    let polarite: String?
}

public struct SelectionNoteDeCours: Codable {
    let mots_cles: [SelectionMotCle]
    let aspects_cles: [String]
    let html: String
    let html_r: String?
    let html_r2: String?
}

public struct SelectionTraitment: Codable {
    let html: String
    let html_b: String?
    let html_r: String?
}

public struct Selection: Codable {
    let note_de_cours: [SelectionNoteDeCours]
    let traitement: SelectionTraitment
}
