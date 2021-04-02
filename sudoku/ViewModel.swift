import SwiftUI

class SudokuViewModel: ObservableObject{
    @Published private(set) var sudoku: SudokuModel?
    
    init() {
        sudoku = nil
    }
    
    func reStart(difficulty: Int) {
        sudoku = SudokuModel(difficulty: difficulty, builder: SudokuViewModel.sudokuBuilder)
    }
    
    func focusOnAUnit(row: Int, column: Int) {
        for i in 0..<9 {
            for j in 0..<9 {
                if i == row || j == column || sudoku!.block[i][j] == sudoku!.block[row][column] {
                    sudoku!.stateTable[i][j] = true
                } else {
                    sudoku!.stateTable[i][j] = false
                }
            }
        }
    }
    
    func collisionDetection(number: Int, row: Int, column: Int) -> (flag: Bool, collisionString: String) {
        var array: [Int] = [number]
        
        // 检测行
        for i in 0..<9 {
            if i != column && sudoku!.numbers[row][i] != 0 {
                array.append(sudoku!.numbers[row][i])
            }
        }
        
        for i in 0..<array.count-1 {
            for j in i+1..<array.count {
                if array[i] == array[j] {
                    return (false, "行冲突!")
                }
            }
        }
        
        array = [number]
        
        // 检测列
        for i in 0..<9 {
            if i != row && sudoku!.numbers[i][column] != 0 {
                array.append(sudoku!.numbers[i][column])
            }
        }

        for i in 0..<array.count-1 {
            for j in i+1..<array.count {
                if array[i] == array[j] {
                    return (false, "列冲突!")
                }
            }
        }
        
        array = [number]
        
        // 检测区块
        for i in 0..<9 {
            for j in 0..<9 {
                if sudoku!.block[row][column] == sudoku!.block[i][j] {
                    if !(i == row && j == column) && sudoku!.numbers[i][j] != 0 {
                        array.append(sudoku!.numbers[i][j])
                    }
                }
            }
        }
        
        for i in 0..<array.count-1 {
            for j in i+1..<array.count {
                if array[i] == array[j] {
                    return (false, "区块冲突!")
                }
            }
        }
        
        return (true, "")
    }
    
    func fillTheNumber(number: Int, row: Int, column: Int) -> String {
        let collision = collisionDetection(number: number, row: row, column: column)
        if collision.flag {
            if !sudoku!.protoTable[row][column] {
                sudoku!.numbers[row][column] = number
            }
        }
        
        checkIfFinish()
        
        return collision.collisionString
    }
    
    func checkIfFinish() {
        for i in 0..<9 {
            for j in 0..<9 {
                if sudoku!.numbers[i][j] == 0 {
                    return
                }
            }
        }
        sudoku!.ifFinished = true
    }
    
    static func sudokuBuilder(forLevel: LevelType) -> (protoArr: [[Int]], shuduArr: [[Int]]) {
        
        let x: PlatePresentationManager = PlatePresentationManager()
        let numbers = x.generate(forLevel: forLevel)
        return (numbers.protoArr, numbers.shuduArr)
        
    }
}
