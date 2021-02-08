package lambda;

import java.util.List;

/**
 *
 * @author Wes Lloyd
 * @author Navid Heydari
 */
public class Request {

    String name;
    
	/**
	 * this field will be used to pass the content as the message payload to the
	 * lambda function.
	 */
	List<Object> messageContent;

    public String getName() {
        return name;
    }
    
    public String getNameALLCAPS() {
        return name.toUpperCase();
    }

    public void setName(String name) {
        this.name = name;
    }
    
    public List<Object> getMessageContent() {
		return messageContent;
	}

	public void setMessageContent(List<Object> messageContent) {
		this.messageContent = messageContent;
	}

	public Request(String name) {
        this.name = name;
    }

    public Request() {

    }
}
