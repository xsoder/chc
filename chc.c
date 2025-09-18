#define NOB_IMPLEMENTATION
#define NOB_STRIP_PREFIX
#define NOB_EXPERIMENTAL_DELETE_OLD
#include "nob.h"

#define SIZE 1024
static const char* TMP = "tmp.c";
static Cmd cmd;

void common() {
    cmd_append(&cmd, "gcc");
    cmd_append(&cmd, "-Wall", "-Werror");
}

int run(int argc, char **argv, const char *input, const char *output) {
    NOB_GO_REBUILD_URSELF(argc, argv);
    common();
    cmd_append(&cmd, "-o", output, input);
    if(!cmd_run(&cmd)) return 1;
    return 0;
}


void compile_block(const char *block, FILE *out) {
    FILE *tmp = fopen(TMP, "w");
    if (!tmp) return;
    const char *text = "#include <nob.h>\n";
    fprintf(tmp,
    "#define NOB_IMPLEMENTATION\n"
    "#define NOB_STRIP_PREFIX\n"
    "#define NOB_EXPERIMENTAL_DELETE_OLD\n"
    "%s\n"
    "int main(void) {\n"
    "%s\n"
    "return 0;\n"
    "}", text, block);
    fclose(tmp);
    // TODO add a parameter to pass in the name
    common();
    cmd_append(&cmd, "-I.", "-o", "temp", TMP);
    if(!cmd_run(&cmd)) return;

    FILE *p = popen("./temp", "r");
    char buf[SIZE];
    if (!out) return ;
    while (fgets(buf, sizeof buf, p)) fputs(buf, out);
    pclose(p);
    if(!delete_file("temp")) return;
    if(!delete_file(TMP)) return;
}

int main(int argc, char **argv) {
    if (argc < 3) {
        nob_log(NOB_ERROR, "Usage: chc <input_file> and <output_file> ");
        return 1;
    }
    else if (argc == 3)
    {
        FILE *in = fopen(argv[1], "r");
        FILE *out = fopen(argv[2], "w");
        if (!in) return 1;
        if (!out) return 1;
        
        int c;
        int inside = 0;
        size_t length = 0;
        char cblock[SIZE];
        
        while ((c = fgetc(in)) != EOF) {
            if (inside) {
                if (c == '@') {
                    cblock[length] = '\0';
                    compile_block(cblock, out);
                    inside = 0;
                    continue;
                }
                if (length < sizeof cblock - 1) {
                    cblock[length++] = (char)c;
                } 
            } else {
                if (c == '@') {
                    inside = 1;
                    length = 0;
                    continue;
                }
                fputc(c, out);
            }
            
        }

        fclose(out);
        fclose(in);

        return 0;
    } else {
        nob_log(NOB_ERROR, "Usage: chc <input_file> and <output_file> ");
        return 1;
    }
}
