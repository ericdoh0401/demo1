//
//  SetUpUserID.swift
//  demo1
//
//  Created by Eric Oh on 3/5/24.
//

import SwiftUI

struct SetUpUserID: View {
    @AppStorage("yourName") var yourName = ""
    @State private var userName = ""
    var body: some View {
        VStack{
            Text("Type in a unique ID name.")
            TextField("Your gameID", text: $userName)
                .textFieldStyle(.roundedBorder)
            Button("Set"){
                yourName = userName
            }
            .buttonStyle(.borderedProminent)
            .disabled(userName.isEmpty)
            Image("smile")
                .resizable()
                .frame(width: 160, height: 160)
            Spacer()
        }
        .padding()
        .navigationTitle("Game Header")
        .inNavigationStack()
    }
}

#Preview {
    SetUpUserID()
}
