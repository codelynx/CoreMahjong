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
	
	func test和了() throws {
		XCTAssertTrue(国士無双十三面待ち判定("🀆🀅🀄︎🀀🀁🀂🀃🀇🀏🀙🀡🀐🀘".牌列, .🀀))
		XCTAssertFalse(国士無双十三面待ち判定("🀆🀅🀄︎🀀🀀🀁🀂🀃🀇🀏🀙🀡🀐".牌列, .🀘))
		XCTAssertTrue(国士無双判定("🀆🀅🀄︎🀀🀀🀁🀂🀃🀇🀏🀙🀡🀐".牌列, .🀘))
		XCTAssertFalse(国士無双判定("🀆🀅🀄︎🀀🀀🀁🀂🀃🀇🀏🀙🀡🀐".牌列, .🀗))
		XCTAssertTrue(七対子判定("🀉🀉🀛🀛🀡🀡🀓🀓🀗🀗🀂🀂🀅".牌列, .🀅))
		XCTAssertFalse(七対子判定("🀉🀉🀛🀛🀡🀡🀓🀓🀗🀗🀂🀂🀂".牌列, .🀂))
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
		XCTAssertTrue(純正九蓮宝燈判定("🀇🀇🀇🀈🀉🀊🀋🀌🀍🀎🀏🀏🀏".牌列, .🀏))
		XCTAssertTrue(四暗刻単騎判定([🀈🀈🀈, 🀛🀛🀛, 🀘🀘🀘, 🀀🀀🀀], 🀄︎🀄︎))
		XCTAssertTrue(四暗刻単騎判定([🀫🀈🀈🀫, 🀛🀛🀛, 🀘🀘🀘, 🀀🀀🀀], 🀄︎🀄︎))
		XCTAssertFalse(四暗刻単騎判定([🀈🀈🀈, 🀛🀛🀛, 🀘🀘🀘, 🀀🀀🀀.副露], 🀄︎🀄︎))
		XCTAssertTrue(清老頭判定([🀏🀏🀏, 🀘🀘🀘, 🀙🀙🀙, 🀐🀐🀐], 🀇🀇))
		XCTAssertFalse(清老頭判定([🀏🀏🀏, 🀘🀘🀘, 🀙🀙🀙, 🀐🀐🀐], 🀆🀆))
		XCTAssertTrue(字一色判定([🀀🀀🀀, 🀁🀁🀁, 🀆🀆🀆, 🀅🀅🀅], 🀃🀃))
		XCTAssertFalse(字一色判定([🀀🀀🀀, 🀁🀁🀁, 🀆🀆🀆, 🀅🀅🀅], 🀙🀙))
		XCTAssertTrue(大三元判定([🀇🀈🀉, 🀆🀆🀆, 🀅🀅🀅, 🀄︎🀄︎🀄︎], 🀡🀡))
		XCTAssertFalse(大三元判定([🀇🀈🀉, 🀆🀆🀆, 🀅🀅🀅, 🀐🀑🀒], 🀡🀡))
		XCTAssertTrue(四暗刻判定([🀇🀇🀇, 🀘🀘🀘, 🀞🀞🀞, 🀀🀀🀀.自摸], 🀅🀅))
		XCTAssertFalse(四暗刻判定([🀇🀇🀇, 🀘🀘🀘, 🀞🀞🀞, 🀀🀀🀀.副露], 🀅🀅))
		XCTAssertTrue(清一色判定([🀉🀉🀉, 🀊🀊🀊, 🀋🀌🀍, 🀍🀎🀏], 🀇🀇))
		XCTAssertFalse(清一色判定([🀉🀉🀉, 🀊🀊🀊, 🀋🀌🀍, 🀍🀎🀏], 🀁🀁))
		XCTAssertTrue(混老頭判定([🀙🀙🀙, 🀂🀂🀂, 🀄︎🀄︎🀄︎, 🀘🀘🀘], 🀇🀇))
		XCTAssertFalse(混老頭判定([🀙🀙🀙, 🀂🀂🀂, 🀄︎🀄︎🀄︎, 🀘🀘🀘], 🀜🀜))
		XCTAssertTrue(小三元判定([🀇🀈🀉, 🀖🀖🀖, 🀄︎🀄︎🀄︎, 🀅🀅🀅], 🀄︎🀄︎))
		XCTAssertFalse(小三元判定([🀇🀈🀉, 🀖🀖🀖, 🀄︎🀄︎🀄︎, 🀅🀅🀅], 🀁🀁))
		XCTAssertTrue(混一色判定([🀐🀑🀒, 🀓🀓🀓, 🀕🀖🀗, 🀃🀃🀃], 🀂🀂))
		XCTAssertFalse(混一色判定([🀐🀑🀒, 🀓🀓🀓, 🀟🀠🀡, 🀃🀃🀃], 🀂🀂))
		XCTAssertTrue(純全帯公九判定([🀐🀐🀐, 🀖🀗🀘, 🀙🀚🀛, 🀡🀡🀡], 🀏🀏))
		XCTAssertFalse(純全帯公九判定([🀈🀈🀈, 🀖🀗🀘, 🀙🀚🀛, 🀡🀡🀡], 🀏🀏))
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
		XCTAssertTrue(平和判定("🀉🀊🀋🀌🀍🀎🀖🀗🀘🀙🀙🀚🀛".牌列, .🀜, 役風牌列: [.東, .北]))
		XCTAssertTrue(平和判定("🀉🀊🀋🀌🀍🀎🀖🀗🀘🀂🀂🀚🀛".牌列, .🀜, 役風牌列: [.東, .北]))
		XCTAssertFalse(平和判定("🀉🀊🀋🀌🀍🀎🀖🀗🀘🀙🀚🀛🀜".牌列, .🀙, 役風牌列: [.東, .北]))
		XCTAssertFalse(平和判定("🀉🀊🀋🀌🀍🀎🀖🀗🀘🀀🀀🀚🀛".牌列, .🀜, 役風牌列: [.東, .北]))
	}
	
	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
}
