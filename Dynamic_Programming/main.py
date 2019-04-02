## zero-one knapsack problem ##

#############################################################################

# set up the problem environment

knapsack_size = 19

s_rods = [15, 5, 16, 7, 1, 15, 6, 3]

#s_rods = [2, 3, 4]
n = len(s_rods)

t_rods = [[0 for x in range(knapsack_size+1)] for x in range(n+1)]

def print_table():
    
    for i in range(0, n+1):
   
        for j in range(0, knapsack_size+1):
 
            print str(t_rods[i][j]) + "\t",
        
        print "\n"

#############################################################################

# initialize the table
t_rods[0][0] = 1

for j in range(1, knapsack_size+1):
    
    t_rods[0][j] = 0

# definition of the pseudo-polynomial function
for i in range(1, n+1):
    
    for j in range(0, knapsack_size+1):
        
        t_rods[i][j] = t_rods[i-1][j]
        
        if (j - s_rods[i-1]) >= 0:
            
            t_rods[i][j] = t_rods[i][j] or t_rods[i-1][j-s_rods[i-1]]

# print the table
#print "default version"
#print_table()

#############################################################################

# initialize the table
for i in range(0, n+1):
    
    for j in range(0, knapsack_size+1):
        
        t_rods[i][j] = -1

t_rods[0][0] = 1

for j in range(1, knapsack_size+1):
    
    t_rods[0][j] = 0
    
# definition of the memoized recursive function    
def knapsack_mem_rec(i, j):
    
    if (i-1) == 0:
        
        t_rods[i][j] = t_rods[i-1][j]
        
        if (j - s_rods[i-1]) >= 0:
            
            t_rods[i][j] = t_rods[i][j] or t_rods[i-1][j-s_rods[i-1]]
            
        return t_rods[i][j]
    
    if t_rods[i-1][j] == -1:
        
        t_rods[i-1][j] = knapsack_mem_rec(i-1, j)

        t_rods[i][j] = t_rods[i-1][j]
        
        if (j - s_rods[i-1]) >= 0:
            
            if (t_rods[i-1][j-s_rods[i-1]] == -1):
                
                t_rods[i-1][j-s_rods[i-1]] = knapsack_mem_rec(i-1, j-s_rods[i-1])
                
            t_rods[i][j] = t_rods[i][j] or t_rods[i-1][j-s_rods[i-1]]
            
    else:
        
        t_rods[i][j] = t_rods[i-1][j]
        
        if (j - s_rods[i-1]) >= 0:
            
            if (t_rods[i-1][j-s_rods[i-1]] == -1):
                
                t_rods[i-1][j-s_rods[i-1]] = knapsack_mem_rec(i-1, j-s_rods[i-1])
                
            t_rods[i][j] = t_rods[i][j] or t_rods[i-1][j-s_rods[i-1]]
        
    return t_rods[i][j]
        
    
# actual call of the memoized recursive function
knapsack_mem_rec(n, knapsack_size)

# print the table
# print "memoized recursive version"
# print_table()

#############################################################################

# initialize the table
for i in range(0, n+1):
    
    for j in range(0, knapsack_size+1):
        
        t_rods[i][j] = 0

t_rods[0][0] = 1

# definition of the recursive function
def knapsack_rec(i, j):
    
    if i == 0 and j == 0:
        
        return 1
        
    if i == 0:
        
        return 0
        
    if j - s_rods[i-1] >= 0:
        
        return knapsack_rec(i-1, j) or knapsack_rec(i-1, j-s_rods[i-1])
        
    else:
        
        return knapsack_rec(i-1, j)

# actual call of the recursive function
# print "recursive version"
# print knapsack_rec(n, knapsack_size)

# construct path
# p is the path matrix which shows if there is a node between node i and j when going from node i to node j

import numpy as np

p = np.array([[-1, 2, -1, 2], [-1, -1, 0, 2], [3, -1, -1, -1], [-1, 2, 0, -1]], np.int32)

def get_path(i, j):
    
    if p[i][j] == -1:
        
        print i, "->",
        print j
    
    else:
        
        get_path(i, p[i][j])
        
        get_path(p[i][j], j)

get_path(3,1)