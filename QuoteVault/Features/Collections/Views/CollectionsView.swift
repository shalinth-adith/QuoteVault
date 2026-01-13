//
//  CollectionsView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Collections
//

import SwiftUI

struct CollectionsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)

                    Text("Your Collections")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Coming soon...")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Collections")
        }
    }
}

#Preview {
    CollectionsView()
}
