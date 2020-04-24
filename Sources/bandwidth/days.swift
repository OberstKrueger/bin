/*

 Two dates are important for this calculation: the current day of the month, and the total days of the month. These two
 dates are returned as a tuple so that it can be stored as a single variable that can have either variable accessed
 from the main level.

 */

import Foundation

enum DaysError: Error {
    case notCalculated
}

func calculateDays() -> (Int, Int) {
    let today = Date()

    let current: Int = Calendar.current.component(.day, from: today)
    // Force-unwrapped due to the calculation parameters being hard-coded.
    // Famous last words: this should never return nil.
    let total: Range<Int> = Calendar.current.range(of: .day, in: .month, for: today)!

    return (current, total[total.endIndex - 1])
}
