//
//  const.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 01.06.2025.
//
import Foundation

public struct Const {
    public static func api() -> String {
        return "https://numerologie.bressani.dev/api/"
    }
    public static func apiT() -> String {
        return "https://divination.bressani.dev/api/"
    }
    public static func token(optionalPassword: String?) -> String {
        if optionalPassword == nil {
            guard let url = Bundle.module.url(forResource: "Secrets", withExtension: "plist"),
                  let data = try? Data(contentsOf: url),
                  let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
                  let dict = plist as? [String: Any],
                  let _ = dict["api_password"] as? String else {
                return ""
            }
            return("\(dict["api_password"] as? String ?? "")")
        } else {
            return optionalPassword!
        }
    }
}
