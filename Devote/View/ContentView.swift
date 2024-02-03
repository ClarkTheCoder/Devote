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
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    // contains all items
    private var items: FetchedResults<Item>

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
            VStack{
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                        } label: {
                            VStack {
                                Text(item.task ?? "")
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .padding()
                .shadow(color: Color(red:0, green:0, blue:0, opacity:0.3), radius: 12)
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
                .padding(.vertical, 0)
                // Remove default vertical padding & maximize list on iPad devices
                .frame(maxWidth: 640)
                .navigationTitle("Daily Tasks")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }.background(BackgroundImageView())
            }
            .background(backgroundGradient)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
