import SwiftUI

struct ContentView: View {
    @State var difficulty: Int = 1 // 1、简单 2、中等 3、困难
    @State var showSelectDifficultyInterface: Bool = false // 选择难度
    @State var flagOfGameBeginning: Bool = false // 开始游戏
    
    @ObservedObject var mv: SudokuViewModel = SudokuViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                mv.reStart(difficulty: difficulty)
                flagOfGameBeginning = true
            }){
                Text("开始游戏")
            }
            .padding()
            .font(.title)
            Button(action: {
                showSelectDifficultyInterface = true
            }){
                Text("选择难度")
            }
            .padding()
            .font(.title)
        }
        .overlay(self.flagOfGameBeginning ? GameInterface(flagOfGameBeginning: $flagOfGameBeginning, mv: mv): nil)
        .overlay(self.showSelectDifficultyInterface ? SelectDifficultyInterface(showSelectDifficultyInterface: $showSelectDifficultyInterface, difficulty: $difficulty): nil)
    }
}

struct GameInterface: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Binding var flagOfGameBeginning: Bool
    
    @State var focusedUnit: (row: Int, column: Int) = (-1, -1)
    @State var timeCount: Int = 0
    @State var time: String = "0s"
    @State var collisionString: String = ""
    
    @ObservedObject var mv: SudokuViewModel
    
    var theAnimationOfTheReminder: Animation {
        Animation.linear(duration: 1)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.yellow)
                .frame(width: 360, height: 50)
                .position(x: 70, y: 400)
            someButtons
            ForEach(0..<9) { i in
                ForEach(0..<9) { j in
                    UnitGamingView(content: mv.sudoku!.numbers[i][j], position: (i, j), focusedUnit: $focusedUnit, mv: mv)
                }
            }
            addSomeLine
            HStack {
                Text("难度：")
                    .font(.title2)
                    .position(x: 130, y: 280)
                if mv.sudoku!.difficulty == 1 {
                    Text("简单")
                        .frame(width: 100)
                        .font(.title2)
                        .position(x: 130, y: 280)
                } else if mv.sudoku!.difficulty == 2 {
                    Text("中等")
                        .frame(width: 100)
                        .font(.title2)
                        .position(x: 130, y: 280)
                } else {
                    Text("困难")
                        .frame(width: 100)
                        .font(.title2)
                        .position(x: 130, y: 280)
                }
            }
            HStack {
                Text("耗时：")
                    .font(.title2)
                    .position(x: 130, y: 325)
                Text(time)
                    .frame(width: 100)
                    .font(.title2)
                    .position(x: 130, y: 325)
            }
            if collisionString != "" {
                Text(collisionString)
                    .font(.title)
                    .foregroundColor(.red)
                    .position(x: 70, y: 220)
                    .onAppear() {
                        withAnimation(theAnimationOfTheReminder) {
                            collisionString = ""
                        }
                    }
            }
        }
        .background(Color.white)
        .onReceive(timer) { timer in
            timeCount += 1
            if timeCount <= 60 {
                time = String(timeCount)+"s"
            } else {
                time = String(timeCount/60)+"min"+String(timeCount%60)+"s"
            }
        }
    }
    
    var addSomeLine: some View {
        Path { path in
            path.move(to: CGPoint(x: -110, y: -220))
            path.addLine(to:CGPoint(x: -110, y: 140))
            path.addLine(to:CGPoint(x: 250,y: 140))
            path.addLine(to:CGPoint(x: 250,y: -220))
            path.addLine(to:CGPoint(x: -110,y: -220))
            path.move(to: CGPoint(x: 10, y: -220))
            path.addLine(to:CGPoint(x: 10, y: 140))
            path.move(to: CGPoint(x: 130, y: -220))
            path.addLine(to:CGPoint(x: 130, y: 140))
            path.move(to: CGPoint(x: -110, y: -100))
            path.addLine(to:CGPoint(x: 250, y: -100))
            path.move(to: CGPoint(x: -110, y: 20))
            path.addLine(to:CGPoint(x: 250, y: 20))
        }
        .stroke(Color.black, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
    }
    
    var someButtons: some View {
        ZStack {
            Button(action: {
                collisionString = mv.fillTheNumber(number: 1, row: focusedUnit.row, column: focusedUnit.column)
            }) {
                Text("1")
                    .font(.largeTitle)
            }
            .position(x: -80, y: 400)
            Button(action: {
                collisionString = mv.fillTheNumber(number: 2, row: focusedUnit.row, column: focusedUnit.column)
            }) {
                Text("2")
                    .font(.largeTitle)
            }
            .position(x: -40, y: 400)
            Button(action: {
                collisionString = mv.fillTheNumber(number: 3, row: focusedUnit.row, column: focusedUnit.column)
            }) {
                Text("3")
                    .font(.largeTitle)
            }
            .position(x: 0, y: 400)
            Button(action: {
                collisionString = mv.fillTheNumber(number: 4, row: focusedUnit.row, column: focusedUnit.column)
            }) {
                Text("4")
                    .font(.largeTitle)
            }
            .position(x: 40, y: 400)
            Button(action: {
                collisionString = mv.fillTheNumber(number: 5, row: focusedUnit.row, column: focusedUnit.column)
            }) {
                Text("5")
                    .font(.largeTitle)
            }
            .position(x: 80, y: 400)
            Button(action: {
                collisionString = mv.fillTheNumber(number: 6, row: focusedUnit.row, column: focusedUnit.column)
            }) {
                Text("6")
                    .font(.largeTitle)
            }
            .position(x: 120, y: 400)
            Button(action: {
                collisionString = mv.fillTheNumber(number: 7, row: focusedUnit.row, column: focusedUnit.column)
            }) {
                Text("7")
                    .font(.largeTitle)
            }
            .position(x: 160, y: 400)
            Button(action: {
                collisionString = mv.fillTheNumber(number: 8, row: focusedUnit.row, column: focusedUnit.column)
            }) {
                Text("8")
                    .font(.largeTitle)
            }
            .position(x: 200, y: 400)
            Button(action: {
                collisionString = mv.fillTheNumber(number: 9, row: focusedUnit.row, column: focusedUnit.column)
            }) {
                Text("9")
                    .font(.largeTitle)
            }
            .position(x: 240, y: 400)
            Button(action: {
                flagOfGameBeginning = false
            }) {
                Text("返回")
                    .font(.title2)
            }
            .position(x: -80, y: -320)
        }
        .offset(x: -10)
    }
}

struct SelectDifficultyInterface: View {
    @Binding var showSelectDifficultyInterface: Bool
    @Binding var difficulty: Int
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    difficulty = 1
                    showSelectDifficultyInterface = false
                }){
                    if difficulty == 1 {
                        Text("Easy")
                            .foregroundColor(.red)
                    } else {
                        Text("Easy")
                    }
                }
                .padding()
                Button(action: {
                    difficulty = 2
                    showSelectDifficultyInterface = false
                }){
                    if difficulty == 2 {
                        Text("Medium")
                            .foregroundColor(.red)
                    } else {
                        Text("Medium")
                    }
                }
                .padding()
                Button(action: {
                    difficulty = 3
                    showSelectDifficultyInterface = false
                }){
                    if difficulty == 3 {
                        Text("Hard")
                            .foregroundColor(.red)
                    } else {
                        Text("Hard")
                    }
                }
                .padding()
            }
            .font(.title)
        }
        .background(Color.white)
    }
}

struct UnitGamingView: View {
    var content: Int
    var position: (row: Int, column: Int)
    
    @Binding var focusedUnit: (row: Int, column: Int)
    
    @ObservedObject var mv: SudokuViewModel
    
    var body: some View {
        Button(action: {
            focusedUnit = position
            mv.focusOnAUnit(row: position.row, column: position.column)
        }) {
            ZStack {
                if mv.sudoku!.stateTable[position.row][position.column] {
                    if position.row == focusedUnit.row && position.column == focusedUnit.column {
                        Rectangle()
                            .fill()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.yellow)
                    } else {
                        Rectangle()
                            .fill()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(red: 128, green: 128, blue: 0))
                    }
                }
                Rectangle()
                    .stroke()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
                if content != 0 {
                    if mv.sudoku!.protoTable[position.row][position.column] {
                        Text(String(content))
                            .bold()
                            .foregroundColor(.black)
                            .font(.title)
                    } else {
                        Text(String(content))
                            .foregroundColor(.black)
                            .font(.title)
                    }
                }
            }
        }
        .position(x: CGFloat(-90+40*position.column), y: CGFloat(-200+40*position.row))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
