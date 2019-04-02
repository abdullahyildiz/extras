#!/usr/bin/python3.4

import numpy as np
import matplotlib.pyplot as plt
import time

# store result in a result class object
class result:
    def __init__(self, _algorithm, _input_size, _runtime):
        self.algorithm = _algorithm
        self.input_size = _input_size
        self.runtime = _runtime

# partition array for quick sort
def PartitionArray(_array, _beg, _end):
    
    _left = _beg
    _right = _end
    _pivotLoc = _beg
    _right2left = 1
    
    while _left < _right:
        
        if _right2left == 1:
            
            if _array[_pivotLoc] > _array[_right]:
                
                _temp = _array[_right]
                _array[_right] = _array[_pivotLoc]
                _array[_pivotLoc] = _temp
                _pivotLoc = _right
                _right2left = 0
                
            else:
                
                _right -= 1
    
        else:
            
            if _array[_pivotLoc] < _array[_left]:
                
                _temp = _array[_left]
                _array[_left] = _array[_pivotLoc]
                _array[_pivotLoc] = _temp
                _pivotLoc = _left
                _right2left = 1
                
            else:
                
                _left += 1
            
    return _pivotLoc

# quick sort
def QuickSort(_array, _beg, _end):
    
    if _beg < _end:
        
        _pivotLoc_t = PartitionArray(_array, _beg, _end)
        QuickSort(_array, _beg, (_pivotLoc_t - 1))
        QuickSort(_array, (_pivotLoc_t + 1), _end)

# insertion sort
def InsertionSort(_array):
    
    for index in range(1,len(_array)):
        
        currentvalue = _array[index]
        position = index

        while position > 0 and _array[position - 1] > currentvalue:
        
            _array[position] = _array[position - 1]
            position = position-1

        _array[position]=currentvalue

# merge sort        
def MergeSort(_array):
    
    # print("Splitting ",_array)
    if len(_array) > 1:
        
        mid = len(_array)//2
        lefthalf = _array[:mid]
        righthalf = _array[mid:]

        MergeSort(lefthalf)
        MergeSort(righthalf)

        i = 0
        j = 0
        k = 0
    
        while i < len(lefthalf) and j < len(righthalf):
            
            if lefthalf[i] < righthalf[j]:
               
                _array[k]=lefthalf[i]
                i = i + 1
    
            else:
    
                _array[k]=righthalf[j]
                j = j + 1
    
            k = k + 1

        while i < len(lefthalf):
    
            _array[k] = lefthalf[i]
            i = i + 1
            k = k + 1

        while j < len(righthalf):
    
            _array[k] = righthalf[j]
            j = j + 1
            k = k + 1
    
    # print("Merging ",_array)

# data set in increasing order
data_set_inc = [
                "1K_integers_in_increasing_order",
                "10K_integers_in_increasing_order",
                "100K_integers_in_increasing_order",
                "1000K_integers_in_increasing_order"
]

# data set in decreasing order
data_set_dec = [
                "1K_integers_in_decreasing_order",
                "10K_integers_in_decreasing_order",
                "100K_integers_in_decreasing_order",
                "1000K_integers_in_decreasing_order"
]

# data set in random order
data_set_rand = [
                "1K_integers_in_random_order",
                "10K_integers_in_random_order",
                "100K_integers_in_random_order",
                "1000K_integers_in_random_order"
]

# data set
data_set = {
    "Increasing" : data_set_inc,
#    "Decreasing" : data_set_dec
    "Random"     : data_set_rand
}

# algorithms to be run
algorithm_list =    {
    "Insertion" : InsertionSort,
    "Merge"     : MergeSort
}

# list to store result class instances
aggregated_results = {}

f_log = open("log.txt", "a")

for algorithm_name in algorithm_list:
    
    f_log.write(algorithm_name + '\n')
    results = {}

    for k, v in data_set.items():

        sub_results = []
    
        for sub_data_set_name in v:

            f_data_string = str(sub_data_set_name) + ".dat"
            f_data = open(f_data_string, "r")
            data_array = np.fromfile(f_data, dtype=np.uint32)
            data_array = np.array(data_array).tolist()
        
            starting_time = time.clock_gettime(time.CLOCK_PROCESS_CPUTIME_ID)
            algorithm_list[algorithm_name](data_array)
            finishing_time = time.clock_gettime(time.CLOCK_PROCESS_CPUTIME_ID)
            running_time = finishing_time - starting_time

            f_log.write(str(sub_data_set_name) + str(len(data_array)) + '\t' + str(running_time) + '\n')
            temp_result = result(algorithm_name, len(data_array), running_time)
            sub_results.append(temp_result)
        
            print (str(algorithm_name) + "\t" + str(len(data_array)) + "\t" + f_data_string + "\t" + str(running_time))
        results[k] = sub_results

    aggregated_results[algorithm_name] = results


merge_inc_runtime = []
insertion_inc_runtime = []

for i in aggregated_results["Merge"]["Increasing"]:
    merge_inc_runtime.append(i.runtime)

for i in aggregated_results["Insertion"]["Increasing"]:
    insertion_inc_runtime.append(i.runtime)

merge_dec_runtime = []
insertion_dec_runtime = []

for i in aggregated_results["Merge"]["Decreasing"]:
    merge_dec_runtime.append(i.runtime)

for i in aggregated_results["Insertion"]["Decreasing"]:
    insertion_dec_runtime.append(i.runtime)

merge_rand_runtime = []
insertion_rand_runtime = []

for i in aggregated_results["Merge"]["Random"]:
    merge_rand_runtime.append(i.runtime)

for i in aggregated_results["Insertion"]["Random"]:
    insertion_rand_runtime.append(i.runtime)


# do plotting

labelfont = {
        'family' : 'sans-serif',  # (cursive, fantasy, monospace, serif)
        'color'  : 'black',       # html hex or colour name
        'weight' : 'normal',      # (normal, bold, bolder, lighter)
        'size'   : 14,            # default value:12
        }

titlefont = {
        'family' : 'serif',
        'color'  : 'black',
        'weight' : 'bold',
        'size'   : 16,
        }

input_size = [1000, 10000, 100000, 1000000]

plt.plot(input_size, merge_dec_runtime,                             
         'darkgreen', # colour
         linestyle='-', # line style
         linewidth=3, # line width
         marker='o', # set marker
         label='$Merge Sort$') # plot label

plt.plot(input_size, insertion_dec_runtime, 
         'darkmagenta', 
         linestyle='-', 
         linewidth=3,
         marker='o',
         label='$Insertion Sort$')

axes = plt.gca()
legend = plt.legend(loc='upper left', shadow=True, fontsize='small')

plt.title('Numbers in Decreasing Order', fontdict=titlefont) 
plt.xlabel('Input Size', fontdict=labelfont)
plt.ylabel('Run-Time (seconds)', fontdict=labelfont)

plt.subplots_adjust(left=0.15)        # prevents overlapping of the y label

plt.show()
 

#array = [45, 2, 6, 1, 3, 4, 1, 2, 39]
#beg = 0
#end = len(array) - 1

#QuickSort(array, beg, end)

#n = c(10^3, 10^4, 10^5, 10^6)
#algorithm = c("merge sort", "insertion sort")

#plot(n, n^(1/2),  type = 'b', col = "red", main="Merge Sort vs. Insertion Sort\n -Numbers in Increasing Order-", xlab="Input Size", ylab="Run-Time (seconds)", xlim=c(10^3, 10^6))
#lines(n, n^(1/3), col="green", type = 'b')
#legend('topleft', algorithm, lty=1, col=c('red', 'green'), bty='n', cex=.75)
