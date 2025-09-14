//
//  rust.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 14.09.2025.
//

@_silgen_name("theme")
func theme(_ password: UnsafePointer<CChar>,
           _ path_cartes: UnsafePointer<CChar>,
           _ nom: UnsafePointer<CChar>,
           _ date: UnsafePointer<CChar>,
           _ id: CInt) -> UnsafePointer<CChar>?

@_silgen_name("selection_traitment")
func selection_traitment(_ password: UnsafePointer<CChar>,
                         _ type_traitement: CInt,
                         _ id: CInt,
                         _ carte: CInt) -> UnsafePointer<CChar>?
@_silgen_name("free_cstring")
func free_cstring(_ ptr: UnsafeMutablePointer<CChar>)

public func rTheme(password: UnsafePointer<CChar>,
                   path_cartes: UnsafePointer<CChar>,
                   nom: UnsafePointer<CChar>,
                   date: UnsafePointer<CChar>,
                   id: CInt) -> UnsafePointer<CChar>? {
    return theme(password, path_cartes, nom, date, id)
}

public func rSelectionTraitement(password: UnsafePointer<CChar>,
                                 type_traitement: TypeTraitement,
                                 id: Int) -> UnsafePointer<CChar>? {
    return selection_traitment(password, CInt(type_traitement.rawValue), CInt(id), CInt(0))
}

public func rSelectionTraitementSecondaire(password: UnsafePointer<CChar>,
                                           type_traitement: TypeTraitement,
                                           id: Int,
                                           carte: Int) -> UnsafePointer<CChar>? {
    return selection_traitment(password, CInt(type_traitement.rawValue), CInt(id), CInt(carte))
}

public func rFreeCString(_ ptr: UnsafeMutablePointer<CChar>) {
    free_cstring(ptr)
}
