//
//  ToDoAPPApp.swift
//  Shared
//
//  Created by Maciej Moczadlo on 09/04/2022.
//

import SwiftUI

@main
struct ToDoAPPApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ListaZadan())
        }
    }
}
