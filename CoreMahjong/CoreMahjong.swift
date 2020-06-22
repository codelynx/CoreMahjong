//
//  CoreMahjong.swift
//  CoreMahjong
//
//  Created by Kaz Yoshikawa on 6/16/20.
//
//	The MIT License (MIT)
//
//	Copyright (c) 2020 Electricwoods LLC, Kaz Yoshikawa.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

import Foundation


extension Array where Element: Equatable {

	func indexes(of element: Element) -> [Int] {
		return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
	}

	mutating func removeIndexes(_ indexes: [Int]) {
		for index in Set(indexes).sorted(by: >) {
			self.remove(at: index)
		}
	}

	func removingIndexes(_ indexes: [Int]) -> Self {
		var array = Array(self)
		array.removeIndexes(indexes)
		return array
	}

}

// MARK: -

public enum 和了役型: String {
//	case 立直
//	case 一発
//	case 門前清自摸和
//	case 役牌
	case 断么九
	case 平和
	case 一盃口
//	case 海底撈月
//	case 河底撈魚
//	case 嶺上開花
//	case 槍槓
//	case ダブル立直
	case 三色同順
	case 三色同刻
	case 三暗刻
	case 一気通貫
	case 七対子
	case 対々和
	case 混全帯么九
	case 三槓子
	case 二盃口
	case 純全帯么九
	case 混一色
	case 小三元
	case 混老頭
	case 清一色
	case 四暗刻
	case 大三元
	case 国士無双
	case 緑一色
	case 字一色
	case 清老頭
	case 四槓子
	case 小四喜
	case 大四喜
	case 九蓮宝燈
//	case 地和
//	case 天和
	case 四暗刻単騎
	case 国士無双十三面張
	case 純正九蓮宝燈
	case 發なし緑一色
}


extension Set where Element == 和了役型 {
	init(役列: [和了役型], 上位下位役一覧: [(和了役型, 和了役型)]) {
		var 役群 = Set<和了役型>(役列)
		for 役 in 役列 {
			for (上位役, 下位役) in 上位下位役一覧 {
				if [上位役, 下位役].contains(役) {
					if 役群.contains(上位役), 上位役 != 役  {
						役群.remove(役)
					}
				}
			}
		}
		self.init(役群)
	}
	func 翻数(副露: Bool) -> Int {
		return self.map { 役 in
			if let 翻数 = 翻数表[役] {
				return 翻数 - (副露 && 喰い下がり役.contains(役) ? 1 : 0)
			}
			return 0
		}.reduce(0, +)
	}
	func 役満数() -> Int {
		return self.map { 役満役数表[$0] ?? 0}.reduce(0, +)
	}
}

//
let 上位下位役満一覧: [(和了役型, 和了役型)] = [
	(.国士無双十三面張, .国士無双),
	(.四暗刻単騎, .四暗刻),
	(.大四喜, .小四喜),
	(.發なし緑一色, .緑一色)
]

let 上位下位役一覧: [(和了役型, 和了役型)] = [
	(.二盃口, .一盃口),
	(.清一色, .混一色),
	(.純全帯么九, .混全帯么九),
	(.混老頭, .混全帯么九)
]

// MARK: -

public enum 牌数型: Int, Comparable {
	case 一, 二, 三, 四, 五, 六, 七, 八, 九
	public static func < (lhs: 牌数型, rhs: 牌数型) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

public enum 字牌種型: Int, Comparable {
	case 三元牌種
	case 四風牌種
	public static func < (lhs: 字牌種型, rhs: 字牌種型) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

public enum 数牌種型: Int, Comparable {
	case 萬子種
	case 筒子種
	case 索子種
	func 牌(牌数: 牌数型) -> 牌識別子型 {
		switch self {
		case .萬子種: return 牌識別子型(rawValue: 牌識別子型.🀇.rawValue + 牌数.rawValue)!
		case .筒子種: return 牌識別子型(rawValue: 牌識別子型.🀙.rawValue + 牌数.rawValue)!
		case .索子種: return 牌識別子型(rawValue: 牌識別子型.🀐.rawValue + 牌数.rawValue)!
		}
	}
	var 牌種: 牌種型 {
		switch self {
		case .萬子種: return .萬子種
		case .筒子種: return .筒子種
		case .索子種: return .索子種
		}
	}
	public static func < (lhs: 数牌種型, rhs: 数牌種型) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

public enum 牌種型: Int, Comparable {
	case 萬子種
	case 筒子種
	case 索子種
	case 三元牌種
	case 四風牌種
	var 数牌種: 数牌種型? {
		switch self {
		case .萬子種: return .萬子種
		case .筒子種: return .筒子種
		case .索子種: return .索子種
		default: return nil
		}
	}
	var 字牌種: 字牌種型? {
		switch self {
		case .三元牌種: return .三元牌種
		case .四風牌種: return .四風牌種
		default: return nil
		}
	}
	var 数牌種判定: Bool { self.数牌種 != nil  }
	var 字牌種判定: Bool { self.字牌種 != nil  }
	public static func < (lhs: 牌種型, rhs: 牌種型) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

public enum 牌識別子型: Int, Comparable {
	case 🀇, 🀈, 🀉, 🀊, 🀋, 🀌, 🀍, 🀎, 🀏
	case 🀙, 🀚, 🀛, 🀜, 🀝, 🀞, 🀟, 🀠, 🀡
	case 🀐, 🀑, 🀒, 🀓, 🀔, 🀕, 🀖, 🀗, 🀘
	case 🀆, 🀅, 🀄︎
	case 🀀, 🀁, 🀂, 🀃
	static var 萬子: [牌識別子型] { [.🀇, .🀈, .🀉, .🀊, .🀋, .🀌, .🀍, .🀎, .🀏] }
	static var 筒子: [牌識別子型] { [.🀙, .🀚, .🀛, .🀜, .🀝, .🀞, .🀟, .🀠, .🀡] }
	static var 索子: [牌識別子型] { [.🀐, .🀑, .🀒, .🀓, .🀔, .🀕, .🀖, .🀗, .🀘] }
	static var 風牌: [牌識別子型] { [.🀀, .🀁, .🀂, .🀃] }
	static var 三元牌: [牌識別子型] { [.🀆, .🀅, .🀄︎] }
	static var 緑牌: [牌識別子型] { [.🀑, .🀒, .🀓, .🀕, .🀗, .🀅] }
	static var 發なし緑牌: [牌識別子型] { [.🀑, .🀒, .🀓, .🀕, .🀗] }
	static var 字牌: [牌識別子型] { self.風牌 + self.三元牌 }
	static var 数牌: [牌識別子型] { self.萬子 + self.筒子 + self.索子 }
	static var 一九牌: [牌識別子型] { [.🀇, .🀏, .🀙, .🀡, .🀐, .🀘] }
	static var 一九字牌: [牌識別子型] { self.字牌 + self.一九牌 }
	static var 文字牌識別子表: [Character: 牌識別子型] = [
		"🀆": .🀆, "🀅": .🀅, "🀄︎": .🀄︎,
		"🀀": .🀀, "🀁": .🀁, "🀂": .🀂, "🀃": .🀃,
		"🀇": .🀇, "🀈": .🀈, "🀉": .🀉, "🀊": .🀊, "🀋": .🀋, "🀌": .🀌, "🀍": .🀍, "🀎": .🀎, "🀏": .🀏,
		"🀙": .🀙, "🀚": .🀚, "🀛": .🀛, "🀜": .🀜, "🀝": .🀝, "🀞": .🀞, "🀟": .🀟, "🀠": .🀠, "🀡": .🀡,
		"🀐": .🀐, "🀑": .🀑, "🀒": .🀒, "🀓": .🀓, "🀔": .🀔, "🀕": .🀕, "🀖": .🀖, "🀗": .🀗, "🀘": .🀘
	]
	static var 牌識別子文字表: [牌識別子型: Character] = [
		.🀆: "🀆", .🀅: "🀅", .🀄︎: "🀄︎",
		.🀀: "🀀", .🀁: "🀁", .🀂: "🀂", .🀃: "🀃",
		.🀇: "🀇", .🀈: "🀈", .🀉: "🀉", .🀊: "🀊", .🀋: "🀋", .🀌: "🀌", .🀍: "🀍", .🀎: "🀎", .🀏: "🀏",
		.🀙: "🀙", .🀚: "🀚", .🀛: "🀛", .🀜: "🀜", .🀝: "🀝", .🀞: "🀞", .🀟: "🀟", .🀠: "🀠", .🀡: "🀡",
		.🀐: "🀐", .🀑: "🀑", .🀒: "🀒", .🀓: "🀓", .🀔: "🀔", .🀕: "🀕", .🀖: "🀖", .🀗: "🀗", .🀘: "🀘"
	]
	var 数牌種: 数牌種型? {
		switch self {
		case .🀇, .🀈, .🀉, .🀊, .🀋, .🀌, .🀍, .🀎, .🀏: return .萬子種
		case .🀙, .🀚, .🀛, .🀜, .🀝, .🀞, .🀟, .🀠, .🀡: return .筒子種
		case .🀐, .🀑, .🀒, .🀓, .🀔, .🀕, .🀖, .🀗, .🀘: return .索子種
		default: return nil
		}
	}
	var 牌数: 牌数型? {
		switch self {
		case .🀇, .🀙, .🀐: return .一
		case .🀈, .🀚, .🀑: return .二
		case .🀉, .🀛, .🀒: return .三
		case .🀊, .🀜, .🀓: return .四
		case .🀋, .🀝, .🀔: return .五
		case .🀌, .🀞, .🀕: return .六
		case .🀍, .🀟, .🀖: return .七
		case .🀎, .🀠, .🀗: return .八
		case .🀏, .🀡, .🀘: return .九
		default: return nil
		}
	}
	var 牌種: 牌種型 {
		switch self {
		case .🀆, .🀅, .🀄︎: return .三元牌種
		case .🀀, .🀁, .🀂, .🀃: return .四風牌種
		case .🀇, .🀈, .🀉, .🀊, .🀋, .🀌, .🀍, .🀎, .🀏: return .萬子種
		case .🀙, .🀚, .🀛, .🀜, .🀝, .🀞, .🀟, .🀠, .🀡: return .筒子種
		case .🀐, .🀑, .🀒, .🀓, .🀔, .🀕, .🀖, .🀗, .🀘: return .索子種
		}
	}
	var 牌: 牌型 { return 牌型(牌識別子: self, 出処: .自家) }
	var character: Character { Self.牌識別子文字表[self]! }
	public static func < (lhs: 牌識別子型, rhs: 牌識別子型) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

public extension Array where Element == 牌識別子型 {
	var 全緑牌判定: Bool { self.filter { 牌識別子型.緑牌.contains($0) }.count == self.count }
	var 全發なし緑牌判定: Bool { self.filter { 牌識別子型.發なし緑牌.contains($0) }.count == self.count }
	var 全字牌判定: Bool { self.filter { 牌識別子型.字牌.contains($0) }.count == self.count }
	var 全風牌判定: Bool { self.filter { 牌識別子型.風牌.contains($0) }.count == self.count }
	var 全三元牌判定: Bool { self.filter { 牌識別子型.三元牌.contains($0) }.count == self.count }
	var 含一九牌判定: Bool { self.filter { 牌識別子型.一九牌.contains($0) }.count > 0 }
	var 全一九牌判定: Bool { self.filter { 牌識別子型.一九牌.contains($0) }.count == self.count }
	var 含一九字牌判定: Bool { self.filter { 牌識別子型.一九字牌.contains($0) }.count > 0 }
	var 全一九字牌判定: Bool { self.filter { 牌識別子型.一九字牌.contains($0) }.count == self.count }
	var 全数牌判定: Bool { self.filter { 牌識別子型.数牌.contains($0) }.count == self.count }
	var 牌列: [牌型] { self.map { $0.牌 }  }
	var 牌表: [牌識別子型: Int] { self.reduce(into: [牌識別子型: Int]()) { (表, 牌) in 表[牌, default: 0] += 1 } }
	var string: String { self.compactMap { $0.character }.map { String($0) }.joined() }
	func sorted() -> Self { self.sorted { (牌1, 牌2) -> Bool in 牌1.牌種 < 牌2.牌種 } }
}

public enum 出処型 {
	case 自家
	case 他家
}

public class 牌型 {
	var 牌識別子: 牌識別子型
	var 出処: 出処型
	var 和了牌: Bool = false
	init(牌識別子: 牌識別子型, 出処: 出処型 = .自家) {
		self.牌識別子 = 牌識別子
		self.出処 = 出処
	}
	var 副露: 牌型 { self.出処 = .他家 ; return self }
	var 自摸和: 牌型 { self.出処 = .自家 ; self.和了牌 = true ; return self }
	var 栄和: 牌型 { self.出処 = .他家 ; self.和了牌 = true ; return self }
	var 副露判定: Bool { self.出処 == .他家 && !self.和了牌 }
}

public extension Array where Element == 牌型 {
	var 含和了牌判定: Bool { self.filter { $0.和了牌 }.count > 0 }
	var 含他家牌判定: Bool { self.filter { $0.出処 != .自家 }.count > 0 }
	var 全自家牌判定: Bool { !self.含他家牌判定 }
}

public enum 順子構成子型 {
	case 一二三
	case 二三四
	case 三四五
	case 四五六
	case 五六七
	case 六七八
	case 七八九
	init?(_ 牌数列: [牌数型]) {
		guard 牌数列.count == 3 else { return nil }
		let (牌数1, 牌数2, 牌数3) = (牌数列[0], 牌数列[1], 牌数列[2])
		switch (牌数1, 牌数2, 牌数3) {
		case (.一, .二, .三): self = .一二三
		case (.二, .三, .四): self = .二三四
		case (.三, .四, .五): self = .三四五
		case (.四, .五, .六): self = .四五六
		case (.五, .六, .七): self = .五六七
		case (.六, .七, .八): self = .六七八
		case (.七, .八, .九): self = .七八九
		default: return nil
		}
	}
	init?(最若牌数: 牌数型) {
		switch 最若牌数 {
		case .一: self = .一二三
		case .二: self = .二三四
		case .三: self = .三四五
		case .四: self = .四五六
		case .五: self = .五六七
		case .六: self = .六七八
		case .七: self = .七八九
		default: return nil
		}
	}
	var 牌数列: [牌数型] {
		switch self {
		case .一二三: return [.一, .二, .三]
		case .二三四: return [.二, .三, .四]
		case .三四五: return [.三, .四, .五]
		case .四五六: return [.四, .五, .六]
		case .五六七: return [.五, .六, .七]
		case .六七八: return [.六, .七, .八]
		case .七八九: return [.七, .八, .九]
		}
	}
}

public enum 場風型: Int {
	case 東
	case 南
	case 西
	case 北
	var 牌: 牌識別子型 {
		switch self {
		case .東: return .🀀
		case .南: return .🀁
		case .西: return .🀂
		case .北: return .🀃
		}
	}
}

public func 面子(_ 牌識別子列: [牌識別子型]) -> 面子型? {
	let 牌識別子群 = Set(牌識別子列)
	switch (牌識別子群.count, 牌識別子列.count) {
	case (1, 4): return 槓子型(牌識別子: 牌識別子群.first!)
	case (1, 3): return 刻子型(牌識別子: 牌識別子群.first!)
	case (3, 3):
		let 数牌種群 = Set(牌識別子列.compactMap { $0.数牌種 })
		let 牌数列 = 牌識別子列.compactMap { $0.牌数 }
		if 数牌種群.count == 1, let 順子構成子 = 順子構成子型(牌数列), let 数牌種 = 数牌種群.first {
			return 順子型(数牌種: 数牌種, 順子構成子: 順子構成子)
		}
		return nil
	default: return nil
	}
}

public func 面子(_ 文字列: String) -> 面子型? {
	switch 文字列.count {
	case 4:
		let scanner = Scanner(string: 文字列)
		if let _ = scanner.scanString("🀫"), let 牌文字列 = scanner.scanUpToString("🀫") { // eg. "🀫🀀🀀🀫", 🀫: U+1F02B
			let 牌群 = Set(牌文字列.compactMap { 牌識別子型.文字牌識別子表[$0] })
			if 牌群.count == 1, let 牌 = 牌群.first {
				return 槓子型(牌識別子: 牌)
			}
			return nil
		}
		else {
			return 面子(文字列.compactMap { 牌識別子型.文字牌識別子表[$0] })
		}
	case 3:
		return 面子(文字列.compactMap { 牌識別子型.文字牌識別子表[$0] })
	default:
		return nil
	}
}

public protocol 面子型: CustomStringConvertible {
	var 順子判定: Bool { get }
	var 刻子判定: Bool { get }
	var 槓子判定: Bool { get }
	var 副露判定: Bool { get }
	var 牌列: [牌型] { get }
	var 牌種: 牌種型 { get }
	var 字牌種: 字牌種型? { get }
	var 数牌種: 数牌種型? { get }
	var string: String { get }
	var 副露: 面子型 { get }
	var 自摸和: 面子型 { get }
	var 栄和: 面子型 { get }
}

public extension 面子型 {
	var 牌列: [牌識別子型] { return self.牌列.map { $0.牌識別子 } }
	var 順子判定: Bool { return false }
	var 刻子判定: Bool { return false }
	var 槓子判定: Bool { return false }
	var 槓刻子判定: Bool { self.槓子判定 || self.刻子判定 }
	var 副露判定: Bool { self.牌列.filter { $0.副露判定 }.count > 0 }
	var 字牌種: 字牌種型? { self.牌種.字牌種 }
	var 数牌種: 数牌種型? { self.牌種.数牌種 }
	var 字牌種判定: Bool { self.字牌種 != nil }
	var 数牌種判定: Bool { self.数牌種 != nil }
	var 含和了牌判定: Bool { self.牌列.含和了牌判定 }
	var 含他家牌判定: Bool { self.牌列.含他家牌判定 }
	var 全自家牌判定: Bool { self.牌列.全自家牌判定 }
	var string: String { self.牌列.map { String($0.character) }.joined() }
	var description: String { return self.string }
}

public extension Array where Element: 面子型 {
	var 牌種列: [牌種型] { return self.map { $0.牌種 } }
	var 牌種表: [牌種型: Int] { self.牌種列.reduce(into: [牌種型: Int]()) { (表, 牌種) in 表[牌種, default: 1] += 1 } }
}

public struct 順子型: 面子型 {
	var 数牌種: 数牌種型
	var 順子構成子: 順子構成子型
	var 牌1, 牌2, 牌3: 牌型
	init?(_ 牌1: 牌型, _ 牌2: 牌型, _ 牌3: 牌型) {
		let 牌列 = [牌1, 牌2, 牌3].sorted { (牌1, 牌2) -> Bool in 牌1.牌識別子 < 牌2.牌識別子 }
		let 数牌種列 = 牌列.compactMap { $0.牌識別子.数牌種 }
		let 牌数列 = 牌列.compactMap { $0.牌識別子.牌数 }
		guard 数牌種列.count == 3 && Set(数牌種列).count == 1, let 順子構成子 = 順子構成子型(牌数列), let 数牌種 = 数牌種列.first else { return nil }
		self.数牌種 = 数牌種
		self.順子構成子 = 順子構成子
		self.牌1 = 牌列[0]
		self.牌2 = 牌列[1]
		self.牌3 = 牌列[2]
	}
	init(数牌種: 数牌種型, 順子構成子: 順子構成子型) {
		self.数牌種 = 数牌種
		self.順子構成子 = 順子構成子
		let 牌列 = 順子構成子.牌数列.map { 数牌種.牌(牌数: $0) }.map { 牌型(牌識別子: $0, 出処: .自家) }
		assert(牌列.count == 3)
		self.牌1 = 牌列[0]
		self.牌2 = 牌列[1]
		self.牌3 = 牌列[2]
	}
	var 平和適合判定: Bool {
		if 牌2.和了牌 { return false } // 🀊🀋🀌 の場合、🀋 待ちは両面待ちにならない
		switch 順子構成子 {
		case .一二三: return !牌3.和了牌 // 🀇🀈🀉 の場合　🀉 待ちは両面待ちにならない
		case .七八九: return !牌1.和了牌 // 🀍🀎🀏 の場合　🀍 待ちは両面待ちにならない
		default: return true
		}
	}
	public var 順子判定: Bool { return true }
	public var 牌列: [牌型] { return [牌1, 牌2, 牌3] }
	public var 牌種: 牌種型 { 数牌種.牌種 }
	public var 副露: 面子型 { self.牌1.出処 = .他家; return self }
	public var 栄和: 面子型 { self.牌1.出処 = .他家; self.牌1.和了牌 = true; return self }
	public var 自摸和: 面子型 { self.牌1.出処 = .自家; self.牌1.和了牌 = true; return self }
}

public struct 刻子型: 面子型 {
	var 牌識別子: 牌識別子型
	var 牌1, 牌2, 牌3: 牌型
	init?(_ 牌1: 牌型, _ 牌2: 牌型, _ 牌3: 牌型) {
		let 牌列 = [牌1, 牌2, 牌3]
		guard Set(牌列.map { $0.牌識別子 }).count == 1, let 牌 = 牌列.first else { return nil }
		self.牌1 = 牌1
		self.牌2 = 牌2
		self.牌3 = 牌3
		self.牌識別子 = 牌.牌識別子
	}
	init(牌識別子: 牌識別子型) {
		self.牌1 = 牌型(牌識別子: 牌識別子, 出処: .自家)
		self.牌2 = 牌型(牌識別子: 牌識別子, 出処: .自家)
		self.牌3 = 牌型(牌識別子: 牌識別子, 出処: .自家)
		self.牌識別子 = 牌識別子
	}
	public var 牌列: [牌型] { [牌1, 牌2, 牌3] }
	public var 刻子判定: Bool { return true }
	public var 牌種: 牌種型 { self.牌識別子.牌種 }
	public var 副露: 面子型 { self.牌1.出処 = .他家; return self }
	public var 栄和: 面子型 { self.牌1.出処 = .他家; self.牌1.和了牌 = true; return self }
	public var 自摸和: 面子型 { self.牌1.出処 = .自家; self.牌1.和了牌 = true; return self }
}

public struct 槓子型: 面子型 {
	var 牌識別子: 牌識別子型
	var 牌1, 牌2, 牌3, 牌4: 牌型
	init?(_ 牌1: 牌型, _ 牌2: 牌型, _ 牌3: 牌型, _ 牌4: 牌型) {
		let 牌列 = [牌1, 牌2, 牌3, 牌4]
		guard Set(牌列.map { $0.牌識別子 }).count == 1, let 牌 = 牌列.first else { return nil }
		self.牌1 = 牌1
		self.牌2 = 牌2
		self.牌3 = 牌3
		self.牌4 = 牌4
		self.牌識別子 = 牌.牌識別子
	}
	init(牌識別子: 牌識別子型) {
		self.牌1 = 牌型(牌識別子: 牌識別子, 出処: .自家)
		self.牌2 = 牌型(牌識別子: 牌識別子, 出処: .自家)
		self.牌3 = 牌型(牌識別子: 牌識別子, 出処: .自家)
		self.牌4 = 牌型(牌識別子: 牌識別子, 出処: .自家)
		self.牌識別子 = 牌識別子
	}
	public var 牌列: [牌型] { [牌1, 牌2, 牌3, 牌4] }
	public var 槓子判定: Bool { return true }
	public var 牌種: 牌種型 { 牌識別子.牌種 }
	public var 副露: 面子型 { self.牌1.出処 = .他家; return self }
	public var 栄和: 面子型 { self.牌1.出処 = .他家; self.牌1.和了牌 = true; return self }
	public var 自摸和: 面子型 { self.牌1.出処 = .自家; self.牌1.和了牌 = true; return self }
}

public struct 対子型: CustomStringConvertible {
	var 牌識別子: 牌識別子型
	var 牌1, 牌2: 牌型
	var 牌種: 牌種型 { 牌識別子.牌種 }
	var 牌列: [牌型] { [牌1, 牌2] }
	var 牌識別子列: [牌識別子型] { [牌1.牌識別子, 牌2.牌識別子] }
	var string: String { self.牌識別子列.map { String($0.character) }.joined() }
	init?(_ 牌1: 牌型, _ 牌2: 牌型) {
		let 牌列 = [牌1, 牌2]
		guard Set(牌列.map { $0.牌識別子 }).count == 1, let 牌 = 牌列.first else { return nil }
		self.牌1 = 牌1
		self.牌2 = 牌2
		self.牌識別子 = 牌.牌識別子
	}
	init(牌識別子: 牌識別子型) {
		self.牌1 = 牌型(牌識別子: 牌識別子, 出処: .自家)
		self.牌2 = 牌型(牌識別子: 牌識別子, 出処: .自家)
		self.牌識別子 = 牌識別子
	}
	var 含和了牌判定: Bool { self.牌列.filter { $0.和了牌 }.count > 0 }
	var 含他家牌判定: Bool { self.牌列.filter { $0.出処 != .自家 }.count > 0 }
	var 全自家牌判定: Bool { !self.牌列.含他家牌判定 }
	public var description: String { return self.string }
	public var 副露: 対子型 { self.牌1.出処 = .他家; return self }
	public var 栄和: 対子型 { self.牌1.出処 = .他家; self.牌1.和了牌 = true; return self }
	public var 自摸: 対子型 { self.牌1.出処 = .自家; self.牌1.和了牌 = true; return self }
}

public extension String {
	var 牌識別子列: [牌識別子型] { self.compactMap { 牌識別子型.文字牌識別子表[$0] } }
	var 牌列: [牌型] { self.compactMap { 牌識別子型.文字牌識別子表[$0] }.map { $0.牌 } }
}

struct 手牌型: CustomStringConvertible {
	var 手牌列: [牌型]
	var 副露面子列: [面子型]
	init(_ 手牌文字列: String, _ 副露面子文字列: [String]) {
		self.手牌列 = 手牌文字列.compactMap { 牌識別子型.文字牌識別子表[$0] }.sorted().map { $0.牌 }
		self.副露面子列 = 副露面子文字列.compactMap { 面子($0) }
	}
	var description: String {
		return "[ " + (手牌列.map { String($0.牌識別子.character) }.joined()) + " | " + (副露面子列.map { $0.牌列.string }.joined(separator: " ")) + " ]"
	}

	/*
	func 和了(牌: 牌型) -> [和了役型] {
		return []
	}
	*/
}

func 四面子一雀頭探索(牌列: [牌型], 副露面子列: [面子型], 和了牌: 牌型) -> [(面子列: [面子型], 雀頭: 対子型)] {
	var 四面子一雀頭列 = [([面子型], 対子型)]()
	let 実牌列 = 牌列 + [和了牌]
	let 牌列 = 実牌列.map { $0.牌識別子 }
	let 出現表 = 牌列.牌表
	for 頭候補 in (出現表.filter { $0.value >= 2 }) {
		let 索引列 = 牌列.indexes(of: 頭候補.key).prefix(2)
		var 牌列 = 牌列.removingIndexes(Array(索引列)).sorted()
		var 面子列 = [面子型]()
		while 牌列.count > 0 {
			for 牌 in Set(牌列).sorted() {
				guard 牌列.contains(牌) else { continue }
				// 刻子
				let 索引列 = 牌列.indexes(of: 牌).prefix(3)
				if 索引列.count == 3 {
					牌列.removeIndexes(Array(索引列))
					面子列.append(刻子型(牌識別子: 牌))
					continue
				}
				// 順子
				if let 数牌種 = 牌.数牌種, let 牌数 = 牌.牌数, let 順子構成子 = 順子構成子型(最若牌数: 牌数) {
					let 順子 = 順子型(数牌種: 数牌種, 順子構成子: 順子構成子)
					let 索引列 = 順子.牌列.flatMap { 牌列.indexes(of: $0) }
					牌列.removeIndexes(Array(索引列))
					if 索引列.count == 順子.牌列.count {
						面子列.append(順子)
						continue
					}
				}
				// 面子不成立
				break
			}
			break
		}
		if 牌列.count == 0, (面子列 + 副露面子列).count == 4 {
			四面子一雀頭列.append((面子列 + 副露面子列, 対子型(牌識別子: 頭候補.key)))
		}
	}
	return 四面子一雀頭列
}

func 国士無双十三面張判定(_ 実牌列: [牌型], _ 実和了牌: 牌型) -> Bool {
	let 国士無双牌群 = Set(牌識別子型.一九字牌)
	return 国士無双牌群 == Set(実牌列.map { $0.牌識別子 }) && 国士無双牌群.contains(実和了牌.牌識別子) && 実和了牌.和了牌
}
func 国士無双判定(_ 実牌列: [牌型], _ 実和了牌: 牌型) -> Bool {
	return Set(実牌列.map { $0.牌識別子 } + [実和了牌.牌識別子]) == Set(牌識別子型.一九字牌)
}
func 七対子判定(_ 実牌列: [牌型], _ 実和了牌: 牌型) -> Bool {
	let 出現表 = (実牌列.map { $0.牌識別子 } + [実和了牌.牌識別子]).牌表
	return 出現表.filter { $0.value == 2 }.count == 7
}
func 四槓子判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter({ $0.牌列.count == 4 }).count == 4
}
func 大四喜判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全風牌判定 }.count == 4
}
func 小四喜判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全風牌判定 }.count == 3 && 頭.牌識別子列.全風牌判定
}
func 發なし緑一色判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全發なし緑牌判定 }.count == 4 && 頭.牌識別子列.全發なし緑牌判定
}
func 緑一色判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全緑牌判定 }.count == 4 && 頭.牌識別子列.全緑牌判定
}
func 純正九蓮宝燈判定(_ 実牌列: [牌型], _ 実和了牌: 牌型) -> Bool {
	let 九蓮宝燈数列: [牌数型] = [ .一,.一,.一,.二,.三,.四,.五,.六,.七,.八,.九,.九,.九 ]
	let 数牌種群 = Set(実牌列.compactMap { $0.牌識別子.数牌種 })
	let 牌数列 = 実牌列.compactMap { $0.牌識別子.牌数 }
	return 数牌種群.count == 1 && 牌数列 == 九蓮宝燈数列 && 数牌種群 == Set([実和了牌.牌識別子.数牌種].compactMap { $0 })
}
func 四暗刻単騎判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.槓刻子判定 && !$0.含和了牌判定 && $0.全自家牌判定 }.count == 4 && 頭.含和了牌判定
}
func 四暗刻判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.槓刻子判定 && $0.全自家牌判定 }.count == 4
}
func 清老頭判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全一九牌判定 }.count == 4 && 頭.牌識別子列.全一九牌判定
}
func 字一色判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全字牌判定 }.count == 4 && 頭.牌識別子列.全字牌判定
}
func 大三元判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全三元牌判定 }.count == 3
}
func 清一色判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 牌種群 = Set(面子列.map({ $0.牌種 }) + [頭.牌識別子.牌種])
	return 牌種群.count == 1 && [牌種型.萬子種, .筒子種, .索子種].contains(牌種群.first)
}
func 混老頭判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全一九字牌判定 }.count == 4 && 頭.牌識別子列.全一九字牌判定
}
func 小三元判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全三元牌判定 }.count == 2 && 頭.牌識別子列.全三元牌判定
}
func 混一色判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 牌種列 = 面子列.map { $0.牌種 } + [頭.牌種]
	return (牌種列.compactMap { $0.字牌種 }).count > 0 && Set(牌種列.compactMap { $0.数牌種 }).count == 1
}
func 純全帯么九判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.含一九牌判定 }.count == 4 && 頭.牌識別子列.含一九牌判定
}
func 二盃口判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool { //　七対子に優先
	let 順子列 = 面子列.filter { $0.順子判定 }
	let 牌列: [牌識別子型] = 順子列.compactMap({ $0.牌列.first })
	let 出現表 = 牌列.reduce(into: [牌識別子型: Int]()) { (表, 牌) in 表[牌, default: 0] += 1 }
	return 出現表.filter { $0.value == 2 }.count == 2
}
func 一盃口判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 順子列 = 面子列.filter { $0.順子判定 }
	let 牌列: [牌識別子型] = 順子列.compactMap({ $0.牌列.first })
	let 出現表 = 牌列.reduce(into: [牌識別子型: Int]()) { (表, 牌) in 表[牌, default: 0] += 1 }
	return 出現表.filter { $0.value == 2 }.count == 1
}
func 三槓子判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.槓子判定 }.count == 3
}
func 混全帯幺九判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.含一九字牌判定 }.count == 4 && 頭.牌識別子列.含一九字牌判定
}
func 対々和判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 槓刻子列 = 面子列.filter { $0.槓刻子判定 }
	return 槓刻子列.count == 4 && 槓刻子列.filter { $0.含他家牌判定 }.count > 0
}
func 一気通貫判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 一気通貫順子構成列: [順子構成子型] = [.一二三, .四五六, .七八九]
	let 順子列 = 面子列.compactMap { $0 as? 順子型 }
	let 一気通貫数牌種 = Set(順子列.map({ $0.数牌種 })).filter { 数牌種 in
		Set(順子列.filter({ $0.数牌種 == 数牌種 }).map({ $0.順子構成子 })).intersection(Set(一気通貫順子構成列)).count == 一気通貫順子構成列.count
	}
	return 一気通貫数牌種.count > 0
}
func 三暗刻判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.槓刻子判定 && $0.全自家牌判定 }.count == 3
}
func 三色同刻判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 数牌刻子列 =  面子列.filter { $0.槓刻子判定 }.filter { $0.数牌種判定 }
	let 出現表: [牌数型: Int] = 数牌刻子列.compactMap { $0.牌列.first!.牌数 }.reduce(into: [牌数型: Int]()) { (表, 牌数) in 表[牌数, default: 0] += 1 }
	return 出現表.filter { $0.value == 3 }.count == 1
}
func 三色同順判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 順子列 = 面子列.compactMap { $0 as? 順子型 }
	let 出現表: [順子構成子型: Int] = 順子列.map { $0.順子構成子 }.reduce(into: [順子構成子型: Int]()) { (表, 構成) in 表[構成, default: 0] += 1 }
	return 出現表.filter { $0.value == 3 }.count == 1
}
func 断么九判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 牌列: [牌識別子型] = (面子列.flatMap { $0.牌列 }) + 頭.牌識別子列
	return !牌列.含一九字牌判定
}
func 平和判定(_ 面子列: [面子型], _ 頭: 対子型, 役風牌列: [場風型]) -> Bool {
	let 実牌列 = 面子列.flatMap { $0.牌列 } + 頭.牌列
	let 和了牌列 = 実牌列.filter { $0.和了牌 }
	if (役風牌列.map { $0.牌 } + 牌識別子型.三元牌).contains(頭.牌識別子) { return false }
	if 和了牌列.count == 1, let 和了牌 = 和了牌列.first, 和了牌.出処 == .他家 {
		let 順子列 = 面子列.compactMap { $0 as? 順子型 }
		return 順子列.count == 4 && 順子列.filter { $0.平和適合判定 }.count == 4
	}
	return false
}

//

public enum 和了型 {
	case 自摸
	case 栄和
}

let 役満役数表: [和了役型: Int] = [
	.純正九蓮宝燈: 2,
	.大四喜: 2,
	.国士無双十三面張: 2,
	.四暗刻単騎: 2,
	.国士無双: 1,
	.四暗刻: 1,
	.大三元: 1,
	.字一色: 1,
	.小四喜: 1,
	.緑一色: 1,
	.清老頭: 1,
	.四槓子: 1
]

let 翻数表: [和了役型: Int] = [
	.清一色: 6,
	.小三元: 4,
	.二盃口: 3,
	.純全帯么九: 3,
	.混一色: 3,
	.混老頭: 2,
	.三色同順: 2,
	.一気通貫: 2,
	.混全帯么九: 2,
	.七対子: 2,
	.対々和: 2,
	.三暗刻: 2,
	.三色同刻: 2,
	.三槓子: 2,
	.断么九: 1,
	.一盃口: 1,
	.平和: 1
]

let 喰い下がり役: [和了役型] = [
	.三色同順, .混全帯么九, .一気通貫, .純全帯么九, .混一色, .清一色
]

func 和了判定(手牌列: [牌型], 副露面子列: [面子型], 和了牌: 牌型) -> Set<和了役型> {
	assert(和了牌.和了牌)
	assert(手牌列.filter { $0.和了牌 }.count == 0)
	assert(副露面子列.filter { $0.含和了牌判定 }.count == 0)
	assert(副露面子列.count * 3 + 手牌列.count == 13)
	let 四面子一雀頭列 = 四面子一雀頭探索(牌列: 手牌列, 副露面子列: 副露面子列, 和了牌: 和了牌)
	let 副露 = 副露面子列.count > 0 && 副露面子列.filter { $0.副露判定 }.count > 0

	// 役満

	let 役満I和了表列: [和了役型] = [
		.純正九蓮宝燈: 純正九蓮宝燈判定(手牌列, 和了牌),
		.国士無双十三面張: 国士無双十三面張判定(手牌列, 和了牌),
		.国士無双: 国士無双判定(手牌列, 和了牌),
	].filter { $0.value }.map { $0.key }
	let 役満II和了表列: [[和了役型]] = 四面子一雀頭列.map { 四面子一雀頭 in
		let 面子列 = 四面子一雀頭.面子列
		return [
			.四暗刻単騎: 四暗刻単騎判定(面子列, 四面子一雀頭.雀頭),
			.四暗刻: 四暗刻判定(面子列, 四面子一雀頭.雀頭),
			.大三元: 大三元判定(面子列, 四面子一雀頭.雀頭),
			.字一色: 字一色判定(面子列, 四面子一雀頭.雀頭),
			.小四喜: 小四喜判定(面子列, 四面子一雀頭.雀頭),
			.大四喜: 大四喜判定(面子列, 四面子一雀頭.雀頭),
			.緑一色: 緑一色判定(面子列, 四面子一雀頭.雀頭),
			.清老頭: 清老頭判定(面子列, 四面子一雀頭.雀頭),
			.四槓子: 四槓子判定(面子列, 四面子一雀頭.雀頭)
		].filter { $0.value }.map { $0.key }
	}
	let 役満和了表列: [[和了役型]] = ([役満I和了表列] + 役満II和了表列).filter { $0.count > 0 }
	let 役満群 = 役満和了表列.map { Set(役列: $0, 上位下位役一覧: 上位下位役満一覧) }.sorted { (役満群1, 役満群2) -> Bool in
		役満群1.役満数() < 役満群2.役満数()
	}
	if let 最高役満群 = 役満群.last {
		return 最高役満群
	}

	//　１〜６翻までの役

	let 和了役表列: [[和了役型]] = 四面子一雀頭列.map { 四面子一雀頭 in
		let 面子列 = 四面子一雀頭.面子列
		return [
			.清一色: 清一色判定(面子列, 四面子一雀頭.雀頭),
			.混老頭: 混老頭判定(面子列, 四面子一雀頭.雀頭),
			.小三元: 小三元判定(面子列, 四面子一雀頭.雀頭),
			.二盃口: 二盃口判定(面子列, 四面子一雀頭.雀頭),
			.純全帯么九: 純全帯么九判定(面子列, 四面子一雀頭.雀頭),
			.混一色: 混一色判定(面子列, 四面子一雀頭.雀頭),
			.三色同順: 三色同順判定(面子列, 四面子一雀頭.雀頭),
			.一気通貫: 一気通貫判定(面子列, 四面子一雀頭.雀頭),
			.混全帯么九: 混全帯幺九判定(面子列, 四面子一雀頭.雀頭),
			.七対子: 七対子判定(手牌列, 和了牌),
			.対々和: 対々和判定(面子列, 四面子一雀頭.雀頭),
			.三暗刻: 三暗刻判定(面子列, 四面子一雀頭.雀頭),
			.三色同刻: 三色同刻判定(面子列, 四面子一雀頭.雀頭),
			.三槓子: 三槓子判定(面子列, 四面子一雀頭.雀頭),
			.断么九: 断么九判定(面子列, 四面子一雀頭.雀頭),
			.一盃口: 一盃口判定(面子列, 四面子一雀頭.雀頭)
		].filter { $0.value }.map { $0.key }
	}.sorted { (役列1, 役列2) -> Bool in
		return Set(役列1).翻数(副露: 副露) < Set(役列2).翻数(副露: 副露)
	}
	if let 和了表 = 和了役表列.first {
		return Set(和了表)
	}

	// 役なし
	return []
}

// 順子

let 🀇🀈🀉 = 順子型(数牌種: .萬子種, 順子構成子: .一二三)
let 🀈🀉🀊 = 順子型(数牌種: .萬子種, 順子構成子: .二三四)
let 🀉🀊🀋 = 順子型(数牌種: .萬子種, 順子構成子: .三四五)
let 🀊🀋🀌 = 順子型(数牌種: .萬子種, 順子構成子: .四五六)
let 🀋🀌🀍 = 順子型(数牌種: .萬子種, 順子構成子: .五六七)
let 🀌🀍🀎 = 順子型(数牌種: .萬子種, 順子構成子: .六七八)
let 🀍🀎🀏 = 順子型(数牌種: .萬子種, 順子構成子: .七八九)

let 🀙🀚🀛 = 順子型(数牌種: .筒子種, 順子構成子: .一二三)
let 🀚🀛🀜 = 順子型(数牌種: .筒子種, 順子構成子: .二三四)
let 🀛🀜🀝 = 順子型(数牌種: .筒子種, 順子構成子: .三四五)
let 🀜🀝🀞 = 順子型(数牌種: .筒子種, 順子構成子: .四五六)
let 🀝🀞🀟 = 順子型(数牌種: .筒子種, 順子構成子: .五六七)
let 🀞🀟🀠 = 順子型(数牌種: .筒子種, 順子構成子: .六七八)
let 🀟🀠🀡 = 順子型(数牌種: .筒子種, 順子構成子: .七八九)

let 🀐🀑🀒 = 順子型(数牌種: .索子種, 順子構成子: .一二三)
let 🀑🀒🀓 = 順子型(数牌種: .索子種, 順子構成子: .二三四)
let 🀒🀓🀔 = 順子型(数牌種: .索子種, 順子構成子: .三四五)
let 🀓🀔🀕 = 順子型(数牌種: .索子種, 順子構成子: .四五六)
let 🀔🀕🀖 = 順子型(数牌種: .索子種, 順子構成子: .五六七)
let 🀕🀖🀗 = 順子型(数牌種: .索子種, 順子構成子: .六七八)
let 🀖🀗🀘 = 順子型(数牌種: .索子種, 順子構成子: .七八九)

// 暗刻子

let 🀇🀇🀇 = 刻子型(牌識別子: .🀇)
let 🀈🀈🀈 = 刻子型(牌識別子: .🀈)
let 🀉🀉🀉 = 刻子型(牌識別子: .🀉)
let 🀊🀊🀊 = 刻子型(牌識別子: .🀊)
let 🀋🀋🀋 = 刻子型(牌識別子: .🀋)
let 🀌🀌🀌 = 刻子型(牌識別子: .🀌)
let 🀍🀍🀍 = 刻子型(牌識別子: .🀍)
let 🀎🀎🀎 = 刻子型(牌識別子: .🀎)
let 🀏🀏🀏 = 刻子型(牌識別子: .🀏)
let 🀙🀙🀙 = 刻子型(牌識別子: .🀙)
let 🀚🀚🀚 = 刻子型(牌識別子: .🀚)
let 🀛🀛🀛 = 刻子型(牌識別子: .🀛)
let 🀜🀜🀜 = 刻子型(牌識別子: .🀜)
let 🀝🀝🀝 = 刻子型(牌識別子: .🀝)
let 🀞🀞🀞 = 刻子型(牌識別子: .🀞)
let 🀟🀟🀟 = 刻子型(牌識別子: .🀟)
let 🀠🀠🀠 = 刻子型(牌識別子: .🀠)
let 🀡🀡🀡 = 刻子型(牌識別子: .🀡)
let 🀐🀐🀐 = 刻子型(牌識別子: .🀐)
let 🀑🀑🀑 = 刻子型(牌識別子: .🀑)
let 🀒🀒🀒 = 刻子型(牌識別子: .🀒)
let 🀓🀓🀓 = 刻子型(牌識別子: .🀓)
let 🀔🀔🀔 = 刻子型(牌識別子: .🀔)
let 🀕🀕🀕 = 刻子型(牌識別子: .🀕)
let 🀖🀖🀖 = 刻子型(牌識別子: .🀖)
let 🀗🀗🀗 = 刻子型(牌識別子: .🀗)
let 🀘🀘🀘 = 刻子型(牌識別子: .🀘)
let 🀆🀆🀆 = 刻子型(牌識別子: .🀆)
let 🀅🀅🀅 = 刻子型(牌識別子: .🀅)
let 🀄︎🀄︎🀄︎ = 刻子型(牌識別子: .🀄︎)
let 🀀🀀🀀 = 刻子型(牌識別子: .🀀)
let 🀁🀁🀁 = 刻子型(牌識別子: .🀁)
let 🀂🀂🀂 = 刻子型(牌識別子: .🀂)
let 🀃🀃🀃 = 刻子型(牌識別子: .🀃)

//　明槓子

let 🀇🀇🀇🀇 = 槓子型(牌識別子: .🀇).副露
let 🀈🀈🀈🀈 = 槓子型(牌識別子: .🀈).副露
let 🀉🀉🀉🀉 = 槓子型(牌識別子: .🀉).副露
let 🀊🀊🀊🀊 = 槓子型(牌識別子: .🀊).副露
let 🀋🀋🀋🀋 = 槓子型(牌識別子: .🀋).副露
let 🀌🀌🀌🀌 = 槓子型(牌識別子: .🀌).副露
let 🀍🀍🀍🀍 = 槓子型(牌識別子: .🀍).副露
let 🀎🀎🀎🀎 = 槓子型(牌識別子: .🀎).副露
let 🀏🀏🀏🀏 = 槓子型(牌識別子: .🀏).副露
let 🀙🀙🀙🀙 = 槓子型(牌識別子: .🀙).副露
let 🀚🀚🀚🀚 = 槓子型(牌識別子: .🀚).副露
let 🀛🀛🀛🀛 = 槓子型(牌識別子: .🀛).副露
let 🀜🀜🀜🀜 = 槓子型(牌識別子: .🀜).副露
let 🀝🀝🀝🀝 = 槓子型(牌識別子: .🀝).副露
let 🀞🀞🀞🀞 = 槓子型(牌識別子: .🀞).副露
let 🀟🀟🀟🀟 = 槓子型(牌識別子: .🀟).副露
let 🀠🀠🀠🀠 = 槓子型(牌識別子: .🀠).副露
let 🀡🀡🀡🀡 = 槓子型(牌識別子: .🀡).副露
let 🀐🀐🀐🀐 = 槓子型(牌識別子: .🀐).副露
let 🀑🀑🀑🀑 = 槓子型(牌識別子: .🀑).副露
let 🀒🀒🀒🀒 = 槓子型(牌識別子: .🀒).副露
let 🀓🀓🀓🀓 = 槓子型(牌識別子: .🀓).副露
let 🀔🀔🀔🀔 = 槓子型(牌識別子: .🀔).副露
let 🀕🀕🀕🀕 = 槓子型(牌識別子: .🀕).副露
let 🀖🀖🀖🀖 = 槓子型(牌識別子: .🀖).副露
let 🀗🀗🀗🀗 = 槓子型(牌識別子: .🀗).副露
let 🀘🀘🀘🀘 = 槓子型(牌識別子: .🀘).副露
let 🀆🀆🀆🀆 = 槓子型(牌識別子: .🀆).副露
let 🀅🀅🀅🀅 = 槓子型(牌識別子: .🀅).副露
let 🀄︎🀄︎🀄︎🀄︎ = 槓子型(牌識別子: .🀄︎).副露
let 🀀🀀🀀🀀 = 槓子型(牌識別子: .🀀).副露
let 🀁🀁🀁🀁 = 槓子型(牌識別子: .🀁).副露
let 🀂🀂🀂🀂 = 槓子型(牌識別子: .🀂).副露
let 🀃🀃🀃🀃 = 槓子型(牌識別子: .🀃).副露

// 暗槓子

let 🀫🀇🀇🀫 = 槓子型(牌識別子: .🀇)
let 🀫🀈🀈🀫 = 槓子型(牌識別子: .🀈)
let 🀫🀉🀉🀫 = 槓子型(牌識別子: .🀉)
let 🀫🀊🀊🀫 = 槓子型(牌識別子: .🀊)
let 🀫🀋🀋🀫 = 槓子型(牌識別子: .🀋)
let 🀫🀌🀌🀫 = 槓子型(牌識別子: .🀌)
let 🀫🀍🀍🀫 = 槓子型(牌識別子: .🀍)
let 🀫🀎🀎🀫 = 槓子型(牌識別子: .🀎)
let 🀫🀏🀏🀫 = 槓子型(牌識別子: .🀏)
let 🀫🀙🀙🀫 = 槓子型(牌識別子: .🀙)
let 🀫🀚🀚🀫 = 槓子型(牌識別子: .🀚)
let 🀫🀛🀛🀫 = 槓子型(牌識別子: .🀛)
let 🀫🀜🀜🀫 = 槓子型(牌識別子: .🀜)
let 🀫🀝🀝🀫 = 槓子型(牌識別子: .🀝)
let 🀫🀞🀞🀫 = 槓子型(牌識別子: .🀞)
let 🀫🀟🀟🀫 = 槓子型(牌識別子: .🀟)
let 🀫🀠🀠🀫 = 槓子型(牌識別子: .🀠)
let 🀫🀡🀡🀫 = 槓子型(牌識別子: .🀡)
let 🀫🀐🀐🀫 = 槓子型(牌識別子: .🀐)
let 🀫🀑🀑🀫 = 槓子型(牌識別子: .🀑)
let 🀫🀒🀒🀫 = 槓子型(牌識別子: .🀒)
let 🀫🀓🀓🀫 = 槓子型(牌識別子: .🀓)
let 🀫🀔🀔🀫 = 槓子型(牌識別子: .🀔)
let 🀫🀕🀕🀫 = 槓子型(牌識別子: .🀕)
let 🀫🀖🀖🀫 = 槓子型(牌識別子: .🀖)
let 🀫🀗🀗🀫 = 槓子型(牌識別子: .🀗)
let 🀫🀘🀘🀫 = 槓子型(牌識別子: .🀘)
let 🀫🀆🀆🀫 = 槓子型(牌識別子: .🀆)
let 🀫🀅🀅🀫 = 槓子型(牌識別子: .🀅)
let 🀫🀄︎🀄︎🀫 = 槓子型(牌識別子: .🀄︎)
let 🀫🀀🀀🀫 = 槓子型(牌識別子: .🀀)
let 🀫🀁🀁🀫 = 槓子型(牌識別子: .🀁)
let 🀫🀂🀂🀫 = 槓子型(牌識別子: .🀂)
let 🀫🀃🀃🀫 = 槓子型(牌識別子: .🀃)

// 対子

let 🀇🀇 = 対子型(牌識別子: .🀇)
let 🀈🀈 = 対子型(牌識別子: .🀈)
let 🀉🀉 = 対子型(牌識別子: .🀉)
let 🀊🀊 = 対子型(牌識別子: .🀊)
let 🀋🀋 = 対子型(牌識別子: .🀋)
let 🀌🀌 = 対子型(牌識別子: .🀌)
let 🀍🀍 = 対子型(牌識別子: .🀍)
let 🀎🀎 = 対子型(牌識別子: .🀎)
let 🀏🀏 = 対子型(牌識別子: .🀏)
let 🀙🀙 = 対子型(牌識別子: .🀙)
let 🀚🀚 = 対子型(牌識別子: .🀚)
let 🀛🀛 = 対子型(牌識別子: .🀛)
let 🀜🀜 = 対子型(牌識別子: .🀜)
let 🀝🀝 = 対子型(牌識別子: .🀝)
let 🀞🀞 = 対子型(牌識別子: .🀞)
let 🀟🀟 = 対子型(牌識別子: .🀟)
let 🀠🀠 = 対子型(牌識別子: .🀠)
let 🀡🀡 = 対子型(牌識別子: .🀡)
let 🀐🀐 = 対子型(牌識別子: .🀐)
let 🀑🀑 = 対子型(牌識別子: .🀑)
let 🀒🀒 = 対子型(牌識別子: .🀒)
let 🀓🀓 = 対子型(牌識別子: .🀓)
let 🀔🀔 = 対子型(牌識別子: .🀔)
let 🀕🀕 = 対子型(牌識別子: .🀕)
let 🀖🀖 = 対子型(牌識別子: .🀖)
let 🀗🀗 = 対子型(牌識別子: .🀗)
let 🀘🀘 = 対子型(牌識別子: .🀘)
let 🀆🀆 = 対子型(牌識別子: .🀆)
let 🀅🀅 = 対子型(牌識別子: .🀅)
let 🀄︎🀄︎ = 対子型(牌識別子: .🀄︎)
let 🀀🀀 = 対子型(牌識別子: .🀀)
let 🀁🀁 = 対子型(牌識別子: .🀁)
let 🀂🀂 = 対子型(牌識別子: .🀂)
let 🀃🀃 = 対子型(牌識別子: .🀃)

