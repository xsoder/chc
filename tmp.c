#define NOB_IMPLEMENTATION
#define NOB_STRIP_PREFIX
#define NOB_EXPERIMENTAL_DELETE_OLD
#include <nob.h>

int main(void) {

for (int i = 0; i < 10; i++) {
    printf("<li>%d</li>\n", i);
}

return 0;
}