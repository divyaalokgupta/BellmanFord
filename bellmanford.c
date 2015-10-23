#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include<string.h>
#include<ctype.h>
#include<math.h>

#define END_ITER 0

#define SIZE 128
int  *tos, *p1, stack[SIZE];

void push(int i)
{
    p1++;
    if(p1 == (tos+SIZE)) 
    {
        printf("Stack Overflow.\n");
    }
    else
    {
        *p1 = i;
    }
}

int pop(void)
{
    if(p1 == tos) 
    {
        return -1;
    }
    p1--;
    return *(p1+1);
}

struct graph_link {
    int index;
    int infinite_bit;
    int weight;
    int dist_from_source;
    int prev_node_index;
    struct graph_link *out_links[128];
    int out_weights[128];
    int source_flag;
    int destination_flag;
    int change_status;
};
    
struct graph_link *link[128];

void print_graph()
{
    printf("\n\nGraph Summary\n");
    int i;
    for(i=1;i<=128;i++)
    {
        if(link[i] != NULL)
        {
            printf("Graph Link %d -> Index:%d Infinite Bit: %d Weight:%d Distance From Source:%d Parent Node:%d Source Flag:%d Destination Flag:%d Change Status:%d\n",i,link[i]->index,link[i]->infinite_bit,link[i]->weight,link[i]->dist_from_source,link[i]->prev_node_index,link[i]->source_flag,link[i]->destination_flag,link[i]->change_status);
            int j;
            for(j=1;j<=127;j++)
            {
                if(link[i]->out_links[j] != NULL)
                {
                    printf(" Link to Index: %d Weight: %d\n",link[i]->out_links[j]->index,link[i]->out_weights[j]);
                }
            }
        }
    }
}

void init_graph_link(int link_index)
{
    link[link_index]->index = link_index;
    link[link_index]->infinite_bit = 1;
    link[link_index]->weight = 0;
    link[link_index]->dist_from_source = 255;
    link[link_index]->prev_node_index = 255;
    int i;
    for(i=1;i<128;i++)
    {
        link[link_index]->out_links[i] = NULL;
        link[link_index]->out_weights[i] = 0;
    }
    link[link_index]->source_flag = 0;
    link[link_index]->destination_flag = 0;
    link[link_index]->change_status=0;
}

void delete_graph_link(struct graph_link *link)
{
    free(link);
}

struct graph_link *search_node(int index)
{
//    printf("Searching for %d\n",index);
    int i;
    for(i=1;i<=128;i++)
    {
        if(link[i]->index == index)
            return link[i];
    }
    printf("Error: Link Not Found on searching...Either invalid link information or nodes have not been setup\n");
    exit(-1);
}

int bellmanford(int node_links, int iteration)
{
    int iter,i,j;
    for(i=1;i<=node_links;i++)
    {
        if(link[i]->source_flag == 1)
        {
            link[i]->weight = 0;
            link[i]->infinite_bit = 0;
            link[i]->prev_node_index = link[i]->index;
            link[i]->dist_from_source = 0;
            link[i]->change_status = 1;
            for(j=1;j<=127;j++)
            {
                if(link[i]->out_links[j] != NULL ) 
                    push(link[i]->out_links[j]->index);
            }
        }
    }

    if(iteration == 1)
        return 2;

    struct graph_link *tmp;
    for(iter=2;iter<=node_links;iter++)
    {
        for(i=1;i<=node_links;i++)
        {
            if(link[i]->infinite_bit == 0)
                link[i]->change_status = 2;
        }

        //tmp = search_node(pop());
        int k;
        for(k=1;k<=node_links;k++)
        {
            tmp = link[k];
            for(i=1;i<=node_links;i++)
            {
                for(j=1;j<=127;j++)
                {
                   if(link[i]->out_links[j] != NULL && link[i]->out_links[j]->index == tmp->index && link[i]->infinite_bit == 0)
                   {
                       if(tmp->infinite_bit == 1)
                       {
                            tmp->infinite_bit = 0;
                            tmp->weight = link[i]->out_weights[j] + link[i]->weight;
                            tmp->prev_node_index = link[i]->index;
                            if(link[i]->source_flag == 1)
                                tmp->dist_from_source = 0;
                            else
                                tmp->dist_from_source = link[i]->dist_from_source + 1;
                            tmp->change_status = 1;
                       }
                       else if(tmp->infinite_bit == 0)
                       {
                            if(tmp->weight > link[i]->out_weights[j] + link[i]->weight)
                            {
                               tmp->weight = link[i]->out_weights[j] + link[i]->weight;
                               tmp->prev_node_index = link[i]->index;
                               if(link[i]->source_flag == 1)
                                   tmp->dist_from_source = 0;
                               else
                                   tmp->dist_from_source = link[i]->dist_from_source + 1;
                               tmp->change_status = 1;
                            }
                            else if(tmp->weight == link[i]->out_weights[j] + link[i]->weight)
                            {
                                if(tmp->dist_from_source > link[i]->dist_from_source + 1)
                                {
                                    tmp->prev_node_index = link[i]->index;
                                    if(link[i]->source_flag == 1)
                                        tmp->dist_from_source = 0;
                                    else
                                        tmp->dist_from_source = link[i]->dist_from_source + 1;
                                    tmp->change_status = 1;
                                }
                                else if(tmp->dist_from_source == link[i]->dist_from_source + 1)
                                {
                                    if(tmp->prev_node_index > link[i]->index)
                                    {
                                        tmp->prev_node_index = link[i]->index;
                                        tmp->change_status = 1;
                                    }
                                }
                            }
                       }
                   }
                }
            }
        }
        
        if(iter == iteration)
            return 2;
    }

    for(i=1;i<=node_links;i++)
        if(link[i]->change_status == 1)
            return 0;

    return 1;
}

int main(int argc, char *argv[])
{
    tos = stack; /* tos points to the top of stack */
    p1 = stack; /* initialize p1 */
    if(argc <= 2)
    {
        printf("Usage: ./bellmanford.out <Input Memory> <Graph Memory>\n");
        return 0;
    }

    FILE *graph = fopen(argv[2],"r");
    FILE *input = fopen(argv[1],"r");

    if (input == NULL)
    {
        printf("Error: Cannot open input file\n");
        return 0;
    }

    if (graph == NULL)
    {
        printf("Error: Cannot open graph file\n");
        return 0;
    }

/*  Initializing Nodes */
    char str[16];
    int num=0,node_count = 0;
    while(fgets(str,16,graph) != NULL)
    {
        if(!strcmp(str,"\n"))
        {
            break;
        }
        else
        {
            num = 0;
            int i,j = 0;
            for(i=0;isblank(str[i])==0;i++);
            j = i - j - 1;
            for(i=0;isblank(str[i])==0;i++)
            {
                num += (str[i] - 48) * pow(10,j);
                j--;
            }
//            printf("Num: %d\n",num);
            link[num] = (struct graph_link*)malloc(sizeof(struct graph_link));
            init_graph_link(num);
            node_count++;
        }
    }
//    print_graph();

/*  Initializing Nodes' links */
    struct graph_link *tmp1;
    while(fgets(str,60,graph) != NULL)
    {
        if(str[0] == '0')
            break;

//        printf("\n%d --> %s",node_count,str);
        int i,num=0,j=0;
        for(i=0;isblank(str[i])==0;i++);
        j = i - j - 1;
        for(i=0;isblank(str[i])==0;i++)
        {
            num += (str[i] - 48) * pow(10,j);
            j--;
        }
        tmp1 = search_node(num);
//        print_graph();
        i++;
        j=i;
        num=0;
        int temp=i;
        for(;isblank(str[i])==0;i++);
        j = i - j - 1;
        for(i=temp;isblank(str[i])==0;i++)
        {
            num += (str[i] - 48) * pow(10,j);
            j--;
        }
        int num_links = num;
//        printf("Links->%d\n",num_links);
        int k;
        if ( num_links <= 7 )
        {
            for(k=1;k<=num_links;k++)
            {
                i++;
                j=i;
                num=0;
                temp=i;
                for(;isblank(str[i])==0;i++);
                j = i - j - 1;
                for(i=temp;isblank(str[i])==0;i++)
                {
                    num += (str[i] - 48) * pow(10,j);
                    j--;
                }
                tmp1->out_links[k] = search_node(num);
                i++;
                j=i;
                num=0;
                temp=i;
                for(;isblank(str[i])==0;i++);
                j = i - j - 1;
                for(i=temp;isblank(str[i])==0;i++)
                {
                    if(!isalpha(str[i]))
                    {
                        num += (str[i] - 48) * pow(10,j);
                        j--;
                    }
                    else
                    {
                        num += (str[i] - 64 + 9) * pow(16,j);
                        j--;
                    }
                }
                if(num > 127)
                {
                    num -= 256;
                }
                tmp1->out_weights[k] = num;
//                print_graph();
            }
        }
        else
        {
        }
        for(;str[i]!='\n';i++);
    }

    int read_source=0;
    while(fgets(str,4,input) != NULL)
    {
        num = 0;
        int i,j=0;
//       printf("Num : %d\n",num); 
        
        for(i=0;isblank(str[i])==0 && str[i]!='\n';i++)
        {
            if(!isalpha(str[i]))
            {
                num += (str[i] - 48) * pow(10,j);
//                printf("Num : %d\n",num); 
            }
            else
            {
                num += (str[i] - 64 + 9) * pow(16,j);
            }
            j++;
        }
        for(;str[i]!='\n';i++);
//       printf("Num : %d\n",num); 
        if(read_source == 0 && num!=255 && num != 0)
        {
            tmp1 = search_node(num);
            tmp1->source_flag = 1;
            read_source = 1;
        }
        else if(read_source == 1 && num != 255 && num != 0)
        {
            tmp1 = search_node(num);
            tmp1->destination_flag = 1;
            read_source = 0;
        }
//      print_graph();
        if(num == 255 || num == 0) 
        {
            int check = bellmanford(node_count,END_ITER);
            if(check == 1)
            {
//              print_graph();

/* Writing Output */
                int array[128],c=1;
                for(i=1;i<=node_count;i++)
                {
                    for(c=1;c<=128;c++)
                        array[c] = 0;
                    c=1;
                    if(link[i]->destination_flag == 1)
                        break;
                }
                printf("%d\n",link[i]->weight);
                array[c++] = i;
                while(link[i]->source_flag == 0)
                {
                    i = link[i]->prev_node_index;
                    array[c++] = i;
                }
                c--;
                for(;c>=1;c--)
                    printf("%d\n",link[array[c]]->index);
                if(num == 255)
                    printf("FFFF\n");
                else if (num == 0)
                    printf("0\n");
            }
            else if(check == 0)
            {
                printf("Negative cycle exists\n");
                break;
            }
            else if(check == 2)
            {
                print_graph();
            }
/* Refreshing Nodes */            
            for(i=1;i<=node_count;i++)
            {
                link[i]->infinite_bit = 1;
                link[i]->weight = 0;
                link[i]->prev_node_index = 255;
                link[i]->dist_from_source = 255;
                link[i]->source_flag = 0;
                link[i]->destination_flag = 0;
                link[i]->change_status = 0;
            }
        }
    }

    int i;
    for(i=1;i<=node_count;i++)
        free(link[i]);

    return 0;
}
