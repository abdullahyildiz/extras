# find combination of elements of two arrays with recursion

def listComb(A, i, B, j):
	if(i == len(A)):
		return
	elif (j == len(B)):
		listComb(A, i+1, B, 0)
	else:
		print A[i], B[j]
		listComb(A, i, B, j+1)

A = [1, 2, 7]
B = [3, 4, 5]

print A
print B
listComb(A, 0, B, 0)
