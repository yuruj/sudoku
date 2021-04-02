import Foundation

struct LevelType {
    
    enum Level: Int{
        case level1 = 1
        case level2 = 2
        case level3 = 3
    }
    
    enum Empty: Int {
        case level1Empty = 40
        case level2Empty = 50
        case level3Empty = 60
    }
    
    let level: Level
    let empty: Empty
}

class PlatePresentationManager {
    public let SIZE = 9
    public let CELL_SIZE = 9
    public let LEVEL_MAX = 3
    public let BASIC_MASK = 40
    public var levelType: LevelType = LevelType(level: .level1, empty: .level1Empty)
    
    public var shuduArr = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: 9), count: 9)
    var nums: [Int] = []
    
    func generate(forLevel level: LevelType) -> (protoArr: [[Int]], shuduArr: [[Int]]) {
        
        print("开始生成数组")
        
        for i in 0...80 {
            nums.append(i)
        }
        var n = Int(arc4random()) % SIZE + 1
        for i in 0 ..< SIZE {
            for j in 0 ..< SIZE {
                for _ in 0 ..< SIZE {
                    if checkRow(n: n, row: i) && checkColumn(n: n, column: j) && checkZoneCells(n: n, x: i, y: j) {
                        shuduArr[i][j] = n
                        break
                    }else{
                        n = n % SIZE + 1
                    }
                }
            }
        
            n = n % SIZE + 1
        }
        
        print("初次生成")
        for i in 0..<9 {
            print(shuduArr[i])
        }
        
        upset()
        
        print("打乱后")
        for i in 0..<9 {
            print(shuduArr[i])
        }
        
        let protoArr: [[Int]] = shuduArr
        maskCells(forLevel: level)
        
        print("挖空后")
        for i in 0..<9 {
            print(shuduArr[i])
        }
        
        return (protoArr, shuduArr)

    }
    
    func maskCells(forLevel level: LevelType) -> Void {

        let count = level.empty.rawValue
 
        for _ in 0 ..< count {
            
            let index = self.createRandomMan(start: 0, end: 80)
            let m = index / 9
            let n = index % 9
            if shuduArr[m][n] != 0 {
                shuduArr[m][n] = 0
            }

        }
        
    }
    
    //随机数生成器函数
    func createRandomMan(start: Int, end: Int) ->Int {
        
        func randomMan() -> Int! {
            if nums.count > 0 {
                let index = Int(arc4random()) % (nums.count)
                let num = nums[index]
                nums.remove(at: index)
                return num
            }
            else {
                return 0
            }
        }
        
        return randomMan()
        
    }

    //随机打乱顺序
    func upset() -> Void {
        
        var i: Int = 0
        
        for _ in 0 ..< 10 {
            //按行交换
            i = Int(arc4random()) % SIZE//获取要交换的九宫格的index
            
            let zoneX = i % 3
            let sx = zoneX * 3
            let row1 = Int(arc4random()) % 3 + sx
            let row2 = Int(arc4random()) % 3 + sx
            for column in 0 ..< SIZE {//交换row1，row2的每列数据
                if row1 != row2 {
                    let tmp = shuduArr[row1][column]
                    shuduArr[row1][column] = shuduArr[row2][column]
                    shuduArr[row2][column] = tmp
                }
            }
            
            // 按列交换
            i = Int(arc4random()) % SIZE//获取要交换的九宫格的index
            
            let zoneY = i / 3
            let sy = zoneY * 3
            let column1 = Int(arc4random()) % 3 + sy
            let column2 = Int(arc4random()) % 3 + sy
            for row in 0 ..< SIZE {//交换column1，column2的每行数据
                if column1 != column2 {
                    let tmp = shuduArr[row][column1]
                    shuduArr[row][column1] = shuduArr[row][column2]
                    shuduArr[row][column2] = tmp
                }
            }
        }
        
    }
    
    //检查某行
    func checkRow(n: Int, row: Int) -> Bool {
        if n <= 0 {
            return false
        }
        var result = true
        for i in 0 ..< SIZE {
            if shuduArr[row][i] == n {
                result = false
                break
            }
        }
        
        return result
    }
    
    //检查某列
    func checkColumn(n: Int, column: Int) -> Bool {
        if n <= 0 {
            return false
        }
        var result = true
        for i in 0 ..< SIZE {
            if shuduArr[i][column] == n {
                result = false
                break
            }
        }
        
        return result
    }
    
    //检查九宫格,n表示填入的数字，x，y表示九宫格坐标
    func checkZoneCells(n: Int, x: Int, y: Int) -> Bool {
        if n <= 0 {
            return false
        }
        var result = true

        let zoneX = x / 3
        let zoneY = y / 3
        let sx = zoneX * 3
        let sy = zoneY * 3

        for i in sx ..< sx + 3 {
            for j in sy ..< sy + 3 {
                if shuduArr[i][j] == n {
                    result = false
                    break
                }
            }
            if !result {
                break
            }
        }
       return result

    }
}

