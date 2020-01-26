# face - Fix Apple Card Exports

Apple Card added an export transactions feature via the Wallet app. The CSV format that Apple exports is not compatible with Banktivity, in that for a credit card account, Banktivity wants charges to be negative and payments to be positive. Apple exports charges as positive and payments as negative.

This app strips out fields that Banktivity does not support, and exports headers that match Banktivity's.

You can build the app, then move the binary to a place of your choosing. Pass a path to an Apple Card exported transactions .csv file, and the app will create a new file of the same name, with ".fixed.csv" appended. (It is super ugly, lol, you end up with foo.csv.fixed.csv) but this is just a late night hack.

There is now a simple Catalina app as well that you can drag an Apple Card Exported CSV file onto and it will generate a .ofx in the same directory.

Libraries used:

- https://github.com/dehesa/CodableCSV.git (My own fork at the moment)
- https://github.com/ShawnMoore/XMLParsing.git