#!/usr/bin/py
def lonelyinteger(a):
    answer = 0
    dict = {}
    hist = []
    freq = []
    for i in range (0, len(a)):
        if(len(hist) == 0):
            hist.append(a[i])
            freq.append(1)
        else:
            found = 0
            for j in range(0, len(hist)):
                if a[i] == hist[j]:
                    found = 1
                    freq[j] += 1
                    break
            if found == 0:
                hist.append(a[i])
                freq.append(1)
    print hist
    print freq
    for i in range(0, len(freq)):
        if freq[i] == 1:
            answer = hist[i]
    return answer
    
    
if __name__ == '__main__':
    a = input()
    b = map(int, raw_input().strip().split(" "))
    print lonelyinteger(b)