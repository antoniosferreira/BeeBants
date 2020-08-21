class Java {
	public static void main(String[] args) {
		String[] array = {"Integer","Boolean","String"};
		for (int i = 1, max = 1 << array.length; i < max; ++i) {
			for (int j = 0, k = 1; j < array.length; ++j, k <<= 1)
				if ((k & i) != 0)
					System.out.print(array[j] + " ");
			System.out.println();
		}
	}
	
	
}