#FlipPredictor
#A coin is drawn at random from a bag of coins of varying probabilities
#Each coin has the same chance of being drawn
#Your class FlipPredictor will be initialized with a list of the probability of 
#heads for each coin. This list of probabilities can be accessed as self.coins 
#in the functions you must write. The function update will be called after every 
#flip to enable you to update your estimate of the probability of each coin being 
#the selected coin. The function pheads may be called and any time and will 
#return your best estimate of the next flip landing on heads.


from __future__ import division
class FlipPredictor(object):
    def __init__(self,coins):
        self.coins=coins
        n=len(coins)
        self.probs=[1/n]*n
    def pheads(self):
        #Write a function that returns 
        #the probability of the next flip being heads
        phead=0
        for (a,b) in zip(self.coins,self.probs):
            phead = phead + a*b
        return phead

    def update(self,result):
        #Write a function the updates
        #the probabilities of flipping each coin
        if result == 'H':
           phead = self.pheads()
           for i in range(len(self.probs)):
              self.probs[i] = self.coins[i]*self.probs[i]/phead
        else:
           ptail = 1 - self.pheads()
           for i in range(len(self.probs)):
              self.probs[i] = (1-self.coins[i])*self.probs[i]/ptail

#The code below this line tests your implementation. 
#You need not change it
#You may add additional test cases or otherwise modify if desired
def test(coins,flips):        
    f=FlipPredictor(coins)
    guesses=[]
    for flip in flips:
        f.update(flip)
        guesses.append(f.pheads())
    return guesses   
        
def maxdiff(l1,l2):
    return max([abs(x-y) for x,y in zip(l1,l2)])

testcases=[
(([0.5,0.4,0.3],'HHTH'),[0.4166666666666667, 0.432, 0.42183098591549295, 0.43639398998330553])]
for inputs,output in testcases:
    if maxdiff(test(*inputs),output)<0.001:
        print 'Correct'
    else: print 'Incorrect'
