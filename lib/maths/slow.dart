import 'package:equations/equations.dart';

List<List<int>> generateNeighborhoodMatrix(int size) {
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

List<int> convertToFractionAndModulo(List<double> numbers, int modulo) {
  // Convert each decimal number to Fraction
  List<Fraction> fractions = numbers.map((e) => Fraction.fromDouble(e)).toList();

  print('Fractions: $fractions');

  // Take modulo with the specified value
  List<int> moduloResult = fractions.map((fraction) {
    int result = fraction.denominator > 100000 ? 0 : fraction.numerator % modulo;
    return result;
  }).toList();

  return moduloResult;
}

List<int> finalSol(List<int> elements, int modulo) {
  List<int> toBeReturned;
  if (modulo==8){
    toBeReturned = elements.map((elementVal) => elementVal == 0 ? 0 : modulo - elementVal - 2).toList();
  } else if (modulo==9){
    toBeReturned = elements.map((elementVal) => elementVal == 0 ? 0 : modulo - elementVal - 1).toList();
  } else {
    toBeReturned = elements.map((elementVal) => elementVal == 0 ? 0 : modulo - elementVal).toList();
  }
  return toBeReturned;
}

void main() {
  int size = 5;
  int modulo = 2;
  List<List<int>> matrix = generateNeighborhoodMatrix(size);
  for (List<int> row in matrix) {
    print(row);
  }

  List<List<double>> data = matrix.map((row) => row.map((value) => value.toDouble()).toList()).toList();
  int rows = matrix.length;
  int columns = matrix[0].length;

  RealMatrix neigh = RealMatrix.fromData(
    rows: rows,
    columns: columns,
    data: data,
  );

  try {
    final gauss = GaussianElimination(
      matrix: neigh,
      knownValues: [1,1,1,0,0,  0,1,0,0,0,   0,1,1,1,1,   1,1,1,0,0,   1,0,1,0,0],
    );

    final solutions = gauss.solve();
    final solutionsModuloK = convertToFractionAndModulo(solutions, modulo); // Taking modulo 2 of the output
    print('Solutions in decimal: $solutions');
    print('Question can be reached via: $solutionsModuloK');
    final solVector = finalSol(solutionsModuloK, modulo);
    print('Solutions will be: $solVector');
  } catch (e) {
    print('Exception occurred: $e');
    // Set the solution vector to contain NaN values
    final solVector = List.filled(size*size, double.nan);
    print('Solution vector: $solVector');
  }
}
