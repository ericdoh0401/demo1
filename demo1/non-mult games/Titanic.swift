//
//  Titanic.swift
//  demo1
//
//  Created by Eric Oh on 2/12/24.
//

import SwiftUI

struct titanic_instruction: View {
    var body: some View{
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .overlay(
                    ScrollView{
                        Text("Welcome aboard the 'Titanic Pour' – where precision meets peril in a game of liquid luck! Get ready to embark on a daring journey of pouring prowess, as you and your fellow sailors navigate the treacherous waters of risk and reward. Will you skillfully fill your cup to the brim, or will you be the captain of chaos, sending your 'ship' to a watery demise? Brace yourselves, pour with caution, and may the driest sailor emerge victorious in this thrilling nautical challenge!\n\nSetup: Decide the order of play through a quick round of rock-paper-scissors or another chosen method.\n\nHow to play:\n1. Turn Order: Players take turns pouring liquid the central designated cup.\n\n2. Pouring Mechanism: Each player can choose how long (how much) to pour into the cup, but they must pour at least a minimum amount such that the game registers it.\n\n3. Pouring Action: The player presses and spins the pouring action button for their chosen duration. The longer they spin, the more they pour into the cup. (You can spin the button slowly)\n\n4. Overpour Penalty: If a player pours too much and the liquid spills over the edge of the cup, they lose the round and the game is over.\n\n5. Reset for the Next Round: Redetermine the order of play again (if playing multiple rounds), and repeat the process.")
                            .foregroundColor(.white)
                            .font(.system(size:15))
                            .padding()
                    }
                )
                .frame(width: 350, height: 600)
                .foregroundColor(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            Spacer()
                .frame(height: 75)
        }
    }
}

struct titanic: View {
    @State private var flickerToggle: Bool = true
    @State private var player_cnt: Int = -1
    @State private var textfield: String = ""
    @State private var curPlayer: Int = 0
    @State private var increment: CGFloat = 0
    @State private var curState: Int = 0
    @State private var default_height: CGFloat = 375
    @State private var slope1: CGFloat = 5
    @State private var slope2: CGFloat = 2
    @State private var cupWidth: CGFloat = 200
    @State private var timer: Timer?
    @State private var game_status: Bool = true
    
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.cyan, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            if player_cnt == -1{
                VStack{
                    HStack{
                        Spacer()
                        
                        Text("Player Count: ")
                        TextField("Maximum 5 players:", text: $textfield)
                            .textFieldStyle(.roundedBorder)
                        
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 30)
                    
                    Button(action: {
                        player_cnt = Int(textfield)!
                    }){
                        Text("Enter")
                            .foregroundColor(.black)
                            .frame(width: 200, height: 25)
                    }
                    .background(Color.green)
                    .clipShape(.capsule)
                }
            }
            else if game_status{
                VStack{
                    if curState == 0 {
                        Image(systemName: "checkmark.square.fill")
                            .resizable()
                            .foregroundColor(Color(UIColor(red: 11/255.0, green: 128/255.0, blue: 18/255.0, alpha: 1)))
                            .frame(width: 50, height: 50)
                            .opacity(flickerToggle ? 0.5 : 1)
                            .onAppear { startFlickering() }
                            .offset(y: -50)
                    } else if curState == 1 {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .foregroundColor(Color(UIColor(red: 128/255.0, green: 128/255.0, blue: 18/255.0, alpha: 1)))
                            .frame(width: 50, height: 50)
                            .opacity(flickerToggle ? 0.5 : 1)
                            .onAppear { startFlickering() }
                            .offset(y: -50)
                    } else {
                        Image(systemName: "exclamationmark.brakesignal")
                            .resizable()
                            .foregroundColor(Color(UIColor(red: 128/255.0, green: 18/255.0, blue: 18/255.0, alpha: 1)))
                            .frame(width: 65, height: 50)
                            .opacity(flickerToggle ? 0.5 : 1)
                            .onAppear { startFlickering() }
                            .offset(y: -50)
                    }
                    
                    Text("Player " + String(curPlayer + 1) + "'s Turn")
                        .font(.title)
                        .bold()
                        .offset(y: -30)
                    
                    ZStack{
                        // animation cup:
                        CupShape(cupWidth: cupWidth, cupTopWidth: cupWidth + (increment * slope2))
                            .fill(LinearGradient(colors: [Color(UIColor(red: 235/255.0, green: 187/255.0, blue: 64/255.0, alpha: 1)), Color(UIColor(red: 41/255.0, green: 14/255.0, blue: 5/255.0, alpha: 1))], startPoint: .top, endPoint: .bottom))
                            .frame(height: increment * slope1)
                            .animation(.linear(duration: 0.1), value: increment)
                            .offset(y: 190 - increment * slope1 / 2)
                            .offset(y: -20)
                        
                        // still cup:
                        CupShape(cupWidth: cupWidth, cupTopWidth: 350)
                            .stroke(Color.blue, lineWidth: 10)
                            .frame(height: default_height)
                            .offset(y: -20)
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Image(systemName: "playpause.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if increment < 75{
                                        increment += 0.1
                                    }
                                }
                                .onEnded { _ in
                                    curPlayer = ((curPlayer + 1) % player_cnt)
                                    if increment > 40 {
                                        curState = 1
                                    }
                                    if increment > 65 {
                                        curState = 2
                                    }
                                    if increment > 75 {
                                        game_status = false
                                    }
                                    
                                }
                        )
                    
                    Text("Press and Spin")
                        .bold()
                        .foregroundColor(.black)
                }
            }
            else{
                VStack{
                    Image("you're_it")
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    Text("Player " + String(curPlayer == 0 ? player_cnt : curPlayer) + " drinks")
                        .bold()
                        .foregroundColor(.black)
                        .font(.title)
                }
            }
        }
    }
    
    private func startFlickering() {
        // Start flickering animation
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            flickerToggle.toggle()
        }
    }
    
}

#Preview {
    titanic()
}
