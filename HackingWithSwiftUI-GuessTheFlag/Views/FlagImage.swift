//
//  FlagImage.swift
//  HackingWithSwiftUI-GuessTheFlag
//
//  Created by Michael Jones on 06/07/2026.
//

import SwiftUI

struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}
