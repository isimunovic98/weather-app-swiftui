//
//  Searchbar.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 01.03.2022..
//

import SwiftUI
import Introspect

struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = true
    
    var body: some View {
        HStack {
            TextField("Search ...", text: $text)
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
                        
                        if isEditing {
                            Button(
                                action: {
                                    self.text = ""
                                }
                            ) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }
                .introspectTextField(
                    customize: { textField in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            textField.becomeFirstResponder()
                        }
                    }
                )
        }
    }
}
