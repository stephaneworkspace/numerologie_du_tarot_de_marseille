//
//  Created by Stéphane Bressani on 01.06.2025.
//

import Foundation
import SwiftUI
import Numerologie_Du_Tarot_De_Marseille_Bressani_Dev

print(Message.hello())

//

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
