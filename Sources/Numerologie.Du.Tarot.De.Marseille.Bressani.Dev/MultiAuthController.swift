//
//  MultiAuthController.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 06.09.2025.
//

import Foundation

public struct MultiAuthController {
    public init(password: String? = nil) {
        self.password = password
        if password == nil {
            self.password = Const.token(optionalPassword: password)
        }
        self.token_n = AuthTokenProvider.token(for: URL(string: Const.api())!, password: password)
        self.token_t = AuthTokenProvider.token(for: URL(string: Const.apiT())!, password: password)
        if self.token_n != nil {
            print("✅ Token ok pour: " + Const.api() + " " + self.token_n!)
        }
        if self.token_t != nil {
            print("✅ Token ok pour: " + Const.apiT() + " " + self.token_t!)
        }
    }
    
    var password: String? = nil
    var token_n: String? = nil
    var token_t: String? = nil
    
    public func getToken() -> (String?, String?) {
        return (token_n, token_t)
    }
}
