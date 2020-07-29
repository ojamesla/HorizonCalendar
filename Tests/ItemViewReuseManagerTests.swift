// Created by Bryan Keller on 3/26/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import XCTest
@testable import HorizonCalendar

// MARK: - ItemViewReuseManagerTests

final class ItemViewReuseManagerTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    reuseManager = ItemViewReuseManager()
  }

  func testInitialViewCreationWithNoReuse() {
    let visibleItems: Set<VisibleCalendarItem> = [
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 01, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 01, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
    ]

    reuseManager.viewsForVisibleItems(
      visibleItems,
      viewHandler: { _, _, previousBackingItem in
        XCTAssert(
          previousBackingItem == nil,
          "Previous backing item should be nil since there are no views to reuse.")
      })
  }

  func testReusingIdenticalViews() {
    let initialVisibleItems: Set<VisibleCalendarItem> = [
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 01, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 01, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
    ]

    let subsequentVisibleItems = initialVisibleItems

    // Populate the reuse manager with the initial visible items
    reuseManager.viewsForVisibleItems(initialVisibleItems, viewHandler: { _, _, _ in })

    // Ensure all views are reused by using the exact same previous views
    reuseManager.viewsForVisibleItems(
      subsequentVisibleItems,
      viewHandler: { _, item, previousBackingItem in
        XCTAssert(
          item == previousBackingItem,
          """
            Expected the new item to be identical to the previous backing item, since the subsequent
            visible items are identical to the initial visible items.
          """)
      })
  }

  func testReusingAllViews() {
    let initialVisibleItems: Set<VisibleCalendarItem> = [
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 01, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 01, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
    ]

    let subsequentVisibleItems: Set<VisibleCalendarItem> = [
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 03, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 03, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 04, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
    ]

    // Populate the reuse manager with the initial visible items
    reuseManager.viewsForVisibleItems(initialVisibleItems, viewHandler: { _, _, _ in })

    // Ensure all views are reused given the subsequent visible items
    reuseManager.viewsForVisibleItems(
      subsequentVisibleItems,
      viewHandler: { _, item, previousBackingItem in
        XCTAssert(
          item.calendarItem.itemViewDifferentiator == previousBackingItem?.calendarItem.itemViewDifferentiator,
          """
            Expected the new item to have the same reuse identifier as the previous backing item,
            since it was reused.
          """)
      })
  }

  func testReusingSomeViews() {
    let initialVisibleItems: Set<VisibleCalendarItem> = [
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 01, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 01, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_2"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_3"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
    ]

    let subsequentVisibleItems: Set<VisibleCalendarItem> = [
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 05, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_3"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 05, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_4"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 04, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_5"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 05, isInGregorianCalendar: true))),
        frame: .zero),
    ]

    // Populate the reuse manager with the initial visible items
    reuseManager.viewsForVisibleItems(initialVisibleItems, viewHandler: { _, _, _ in })

    // Ensure the correct subset of views are reused given the subsequent visible items
    reuseManager.viewsForVisibleItems(
      subsequentVisibleItems,
      viewHandler: { _, item, previousBackingItem in
        switch item.calendarItem.itemViewDifferentiator {
        case .init(viewType: AnyHashable(0), invariantViewProperties: AnyHashable("item_type_1")),
             .init(viewType: AnyHashable(0), invariantViewProperties: AnyHashable("item_type_3")):
          XCTAssert(
            item.calendarItem.itemViewDifferentiator == previousBackingItem?.calendarItem.itemViewDifferentiator,
            """
              Expected the new item to have the same reuse identifier as the previous backing item,
              since it was reused.
            """)
        default:
          XCTAssert(
            previousBackingItem == nil,
            "Previous backing item should be nil since there are no views to reuse.")
        }
      })
  }

  func testDepletingAvailableReusableViews() {
    let initialVisibleItems: Set<VisibleCalendarItem> = [
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 01, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 01, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 02, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 03, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
    ]

    let subsequentVisibleItems: Set<VisibleCalendarItem> = [
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 03, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 04, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_0"),
        itemType: .layoutItemType(
          .monthHeader(Month(era: 1, year: 2020, month: 05, isInGregorianCalendar: true))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 03, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 04, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 05, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 06, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_1"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 07, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
      .init(
        calendarItem: MockCalendarItem(reuseIdentifier: "item_type_2"),
        itemType: .layoutItemType(
          .day(
            Day(
              month: Month(era: 1, year: 2020, month: 07, isInGregorianCalendar: true),
              day: 01))),
        frame: .zero),
    ]

    // Populate the reuse manager with the initial visible items
    reuseManager.viewsForVisibleItems(initialVisibleItems, viewHandler: { _, _, _ in })

    // Ensure the correct subset of views are reused given the subsequent visible items
    var reuseCountsForDifferentiators = [CalendarItemViewDifferentiator: Int]()
    var newViewCountsForDifferentiators = [CalendarItemViewDifferentiator: Int]()
    reuseManager.viewsForVisibleItems(
      subsequentVisibleItems,
      viewHandler: { _, item, previousBackingItem in
        if previousBackingItem != nil {
          let reuseCount = (reuseCountsForDifferentiators[item.calendarItem.itemViewDifferentiator] ?? 0) + 1
          reuseCountsForDifferentiators[item.calendarItem.itemViewDifferentiator] = reuseCount
        } else {
          let newViewCount = (newViewCountsForDifferentiators[item.calendarItem.itemViewDifferentiator] ?? 0) + 1
          newViewCountsForDifferentiators[item.calendarItem.itemViewDifferentiator] = newViewCount
        }
      })

    let expectedReuseCountsForDifferentiators: [CalendarItemViewDifferentiator: Int] = [
      .init(viewType: AnyHashable(0), invariantViewProperties: AnyHashable("item_type_0")): 2,
       .init(viewType: AnyHashable(0), invariantViewProperties: AnyHashable("item_type_1")): 3,
    ]
    let expectedNewViewCountsForDifferentiators: [CalendarItemViewDifferentiator: Int] = [
       .init(viewType: AnyHashable(0), invariantViewProperties: AnyHashable("item_type_0")): 1,
       .init(viewType: AnyHashable(0), invariantViewProperties: AnyHashable("item_type_1")): 2,
       .init(viewType: AnyHashable(0), invariantViewProperties: AnyHashable("item_type_2")): 1,
    ]

    XCTAssert(
      reuseCountsForDifferentiators == expectedReuseCountsForDifferentiators,
      "The number of reuses does not match the expected number of reuses.")

    XCTAssert(
      newViewCountsForDifferentiators == expectedNewViewCountsForDifferentiators,
      "The number of new view creations does not match the expected number of new view creations.")
  }

  // MARK: Private

  private var reuseManager: ItemViewReuseManager!

}

// MARK: - MockCalendarItem

private struct MockCalendarItem: AnyCalendarItem {

  // MARK: Lifecycle

  init(reuseIdentifier: String) {
    itemViewDifferentiator = CalendarItemViewDifferentiator(
      viewType: AnyHashable(0),
      invariantViewProperties: AnyHashable(reuseIdentifier))
  }

  // MARK: Internal

  let itemViewDifferentiator: CalendarItemViewDifferentiator

  func buildView() -> UIView { UIView() }

  func updateViewModel(view: UIView) { }

  func updateHighlightState(view: UIView, isHighlighted: Bool) { }

  func isInvariantViewProperties(
    equalToInvariantViewPropertiesOf otherCalendarItem: CalendarItemInvariantViewPropertiesEquatable)
    -> Bool
  {
    false
  }

  func isViewModel(equalToViewModelOf otherCalendarItem: CalendarItemViewModelEquatable) -> Bool {
    false
  }

}
