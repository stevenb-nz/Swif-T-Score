//
//  ContentView.swift
//  Swif-T-Score
//
//  Created by Steven Brown on 23/04/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var fileContents = ""
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Tournament.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Tournament.endDate, ascending: true)
        ],
        animation: .default)
    private var items: FetchedResults<Tournament>

    var body: some View {
        HStack {
            Text(fileContents)
            Button("select File") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK {
                    if let url = panel.url?.standardizedFileURL {
                        if let contents = try? String(contentsOf: url) {
                            self.fileContents = contents
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        List {
            ForEach(items) { item in
                Text("Item at \(item.endDate!, formatter: itemFormatter)")
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Tournament(context: viewContext)
            newItem.endDate = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
