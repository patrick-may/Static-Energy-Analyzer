
int powerOf(int base, int power) {
    if (power == 0) {
        return 1;
    }
    return base * powerOf(base, power - 1);
}