//
//  Created by Stéphane Bressani on 01.06.2025.
//

import Foundation
import SwiftUI
import Numerologie_Du_Tarot_De_Marseille_Bressani_Dev

let nomC = "Stéphane".cString(using: .utf8)!
let dateC = "03.04.1986".cString(using: .utf8)!
let pathCartesC = "./".cString(using: .utf8)!
let url = URL(fileURLWithPath: "./Sources/Numerologie.Du.Tarot.De.Marseille.Bressani.Dev/Resources/Secrets.plist")
let data = try? Data(contentsOf: url)
let plist = try? PropertyListSerialization.propertyList(from: data!, options: [], format: nil)
if let dict = plist as? [String: Any],
   let password = dict["api_password"] as? String,
   let passwordC = password.cString(using: .utf8) {
    // passwordC est maintenant un [CChar]
    /*if let ptr = theme(passwordC, pathCartesC, nomC, dateC, 43) {
        let str = String(cString: ptr)
        print(str)
    } else {
        print("Erreur rust")
    }*/
    if let ptr = rSelectionTraitement(password: passwordC,
                                      type_traitement: TypeTraitement.ppr,
                                      id: 43) {
        let jsonString = String(cString: ptr)

        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let selection = try JSONDecoder().decode(Selection.self, from: jsonData)
                print("✅ Décodé en struct:", selection)
            } catch {
                print("❌ Erreur de décodage:", error)
                print("Chaîne JSON brute:", jsonString)
            }
        }
        // ⚠️ libérer le CString
        rFreeCString(UnsafeMutablePointer(mutating: ptr))
    }
} else {
    print("Mot de passe manquant ou invalide")
    exit(1)
}


let controller = MultiAuthController()
guard let token = controller.getToken().1 else {
    print("Token manquant")
    exit(1)
}

let tNumerologieController = TNumerologieController(token: token)


let mainTask = Task {
    // getShow
    do {
        let themes = try await tNumerologieController.getShow(numerologie_type: 1)
        for theme in themes {
            print("\(theme.id): \(theme.annee)")
        }
    } catch {
        print("Erreur getShow: \(error)")
    }

    // getIndex
    do {
        let theme = try await tNumerologieController.getIndex(id: 1)
        print("\(theme.id): \(theme.jour).\(theme.mois).\(theme.annee)")
    } catch {
        print("Erreur getIndex: \(error)")
    }

    // Quitter le programme si nécessaire
    exit(0)
}

// Maintenir le RunLoop principal pour permettre à Task de s'exécuter
RunLoop.main.run()




/*


let controller = LameMajeuresController()

let semaphore = DispatchSemaphore(value: 0)

controller.getAllLamesMajeures { result in
    switch result {
    case .success(let lames):
        for lame in lames {
            print("\(lame.id): \(lame.cartouche)")
        }
    case .failure(let error):
        print("Erreur: \(error)")
    }
    semaphore.signal()
}

semaphore.wait()

//

controller.getLameMajeure(id: 1) { result in
    switch result {
    case .success(let lame):
        print("Lame 1 → \(lame.nombre_romain): \(lame.cartouche)")
    case .failure(let error):
        print("Erreur (lame id 1): \(error)")
    }
    semaphore.signal()
}

semaphore.wait()


let t_controller = ThemeController()

t_controller.downloadXlsx(prenoms: "Jean-Sebastien", noms: "Dupont", date: "1981-01-01") { result in
    switch result {
    case .success(let fileURL):
        print("Fichier téléchargé à : \(fileURL)")
    case .failure(let error):
        print("Erreur : \(error)")
    }
}

semaphore.wait()*/
