#include <stddef.h>

int main() {
    int res = 1;
    
    for (size_t i = 0; i < 20; ++i) {
        res *= 2;
    }

    return 0;
}
