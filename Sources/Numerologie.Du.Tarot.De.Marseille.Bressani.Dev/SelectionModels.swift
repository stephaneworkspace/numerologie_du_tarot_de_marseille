//
//  SelectionModels.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 14.09.2025.
//

import Foundation
import SwiftUI

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
    
    public func makeAttributedTextWithExposants(fontSize: CGFloat = 12) -> (AttributedString, AttributedString, AttributedString) {
        
        func processHtml(_ htmlText: String?) -> AttributedString {
            guard let htmlText = htmlText else {
                return AttributedString("")
            }
            let parts = parseText(htmlText)
            var result = AttributedString()
            for part in parts {
                var attrPart = makeAttributedText(from: part.text)
                if part.isExposant {
                    attrPart.font = .system(size: fontSize)//.smallCaps()
                    attrPart.baselineOffset = fontSize * 0.5
                }
                result.append(attrPart)
            }
            return result
        }
        
        let attrHtml = processHtml(html)
        let attrHtmlR = processHtml(html_r)
        let attrHtmlR2 = processHtml(html_r2)
        
        return (attrHtml, attrHtmlR, attrHtmlR2)
    }
}

public struct SelectionTraitment: Codable {
    public let html: String
    public let html_b: String?
    public let html_r: String?
    public let aspects_cles: [String]
    
    public func makeAttributedTextWithExposants(fontSize: CGFloat = 12) -> (AttributedString, AttributedString, AttributedString) {
        
        func processHtml(_ htmlText: String?) -> AttributedString {
            guard let htmlText = htmlText else {
                return AttributedString("")
            }
            let parts = parseText(htmlText)
            var result = AttributedString()
            for part in parts {
                var attrPart = makeAttributedText(from: part.text)
                if part.isExposant {
                    attrPart.font = .system(size: fontSize)//.smallCaps()
                    attrPart.baselineOffset = fontSize * 0.5
                }
                result.append(attrPart)
            }
            return result
        }
        
        let attrHtml = processHtml(html)
        let attrHtmlB = processHtml(html_b)
        let attrHtmlR = processHtml(html_r)
        
        return (attrHtml, attrHtmlB, attrHtmlR)
    }
}

public struct SelectionAspect: Codable {
    public let nom: String
    public let sw_bold: Bool
    public let polarite: String
    public let def_robert_l1: String
    public let def_robert_l2: String
    public let def_robert_l3: String
    public let def_robert_l4: String
    public let def_robert_l5: String
}

public struct SelectionVocabulaireDivers: Codable {
    public let nom: String
    public let def_robert_l1: String
    public let def_robert_l2: String
    public let def_robert_l3: String
    public let def_robert_l4: String
    public let def_robert_l5: String
}


public struct Selection: Codable {
    public let note_de_cours: [SelectionNoteDeCours]
    public let aspects: [SelectionAspect]
    public let traitement: SelectionTraitment
    public let vocabulaire_divers: [SelectionVocabulaireDivers]
    // helper pour afficher les définitions (lignes def_robert_l1..l5) pour un nom d'aspect
    @ViewBuilder
    public func defsVStack(for name: String) -> some View {
        // on récupère l'aspect correspondant une seule fois
        if let aspect = self.aspects.first(where: { $0.nom == name }) {
            if !aspect.def_robert_l1.isEmpty {
                Text("1. \(aspect.def_robert_l1)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            if !aspect.def_robert_l2.isEmpty {
                Text("2. \(aspect.def_robert_l2)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            if !aspect.def_robert_l3.isEmpty {
                Text("3. \(aspect.def_robert_l3)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            if !aspect.def_robert_l4.isEmpty {
                Text("4. \(aspect.def_robert_l4)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            if !aspect.def_robert_l5.isEmpty {
                Text("5. \(aspect.def_robert_l5)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // helper pour générer la liste d'aspects pour une polarité ("+" ou "-")
    @ViewBuilder
    public func aspectsList(polarity: String) -> some View {
        let filtered = self.aspects.filter { aspect in
            self.traitement.aspects_cles.contains(aspect.nom) && aspect.polarite == polarity
        }
        ForEach(filtered, id: \.nom) { x in
            HStack(alignment: .top) {
                Text(x.nom)
                    .font(.system(.body, design: .default).smallCaps())
                    .fontWeight(x.sw_bold ? .bold : .regular)   // applique le bold conditionnel
                    .foregroundStyle(polarity == "+" ? .blue : .red) // couleur selon polarité
                    .frame(width: 200, alignment: .leading)

                VStack(alignment: .leading) {
                    defsVStack(for: x.nom)
                }
            }
        }
    }
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

func parseText(_ fullText: String) -> [(text: String, isExposant: Bool)] {
    var parts: [(String, Bool)] = []
    var remaining = fullText
    
    while let start = remaining.range(of: "###"),
          let end = remaining.range(of: "###", range: start.upperBound..<remaining.endIndex) {
        
        // Texte avant l'exposant
        let before = remaining[..<start.lowerBound]
        if !before.isEmpty {
            parts.append((String(before), false))
        }
        
        // Vérifier le dernier caractère du texte précédent
        if !before.isEmpty && !before.hasSuffix(" ") {
            // Ajouter un espace avant l’exposant
            parts.append((" ", false))
        }
        
        // Texte exposant
        let expo = remaining[start.upperBound..<end.lowerBound]
        parts.append((String(expo), true))
        
        // Reste du texte
        remaining = String(remaining[end.upperBound...])
    }
    
    // Texte final après le dernier exposant
    if !remaining.isEmpty {
        parts.append((String(remaining), false))
    }
    
    return parts
}
func makeAttributedText(from htmlText: String) -> AttributedString {
    var result = AttributedString(htmlText)

    // Patterns for bold and italic
    let boldPattern = "_BBB(.*?)BBB_"
    let italicPattern = "_III(.*?)III_"

    // Helper function to process matches and apply attribute
    func applyStyle(pattern: String, to result: inout AttributedString, fontTrait: (Font) -> Font) {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return }
        let nsString = NSString(string: String(result.characters))
        let matches = regex.matches(in: String(result.characters), options: [], range: NSRange(location: 0, length: nsString.length))
        for match in matches.reversed() {
            let captureNSRange = match.range(at: 1)
            let fullNSRange = match.range(at: 0)
            if let captureRange = Range(captureNSRange, in: result),
               let fullRange = Range(fullNSRange, in: result) {
                let capturedText = result[captureRange]
                var styledText = capturedText
                styledText.font = fontTrait(.system(.body))
                // Replace the full marker with styled text
                result.replaceSubrange(fullRange, with: styledText)
            }
        }
    }

    // Apply bold (_BBB_..._BBB_)
    applyStyle(pattern: boldPattern, to: &result, fontTrait: { $0.bold() })
    // Apply italics (_III_..._III_)
    applyStyle(pattern: italicPattern, to: &result, fontTrait: { $0.italic() })

    return result
}
