class Extended {
    public static void main(String[] a) {
        System.out.println(new A().go());
    }
}

class A extends B{
    int c4;
    public int go() {
        Class1 c1;
        Class2 c2;
        Class3 c3;
        Class1 c1_2;
        Class1 c1_3;
        Class2 c2_3;
        int x;
        int y;
        y = x;
        c1 = new Class1();
        c2 = new Class2();
        c3 = new Class3();
        c1_2 = new Class1();
        x = c3.FMethod(c2);
        return 1337;
    }
}

class Class1 {
    public int AMethod() {
        return 0;
    }

    public Class1 BMethod() {
        return new Class1();
    }

    public int CMethod() {
        return 2;
    }
}

class Class2 extends Class1 {
    public Class2 BMethod() {
        return new Class2();
    }

    public int DMethod() {
        return 4;
    }
}

class Class3 extends Class2 {
    public int AMethod() {
        return 5;
    }

    public int DMethod() {
        return 5;
    }

    public int FMethod(Class1 x) {
        return 6;
    }
}

class B {
    int c2;
}