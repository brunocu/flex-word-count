struct word_node
{
    char *word;
    unsigned count;
    struct word_node *next;
};

typedef struct word_list {
    char *name;
    struct word_node *head;
    struct word_list *next;
} word_list;

typedef struct {
    word_list *head;
} list_list;

void init_list(list_list *list);
word_list* lazy_get_word_list(list_list *list, const char *name);
void add_word(word_list *list, const char *word);

word_list* new_word_list_init(const char *name);
struct word_node* new_node_init(const char *word);

void print_list_list(list_list *list);
