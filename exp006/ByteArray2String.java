class ByteArray2String {
    public static void main (String args[]) {

        byte[] key = new byte[] {76, 50, -39, -9, -50, 16, -11, -83, 76, 50, -39, -9, -50, 16, -11, -83, 76, 50, -39, -9, -50, 16, -11, -83, 76, 50, -39, -9, -50, 16, -11, -83 };

        System.out.println(bytesToHexString(key));

    }

    public static String bytesToHexString(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for(byte b: bytes) {
            sb.append(String.format("%02x",b&0xff));
        }
        return sb.toString();

    }
}
