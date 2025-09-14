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
                         _ id: CInt) -> UnsafePointer<CChar>?
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
                                 type_traitement: CInt,
                                 id: CInt) -> UnsafePointer<CChar>? {
    return selection_traitment(password, type_traitement, id)
}

public func rFreeCString(_ ptr: UnsafeMutablePointer<CChar>) {
    free_cstring(ptr)
}
