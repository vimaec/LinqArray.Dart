import 'package:flutter_test/flutter_test.dart';

import 'package:vim_linq_array/vim_linq_array.dart';

void main() {
  group('LinqArrayTests', () {
    const List<int> arrayToTen = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    final rangeToTen = 10.range();
    final buildToTen = LinqArray.build<int>(0, (x) => x + 1, (x) => x < 10);
    final tensData = <IArray<int>>[
      arrayToTen.toIArray(),
      rangeToTen,
      buildToTen
    ];

    test('CheckTens', () {
      for (var tens in tensData) {
        expect(tens.sequenceEquals(arrayToTen.toIArray()), true);
        expect(tens.first(-1), 0);
        expect(tens.last(-1), 9);
        expect(tens.aggregate(0, (int a, int b) => a + b), 45);
        expect(tens.count, 10);
        expect(tens[5], 5);
        expect(tens.elementAt(5), 5);

        var ones = 1.repeat(9);
        var diffs = tens.zipEachWithNext((x, y) => y - x);
        expect(ones.sequenceEquals(diffs), true);
        expect(ones.sequenceEquals(tens), false);

        var indices = tens.indices();
        expect(tens.sequenceEquals(indices), true);
        expect(tens.sequenceEquals(tens.selectByIndices(indices)), true);
        expect(
            tens
                .reverse()
                .sequenceEquals(tens.selectByIndices(indices.reverse())),
            true);

        var sum = 0;
        for (var x in tens.toIterable()) {
          sum += x;
        }
        for (var x in tens.toIterable()) {
          print(x.toString());
        }
        expect(sum, 45);
        expect(tens.first(-1), 0);
        expect(tens.all((x) => x < 10), true);
        expect(tens.any((x) => x < 5), true);
        expect(tens.countWhere((x) => x % 2 == 0), 5);
        expect(tens.reverse().last(-1), 0);
        expect(tens.reverse().reverse().first(-1), 0);
        var split = tens.splitByIndices(LinqArray.create([3, 6]));
        expect(3, split.count);

        var batch = tens.subArrays(3);
        expect(4, batch.count);
        expect(batch[0].sequenceEquals(LinqArray.create([0, 1, 2])), true);
        expect(batch[3].sequenceEquals(LinqArray.create([9])), true);

        var batch2 = tens.take(9).subArrays(3);
        expect(3, batch2.count);

        var counts = split.select((x) => x.count);
        expect(counts.sequenceEquals(LinqArray.create([3, 3, 4])), true);
        var indices2 = counts.accumulate((x, y) => x + y);
        expect(indices2.sequenceEquals(LinqArray.create([3, 6, 10])), true);
        var indices3 = counts.postAccumulate((x, y) => x + y, 0);
        expect(indices3.sequenceEquals(LinqArray.create([0, 3, 6, 10])), true);
        var flattened = split.flatten();
        expect(flattened.sequenceEquals(tens), true);
      }
    });
  });
}


// import 'package:vim.linq_array/vim.linq_array.dart';
// class LinqArrayTests {
//   static List<int> ArrayToTen = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
//   static IArray<int> RangeToTen = 10.range();
//   static IArray<int> BuildToTen = LinqArray.build1<T>(0, (x) => x + 1, (x) => x < 10);

//   static List<Object> TensData = [arrayToTen.toIArray<int>(), rangeToTen, buildToTen];

//   void checkTens(IArray<int> tens) {
//     expect(tens.sequenceEquals(arrayToTen.toIArray<int>()));
//     expect(0, tens.first<int>());
//     expect(9, tens.last<int>());
//     expect(45, tens.aggregate(0, (a, b) => a + b));
//     expect(10, tens.count);
//     expect(5, tens[5]);
//     expect(5, tens.elementAt(5));

//     var ones = 1.repeat(9);
//     var diffs = tens.zipEachWithNext((x, y) => y - x);
//     expect(ones.sequenceEquals(diffs));
//     Assert.isFalse(ones.sequenceEquals(tens));

//     var indices = tens.indices();
//     expect(tens.sequenceEquals(indices));
//     expect(tens.sequenceEquals(tens.selectByIndex(indices)));
//     expect(tens.reverse<int>().sequenceEquals(tens.selectByIndex(indices.reverse<int>())));

//     var sum = 0;
//     for (var x in tens.toEnumerable()) {
//       sum += x;
//     }
//     for (var x in tens.toEnumerable()) {
//       print(x.toString());
//     }
//     expect(45, sum);
//     expect(0, tens.first<int>());
//     assertTrue(tens.all((x) => x < 10));
//     assertTrue(tens.any((x) => x < 5));
//     expect(5, tens.countWhere((x) => x % 2 == 0));
//     expect(0, tens.reverse<int>().last<int>());
//     expect(0, tens.reverse<int>().reverse<int>().first<int>());
//     var split = tens.split(LinqArray.create<T>(3, 6));
//     expect(3, split.Count);

//     var batch = tens.subArrays(3);
//     expect(4, batch.count);
//     assertTrue(batch[0].sequenceEquals(LinqArray.create<T>(0, 1, 2)));
//     assertTrue(batch[3].sequenceEquals(LinqArray.create<T>(9)));

//     var batch2 = tens.take(9).subArrays<T>(3);
//     expect(3, batch2.count);

//     var counts = split.select((x) => x.Count);
//     assertTrue(counts.sequenceEquals(LinqArray.create<T>(3, 3, 4)));
//     var indices2 = counts.accumulate((x, y) => x + y);
//     assertTrue(indices2.sequenceEquals(LinqArray.create<T>(3, 6, 10)));
//     var indices3 = counts.postAccumulate((x, y) => x + y);
//     assertTrue(indices3.sequenceEquals(LinqArray.create<T>(0, 3, 6, 10)));
//     var flattened = split.flatten();
//     assertTrue(flattened.sequenceEquals(tens));
//   }
// }
