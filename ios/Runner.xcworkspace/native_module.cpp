#include <string>
#include <sstream>
#include <cmath>
#include <cstdio>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
const char* native_quadratic(int32_t a, int32_t b, int32_t c) {
    static char result[256];

    if (a == 0) {
        if (b == 0) {
            if (c == 0) {
                snprintf(result, sizeof(result), "Phương trình có vô số nghiệm!");
            } else {
                snprintf(result, sizeof(result), "Phương trình vô nghiệm!");
            }
        } else {
            float x = -static_cast<float>(c) / b;
            snprintf(result, sizeof(result), "Phương trình có nghiệm duy nhất là: %.2f", x);
        }
    } else {
        int32_t d = b * b - 4 * a * c; // Biệt thức delta
        if (d < 0) {
            snprintf(result, sizeof(result), "Phương trình vô nghiệm!");
        } else if (d == 0) {
            float x = -static_cast<float>(b) / (2 * a);
            snprintf(result, sizeof(result), "Phương trình có nghiệm kép là: %.2f", x);
        } else {
            float x1 = (-b + sqrt(d)) / (2.0f * a);
            float x2 = (-b - sqrt(d)) / (2.0f * a);
            snprintf(result, sizeof(result), "Phương trình có 2 nghiệm phân biệt là: x1 = %.2f, x2 = %.2f", x1, x2);
        }
    }

    return result;
}
