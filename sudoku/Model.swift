import Foundation

struct SudokuModel {
    var numbers:[[Int]]
    var protoNumbers: [[Int]]
    var protoTable: [[Bool]] // 记录是否是题目原本的数字，true表示原生
    var stateTable: [[Bool]] // 状态表，true表示被选中
    var block: [[Int]] // 记录每个数字的Block序号
    var ifFinished: Bool = false
    var difficulty: Int
    
    init(difficulty: Int = 1, builder: (_ forLevel: LevelType)-> (protoArr: [[Int]], shuduArr: [[Int]])) {
        var level: LevelType = LevelType(level: .level1, empty: .level1Empty)
        self.difficulty = difficulty
        
        if difficulty == 2 {
            level = LevelType(level: .level2, empty: .level2Empty)
        }
        if difficulty == 3 {
            level = LevelType(level: .level3, empty: .level3Empty)
        }
        
        let x = builder(level)
        numbers = x.shuduArr
        protoNumbers = x.protoArr
        
        protoTable = []
        stateTable = []
        var temp: [Bool] = []
        
        for i in 0..<9 {
            stateTable.append([false, false, false, false, false, false, false, false, false])
            for j in 0..<9 {
                if numbers[i][j] != 0 {
                    temp.append(true)
                } else {
                    temp.append(false)
                }
            }
            protoTable.append(temp)
            temp = []
        }
        
        block = [[0, 0, 0, 1, 1, 1, 2, 2, 2],
                 [0, 0, 0, 1, 1, 1, 2, 2, 2],
                 [0, 0, 0, 1, 1, 1, 2, 2, 2],
                 [3, 3, 3, 4, 4, 4, 5, 5, 5],
                 [3, 3, 3, 4, 4, 4, 5, 5, 5],
                 [3, 3, 3, 4, 4, 4, 5, 5, 5],
                 [6, 6, 6, 7, 7, 7, 8, 8, 8],
                 [6, 6, 6, 7, 7, 7, 8, 8, 8],
                 [6, 6, 6, 7, 7, 7, 8, 8, 8]]
    }
}
