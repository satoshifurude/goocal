

class org.osflash.arp.ValueObjectsTemplate
{
	// Properties
	static private var inst = null;

	function ValueObjectsTemplate()
	{	
	}
	
	static public function getInstance()
	{
		// Singleton access
		if(inst == null)
		{
			inst = new ValueObjectsTemplate();
		}
		return inst;
	}
	
	public function registerValueObjects()
	{
		//
		// Add all value objects used in this application here. Each needs
		// to be registered as a class for Flash Remoting to successfully 
		// map incoming objects to AS classes. The same is true for outgoing
		// value objects.
		//
		// In OpenAMF, using the Advanced Gateway, you also have to update
		// the openamf-config.xml file and add a custom class mapping for each 
		// value object, in the following form:
		//
		//	<custom-class-mapping>
		//		<java-class>com.rbx.selfservice.model.vo.ValueObjects</java-class>
		//		<custom-class>com.rbx.selfservice.model.vo.ValueObjects</custom-class>
		//	</custom-class-mapping>	 	
		//

		//registerValueObject("com.company.project.model.vo.ValueObject",
						   // com.company.project.model.vo.ValueObject);		
				
		//registerValueObject("com.company.project.model.vo.AnotherValueObject",
							//com.company.project.model.vo.AnotherValueObject);		
		
	}
	
	private function registerValueObject(remoteObject, localObject):Void
	{
		var result:Boolean = Object.registerClass(remoteObject, localObject);
		if(result == false)
		{
			//trace("ValueObjects::registerValueObject, Could not register " + remoteObject + " to local object.");
			//TRACE(Flashout.ERROR + "ValueObjects::registerValueObject, Could not register " + remoteObject + " to local object.");
			//throw new Error("ERROR: ValueObjects::registerValueObject, Could not register " + remoteObject + " to local object.");	
		}
		else
		{
			//trace("ValueObjects::registerValueObject, successfully registered " + remoteObject + " to localObject.");
			//TRACE(Flashout.INFO + "ValueObjects::registerValueObject, successfully registered " + remoteObject + " to localObject.");
		}
	}
}
