//
//  const.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 01.06.2025.
//
import Foundation

public struct Const {
    public static func api() -> String {
        return "https://numerologie.du.tarot.de.marseille.bressani.dev:1122"
    }
    public static func token() -> String {
        guard let url = Bundle.module.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
              let dict = plist as? [String: Any],
              let _ = dict["api_token"] as? String else {
            return ""
        }
        return("\(dict["api_token"] as? String ?? "")")
    }
}
