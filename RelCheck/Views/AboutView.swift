//
//  AboutView.swift
//  notifyme
//
//  Created by Anne Ferret on 14/11/2025.
//


import SwiftUI

struct AboutView: View {
    @State private var debugCountdown: Int = 5

    var body: some View {
        NavigationStack {
            Form {
                Section("about.author.header") {
                    let paragraph = String(localized: "about.author.message").split(separator: "\\n")
                    ForEach(paragraph, id: \.self) { p in
                        Text(p)
                    }
                }
                .listRowSeparator(.hidden)
                Section("about.thisApp.header") {
                    let paragraph = String(localized: "about.thisApp.message").split(separator: "\\n")
                    ForEach(paragraph, id: \.self) { p in
                        Text(p)
                    }
                }
                .listRowSeparator(.hidden)
                .onTapGesture {
                    if debugCountdown > 0 { debugCountdown -= 1 }
                }
                Section("about.links.header") {
                    Link(destination: URL(string: "https://github.com/ombremad/RelCheck")!) {
                        Label("about.links.relCheckOnGitHub", systemImage: "link")
                    }
                    Link(destination: URL(string: "https://anneferret.eu")!) {
                        Label("about.links.anneFerretWebsite", systemImage: "link")
                    }
                    if debugCountdown == 0 {
                        NavigationLink {
                            DebugView()
                        } label: {
                            Label("about.debugMenu", systemImage: "ant")
                        }
                    }
                }
            }
            .navigationTitle("about.title")
        }
    }
}

#Preview {
    AboutView()
}
