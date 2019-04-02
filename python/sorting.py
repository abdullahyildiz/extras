
step = 0

def median(_array, a, b, c):
    
    if _array[a] >= _array[b] and _array[a] >= _array[c]:
        
        if _array[b] >= _array[c]:
            
            return b
            
        else:
            
            return c
            
    elif _array[b] >= _array[a] and _array[b] >= _array[c]:
        
        if _array[a] >= _array[c]:
            
            return a
            
        else:
        
            return c
            
    elif _array[c] >= _array[a] and _array[c] >= _array[b]:
        
        if _array[a] >= _array[b]:
            
            return a
            
        else:
        
            return b

def PartitionArray(_array, _beg_t, _end_t):
    
    print "Before partitioning: ", _array
    
    # select pivot with Median-of-Three Way
    _pivotLoc_t = median(_array, _beg_t, _end_t, int((_beg_t + _end_t) / 2))
    print "Pivot selected: ", _array[_pivotLoc_t]

     # swap pivot element with the last element of the list
    _array[_pivotLoc_t], _array[_end_t] = _array[_end_t], _array[_pivotLoc_t]
    
    # set left and right indices of the array
    _left_t = _beg_t
    _right_t = _end_t - 1
    
    # print "_left: ", (_left_t), " _right: ", (_right_t)
    
    # iterate until left and right indices cross
    while _left_t <= _right_t:
        
        # move right index to the left, skipping all the elements greater than the pivot
        while _array[_end_t] < _array[_right_t]:
                
                _right_t -= 1
        
        # move left index to the right, skipping all the elements less than the pivot        
        while _array[_end_t] > _array[_left_t]:
            
                _left_t += 1
        
        # swap elements indicated by right and left indices
        if _right_t > _left_t:
            
            _array[_left_t], _array[_right_t] = _array[_right_t], _array[_left_t]
        
    # place pivot element into its true location
    _array[_left_t], _array[_end_t] = _array[_end_t], _array[_left_t]
    
    print "After partitioning: ", _array
    
    return _left_t

# original quicksort algorithm
def QuickSort(_array, _beg, _end):
    
    if _beg < _end:
        global step
        step += 1
        print "STEP: ", step
        _pivotLoc = PartitionArray(_array, _beg, _end)
        QuickSort(_array, _beg, (_pivotLoc - 1))
        QuickSort(_array, (_pivotLoc + 1), _end)

# optimized version of quicksort algorithm using tail recursion
def QuickSortTR(_array, _beg, _end):
    
    global step
    
    while _beg < _end:
        
        print "================================================================"
        step += 1
        print "STEP: ", step
        print "run quicksort in the range (", _beg, ",", _end,")"
        _pivotLoc = PartitionArray(_array, _beg, _end)
        print "pivot is placed at location ", _pivotLoc
        QuickSortTR(_array, _beg, (_pivotLoc - 1))
        _beg = _pivotLoc + 1
    
    if _beg >= _end:
        
        print "================================================================"
        step += 1
        print "STEP: ", step
        print "run quicksort in the range (", _beg, ",", _end,")"
        print "return doing anything", _array
    
        
    # return _array

array_1 = [8, 7, 6, 5, 4, 3, 2, 1]
array_2 = [2, 8, 7, 1, 3, 5, 6, 4]
array_3 = [13, 19, 9, 5, 12, 8, 7, 4, 11, 2, 6, 21]

array = array_3
beg = 0
end = len(array) - 1

print "Array to be sorted: ", array
QuickSortTR(array, beg, end)
print "================================================================"

print "ALGORITHM HAS FINISHED. \nArray is now sorted: ", array

# print PartitionArray(array, 2, 3)