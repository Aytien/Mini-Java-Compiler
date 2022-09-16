class InternalMethodCall {
    public static void main(String[] argu) {
        System.out.println(
            new A1().funA1(
                new A1().funA1_2(), new A1().funA1(
                    true, new A1().funA1(false, new A1().funA1(
                        true, 6, new B1()), new A1()), new B1()), new A1()));
    }
}

class A1 {
    int x;
    boolean y;

    public int funA1(boolean arg2, int arg1, A1 arg3) {
        return arg1*5;
    }

    public boolean funA1_2() {
        return y;
    }
}

class B1 extends A1{
    
}
