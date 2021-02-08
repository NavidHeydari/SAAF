package lambda.tasks.cpuintensive;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import lambda.Request;
import saaf.Inspector;
import saaf.Response;

import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * uwt.lambda_test::handleRequest
 *
 * @author Wes Lloyd
 * @author Navid Heydari
 */
public class CPUIntensiveTask implements RequestHandler<Request, HashMap<String, Object>> {

	/**
	 * Lambda Function Handler
	 * 
	 * @param request Request POJO with defined variables from Request.java
	 * @param context
	 * @return HashMap that Lambda will automatically convert into JSON.
	 */
	public HashMap<String, Object> handleRequest(Request request, Context context) {

		// Collect inital data.
		StringBuffer responseMsg = new StringBuffer();
		UUID uuid = UUID.fromString(System.nanoTime() + "");

		Inspector inspector = new Inspector();
		inspector.inspectAll();

		// ****************START FUNCTION IMPLEMENTATION*************************
		// Add custom key/value attribute to SAAF's output. (OPTIONAL)
		responseMsg.append("uuid=").append(uuid);

		Instant start = Instant.now();
		// Step 1: Input Validation
		if (isInputValidForPrimeGeneratorFunction(request)) {

			// Step 2: extract input value from req
			int givenNumber = extractGivenInputNumberFromRequest(request);

			responseMsg.append("\ttask=PrimeNumbersGeneratorBruteForce(").append(givenNumber).append(")");

			inspector.addAttribute("message", responseMsg.toString());

			// Step 3: Create and populate a separate response object for function output.
			Response response = new Response();

			// Step 4: Executing customized Task
			List<Integer> result = new PrimeNumbersGeneratorBruteForce().generatePrimeNumbers(givenNumber);

			// Step 5: Preparing Response
			responseMsg.append("\tresultSize=").append(result.size()).append("\texecTimeMS=")
					.append(Duration.between(start, Instant.now()).toMillis());

			response.setValue(responseMsg.toString());

			inspector.consumeResponse(response);
		}

		// ****************END FUNCTION IMPLEMENTATION***************************

		// Collect final information such as total runtime and cpu deltas.
		inspector.inspectAllDeltas();
		return inspector.finish();
	}

	/**
	 * validate the input values for this prime generator task.
	 * 
	 * @param request
	 * @return
	 */
	boolean isInputValidForPrimeGeneratorFunction(Request request) {
		return (Objects.nonNull(request.getName()) && !request.getName().trim().equalsIgnoreCase(""));
	}

	/**
	 * extract fields for this specific senario
	 * 
	 * @param request
	 * @return
	 */
	private int extractGivenInputNumberFromRequest(Request request) {
		int givenNumber;

		try {
			givenNumber = Integer.valueOf(request.getName());
		} catch (NumberFormatException e) {
			givenNumber = Integer.MIN_VALUE;
		}
		return givenNumber;
	}

}
