#include "word_list.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void init_list(list_list *list)
{
    list->head = NULL;
}

/**
 * Get word_list with name `name`
 * Create if doesn't exist
 */
word_list *lazy_get_word_list(list_list *list, const char *name)
{
    if (list->head == NULL)
    {
        // empty list
        list->head = new_word_list_init(name);
        return list->head;
    }
    else
    {
        int cmp = strcmp((list->head)->name, name);
        if (cmp > 0)
        {
            // new head
            word_list *new_word_list = new_word_list_init(name);
            new_word_list->next = list->head;
            list->head = new_word_list;
            return new_word_list;
        }
        else if (cmp == 0)
        {
            return list->head;
        }
        else
        {
            // else locate node *before* insertion
            word_list *curr = list->head;
            // current->next->data < new_node->data
            while (curr->next != NULL)
            {
                cmp = strcmp((curr->next)->name, name);
                if (cmp < 0)
                    curr = curr->next;
                else
                    break;
            }
            if (cmp == 0)
            {
                return curr;
            }
            else
            {
                word_list *new_word_list = new_word_list_init(name);
                new_word_list->next = curr->next;
                curr->next = new_word_list;
                return new_word_list;
            }
        }
    }
}

void add_word(word_list *list, const char *word)
{
    if (list->head == NULL)
    {
        // empty list
        list->head = new_node_init(word);
    }
    else
    {
        int cmp = strcmp((list->head)->word, word);
        if (cmp > 0)
        {
            // new head
            struct word_node *new_node = new_node_init(word);
            new_node->next = list->head;
            list->head = new_node;
        }
        else if (cmp == 0)
        {
            list->head->count++;
        }
        else
        {
            struct word_node *curr = list->head;
            while (curr->next != NULL)
            {
                cmp = strcmp((curr->next)->word, word);
                if (cmp < 0)
                    curr = curr->next;
                else
                    break;
            }
            if (cmp == 0)
            {
                curr->count++;
            }
            else
            {
                struct word_node *new_node = new_node_init(word);
                new_node->next = curr->next;
                curr->next = new_node;
            }
        }
    }
}

word_list *new_word_list_init(const char *name)
{
    // allocate
    word_list *new_node = (word_list *)malloc(sizeof(word_list));
    // put name
    new_node->name = strdup(name);
    new_node->head = NULL;
    new_node->next = NULL;

    return new_node;
}

struct word_node *new_node_init(const char *word)
{
    // allocate
    struct word_node *new_node = (struct word_node *)malloc(sizeof(struct word_node));
    // put word
    new_node->word = strdup(word);
    new_node->count = 1;
    new_node->next = NULL;

    return new_node;
}

void print_list_list(list_list *list)
{
    word_list *word_list_ptr = list->head;
    while (word_list_ptr)
    {
        int word_tot = 0;
        struct word_node *word = word_list_ptr->head;
        while (word)
        {
            word_tot++;
            word = word->next;
        }
        printf("List=\"%s\",words=%d\n", word_list_ptr->name, word_tot);
        word_list_ptr = word_list_ptr->next;
    }
}