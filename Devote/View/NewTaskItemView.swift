//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Carson Clark on 2024-02-03.
//

import SwiftUI

struct NewTaskItemView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var task: String = ""
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    var body: some View {
        VStack {
            Spacer()
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
            .shadow(color: Color(red:0, green:0, blue:0, opacity:0.3), radius: 12)
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            .padding(.vertical, 0)
            // Remove default vertical padding & maximize list on iPad devices
            .frame(maxWidth: 640)
            
        }
        }
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

}

#Preview {
    NewTaskItemView()
        .background(Color.gray.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
}
