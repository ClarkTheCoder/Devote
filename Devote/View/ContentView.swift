//
//  ContentView.swift
//  Devote
//
//  Created by Carson Clark on 2024-02-02.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // Mark: - Property
    // managed object context - environment where we manipulate coredata objects in RAM
    // think of as scratch pad to retrieve, update, and store objects
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var task: String = ""
    
    // FETCHING DATA
    @FetchRequest(
        // 4 param - 1st entity (what we want to query)
        // 2nd, sort descriptor (sets order)
        // 3rd predicate - used to filter
        // animation
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    // contains all items
    private var items: FetchedResults<Item>
    
    // MARK: - Function
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
               
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 16) {
                    TextField("New Task", text: $task)
                        .padding()
                        .background(
                            Color(uiColor: .systemGray))
                        .cornerRadius(10)

                    Button(action: {
                        addItem()
                    }, label: {
                        Spacer()
                        Text("Save")
                    })
                }
                .padding()
                
                List {
                    ForEach(items) { swag in
                        NavigationLink {
                            Text("Item at \(swag.timestamp!, formatter: itemFormatter)")
                        } label: {
                            Text(swag.timestamp!, formatter: itemFormatter)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            } //: End of VStack
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            } //: End of Toolbar
        Text("Select an item")
        }//: End of Navigation
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
