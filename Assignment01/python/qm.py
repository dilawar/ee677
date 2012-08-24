# Quine-McClusky Implementation
# Written by Savant Krishna "savant.2020@gmail.com"
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

class QuineMcClusky:
    def __init__(self,filename):
        self.filename=filename #filename passed from main function
        self.vars=0 #no. of variables: to be parsed
        self.minterms=[] #to store the minterms : to be parsed
        self.reducedterms=[] #to store the output reducedterms
        try:
            self.fin=open(filename,"r") #open the file
        except IOError:
            print "Cannot open the file! Give another minterms file name!"
            self.filename=raw_input("Filename :")
        self.getminterms()
        self.fin.close()

    def getminterms(self):
        line=self.fin.readline() #read first line
        try:
            assert line[:7]=="vars = "
        except AssertionError:
            print "Not correct format! Need \'vars = <>\'"
            return
        try:
            self.vars=int(line[7:]) #get the no. of variables
        except ValueError:
            print "Not an integer variable number!"
            return
        line=self.fin.readline() #read the next line
        try:
            assert line[:11]=="minterms = "
        except AssertionError:
            print "Not correct format! Need \'minterms = <>\'"
            return
        try:
            self.minterms=map(int,line[11:len(line)-2].split(','))
            #Eg : minterms = 0,1,2,5,7,8,9,10,13,15,
            #gets the minterms into a list of int
        except ValueError:
            print "Not got integers as minterms! Error!"
            print line[11:len(line)-2].split(',')
            return

    def do_quinemcclusky(self):
        self.reducedterms=[] #reasserting that initially empty
        self.minterms=self.mintermstobinary()
        #this will change minterms to list of lists(minterms: elements being bits) with binary representation
        #Change the representation from integers to bits corresponding to variables

        #After getting the representation, apply the algo.
        #To implement the algorithm

    def mintermstobinary(self):
        newminterms=[]
        #To change self.minterm to bits
        for term in self.minterms: #go through each minterm and find it's binary form
            newminterms.append(self.tobinary(term))
        return newminterms

    def tobinary(self,term):
        binaryterm=[]
        for i in range(self.vars): #finding the binary form of a number representing minterm
            binaryterm.append(term%2)
            term=term/2
        return binaryterm[::-1]

    def print_reduced_terms(self): #used finally to print the reducedterms
        for e in self.reducedterms:
            print e


if __name__=="__main__":
    #call a instance of the class QuineMcClusky with the filename of minterms.txt
    qm=QuineMcClusky("../clang/minterms.txt")
    #call the do_quinemcclusky method which will compute the reducedterms
    qm.do_quinemcclusky()
    #print the reduceedterms
    qm.print_reduced_terms()
