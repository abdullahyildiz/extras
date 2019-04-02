public class Singleton {

    private static Singleton instance;
    private Singleton() {}
    public static Singleton factory() {
	
	if(instance == null) {
	    
	    instance = new Singleton();
	    
	}

	return instance;
	
    }

}