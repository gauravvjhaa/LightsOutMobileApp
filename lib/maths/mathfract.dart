import 'package:equations/equations.dart';

class Slow {
  static List<List<double>> accessLightsOutFunctionality() {
    int size = 5;
    int modulo = 2;

    // Generate neighborhood matrix
    List<List<int>> matrix = generateNeighborhoodMatrix(size);
    print('Neighborhood Matrix:');
    matrix.forEach((row) {
      print(row);
    });
    print('');

    // Convert matrix to RealMatrix
    List<List<double>> data = matrix.map((row) => row.map((value) => value.toDouble()).toList()).toList();
    int rows = matrix.length;
    int columns = matrix[0].length;
    RealMatrix neigh = RealMatrix.fromData(
      rows: rows,
      columns: columns,
      data: data,
    );


    try {
      // Solve using Gaussian Elimination
      final gauss = GaussianElimination(
        matrix: neigh,
        knownValues:[0,0,1,1,0,0,0,1,0,0,0,0,0,0,0,0]
      );

      List<double> solutions = gauss.solve();
      print('Decimal Solutions:');
      print(solutions);
      print('');

      // Convert solutions to modulo
      List<double> solutionsModuloK = convertToFractionAndModulo(solutions, modulo);
      print('Fractional Solutions (Modulo $modulo):');
      print(solutionsModuloK);
      print('');

      // Compute final solution vector
      List<double> solVec = finalSol(solutionsModuloK, modulo);
      List<List<double>> solVector = convertToListOfListOfDoubles(solVec, size);

      print('Final Solution Vector:');
      solVector.forEach((row) {
        print(row);
      });

      return solVector;
    } catch (e) {
      // Handle exception
      print('Exception occurred: $e');

      // Set the solution vector to contain NaN values
      List<List<double>> solVector = List.generate(size, (_) => List.filled(size, 0.0));
      print('Solution vector: $solVector');

      return solVector;
    }
  }

  static List<List<double>> convertToListOfListOfDoubles(List<double> doubles, int sublistLength) {
    List<List<double>> result = [];
    for (int i = 0; i < doubles.length; i += sublistLength) {
      List<double> sublist = doubles.sublist(i, i + sublistLength);
      result.add(sublist);
    }
    return result;
  }

  static List<List<int>> generateNeighborhoodMatrix(int size) {
    int n = size * size;
    List<List<int>> neighborhoodMatrix = List.generate(n, (_) => List<int>.filled(n, 0));

    for (int cell = 1; cell <= n; cell++) {
      int row = (cell - 1) ~/ size + 1;
      int col = (cell - 1) % size + 1;

      neighborhoodMatrix[cell - 1][cell - 1] = 1;

      if (row > 1) neighborhoodMatrix[cell - 1][cell - size - 1] = 1;
      if (row < size) neighborhoodMatrix[cell - 1][cell + size - 1] = 1;
      if (col > 1) neighborhoodMatrix[cell - 1][cell - 2] = 1;
      if (col < size) neighborhoodMatrix[cell - 1][cell] = 1;
    }

    return neighborhoodMatrix;
  }

  static List<double> convertToFractionAndModulo(List<double> numbers, int modulo) {
    // Convert each decimal number to Fraction
    List<Fraction> fractions = numbers.map((e) => Fraction.fromDouble(e)).toList();

    print('Fractions: $fractions');

    // Take modulo with the specified value
    List<double> moduloResult = fractions.map((fraction) {
      double result = fraction.denominator > 10000 ? 0 : fraction.numerator % modulo.toDouble();
      return result;
    }).toList();

    return moduloResult;
  }

  static List<double> finalSol(List<double> elements, int states) {
    return elements.map((elementVal) => elementVal == 0 ? 0.0 : (states - elementVal).toDouble()).toList();
  }

  static void computeFinalSolution() {
    accessLightsOutFunctionality();
  }
}

void main() {
  Slow.computeFinalSolution();
}
