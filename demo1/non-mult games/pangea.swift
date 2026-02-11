//
//  pangea.swift
//  demo1
//
//  Created by Eric Oh on 2/6/24.
//

import SwiftUI


struct pangea: View {
    @State private var covered: Bool = true
    @State private var grid: [Int] = []
    @State private var base: Int = -1
    @State private var next: Int = -1
    @State private var placeHolder: Bool = false
    @State private var firstRoll: Bool = true
    @State private var secondRoll: Bool = false
    let Zolors: [Color] = [.blue, .red]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.brown, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            if firstRoll && !secondRoll{
                VStack{
                    Spacer()
                        .frame(height: 50)
                    
                    VStack{
                        ForEach(0..<10, id: \.self) { i in
                            HStack(spacing: 5) {
                                Spacer()
                                ForEach(0..<10, id: \.self) { j in
                                    let index = 10 * i + j
                                    
                                    if index < self.grid.count {
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(self.Zolors[self.grid[index]])
                                            .overlay(Text(String(index)))
                                            .shadow(radius: 5)
                                    }
                                }
                                Spacer()
                            }
                        }
                        Spacer()
                            .frame(height:5)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
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
                VStack{
                    Spacer()
                    
                    Image("you're_it")
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    Spacer()
                    
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
        .edgesIgnoringSafeArea(.all)
        
        .onAppear(){
            let count = 0...100
            for _ in count{
                grid.append(0)
            }
        }
    }
    
    func checkOccupy(){
        if firstRoll{
            base = Int.random(in:0..<100)
            if base < grid.count && grid[base] == 0{
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
            if next == 0{
                grid[base] = 1
            }
            else{
                let lowerbound = max(0, base - next)
                let upperbound = min(100, base + next + 1)
                print(lowerbound, upperbound)
                for n in lowerbound ..< upperbound {
                    grid[n] = 1
                }
            }
            secondRoll = false
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
    }
}
