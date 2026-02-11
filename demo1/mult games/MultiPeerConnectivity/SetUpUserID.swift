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
            Text("Type in a unique gameID.")
            TextField("Your gameID", text: $userName)
                .textFieldStyle(.roundedBorder)
            
            Spacer()
                .frame(height: 20)
            
            Image("logo")
                .resizable()
                .frame(width: 200, height: 200)
            
            Spacer()
                .frame(height: 30)
            
            Button("Set"){
                yourName = userName
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(.black)
            .disabled(userName.isEmpty)
            Spacer()
        }
        .padding()
        .navigationTitle("Welcome!")
        .inNavigationStack()
    }
}

#Preview {
    SetUpUserID()
}
