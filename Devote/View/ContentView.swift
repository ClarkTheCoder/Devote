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
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    // FETCHING DATA
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    // contains all items
    private var items: FetchedResults<Item>
    
    // MARK: - Function
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
         
            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            task = ""
            hideKeyboard()
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
            ZStack {
                VStack {
                    VStack(spacing: 16) {
                        TextField("New Task", text: $task)
                            .padding()
                            .background(
                                Color(uiColor: .systemGray6))
                            .cornerRadius(10)
                        Button(action: {
                            addItem()
                        }, label: {
                            Spacer()
                            Text("Save")
                            Spacer()
                        })
                        .disabled(isButtonDisabled)
                        .padding()
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .background(isButtonDisabled ? Color.gray : Color.pink)
                        .cornerRadius(10)
                    }
                    .padding()
                    
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
                    }//: List
                    .shadow(color: Color(red:0, green:0, blue:0, opacity:0.3), radius: 12)
                    .listStyle(InsetGroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .padding(.vertical, 0)
                    // Remove default vertical padding & maximize list on iPad devices
                    .frame(maxWidth: 640)
                    
                }//: VStack
                .background(
                    BackgroundImageView()
                )
            }//: ZStack
            .navigationTitle("Daily Tasks")
            .background(backgroundGradient)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }//: Toolbar
        }//: Navigation
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
