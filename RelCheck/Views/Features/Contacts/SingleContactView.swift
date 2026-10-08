//
//  SingleContactView.swift
//  notifyme
//
//  Created by Anne Ferret on 13/11/2025.
//

import SwiftUI
import SwiftData

struct SingleContactView: View {
  @Environment(AppNavigator.self) private var navigator
  @Environment(\.modelContext) private var modelContext

  @Bindable var contact: Contact
  @State private var hasCheckedIn: Bool = false
  @State private var showDeleteAlert: Bool = false

  var body: some View {
    Form {
      SingleContactCard(contact)
      if hasCheckedIn {
        VStack(alignment: .center, spacing: 16) {
          Image(systemName: "checkmark.message.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.white)
            .frame(maxWidth: 55)
          HStack {
            Spacer()
            Text("singleContact.checkInCompleted").font(.headline)
            Spacer()
          }
        }
        .foregroundStyle(.white)
        .frame(minHeight: 200)
        .listRowBackground(LinearGradient.primary)
      } else {
        VStack(alignment: .center, spacing: 16) {
          Image(systemName: "questionmark.message.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(LinearGradient.primary)
            .frame(maxWidth: 55)
          HStack {
            Spacer()
            Text("singleContact.didYouJustCheckInWith \(contact.name)").font(.headline)
            Spacer()
          }
          Button("button.checkIn") { checkIn() }
            .buttonStyle(GlassButton())
        }
        .frame(minHeight: 200)
      }
      Section {
        if contact.checkIns?.isEmpty == true {
          Text("singleContact.noCheckInsYet \(contact.name)").font(.subheadline)
        } else {
          ForEach(contact.checkIns?.reversed() ?? []) { checkIn in
            Text(checkIn.dateFormatted).font(.subheadline)
          }
        }
      } header: {
        Label("singleContact.header.checkInHistory", systemImage: "ellipsis.message")
      }
    }
    .navigationTitle($contact.name)
    .navigationBarTitleDisplayMode(.inline)

    .alert(
      "singleContact.deleteAlert.title",
      isPresented: $showDeleteAlert,
    ) {
      Button("button.delete", role: .destructive) {
        contact.delete(from: modelContext)
        navigator.back()
      }
      Button("button.cancel", role: .cancel) {}
    } message: {
      Text("singleContact.deleteAlert.message")
    }

    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("button.delete", systemImage: "trash") { showDeleteAlert = true }
          .tint(.red)
      }
      ToolbarItem(placement: .primaryAction) {
        Button {
          navigator.push(.editContact(id: contact.id))
        } label: {
          Label("button.edit", systemImage: "pencil")
        }
      }
    }
  }

  private func checkIn() {
    contact.checkIn(modelContext: modelContext)
    try? modelContext.save()
    hasCheckedIn = true
  }
}

#Preview {
  @Previewable @State var contact = Preview.contact
  SingleContactView(contact: contact).environment(AppNavigator())
}
