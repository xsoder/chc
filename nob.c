#define NOB_IMPLEMENTATION
#define NOB_STRIP_PREFIX
#define NOB_EXPERIMENTAL_DELETE_OLD
#include "nob.h"

static Cmd cmd;

void common() {
    cmd_append(&cmd, "gcc");
    cmd_append(&cmd, "-Wall", "-Werror");
}

int main(int argc, char **argv) {
    NOB_GO_REBUILD_URSELF(argc, argv);
    common();
    if(needs_rebuild1("chc", "chc.c")) {
        cmd_append(&cmd, "-o", "chc", "chc.c");
        if(!cmd_run(&cmd)) return 1;
    }
    return 0;
}
