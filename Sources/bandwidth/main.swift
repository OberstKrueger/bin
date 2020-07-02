/*

 Since Comcast has a 1,024 gigabyte per month bandwidth limit, I needed a tool to calculate how I am doing for the
 month. This tool will display different levels of bandwidth for the whole month, and if I were to use that total
 value, it would display what the current bandwidth usage should be.

 The values that are displayed are arbitrary, other than the last. 1,024 gigabytes is broken up into 8 levels, as it
 seems fun to use this number as 8 bits are in a byte, and we are calculating total bandwidth. These are broken up into
 different levels, based on color: green, yellow, and red. If all bandwidth is below the 7th level (896 gigabytes), it
 is considered green and on track to stay substantially below the 1,024 gigabyte cap. If it is between above the 7th
 level but below the 8th and final level (1,024 gigabytes), then it is yellow, indicating that usage is below the
 monthly cap but in danger of going over. If it is at or above 1,024 gigabytes, then it is considered red. If usage
 continues at the same level, then the monthly cap will be surpassed, incurring a charge from Comcast.

 There are two data structures: the days tuple and the values array. The days tuple includes both the current day of
 the month and the totals in the month, allowing for quick calculation of where bandwidth usage should be for different
 values. The values array includes entries for current bandwidth, total bandwidth, and whether that entry is one of the
 built-in levels or is user provided. The current value for the built-in values are calculated based on the days and
 total value, whereas user-provided values will have the total value calculated based on current usage.

 All output is sorted and color-coded as appropriate before printing.

 This tool uses two external dependencies: Apple's ArgumentParser and my own SwiftyTerminalColors. ArgumentParser is
 used for determining if the inputed values are valid numbers. SwiftyTerminalColors provides some helper functions for
 printing to a terminal in different colors and styles. The output for all user-provided values are given a color as
 described earlier in this explanation, and, for those using fonts and terminals that support it, bolded to make it
 stand out more.

 */

import ArgumentParser
import SwiftyTerminalColors

struct Value {
    var base: Bool
    var current: Float64
    var total: Float64
}

/*
 @Flag(name: .shortAndLong, help: "Prints debug information about the playlists.")
 var debug: Bool
 */

struct Bandwidth: ParsableCommand {
    @Argument()
    var inputs: [UInt]

    @Option(name: .shortAndLong, default: 1_229, help: "Monthly bandwidth cap set by ISP.")
    var cap: Float64

    func run() {
        let days: (current: Int, total: Int) = calculateDays()
        var values: [Value] = stride(from: 0.1, through: 1.0, by: 0.1)
                              .map({Value(base: true, current: 0, total: cap * $0)})

        // Appends the contents of all inputs.
        values.append(contentsOf: inputs.map({Value(base: false, current: Float64($0), total: 0)}))

        // Calculate current and total bandwidth for all inputed values.
        for (index, value) in values.enumerated() {
            if value.current == 0 {
                let current = (Float64(days.current) / Float64(days.total)) * value.total
                values[index].current = current
            } else if value.total == 0 {
                let total = (Float64(days.total) / Float64(days.current)) * value.current
                values[index].total = total
            }
        }

        // Print sorted output.
        for value in values.sorted(by: {$0.total < $1.total}) {
            let output = formatOutput(value.current, value.total)

            switch value.base {
            case false:
                let warning: Float64 = 0.9 * cap

                switch value.total {
                case ..<warning: print(output.color(.green).style(.bold))
                case ..<cap:     print(output.color(.yellow).style(.bold))
                default:         print(output.color(.red).style(.bold))
                }
            case true:
                print(output)
            }
        }
    }
}

Bandwidth.main()
