//
//  ContentView.swift
//  Shared
//
//  Created by Maciej Moczadlo on 09/04/2022.
//

import SwiftUI
//Struktura pojedynczego zadania z prywatnym ID
struct Zadanie: Identifiable,Equatable,Codable {
    private(set) var id = UUID()
    var title: String
    var isCompleted: Bool = false
}
//Klasa listyZadan zapisujaca i odczytujaca z userDefaults dane
class ListaZadan: ObservableObject {
    @Published var todos: [Zadanie] = [] {
        didSet {
            if let data = try? JSONEncoder().encode(todos) {
                UserDefaults.standard.set(data,forKey: "TODO")
            }
        }
    }
    init() {
        if let data =  UserDefaults.standard.data(forKey: "TODO") {
            if let todos = try? JSONDecoder().decode([Zadanie].self,from:data) {self.todos = todos}
        }
    }
}
//Metoda wyswietlaja liste zadan
struct ContentView: View {
    //Zmienna środowiskowa bazy zadań
    @EnvironmentObject var database: ListaZadan
    @State var newZadanieTitle = ""
    @State var editMode: EditMode = .inactive
    var body: some View {
        HStack {
            NavigationView {
            List {
                
                ForEach(self.database.todos) {item in
                    NavigationLink(destination: ScrollView{
                        Text(item.title).font(.largeTitle).frame(minWidth: 0, maxWidth:.infinity, alignment: .leading).padding()
                    }
                        .navigationBarTitle("Szczegóły")
                    ) {
                        ZadanieRow(item: item)
                        .environment(\.editMode, self.$editMode)
                        
                    }
                    
                }
                .onDelete{(indices) in self.database.todos.remove(at:indices.first!)
                    
                }
                HStack {
                    Image(systemName: "circle").imageScale(.large).foregroundColor(Color(.systemGray3))
                    TextField("Nowe zadanie", text:$newZadanieTitle) {
                        self.database.todos.append(
                            Zadanie(title:self.newZadanieTitle))
                        self.newZadanieTitle = ""
                    }
                }
            }
            .navigationBarTitle("Lista zadań")
            .navigationBarItems( trailing: EditButton())
            .environment(\.editMode, self.$editMode)
            }
            
    }
        
    }}
//Glowna metoda
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ListaZadan())
    }
}
//Struktura wyswietlajaca linie zadania
struct ZadanieRow: View {
    @Environment(\.editMode)
    var editMode
    @EnvironmentObject var database: ListaZadan
    var item: Zadanie
    var body: some View {
        HStack{
            if editMode?.wrappedValue != .active {
            Image(systemName: item.isCompleted ? "checkmark.circle.fill":"circle").imageScale(.large).foregroundColor(item.isCompleted ? .green : .primary)
                .onTapGesture {
                    self.database.todos[self.database.todos.firstIndex(of: self.item)!].isCompleted.toggle()
                }
            }
            Text(item.title)
        }
    }
}
