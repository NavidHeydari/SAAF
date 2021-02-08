package lambda.tasks.cpuintensive;

import java.util.ArrayList;
import java.util.List;

public class PrimeNumbersGeneratorBruteForce {

	/**
	 * generate a collection of all prime numbers equals or less than the given
	 * input number.
	 * 
	 * @param givenInputNumber
	 * @return
	 */
	public List<Integer> generatePrimeNumbers(int givenInputNumber) {
		List<Integer> listOfPrimeNumbers = new ArrayList<>();
		for (int num = 2; num <= givenInputNumber; num++) {
			if (isPrime(num)) {
				listOfPrimeNumbers.add(num);
			}
		}
		return listOfPrimeNumbers;
	}

	/**
	 * checking if the input number is prime or not.
	 * 
	 * @param number
	 * @return
	 */
	public boolean isPrime(int number) {
		for (int i = 2; i < number; i++) {
			if (number % i == 0) {
				return false;
			}
		}
		return true;
	}

}
