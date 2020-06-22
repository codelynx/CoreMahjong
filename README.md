# Core Mahjong

当リポジトリは日本語と高階関数を多用すれば、麻雀の和了判定するコードなどさくっとかけるのではないかと<strike>侮って</strike>、知的好奇心から始めたものです。実際の麻雀ゲームなどに組み込む事を想定しているわけではありません。

では、Swift で和了判定に必要となる様々な定義を見ていきましょう。

###  和了役

 和了役を定義します。今回は、天和、立直などゲームの流れに起因する役は除外するもとします。

```.swift
public enum 和了役型: String {
	case 断么九
	case 平和
	case 一盃口
	case 三色同順
	case 三色同刻
	case 三暗刻
	case 一気通貫
	case 七対子
	case 対々和
	...
}
```

### 牌識別子

牌を識別するためにこんな enum を用意しました。せっかく麻雀牌の文字コードも識別子として使えるので、積極的に使って見るものとします。


```.swift
public enum 牌識別子型: Int, Comparable {
	case 🀇, 🀈, 🀉, 🀊, 🀋, 🀌, 🀍, 🀎, 🀏
	case 🀙, 🀚, 🀛, 🀜, 🀝, 🀞, 🀟, 🀠, 🀡
	case 🀐, 🀑, 🀒, 🀓, 🀔, 🀕, 🀖, 🀗, 🀘
	case 🀆, 🀅, 🀄︎
	case 🀀, 🀁, 🀂, 🀃
	...
}
```

また、全ての萬子とか全ての三元牌とか全ての一九字牌とかの定義がsれているので、これらに簡単にアクセスできます。

```.swift
public enum 牌識別子型: Int, Comparable {
	...
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
	...
}
```

### 牌種

牌の種類を次の`萬子`、`筒子`、`索子`、`三元牌`、`四風牌`に分類しそれを定義します。

```.swift
public enum 牌種型: Int, Comparable {
	case 萬子種
	case 筒子種
	case 索子種
	case 三元牌種
	case 四風牌種
	...
}
```

### 字牌種

字牌として`三元牌`と`四風牌`は分別できた方が便利な場合が多いので、それを定義します。

```.swift
public enum 字牌種型: Int, Comparable {
	case 三元牌種
	case 四風牌種
	...
}
```

### 数牌種

同様に数牌も`萬子`、`筒子`、`索子`に分別できた方が、便利なので、それを定義します。

```.swift
public enum 数牌種型: Int, Comparable {
	case 萬子種
	case 筒子種
	case 索子種
	...
}
```

### 牌

例えば、同じ🀝でも雀卓の上には四枚あります。ある🀝は赤ドラかもしれませんし、別の🀝は副露してきたものかもしれません。それらを区別するために`牌識別子型`に加えて`牌型`を定義します。ポン、カン、チー、ロンで手牌の仲間となった牌は`出処`プロパティで`自家`か`他家`で区別します。また、自摸和了か栄和了かで役の扱いが変わることがあるため、`和了牌`で識別子できます。`和了牌`が`true`である手牌は一つであると想定します。

```.swift
public class 牌型 {
	var 牌識別子: 牌識別子型
	var 出処: 出処型
	var 和了牌: Bool = false
	init(牌識別子: 牌識別子型, 出処: 出処型 = .自家) {
		...
	}
}
```

```.swift
public enum 出処型 {
	case 自家
	case 他家
}
```

### 面子

さて、順子、刻子、槓子をなんとか共通の型で扱いたい為、`面子型`と言うプロトコル を用意しました。これで、面子の配列の中から、全ての牌のArrayを取得するなんて事が高階関数など用いて簡単にできるようになります。

```.swift
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
```

### 牌数と順子構成子

順子を定義する前に、順子は萬子、筒子、索子と１〜９の数字の牌で構成されています。１〜９の牌を牌数型として定義します。

```.swift
public enum 牌数型: Int, Comparable {
	case 一, 二, 三, 四, 五, 六, 七, 八, 九
}
```

また順子として構成される、数字の牌は、同じ数字の牌の種類で 123、234、345、456、567、789の組み合わせしかないので、`順子構成子型`として定義してみました。全角の漢数字を使ってみました。


```.swift
public enum 順子構成子型 {
	case 一二三
	case 二三四
	case 三四五
	case 四五六
	case 五六七
	case 六七八
	case 七八九
	init?(_ 牌数列: [牌数型]) { ... }
	init?(最若牌数: 牌数型) { ... }
	...
}
```

### 順子

順子を定義します。基本的に`数牌種型`と`順子構成子`で一意に決定しますが、副露や栄和了で成立した順子もあるので、牌1, 牌2, 牌3と`牌型`のインスタンスを持ちます。

```.swift
public struct 順子型: 面子型 {
	var 数牌種: 数牌種型
	var 順子構成子: 順子構成子型
	var 牌1, 牌2, 牌3: 牌型
	init?(_ 牌1: 牌型, _ 牌2: 牌型, _ 牌3: 牌型) {
		...
	}
	init(数牌種: 数牌種型, 順子構成子: 順子構成子型) {
		...
	}
	...
}
```

### 刻子

刻子は同じ牌３つなので、`牌識別子型`で一意に決定しますが、順子同様、副露や栄和了で成立した順子もあるので、牌1, 牌2, 牌3と`牌型`のインスタンスを持ちます。

```.swift
public struct 刻子型: 面子型 {
	var 牌識別子: 牌識別子型
	var 牌1, 牌2, 牌3: 牌型
	init?(_ 牌1: 牌型, _ 牌2: 牌型, _ 牌3: 牌型) { ... }
	init(牌識別子: 牌識別子型) { ... }
	...	
}

```

### 槓子

刻子は同じ牌４つなので、`牌識別子型`で一意に決定しますが、順子や刻子と同様、副露や栄和了で成立した順子もあるので、牌1, 牌2, 牌3, 牌4と`牌型`のインスタンスを持ちます。

```.swift
public struct 槓子型: 面子型 {
	var 牌識別子: 牌識別子型
	var 牌1, 牌2, 牌3, 牌4: 牌型
	init?(_ 牌1: 牌型, _ 牌2: 牌型, _ 牌3: 牌型, _ 牌4: 牌型) { ... }
	init(牌識別子: 牌識別子型) { ... }
	...
}
```

### 対子

対子は同じ牌２つで対子として成立します。副露はありませんが、自摸和了や栄和了で成立する場合もあるので、牌1, 牌2と`牌型`のインスタンスを持ちます。


```.swift
public struct 対子型: CustomStringConvertible {
	var 牌識別子: 牌識別子型
	var 牌1, 牌2: 牌型
	...
}
```

### ユーティリティエクステンション

役の判定では、全ての牌が`字牌`であるか？全ての牌が`一九字牌`を含むか？、一つでも`一九字牌`を含むか？と言う判定を多用するので、`牌識別子型`や`牌型`の`Array`の`extension`でまとめて判定する事で、クライアントの判定コードの可読性が向上する事を期待しています。

```.swift
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
```

```.swift
public extension Array where Element == 牌型 {
	var 含和了牌判定: Bool { self.filter { $0.和了牌 }.count > 0 }
	var 含他家牌判定: Bool { self.filter { $0.出処 != .自家 }.count > 0 }
	var 全自家牌判定: Bool { !self.含他家牌判定 }
}
```

### 四面子一雀頭探索

和了判定では手牌の組み合わせで役が異なる場合があります。そこで、`国士無双`や`七対子`といったイレギュラーな組み合わせを除く、四面子一雀頭の組み合わせを洗い出す必要があります。

```.swift
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
```
最初は、麻雀版 `Scanner`みたいなものを作って試してみましたが、`清一色`のようなケースで拾ってくれない組み合わせが見つかったので、結局泥臭い組み合わせを計算するコードになってしまいました。

### 単純役の判定

では、単純な大三元と小三元をみてみましょう。

```.swift
func 大三元判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全三元牌判定 }.count == 3
}
```

```.swift
func 小三元判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.全三元牌判定 }.count == 2 && 頭.牌識別子列.全三元牌判定
}
```

次に混一色と純全帯么九の判定です。

```.swift
func 混一色判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 牌種列 = 面子列.map { $0.牌種 } + [頭.牌種]
	return (牌種列.compactMap { $0.字牌種 }).count > 0 && Set(牌種列.compactMap { $0.数牌種 }).count == 1
}
```

```.swift
func 純全帯么九判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	return 面子列.filter { $0.牌列.含一九牌判定 }.count == 4 && 頭.牌識別子列.含一九牌判定
}
```

ここだけ見ると、高階関数の利点を利用して、シュッと判定できているように思えます。では、もう少し複雑な役の判定を見てみましょう。

```.swift
func 一気通貫判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 一気通貫順子構成列: [順子構成子型] = [.一二三, .四五六, .七八九]
	let 順子列 = 面子列.compactMap { $0 as? 順子型 }
	let 一気通貫数牌種 = Set(順子列.map({ $0.数牌種 })).filter { 数牌種 in
		Set(順子列.filter({ $0.数牌種 == 数牌種 }).map({ $0.順子構成子 })).intersection(Set(一気通貫順子構成列)).count == 一気通貫順子構成列.count
	}
	return 一気通貫数牌種.count > 0
}
```

```.swift
func 三色同刻判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 数牌刻子列 =  面子列.filter { $0.槓刻子判定 }.filter { $0.数牌種判定 }
	let 出現表: [牌数型: Int] = 数牌刻子列.compactMap { $0.牌列.first!.牌数 }.reduce(into: [牌数型: Int]()) { (表, 牌数) in 表[牌数, default: 0] += 1 }
	return 出現表.filter { $0.value == 3 }.count == 1
}
```

```.swift
func 三色同順判定(_ 面子列: [面子型], _ 頭: 対子型) -> Bool {
	let 順子列 = 面子列.compactMap { $0 as? 順子型 }
	let 出現表: [順子構成子型: Int] = 順子列.map { $0.順子構成子 }.reduce(into: [順子構成子型: Int]()) { (表, 構成) in 表[構成, default: 0] += 1 }
	return 出現表.filter { $0.value == 3 }.count == 1
}

```

こんな感じで一つづつ地道に役を判定する関数を用意します。この際、後述する上位役と下位役が同時に成立する場合は、上位役を優先すると言うルールは個別の判定では意識しないものとします。

### 複合役の判定

手牌と副露された面子列の組み合わせより、全ての四面子一雀頭の組み合わせを探索して、それぞれの組み合わせで最も高い役の組み合わせを計算します。ここでは場の情報が与えられていないので平和の判定はしないものとします。`和了判定()`では前半に役満の判定、後半で役満未満の役の判定をします。

役満どうしの組み合わせで、同じ種類の上位と下位の役満が同時に成立する場合は上位の役を優先させています。同様に、役満未満の場合の役の組み合わせでも、同じ種類の上位と下位の役が同時に成立する場合は上位の役を優先させています。

```.swift
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
```

上位下位の役が同時に成立する場合は上位の役を優先させるために、`Set`の`和了役型`専用版の`extension`を用意しました。`Set`を用意する際に、上位と下位の役が両方含まれる場合は、下位の役を含めないコードになっています。

```.swift
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
}
```

役満以上の役と役満未満の役を同じ`和了役型`で扱ってしまった為、`和了役型`の`Set`を作る際には次のどちらかを指定する必要があります。

```.swift
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
```

実際上位役下位役の判定は地味に面倒です。これで、上位役下位役の優先順位の扱いは簡単になります。

```.swift
Set(役列: [和了役列.二盃口, .一盃口], 上位下位役一覧: 上位下位役一覧) // Set([.二盃口])
Set(役列: [和了役列.四暗刻単騎, .四暗刻], 上位下位役一覧: 上位下位役満一覧) // Set([.四暗刻単騎])
```


## 翻数の計算と食い下がり

役満以上の場合は役満の数、または、役満未満の場合はその役の組み合わせの翻数を計算します。せっかく`和了役型`が`Set`の中に入っているので、`和了役型`専用`Set`の`extension`を書いて、役満の数または翻数を計算する事にします。翻数の計算では、副露か否かで喰い下がりがあるの場合があるので、引数に副露を用意します。

```.swift
extension Set where Element == 和了役型 {
	func 役満数() -> Int {
		return self.map { 役満役数表[$0] ?? 0}.reduce(0, +)
	}
	func 翻数(副露: Bool) -> Int {
		return self.map { 役 in
			if let 翻数 = 翻数表[役] {
				return 翻数 - (副露 && 喰い下がり役.contains(役) ? 1 : 0)
			}
			return 0
		}.reduce(0, +)
	}
}
```

```.swift
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
	.混老頭: 4,
	.小三元: 4,
	.二盃口: 3,
	.純全帯么九: 3,
	.混一色: 3,
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
```

```.swift
let 喰い下がり役: [和了役型] = [
	.三色同順, .混全帯么九, .一気通貫, .純全帯么九, .混一色, .清一色
]
```

### 最後に

Swiftと高階関数があれば麻雀の和了判定なんて週末にチョチョイでできると甘く考えていましたが、思ったよりも面倒でした。何より麻雀ゲームを作るとかの野望があるわけはなく単なる知的好奇心だけでこのモチベーションを維持するのは大変でした。

Unit Test の `test複合役判定()` を見ると、複合役の判定があまりないのですが、自分で複合役のデータを自身を持って作れなかったからであります。

繰り返します。知的好奇心に基づくコードの探究としては面白いと思いますが、実際に麻雀ゲームに組み込むには程遠い品質である事が予想されます。筆者も次いつコードの改善などに取り組むかは予想できません。これらの点はご了承ください。

### License

The MIT License (MIT)

Copyright (c) 2020 Electricwoods LLC, Kaz Yoshikawa.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

### 環境

```.log
Apple Swift version 5.2.4 (swiftlang-1103.0.32.9 clang-1103.0.32.53)
Target: x86_64-apple-darwin19.5.0
```

