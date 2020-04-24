/*

 The initial perogative for making this tool was to test out Apple's new ArgumentParser framework. I have a short
 script which will print out random numbers as I need them (which is often for when I am randomly picking what project
 to work on), which this tool will replace. ArgumentParser is new and will be in flux for a while, but I plan to keep
 up with its progress using this tool, as it is simple and easy to take the logic and apply it to something new.

 ArgumentParser is appealing to use due to the likelihood of Apple maintaining it to at least a 1.0 release. There are
 many argument parsers on GitHub, but since Swift does not have a package source that prevents previously published
 packages from being pulled like JavaScript's npm or Rust's cargo, I would be required to either trust that another
 developer would not pull their package or vendor the package to my own sources. Vendoring is a good way to keep
 access to code that others released, but I prefer to not have to keep my own forks of every package I use. Therefore,
 when I am working with Swift, I stick to my own code, Apple's provided frameworks that are built into their operating
 systems, and officially released packages they release online.

 ArgumentParser is used to validate an input of 0, 1, or 2 numbers. If 0 numbers are provided, the output will be a
 random number between 0 and 255. If 1 number is provided, the output will be a random number between 0 and the
 provided number. If 2 numbers are provided, the output will be a random number between the 2 provided numbers.

 Unsigned integers are used instead of signed integers within this tool. While Swift provides a random number generator
 for integers, it is difficult to pass a negative number through ArgumentParser. Doing so would require additional
 flags that would not be intuitive. Therefore, simply using unsigned integers provides a greater upper-bound instead of
 being limited to the half-range of signed integers.

 A repeat optional is included to produce multiple random numbers. This has the short-name of r and long-name of
 repeat. Due to Swift keyboard reservations, the variable is named "times" to prevent a conflict with the "repeat"
 keyword.

 */

import ArgumentParser

struct Random: ParsableCommand {
    @Option(name: [.customShort("r"), .customLong("repeat")], default: 1)
    var times: UInt

    @Argument(default: 255)
    var first: UInt?

    @Argument(default: 0)
    var second: UInt?

    func run() {
        for _ in 1...times {
            let minimum = min(first!, second!)
            let maximum = max(first!, second!)
            print(UInt.random(in: minimum...maximum))
        }
    }
}

Random.main()
