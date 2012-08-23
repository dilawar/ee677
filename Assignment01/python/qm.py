
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

    def getminterms(self):
        line=self.fin.readline()
        try:
            assert line[:7]=="vars = "
        except AssertionError:
            print "Not correct format! Need \'vars = <>\'"
            return
        try:
            self.vars=int(line[7:])
        except ValueError:
            print "Not an integer variable number!"
            return
        line=self.fin.readline()
        try:
            assert line[:11]=="minterms = "
        except AssertionError:
            print "Not correct format! Need \'minterms = <>\'"
            return
        try:
            self.minterms=map(int,line[11:len(line)-2].split(','))
            #Eg : minterms = 0,1,2,5,7,8,9,10,13,15,
        except ValueError:
            print "Not got integers as minterms! Error!"
            print line[11:len(line)-2].split(',')
            return

if __name__=="__main__":
    #call a instance of the class QuineMcClusky with the filename of minterms.txt
    qm=QuineMcClusky("../clang/minterms.txt")
