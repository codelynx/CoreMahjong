//
//  CoreMahjong_macTests.swift
//  CoreMahjong-macTests
//
//  Created by Kaz Yoshikawa on 6/16/20.
//

import XCTest
@testable import CoreMahjong_mac


class CoreMahjong_macTests: XCTestCase {
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	let 🀈🀉自摸🀇 = 順子型(牌識別子型.🀇.牌.自摸和, 牌識別子型.🀈.牌, 牌識別子型.🀉.牌)!
	let 🀈🀉栄和🀇 = 順子型(牌識別子型.🀇.牌.栄和, 牌識別子型.🀈.牌, 牌識別子型.🀉.牌)!
	let 🀇🀉自摸🀈 = 順子型(牌識別子型.🀇.牌, 牌識別子型.🀈.牌.自摸和, 牌識別子型.🀉.牌)!
	let 🀇🀉栄和🀈 = 順子型(牌識別子型.🀇.牌, 牌識別子型.🀈.牌.栄和, 牌識別子型.🀉.牌)!
	let 🀇🀈自摸🀉 = 順子型(牌識別子型.🀇.牌, 牌識別子型.🀈.牌, 牌識別子型.🀉.牌.自摸和)!
	let 🀇🀈栄和🀉 = 順子型(牌識別子型.🀇.牌, 牌識別子型.🀈.牌, 牌識別子型.🀉.牌.栄和)!

	let 🀛🀜自摸🀚 = 順子型(牌識別子型.🀚.牌.自摸和, 牌識別子型.🀛.牌, 牌識別子型.🀜.牌)!
	let 🀛🀜栄和🀚 = 順子型(牌識別子型.🀚.牌.栄和, 牌識別子型.🀛.牌, 牌識別子型.🀜.牌)!
	let 🀚🀜自摸🀛 = 順子型(牌識別子型.🀚.牌, 牌識別子型.🀛.牌.自摸和, 牌識別子型.🀜.牌)!
	let 🀚🀜栄和🀛 = 順子型(牌識別子型.🀚.牌, 牌識別子型.🀛.牌.栄和, 牌識別子型.🀜.牌)!
	let 🀚🀛自摸🀜 = 順子型(牌識別子型.🀚.牌, 牌識別子型.🀛.牌, 牌識別子型.🀜.牌.自摸和)!
	let 🀚🀛栄和🀜 = 順子型(牌識別子型.🀚.牌, 牌識別子型.🀛.牌, 牌識別子型.🀜.牌.栄和)!
	
	func test和了役Set() {
		do {
			// 二盃口は一盃口に優先する
			let 和了役列: [役型] = [.二盃口, .一盃口]
			let 和了役群 = Set(役列: 和了役列)
			XCTAssert(和了役群 == Set([.二盃口]))
		}
		do {
			// 現実の麻雀ではあり得ない
			let 和了役列: [役型] = [.二盃口, .一盃口, .混一色, .清一色, .混全帯么九, .純全帯么九, .混全帯么九, .混老頭]
			let 和了役群 = Set(役列: 和了役列)
			XCTAssert(和了役群 == Set([.二盃口, .清一色, .純全帯么九, .混老頭]))
		}
		do {
			// 下位役満
			let 和了役列: [役満型] = [.四暗刻]
			let 和了役群 = Set(役列: 和了役列)
			XCTAssert(和了役群 == Set([.四暗刻]))
		}
		do {
			// 上位役満
			let 和了役列: [役満型] = [.四暗刻単騎]
			let 和了役群 = Set(役列: 和了役列)
			XCTAssert(和了役群 == Set([.四暗刻単騎]))
		}
		do {
			// 四暗刻単騎は四暗刻に優先する
			let 和了役列: [役満型] = [.四暗刻単騎, .四暗刻]
			let 和了役群 = Set(役列: 和了役列)
			XCTAssert(和了役群 == Set([.四暗刻単騎]))
		}
		do {
			// 現実の麻雀ではあり得ない
			let 和了役列: [役満型] = [.国士無双十三面張, .国士無双, .大四喜, .小四喜, .發なし緑一色, .緑一色]
			let 和了役群 = Set(役列: 和了役列)
			XCTAssert(和了役群 == Set([.国士無双十三面張, .大四喜, .發なし緑一色]))
		}
	}

	func test単純和了() throws {
		XCTAssertTrue(国士無双十三面張判定("🀆🀅🀄︎🀀🀁🀂🀃🀇🀏🀙🀡🀐🀘".牌列, 牌識別子型.🀀.牌.自摸和))
		XCTAssertFalse(国士無双十三面張判定("🀆🀅🀄︎🀀🀀🀁🀂🀃🀇🀏🀙🀡🀐".牌列, 牌識別子型.🀘.牌.自摸和))
		XCTAssertTrue(国士無双判定("🀆🀅🀄︎🀀🀀🀁🀂🀃🀇🀏🀙🀡🀐".牌列, 牌識別子型.🀘.牌))
		XCTAssertFalse(国士無双判定("🀆🀅🀄︎🀀🀀🀁🀂🀃🀇🀏🀙🀡🀐".牌列, 牌識別子型.🀗.牌))
		XCTAssertTrue(七対子判定("🀉🀉🀛🀛🀡🀡🀓🀓🀗🀗🀂🀂🀅".牌列, 牌識別子型.🀅.牌))
		XCTAssertFalse(七対子判定("🀉🀉🀛🀛🀡🀡🀓🀓🀗🀗🀂🀂🀂".牌列, 牌識別子型.🀂.牌))
		XCTAssertTrue(四槓子判定([🀫🀇🀇🀫, 🀚🀚🀚🀚, 🀓🀓🀓🀓, 🀃🀃🀃🀃], 🀑🀑))
		XCTAssertFalse(四槓子判定([🀫🀇🀇🀫, 🀚🀚🀚🀚, 🀓🀓🀓🀓, 🀃🀃🀃], 🀑🀑))
		XCTAssertTrue(大四喜判定([🀀🀀🀀, 🀁🀁🀁, 🀂🀂🀂, 🀃🀃🀃], 🀎🀎))
		XCTAssertFalse(大四喜判定([🀫🀀🀀🀫, 🀁🀁🀁, 🀂🀂🀂, 🀏🀏🀏], 🀎🀎))
		XCTAssertTrue(小四喜判定([🀀🀀🀀, 🀁🀁🀁, 🀂🀂🀂, 🀜🀝🀞], 🀃🀃))
		XCTAssertFalse(小四喜判定([🀀🀀🀀, 🀁🀁🀁, 🀂🀂🀂, 🀜🀝🀞], 🀆🀆))
		XCTAssertTrue(發なし緑一色判定([🀑🀑🀑, 🀓🀓🀓, 🀕🀕🀕, 🀗🀗🀗], 🀒🀒))
		XCTAssertFalse(發なし緑一色判定([🀑🀑🀑, 🀓🀓🀓, 🀕🀕🀕, 🀗🀗🀗], 🀅🀅))
		XCTAssertFalse(發なし緑一色判定([🀑🀑🀑, 🀓🀓🀓, 🀕🀕🀕, 🀅🀅🀅], 🀒🀒))
		XCTAssertTrue(緑一色判定([🀑🀑🀑, 🀓🀓🀓, 🀕🀕🀕, 🀗🀗🀗], 🀅🀅))
		XCTAssertFalse(緑一色判定([🀑🀑🀑, 🀓🀓🀓, 🀔🀔🀔, 🀗🀗🀗], 🀅🀅))
		XCTAssertTrue(純正九蓮宝燈判定("🀇🀇🀇🀈🀉🀊🀋🀌🀍🀎🀏🀏🀏".牌列, 牌識別子型.🀏.牌.栄和))
		XCTAssertTrue(四暗刻単騎判定([🀈🀈🀈, 🀛🀛🀛, 🀘🀘🀘, 🀀🀀🀀], 🀄︎🀄︎.自摸))
		XCTAssertTrue(四暗刻単騎判定([🀫🀈🀈🀫, 🀛🀛🀛, 🀘🀘🀘, 🀀🀀🀀], 🀄︎🀄︎.栄和))
		XCTAssertFalse(四暗刻単騎判定([🀈🀈🀈, 🀛🀛🀛, 🀘🀘🀘, 🀀🀀🀀.副露], 🀄︎🀄︎))
		XCTAssertTrue(清老頭判定([🀏🀏🀏, 🀘🀘🀘, 🀙🀙🀙, 🀐🀐🀐], 🀇🀇))
		XCTAssertFalse(清老頭判定([🀏🀏🀏, 🀘🀘🀘, 🀙🀙🀙, 🀐🀐🀐], 🀆🀆))
		XCTAssertTrue(字一色判定([🀀🀀🀀, 🀁🀁🀁, 🀆🀆🀆, 🀅🀅🀅], 🀃🀃))
		XCTAssertFalse(字一色判定([🀀🀀🀀, 🀁🀁🀁, 🀆🀆🀆, 🀅🀅🀅], 🀙🀙))
		XCTAssertTrue(大三元判定([🀇🀈🀉, 🀆🀆🀆, 🀅🀅🀅, 🀄︎🀄︎🀄︎], 🀡🀡))
		XCTAssertFalse(大三元判定([🀇🀈🀉, 🀆🀆🀆, 🀅🀅🀅, 🀐🀑🀒], 🀡🀡))
		XCTAssertTrue(四暗刻判定([🀇🀇🀇, 🀘🀘🀘, 🀞🀞🀞, 🀀🀀🀀.自摸和], 🀅🀅))
		XCTAssertFalse(四暗刻判定([🀇🀇🀇, 🀘🀘🀘, 🀞🀞🀞, 🀀🀀🀀.副露], 🀅🀅))
		XCTAssertTrue(清一色判定([🀉🀉🀉, 🀊🀊🀊, 🀋🀌🀍, 🀍🀎🀏], 🀇🀇))
		XCTAssertFalse(清一色判定([🀉🀉🀉, 🀊🀊🀊, 🀋🀌🀍, 🀍🀎🀏], 🀁🀁))
		XCTAssertTrue(混老頭判定([🀙🀙🀙, 🀂🀂🀂, 🀄︎🀄︎🀄︎, 🀘🀘🀘], 🀇🀇))
		XCTAssertFalse(混老頭判定([🀙🀙🀙, 🀂🀂🀂, 🀄︎🀄︎🀄︎, 🀘🀘🀘], 🀜🀜))
		XCTAssertTrue(小三元判定([🀇🀈🀉, 🀖🀖🀖, 🀄︎🀄︎🀄︎, 🀅🀅🀅], 🀄︎🀄︎))
		XCTAssertFalse(小三元判定([🀇🀈🀉, 🀖🀖🀖, 🀄︎🀄︎🀄︎, 🀅🀅🀅], 🀁🀁))
		XCTAssertTrue(混一色判定([🀐🀑🀒, 🀓🀓🀓, 🀕🀖🀗, 🀃🀃🀃], 🀂🀂))
		XCTAssertFalse(混一色判定([🀐🀑🀒, 🀓🀓🀓, 🀟🀠🀡, 🀃🀃🀃], 🀂🀂))
		XCTAssertTrue(純全帯么九判定([🀐🀐🀐, 🀖🀗🀘, 🀙🀚🀛, 🀡🀡🀡], 🀏🀏))
		XCTAssertFalse(純全帯么九判定([🀈🀈🀈, 🀖🀗🀘, 🀙🀚🀛, 🀡🀡🀡], 🀏🀏))
		XCTAssertTrue(二盃口判定([🀌🀍🀎, 🀌🀍🀎, 🀑🀒🀓, 🀑🀒🀓], 🀄︎🀄︎))
		XCTAssertFalse(二盃口判定([🀇🀈🀉, 🀇🀈🀉, 🀖🀗🀘, 🀟🀟🀟], 🀄︎🀄︎))
		XCTAssertTrue(一盃口判定([🀇🀈🀉, 🀇🀈🀉, 🀖🀗🀘, 🀟🀟🀟], 🀄︎🀄︎))
		XCTAssertFalse(一盃口判定([🀇🀈🀉, 🀈🀉🀊, 🀖🀗🀘, 🀟🀟🀟], 🀄︎🀄︎))
		XCTAssertTrue(三槓子判定([🀆🀆🀆🀆, 🀋🀋🀋🀋, 🀖🀖🀖🀖, 🀝🀞🀟], 🀁🀁))
		XCTAssertFalse(三槓子判定([🀆🀆🀆🀆, 🀋🀋🀋🀋, 🀖🀖🀖, 🀝🀞🀟], 🀁🀁))
		XCTAssertTrue(混全帯幺九判定([🀇🀈🀉, 🀙🀚🀛, 🀁🀁🀁, 🀖🀗🀘], 🀀🀀))
		XCTAssertFalse(混全帯幺九判定([🀈🀉🀊, 🀙🀚🀛, 🀁🀁🀁, 🀖🀗🀘], 🀀🀀))
		XCTAssertTrue(対々和判定([🀏🀏🀏.副露, 🀗🀗🀗, 🀉🀉🀉, 🀚🀚🀚], 🀄︎🀄︎))
		XCTAssertFalse(対々和判定([🀏🀏🀏.副露, 🀗🀗🀗, 🀉🀉🀉, 🀙🀚🀛], 🀄︎🀄︎))
		XCTAssertTrue(一気通貫判定([🀇🀈🀉, 🀊🀋🀌, 🀍🀎🀏, 🀛🀜🀝], 🀅🀅))
		XCTAssertFalse(一気通貫判定([🀇🀈🀉, 🀜🀝🀞, 🀖🀗🀘, 🀁🀁🀁], 🀅🀅))
		XCTAssertTrue(三暗刻判定([🀊🀋🀌, 🀑🀑🀑, 🀞🀞🀞, 🀃🀃🀃], 🀄︎🀄︎))
		XCTAssertFalse(三暗刻判定([🀊🀋🀌, 🀑🀑🀑, 🀞🀞🀞, 🀃🀃🀃.副露], 🀄︎🀄︎))
		XCTAssertTrue(三色同刻判定([🀊🀊🀊, 🀜🀜🀜, 🀓🀓🀓, 🀌🀍🀎], 🀂🀂))
		XCTAssertFalse(三色同刻判定([🀊🀊🀊, 🀝🀝🀝, 🀓🀓🀓, 🀌🀍🀎], 🀂🀂))
		XCTAssertTrue(三色同順判定([🀇🀈🀉, 🀙🀚🀛, 🀐🀑🀒, 🀓🀓🀓], 🀠🀠))
		XCTAssertFalse(三色同順判定([🀇🀈🀉, 🀚🀛🀜, 🀐🀑🀒, 🀓🀓🀓], 🀠🀠))
		XCTAssertTrue(断么九判定([🀈🀉🀊, 🀌🀍🀎, 🀔🀕🀖, 🀛🀛🀛], 🀟🀟))
		XCTAssertFalse(断么九判定([🀈🀉🀊, 🀌🀍🀎, 🀔🀕🀖, 🀖🀗🀘], 🀟🀟))
		
		XCTAssertTrue(平和判定([🀉🀊🀋, 🀌🀍🀎, 🀖🀗🀘, 🀚🀛栄和🀜], 🀂🀂, 役風牌列: [.東, .北]))
		XCTAssertFalse(平和判定([🀉🀊🀋, 🀌🀍🀎, 🀖🀗🀘, 🀚🀛自摸🀜], 🀙🀙, 役風牌列: [.東, .北]))
		XCTAssertFalse(平和判定([🀉🀊🀋, 🀌🀍🀎, 🀖🀗🀘, 🀚🀛栄和🀜], 🀅🀅, 役風牌列: [.東, .北]))
		XCTAssertFalse(平和判定([🀉🀊🀋, 🀌🀍🀎, 🀖🀗🀘, 🀚🀛栄和🀜], 🀀🀀, 役風牌列: [.東, .北]))
	}
	
	func test複合役判定() {
		//	🀇, 🀈, 🀉, 🀊, 🀋, 🀌, 🀍, 🀎, 🀏, 🀙, 🀚, 🀛, 🀜, 🀝, 🀞, 🀟, 🀠, 🀡, 🀐, 🀑, 🀒, 🀓, 🀔, 🀕, 🀖, 🀗, 🀘
		//	🀆, 🀅, 🀄︎, 🀀, 🀁, 🀂, 🀃
		XCTAssertTrue(和了判定(手牌列: "🀇🀏🀙🀡🀐🀘🀆🀅🀄︎🀀🀁🀂🀃".牌列, 副露面子列: [], 和了牌: 牌識別子型.🀏.牌.栄和)?.役満群 == Set([.国士無双十三面張]))
		XCTAssertTrue(和了判定(手牌列: "🀇🀈🀉🀊🀋🀌🀍🀎🀜🀝🀞🀁🀁".牌列, 副露面子列: [], 和了牌: 牌識別子型.🀏.牌.栄和)?.役群 == Set([.一気通貫]))
	}
	
	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
}
