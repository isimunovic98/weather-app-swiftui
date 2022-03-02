//
//  SearchbarDummy.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//

import SwiftUI

struct SearchBarDummy: View {
    
    @State private var isEditing = false
    
    
    var body: some View {
        HStack {
            TextField("Search ...", text: .constant("Search..."))
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                    }
                )
                .padding(.horizontal, 10)
        }
    }
}
