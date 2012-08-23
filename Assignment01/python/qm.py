
class QuineMcClusky:
    def __init__(self,filename):
        self.filename=filename
        self.vars=0
        self.minterms=[]
        self.reducedterms=[]
        try:
            self.fin=open(filename,"r")
        except IOError:
            print "Cannot open the file! Give another minterms file name!"
            self.filename=raw_input("Filename :")
        self.getminterms()

if __name__=="__main__":
    #call a instance of the class QuineMcClusky with the filename of minterms.txt
    qm=QuineMcClusky("../clang/minterms.txt")
