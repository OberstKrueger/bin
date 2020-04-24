/*

 For the output of the program, the current bandwidth is formatted to 2 decimal places. This is completely arbitrary,
 as any value past the decimal place does not provide a lot of useful information. Since all values are in gigabytes,
 modern internet usage is hard to alter in a way that makes sub-gigabyte changes to monthly downloads.

 Additional spaces are also added to the front of the total bandwidth count so that all lines line up better. This does
 not account for extraneous bandwidth usage where total bandwidth exceeds 10 gigabytes and is 5 digits long. For
 typical use, this should not occur.

 */

import Foundation

/// Formats the output, rounding down numbers and adding spacing.
/// - parameters:
///     - current: Current bandwidth used.
///     - total: Total bandwidth used.
func formatOutput(_ current: Float64, _ total: Float64) -> String {
    let formatter = NumberFormatter()
    let roundedTotal = Int(total.rounded())

    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2

    switch roundedTotal {
    // All of the below formatted strings will be provided with a valid Float64. This value does not have to be correct
    // as far as previous calculations go for it to be formatted..
    case ...9:   return "   \(roundedTotal) => \(formatter.string(for: current)!)"
    case ...99:  return "  \(roundedTotal) => \(formatter.string(for: current)!)"
    case ...999: return " \(roundedTotal) => \(formatter.string(for: current)!)"
    default:     return "\(roundedTotal) => \(formatter.string(for: current)!)"
    }
}
