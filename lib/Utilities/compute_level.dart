class Level {
  static num level = 0;
  static num before = 0, after = 1;
  static num computeLevel(num n) {
    // Peek Fibonacci
    int a = 0;
    int b = 1;
    if (n == a || n == b) return n;
    int c = a + b;
    int i = 0;
    while (c <= n) {
      a = b;
      i++;
      b = c;
      before = c;
      c = a + b;
    }
    level = i;
    after = c;
    return i;
  }
}
