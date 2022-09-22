#include "word_list.h"
#include <stdlib.h>
#include <string.h>

void init_list(word_list *list, const char *name)
{
    list->name = strdup(name);
    list->head = NULL;
}

void add_word(word_list *list, const char *word)
{
    // empty
    if (list->head == NULL)
        list->head = init_new_node(word);
    else
    {
        struct word_node *curr = list->head;
        int cmp = strcmp(curr->word, word);
        while (curr->next != NULL && cmp < 0)
        {
            curr = curr->next;
            cmp = strcmp(curr->word, word);
        }
        if (cmp == 0)
        {
            curr->count++;
        }
        else
        {
            struct word_node *new_node = init_new_node(word);
            new_node->next = curr->next;
            curr->next = new_node;
        }
    }
}

struct word_node* init_new_node(const char *word)
{
    // allocate
    struct word_node *new_node = (struct word_node *)malloc(sizeof(struct word_node));
    // put word
    new_node->word = strdup(word);
    new_node->count = 1;
    new_node->next = NULL;

    return new_node;
}
