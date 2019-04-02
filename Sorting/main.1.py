import numpy as np
import matplotlib
import matplotlib.pyplot as plt

import time

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

def QuickSort(_array, _beg, _end):
    
    if _beg < _end:
        
        _pivotLoc_t = PartitionArray(_array, _beg, _end)
        QuickSort(_array, _beg, (_pivotLoc_t - 1))
        QuickSort(_array, (_pivotLoc_t + 1), _end)
        
def QuickSortTailRecursion(_array, _beg, _end):
    
    while _beg < _end:
        print _array
        print "beg: ", (_beg + 1), "end: ", (_end + 1)
        _pivotLoc_t = PartitionArray(_array, _beg, _end)
        print "pivot: ", _pivotLoc_t
        print _array
        QuickSortTailRecursion(_array, _beg, (_pivotLoc_t - 1))
        _beg = _pivotLoc_t + 1

def InsertionSort(_array):
    
    for index in range(1,len(_array)):
        
        currentvalue = _array[index]
        position = index

        while position > 0 and _array[position - 1] > currentvalue:
        
            _array[position] = _array[position - 1]
            position = position-1

        _array[position]=currentvalue
        
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

array = [2, 8, 7, 1, 3, 5, 6, 4]
beg = 0
end = len(array) - 1

QuickSortTailRecursion(array, beg, end)
print array

#plot(n, n^(1/2),  type = 'b', col = "red", main="Merge Sort vs. Insertion Sort\n -Numbers in Increasing Order-", xlab="Input Size", ylab="Run-Time (seconds)", xlim=c(10^3, 10^6))
#lines(n, n^(1/3), col="green", type = 'b')
#legend('topleft', algorithm, lty=1, col=c('red', 'green'), bty='n', cex=.75)