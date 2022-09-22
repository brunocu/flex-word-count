struct word_node
{
    char *word;
    unsigned count;
    struct word_node *next;
};

typedef struct {
    char *name;
    struct word_node *head;
} word_list;

void init_list(word_list *list, const char *name);
void add_word(word_list *list, const char *word);

struct word_node* init_new_node(const char *word);
