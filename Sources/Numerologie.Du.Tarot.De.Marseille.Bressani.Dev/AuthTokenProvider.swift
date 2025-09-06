//
//  AuthTokenProvider.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 14.07.2025.
//

import Foundation

public enum AuthTokenProvider {
    public static func token(for baseURL: URL, password: String?) -> String {
        final class Box<T>: @unchecked Sendable {
            var value: T
            init(_ value: T) { self.value = value }
        }

        let tokenBox = Box<String?>(nil)
        let semaphore = DispatchSemaphore(value: 0)

        var components = URLComponents(url: baseURL.appendingPathComponent("token_ipad"), resolvingAgainstBaseURL: false)!
               components.queryItems = [URLQueryItem(name: "password", value: Const.token(optionalPassword: password))]


        guard let url = components.url else {
            return ""
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"  //
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            defer { semaphore.signal() }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let token = json["token"] as? String else {
                return
            }
            tokenBox.value = token
        }.resume()

        semaphore.wait()
 
        let tokenValue = tokenBox.value ?? ""
        //print("token: \(tokenValue)")
        return tokenValue
    }
}
