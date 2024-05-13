
class MathHelper {

  static int _calculateTotalOnes(List<List<int>> toggleMatrix) {
    int totalSum = 0;

    for (int i = 0; i < toggleMatrix.length; i++) {
      for (int j = 0; j < toggleMatrix[i].length; j++) {
        totalSum += toggleMatrix[i][j]; // Add each element to the total sum
      }
    }
    return totalSum;
  }


  static List<List<int>> findMinSumArray(List<List<int>> array1, List<List<int>> array2, List<List<int>> array3, List<List<int>> array4) {
    int sum1 = _calculateTotalOnes(array1);
    int sum2 = _calculateTotalOnes(array2);
    int sum3 = _calculateTotalOnes(array3);
    int sum4 = _calculateTotalOnes(array4);

    print(array1);
    print(array2);
    print(array3);
    print(array4);

    if (sum1 <= sum2 && sum1 <= sum3 && sum1 <= sum4) {
      return array1;
    } else if (sum2 <= sum1 && sum2 <= sum3 && sum2 <= sum4) {
      return array2;
    } else if (sum3 <= sum1 && sum3 <= sum2 && sum3 <= sum4) {
      return array3;
    } else {
      return array4;
    }
  }

  static List<List<int>> findMinSumArray16(List<List<int>> array1, List<List<int>> array2, List<List<int>> array3, List<List<int>> array4,
      List<List<int>> array5, List<List<int>> array6, List<List<int>> array7, List<List<int>> array8,
      List<List<int>> array9, List<List<int>> array10, List<List<int>> array11, List<List<int>> array12,
      List<List<int>> array13, List<List<int>> array14, List<List<int>> array15, List<List<int>> array16) {

    int sum1 = _calculateTotalOnes(array1);
    int sum2 = _calculateTotalOnes(array2);
    int sum3 = _calculateTotalOnes(array3);
    int sum4 = _calculateTotalOnes(array4);
    int sum5 = _calculateTotalOnes(array5);
    int sum6 = _calculateTotalOnes(array6);
    int sum7 = _calculateTotalOnes(array7);
    int sum8 = _calculateTotalOnes(array8);
    int sum9 = _calculateTotalOnes(array9);
    int sum10 = _calculateTotalOnes(array10);
    int sum11 = _calculateTotalOnes(array11);
    int sum12 = _calculateTotalOnes(array12);
    int sum13 = _calculateTotalOnes(array13);
    int sum14 = _calculateTotalOnes(array14);
    int sum15 = _calculateTotalOnes(array15);
    int sum16 = _calculateTotalOnes(array16);


    print(array1);
    print(array2);
    print(array3);
    print(array4);
    print(array5);
    print(array6);
    print(array7);
    print(array8);
    print(array9);
    print(array10);
    print(array11);
    print(array12);
    print(array13);
    print(array14);
    print(array15);
    print(array16);


    List<int> sums = [sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, sum9, sum10, sum11, sum12, sum13, sum14, sum15, sum16];
    mergeSort(sums, 0, sums.length - 1);

    List<List<int>> resultArray = sums[0] == sum1 ? array1
        : sums[0] == sum2 ? array2
        : sums[0] == sum3 ? array3
        : sums[0] == sum4 ? array4
        : sums[0] == sum5 ? array5
        : sums[0] == sum6 ? array6
        : sums[0] == sum7 ? array7
        : sums[0] == sum8 ? array8
        : sums[0] == sum9 ? array9
        : sums[0] == sum10 ? array10
        : sums[0] == sum11 ? array11
        : sums[0] == sum12 ? array12
        : sums[0] == sum13 ? array13
        : sums[0] == sum14 ? array14
        : sums[0] == sum15 ? array15
        : array16;

    return resultArray;
  }


  static void mergeSort(List<int> array, int left, int right) {
    if (left < right) {
      int mid = (left + right) ~/ 2;
      mergeSort(array, left, mid);
      mergeSort(array, mid + 1, right);
      merge(array, left, mid, right);
    }
  }

  static void merge(List<int> array, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;

    List<int> leftArray = List<int>.filled(n1, 0);
    List<int> rightArray = List<int>.filled(n2, 0);

    for (int i = 0; i < n1; i++) {
      leftArray[i] = array[left + i];
    }
    for (int j = 0; j < n2; j++) {
      rightArray[j] = array[mid + 1 + j];
    }

    int i = 0, j = 0;
    int k = left;

    while (i < n1 && j < n2) {
      if (leftArray[i] <= rightArray[j]) {
        array[k] = leftArray[i];
        i++;
      } else {
        array[k] = rightArray[j];
        j++;
      }
      k++;
    }

    while (i < n1) {
      array[k] = leftArray[i];
      i++;
      k++;
    }

    while (j < n2) {
      array[k] = rightArray[j];
      j++;
      k++;
    }
  }

}

