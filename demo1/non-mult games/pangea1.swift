//
//  pangea.swift
//  demo1
//
//  Created by Eric Oh on 2/6/24.
//

import SwiftUI

// need to find a way to take in user input
// assume that variable base_length holds such value

struct pan1_instruction: View {
    var body: some View{
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .overlay(
                    ScrollView{
                        Text("Welcome to Pangea: The Conquest Unleashed! Embark on a thrilling journey of land conquest and camaraderie with Pangea. Roll the dice, claim your territory, and strategize your way to victory! But beware, for every sip awaits those who tread on another's empire. Get ready for a night of laughter, strategy, and unforgettable conquests. Let the games begin!\n\nHow to play:\n1. Your group will play on a 10x10 board representing unconquered land.\n\n2. On a player's turn, they roll the first dice.\n\n3. If the number rolled is unconquered land, the player attempts to conquer it.\n\n4. If the rolled number is someone else's conquered land, that player must drink.\n\n5. To conquer land, the player rolls a second dice (q) between 0-10.\n\n6. The player conquers lands from N-q to N+q on their board, where N is the number rolled with the first dice.\n\n7. Conquering is not allowed if there is already conquered land in that range belonging to another player.\n\n8. Unconquered land is first-come, first-served.\n\nEnjoy the strategic conquests and the social dynamics of Pangea! The game ends once all land is conquered.")
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

struct pangea1: View {
    @State private var covered: Bool = true
    @State private var grid: [Int] = []
    @State private var currentPlayer: Int = 0
    @State private var base_length: Int = -1
    @State private var base: Int = -1
    @State private var next: Int = -1
    @State private var placeHolder: Bool = false
    @State private var firstRoll: Bool = true
    @State private var secondRoll: Bool = false
    @State private var textValue: String = ""
    @State private var occupyCount: Int = 0
    let Zolors: [Color] = [.red, .orange, .yellow, .green, .purple, .cyan, .indigo, .mint, .pink, .teal]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.brown, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            if base_length == -1{
                VStack{
                    HStack{
                        Spacer()
                        
                        Text("Player count:")
                        TextField("Max 10 players:", text: $textValue)
                            .textFieldStyle(.roundedBorder)
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Button(action: {
                        if textValue == "" {
                            base_length = 2
                        } else {
                            base_length = Int(textValue)!
                        }
                    }) {
                        Text("Enter")
                            .bold()
                            .foregroundColor(.black)
                            .frame(width: 200, height: 25)
                    }
                    .background(Color.green)
                    .clipShape(.capsule)
                }
            }
            
            else{
                if occupyCount < 100 {
                    if firstRoll && !secondRoll{
                        VStack{
                            Spacer()
                                .frame(height: 50)
                            
                            HStack{
                                Text("Player " + String(currentPlayer + 1) + "'s turn")
                                    .font(.title)
                                    .bold()
                                
                                RoundedRectangle(cornerRadius:5)
                                    .foregroundColor(self.Zolors[currentPlayer])
                                    .frame(width: 30, height: 30)
                                
                            }
                            
                            Spacer()
                                .frame(height: 50)
                            
                            VStack{
                                ForEach(0..<10, id: \.self) { i in
                                    HStack(spacing: 5) {
                                        Spacer()
                                        ForEach(0..<10, id: \.self) { j in
                                            let index = 10 * i + j
                                            
                                            if index < self.grid.count {
                                                if self.grid[index] == -1 {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .foregroundColor(Color.white)
                                                        .overlay(Text(String(index)).foregroundColor(.black))
                                                        .frame(width: 30, height: 30)
                                                        .shadow(radius: 5)
                                                    
                                                }
                                                else{
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .foregroundColor(self.Zolors[self.grid[index]])
                                                        .overlay(Text(String(index)).foregroundColor(.black))
                                                        .frame(width: 30, height: 30)
                                                        .shadow(radius: 5)
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                                Spacer()
                                    .frame(height:5)
                            }
                            
                            Spacer()
                                .frame(height: 50)
                            
                            Button(action: {
                                checkOccupy()
                            }){
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 70, height: 70)
                            }
                            
                            Spacer()
                                .frame(height: 30)
                            
                            if base > -1{
                                Text("\(base)")
                                    .font(.title)
                                    .bold()
                            }
                        }
                    }
                    else if placeHolder{
                        if grid[base] == currentPlayer{
                            VStack{
                                Spacer()
                                
                                Image("you're safe")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                                
                                Spacer()
                                    .frame(height: 50)
                                
                                Text("You rolled a " + String(base) + ".")
                                    .font(.title)
                                    .bold()
                                Text("This is your spot.")
                                    .font(.title)
                                    .bold()
                                
                                Spacer()
                                    .frame(height: 50)
                                
                                Button(action: {
                                    home()
                                }){
                                    Image(systemName: "house.circle.fill")
                                        .resizable()
                                        .foregroundColor(.black)
                                        .frame(width: 70, height: 70)
                                }
                                
                                Spacer()
                            }
                        }
                        else{
                            VStack{
                                Spacer()
                                
                                Image("you're_it")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                                
                                Spacer()
                                    .frame(height: 50)
                                
                                Text("You rolled a " + String(base) + ".")
                                    .font(.title)
                                    .bold()
                                Text("This is player " + String(grid[base] + 1) + "'s spot.")
                                    .font(.title)
                                    .bold()
                                
                                Spacer()
                                    .frame(height: 50)
                                
                                Button(action: {
                                    home()
                                }){
                                    Image(systemName: "house.circle.fill")
                                        .resizable()
                                        .foregroundColor(.black)
                                        .frame(width: 70, height: 70)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    else{
                        VStack{
                            Spacer()
                            
                            Text("You rolled: " + String(base))
                                .font(.title)
                                .bold()
                            
                            HStack{
                                Spacer()
                                    .frame(width: 80)
                                
                                Button(action: {
                                    Roll2()
                                }){
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .resizable()
                                        .foregroundColor(.black)
                                        .frame(width: 70, height: 70)
                                }
                                
                                Spacer()
                                    .frame(height: 30)
                                
                                Button(action: {
                                    goBack()
                                }){
                                    Image(systemName: "house.circle.fill")
                                        .resizable()
                                        .foregroundColor(.black)
                                        .frame(width: 70, height: 70)
                                }
                                
                                Spacer()
                                    .frame(width: 80)
                            }
                            
                            if next > -1{
                                Text("\(next)")
                                    .font(.title)
                                    .bold()
                            }
                            
                            Spacer()
                        }
                    }
                }
                else{
                    Image("complete")
                        .resizable()
                        .frame(width: 300, height: 300)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        
        
        .onAppear(){
            let count = 0..<100
            for _ in count{
                grid.append(-1)
            }
        }
    }
    
    func checkOccupy(){
        print(occupyCount)
        if firstRoll{
            base = Int.random(in:0..<100)
            if base < grid.count && grid[base] == -1{
                secondRoll = true
            }
            else{
                placeHolder = true
            }
            firstRoll = false
        }
    }
    
    func Roll2(){
        if secondRoll{
            next = Int.random(in:0..<11)
            let lowerbound = max(0, base - next)
            let upperbound = min(100, base + next + 1)
            for n in lowerbound ..< upperbound {
                if grid[n] == -1{
                    occupyCount += 1
                    grid[n] = currentPlayer
                }
            }
            secondRoll = false
            currentPlayer = ((currentPlayer + 1) % base_length)
        }
    }
    
    func goBack(){
        if !secondRoll{
            base = -1
            next = -1
            firstRoll = true
        }
    }
    
    func home(){
        placeHolder = false
        firstRoll = true
        base = -1
        currentPlayer = ((currentPlayer + 1) % base_length)
    }
}
