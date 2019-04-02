#############################TEST DATA#############################
mem_ref_profile_1 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] # sequential access
mem_ref_profile_2 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9] # sequential and repetitive access (increasing)
mem_ref_profile_3 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0] # sequential and repetitive access (decreasing)

mem_ref_profile_4 = [0, 50, 100, 150, 200] # sequential access
mem_ref_profile_5 = [0, 50, 100, 150, 200, 0, 50, 100, 150, 200] # sequential and repetitive access (increasing)
mem_ref_profile_6 = [0, 50, 100, 150, 200, 200, 150, 100, 50, 0] # sequential and repetitive access (decreasing)


mem_ref_profile_7 = [0, 50, 100, 150, 200, 250, 300, 350, 400, 450] # sequential access
mem_ref_profile_8 = [0, 50, 100, 150, 200, 250, 300, 350, 400, 450, 0, 50, 100, 150, 200, 250, 300, 350, 400, 450] # sequential and repetitive access (increasing)
mem_ref_profile_9 = [0, 50, 100, 150, 200, 250, 300, 350, 400, 450, 450, 400, 350, 300, 250, 200, 150, 100, 50, 0] # sequential and repetitive access (decreasing)

mem_ref_profile_10 = [10, 11, 104, 170, 73, 309, 185, 245, 246, 434, 458, 364] # random access
mem_ref_profile_11 = [42, 34, 108, 266, 333, 444, 1, 2, 34, 256, 117] # random access
mem_ref_profile_12 = [135, 35, 331, 48, 246, 383, 398, 124, 392, 432, 7] #random access
#############################TEST DATA#############################

#################################################################################
def mem_sim(_mem_ref, _mem_size, _page_size, _replacement_policy):
    
    #_debug = 0 # debug print disabled
    
    _mem_ref_dict = {} # memory reference and its corresponding page number
    
    for m in _mem_ref:
        _mem_ref_dict[m] = int(m / _page_size)

    if debug == 1:
        print "----------------------------------------"
        print "Page Size: ", _page_size
        print 'Memory Reference\tCorresponding Page Number'
        for k,v in _mem_ref_dict.iteritems():
            print k, '\t\t\t', v
        print "----------------------------------------"


    _num_of_page_frames = _mem_size / _page_size # number of page frames

    _page_table = [-1] * _num_of_page_frames # initialize page table

    _num_of_page_hits = 0
    _num_of_page_faults = 0

    _fifo_index = 0 # variable for fifo replacement policy
    
    if debug == 1:
        print "----------------------------------------"
    for m in _mem_ref: # take memory references one-by-one and update the page list accordingly
        if _replacement_policy == "fifo":
            if int(m / _page_size) in _page_table:
                if debug == 1:
                    print 'Page hit for word\t', m
                _num_of_page_hits += 1
            else:
                if debug == 1:
                    print 'Page fault for word\t', m
                _num_of_page_faults += 1
                _page_table[_fifo_index] = int(m / _page_size)
                _fifo_index = (_fifo_index + 1) % len(_page_table)
    if debug == 1:
        print "----------------------------------------"

    return _num_of_page_hits
#################################################################################

# parameters
debug = 1 # debug print disabled
mem_ref = mem_ref_profile_10
mem_size = 200
replacement_policy = "fifo"
page_size = [100, 50, 200]

#print "########################################"
print "MEMORY REFERENCES:"
for m in mem_ref[:-1]:
    print m, # print memory references
print mem_ref[len(mem_ref)-1]
print "########################################"
#print "========================================"
print "SPECS:" # print specs
print "mem_size: ", mem_size
print "replacement_policy: ", replacement_policy
print "========================================"
#print "****************************************"
print "RESULTS:"
for p in page_size:
    
    num_of_page_hits = mem_sim(mem_ref, mem_size, p, replacement_policy)
    print "Page Size:\t", p, "\tSuccess Rate:\t", (float(num_of_page_hits) / len(mem_ref)) * 100, "%" # print results
print "****************************************"

print "****************************************"
print "AMAT"
print "****************************************"

pt = 0.1
# pt = 0.05
pp = 0.0002
pp = 0.0001
tt = 0.0
tm = 1.0
td = 10000.0
# td = 8000.0
pd = 0.5

amat = (1-pt)*(tt + tm) + pt*((1-pp)*(tt+tm+tm) + pp*((1-pd)*(tt+tm+tm+td)+pd*(tt+tm+tm+td+td)))

print "amat ", amat
