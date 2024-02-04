//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Carson Clark on 2024-02-03.
//

import SwiftUI

struct NewTaskItemView: View {
    
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @State var task: String = ""
    @Binding var isShowing: Bool
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    //MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                TextField("New Task", text: $task)
                    .foregroundStyle(Color.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        Color(uiColor: .systemGray6))
                    .cornerRadius(10)
                Button(action: {
                    addItem()
                }, label: {
                    Spacer()
                    Text("Save")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                })
                .disabled(isButtonDisabled)
                .padding()
                .font(.headline)
                .foregroundStyle(Color.white)
                .background(isButtonDisabled ? Color.blue : Color.pink)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
            .frame(maxWidth: 640)
        }
        .padding()
    }
    
    //MARK: - Function
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
            isShowing = false
        }
    }

}

#Preview {
    NewTaskItemView(isShowing: .constant(true))
        .background(Color.gray.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
}
